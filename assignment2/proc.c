#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;


struct {
  struct spinlock lock;
  struct spinlock semlocks[128];
  struct b_semaphore binary_semaphores[128];
} semtable;

static struct proc *initproc;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
  initlock(&semtable.lock, "semtable");
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
  p->sem_queue_pos = 0;
  p->threadnum = 1;
  p->waiting_for_semaphore = -1;
  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
  initproc = p;
  if((p->pgdir = setupkvm(kalloc)) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->state = RUNNABLE;
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  
  sz = proc->sz;
  if(n > 0){
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  proc->sz = sz;
  switchuvm(proc);
  return 0;
}

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = proc->sz;
  if(!proc->isthread)
    np->parent = proc;
  else
    np->parent = proc->parent;
  *np->tf = *proc->tf;
  
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
  np->thread_id = 0;
  np->isthread = 0;
  np->isjoined = 0;
  pid = np->pid;
  np->state = RUNNABLE;
  safestrcpy(np->name, proc->name, sizeof(proc->name));
  return pid;
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *p;
  int fd;

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(proc->ofile[fd]){
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
  proc->cwd = 0;

  acquire(&ptable.lock);
  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
  // Pass abandoned children to init.
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == proc->pid && p->state != ZOMBIE){		// for threads
        // Found one.
        p->state = ZOMBIE;
	if(p->isthread)
	{
	  if(p->parent->threadnum)
	    p->parent->threadnum--;
	  if(!p->parent->threadnum)
	    wakeup1(p->parent->parent);
	}
	else
	{
	  p->threadnum--;
	  if(!p->threadnum)
	    wakeup1(p->parent);
	}
      }
    else if(p->parent == proc && p->isthread !=1){		// for child processes
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  int found = 0, first = 0;

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE && !p->isthread && p->threadnum == 0){
        found = p->pid;
	break;
      }
    }
    
    if(found > 0)
    {
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
	if(p->pid != found)
	  continue;
			    // we found a child process whom all of his threads are zombies (including himself)
	if(!first)
	{
	 freevm(p->pgdir);
	 first = 1;
	}
	pid = p->pid;
	kfree(p->kstack);
	p->kstack = 0;
	p->state = UNUSED;
	p->pid = 0;
	p->parent = 0;
	p->name[0] = 0;
	p->killed = 0;
      }
    }
    
    if(found)
    {
      release(&ptable.lock);
      return pid;
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
  }
}

void
register_handler(sighandler_t sighandler)
{
  char* addr = uva2ka(proc->pgdir, (char*)proc->tf->esp);
  if ((proc->tf->esp & 0xFFF) == 0)
    panic("esp_offset == 0");

    /* open a new frame */
  *(int*)(addr + ((proc->tf->esp - 4) & 0xFFF))
          = proc->tf->eip;
  proc->tf->esp -= 4;

    /* update eip */
  proc->tf->eip = (uint)sighandler;
}


//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
      switchuvm(p);
      p->state = RUNNING;
      swtch(&cpu->scheduler, proc->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
  int intena;

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(cpu->ncli != 1)
    panic("sched locks");
  if(proc->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = cpu->intena;
  swtch(&proc->context, cpu->scheduler);
  cpu->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  proc->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
    initlog();
  }
  
  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  if(proc == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }

  // Go to sleep.
  proc->chan = chan;
  proc->state = SLEEPING;
  sched();

  // Tidy up.
  proc->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}

int
thread_create(void*(*start_func)(), void* stack, uint stack_size)
{
  int i, tid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
    return -1;

  np->pid = proc->pid;
  // Copy process state from p.
  np->pgdir = proc->pgdir;
  np->sz = proc->sz;
  if(proc->isthread)
    np->parent = proc->parent;
  else
    np->parent = proc;
  acquire(&ptable.lock);
  np->parent->threadnum++;
  release(&ptable.lock);

  np->isthread = 1;
  np->isjoined = 0;
  np->thread_id = ++(np->parent->thread_id);
  *np->tf = *proc->tf;
  np->tf->esp = (uint)stack+stack_size;
  np->tf->eip = (uint)start_func;
  for(i = 0; i < NOFILE; i++)
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = proc->cwd;
  tid = np->thread_id;
  np->state = RUNNABLE;
  safestrcpy(np->name, proc->name, sizeof(proc->name));
  return tid;
}

int 
thread_getId()
{
  if(proc && proc->isthread)
    return proc->thread_id;
  else
    return -1; 
}

int 
thread_getProcId()
{
  if(proc)
    return proc->pid;  
  else
    return -1;
}

int 
thread_join(int thread_id, void** ret_val)
{
  struct proc *t = 0;
  int found = 0;

  acquire(&ptable.lock);
  for(t = ptable.proc; t < &ptable.proc[NPROC]; t++)
  {
    if(t->pid == proc->pid && t->isthread && t->thread_id == thread_id && t != proc)
    {
      if(t->isjoined)
      {
	release(&ptable.lock);
	return -2;
      }
      if(t->state == ZOMBIE)
      {
	ret_val =  &(t->ret_val);
	release(&ptable.lock);
	return 0;
      }      
      t->isjoined = 1;
      found = 1;
      break;
    }
  }

  if(!found)
  {
    release(&ptable.lock);
    return -1;
  }

  sleep(t,&ptable.lock);
  release(&ptable.lock);
  return 0;
}

void 
thread_exit(void * ret_val)
{
  acquire(&ptable.lock);
  if(proc->isthread)
  {
    if(proc->parent->threadnum == 1)		// when main thread already commited thread_exit and all other threads have exited
    {
      proc->parent->threadnum--;
      release(&ptable.lock);
      exit();
    }
    proc->ret_val = ret_val;			// not main thread and not the last one
    proc->parent->threadnum--;
    proc->state = ZOMBIE;
    if(proc->isjoined)
      wakeup1(proc);
    sched();
    release(&ptable.lock);
  }
  else if(proc->threadnum == 1)		// main thread is the last thread of the process
  {
    proc->threadnum--;
    release(&ptable.lock);
    exit();
  }
  else						// main thread has other live threads
  {
    proc->threadnum--;
    proc->state = ZOMBIE;
    sched();
    release(&ptable.lock);
  }
}

int
binary_semaphore_create(int initial_value)
{
  struct b_semaphore* sem;
  int i = 0;
  acquire(&semtable.lock);
  for(;i<128;i++)
  {
    sem = &semtable.binary_semaphores[i];
    if(sem->created)
      continue;
    
    initlock(&semtable.semlocks[i],"b_semaphore");
    sem->created = 1;
    sem->value = initial_value;
    release(&semtable.lock);
    return i;
  }
  release(&semtable.lock);
  return -1;
}

int 
binary_semaphore_down(int binary_semaphore_ID)
{
  struct b_semaphore* sem = &semtable.binary_semaphores[binary_semaphore_ID];
  acquire(&semtable.semlocks[binary_semaphore_ID]);
  if(sem->waiting)
    proc->sem_queue_pos = ++(sem->waiting);
  for(;;)
  { 
    if(sem->created)
    {
      if(sem->value && !proc->sem_queue_pos)
      {
	sem->value = 0;
	proc->waiting_for_semaphore = -1;
	release(&semtable.semlocks[binary_semaphore_ID]);
	return 0;
      }
      else
      {
	if(!proc->sem_queue_pos)
	  proc->sem_queue_pos = ++(sem->waiting);
	proc->waiting_for_semaphore = binary_semaphore_ID;
	//cprintf("thread %d is sleeping on semaphore %d\n",thread_getId(),binary_semaphore_ID);
	sleep(sem,&semtable.semlocks[binary_semaphore_ID]);
      }
    }
    else
    {
      release(&semtable.semlocks[binary_semaphore_ID]);
      return -1;
    }
  }
}

int
binary_semaphore_up(int binary_semaphore_ID)
{
  acquire(&semtable.semlocks[binary_semaphore_ID]);
  struct b_semaphore* sem = &semtable.binary_semaphores[binary_semaphore_ID];
  if(sem->created)
  {     
    struct proc *p;
    struct proc* first = 0;
    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    {
      if(p != proc && p->waiting_for_semaphore == binary_semaphore_ID)
      {
	  p->sem_queue_pos--;
	  if(p->sem_queue_pos == 0)
	    first = p;
      }
    }
    
    if(sem->waiting>0)
	sem->waiting--;
    sem->value = 1;
    if(first && first->state == SLEEPING)
      first->state = RUNNABLE;
    release(&ptable.lock);
    release(&semtable.semlocks[binary_semaphore_ID]);
    return 0;
  }
  else
    release(&semtable.semlocks[binary_semaphore_ID]);
    return -1;
}

