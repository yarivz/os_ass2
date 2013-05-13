#include "bienstein.h"

struct semaphore* bouncer;
//struct semaphore* cupsem;
int cupsem;
int dirtycups;
struct BB* ABB;
struct BB* DrinkBB;
struct BB* CBB;
struct BB* DBB;

int M,A,C,S,B,fd;


void enter_bar() //bouncer
{
  semaphore_down(bouncer);
}

void leave_bar() //bouncer
{
  semaphore_up(bouncer);
}

void place_action(struct Action* action) //ABB
{
  BB_put(ABB, action);
}

struct Action* get_action() //ABB
{
  return BB_pop(ABB);
}

void serve_drink(struct Cup* cup) //DrinkBB
{
  BB_put(DrinkBB,cup);
}

struct Cup* get_drink() //DrinkBB
{
  return BB_pop(DrinkBB);
}

struct Cup* get_clean_cup() //CBB
{
  return BB_pop(CBB);
}

void add_clean_cup(struct Cup* cup) //CBB
{
  BB_put(CBB,cup);
}

void return_cup(struct Cup* cup) //DBB
{
  BB_put(DBB,cup);
}

struct Cup* wash_dirty() //DBB
{
  return BB_pop(DBB);
}

int getconf(void)
{
  int fdin,rd;
  char buf[512];
  memset(&buf,0,512);
  
  if((fdin = open("con.conf",O_RDONLY)) < 0)
  {
    printf(2,"Couldn't open the conf file\n");
    return -1;
  }
  
  if((rd = read(fdin, &buf, 512)) <= 0)
  {
    printf(2,"Couldn't read from conf file\n");
    return -1;
  }
  
  int i = 0;
  for(;i<rd;i++)
    if(buf[i] == '\n')
      buf[i] = 0;

  for(i=0;i<rd;i++)
  {
    if(buf[i] == '=')
    {
      switch(buf[i-1])
      {
	case 'M':
	  M = atoi(&buf[i+1]);
	  break;
	case 'A':
	   A = atoi(&buf[i+1]);
	  break;
	case 'C':
	   C = atoi(&buf[i+1]);
	  break;
	case 'S':
	   S = atoi(&buf[i+1]);
	  break;
	case 'B':
	   B = atoi(&buf[i+1]);
	  break;
      }
    }
  }
  return 0;
}

void* student_func(void)
{
  int tid = thread_getId();
  int i = 0;
  
  enter_bar();
  for(;i < tid%5;i++)
  {
    struct Action* get = malloc(sizeof(struct Action)); //create the get_drink action
    get->type = GET_DRINK;
    get->cup = 0;
    get->tid = tid;
    place_action(get);
    struct Cup * cup = get_drink();			//get cup from DrinkBB buffer
    printf(fd,"Student %d is having his %d drink, with cup %d\n",tid,i+1,cup->id);
    sleep(1);
    struct Action* put = malloc(sizeof(struct Action));
    put->type = PUT_DRINK;
    put->cup = cup;
    put->tid = tid;
    place_action(put);
  }
  printf(fd,"Student %d is drunk, and trying to go home\n",tid);
  leave_bar();
  thread_exit(0);
  return 0;
}

void* bartender_func(void)
{
  double n,bufSize;
  int tid = thread_getId();
  for(;;)
  {
    struct Action * act = get_action();
    if(act->type == GET_DRINK)
    {
      struct Cup * cup = get_clean_cup();
      printf(fd,"Bartender %d is making drink with cup #%d\n",tid,cup->id);
      serve_drink(cup);
    }
    else if(act->type == PUT_DRINK)
    {
      struct Cup * cup = act->cup;
      return_cup(cup);
      printf(fd,"Bartender %d returned cup #%d\n",tid,cup->id);
      
      n = DBB->full->value;
      bufSize = DBB->BUFFER_SIZE;
      if(n/bufSize >= 0.6)
      {
	dirtycups = n;
	binary_semaphore_up(cupsem);
      }
    }
    free(act);
  }
  return 0;
}

void* cupboy_func(void)
{
  int i, n;
  
  for(;;)
  {
    //n = dirtycups;
    n = DBB->full->value;
    for(i=0;i<n;i++)
    {
      struct Cup * cup = wash_dirty();
      sleep(1);
      add_clean_cup(cup);
      printf(fd,"Cup boy added clean cup #%d\n",cup->id);    
    }
    binary_semaphore_down(cupsem);
  }
  
  return 0;
}


int 
main(void)
{
  printf(1,"Running simulation...\nPlease run 'cat Synch_problem_log.txt' to see results\n");
  close(1);
  if((fd = open("Synch_problem_log.txt",(O_WRONLY | O_CREATE))) < 0)
  {
    printf(2,"Couldn't open the log file\n");
    return -1;
  }
  if (getconf() == -1)
  {
    return -1;
  }
  //fd=1;
  void * barStack[B];
  void * studStack[S];
  int studTid[S];
  int i = 0;  
  bouncer = semaphore_create(M,"bouncer");
  cupsem = binary_semaphore_create(1/*,"cupboy"*/);
  ABB = BB_create(A,"ABB");
  DrinkBB = BB_create(A,"DrinkBB");
  CBB = BB_create(C,"CBB");
  DBB = BB_create(C,"DBB");
  struct Cup* cups[C];
  
  for(;i<C;i++)
  {
    cups[i] = malloc(sizeof(struct Cup));
    cups[i]->id = i;
    BB_put(CBB,cups[i]);
  }
  
  void* cupStack = malloc(sizeof(void*)*1024);
  memset(cupStack,0,sizeof(void*)*1024);
  if(thread_create(cupboy_func,cupStack,sizeof(void*)*1024) < 0)
  {
    printf(2,"Failed to create cupboy thread. Exiting...\n");
    exit();
  }
  
  for(i=0;i<B;i++)
  {
    barStack[i] = malloc(sizeof(void*)*1024);
    memset(barStack[i],0,sizeof(void*)*1024);
    if(thread_create(bartender_func,barStack[i],sizeof(void*)*1024) < 0)
    {
      printf(2,"Failed to create bartender thread #%d. Exiting...\n",i+1);
      exit();
    } 
  }
  for(i=0;i<S;i++)
  {
    studStack[i] = malloc(sizeof(void*)*1024);
    memset(studStack[i],0,sizeof(void*)*1024);
    if((studTid[i] = thread_create(student_func,studStack[i],sizeof(void*)*1024)) < 0)
    {
      printf(2,"Failed to create student thread #%d. Exiting...\n",i+1);
      exit();
    } 
  }

  for(i=0;i<S;i++)
  {
    if(thread_join(studTid[i],0) != 0)
    {
      printf(2,"Failed to join on student thread #%d. Exiting...\n",i+1);
      exit();
    }
    
    free(studStack[i]);
  }
  
  for(i=0;i<B;i++)
    free(barStack[i]);
  free(cupStack);
  
  for(i=0;i<C;i++)
    free(cups[i]);
  

  free(CBB->elements);
  free(DBB->elements);
  free(CBB);
  free(DBB);
  
  free(ABB->elements);
  free(DrinkBB->elements);
  free(ABB);
  free(DrinkBB);
  close(fd);
  exit();
  return 0;
}

