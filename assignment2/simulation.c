#include "simulation.h"

struct semaphore bouncer;
struct semaphore cupsem;
struct boundedbuffer ABB;
struct boundedbuffer DrinkBB;
struct boundedbuffer CBB;
struct boundedbuffer DBB;

int M,A,C,S,B,fd;


void enter_bar() //bouncer
{
  semaphore_down(&bouncer);
}

void leave_bar() //bouncer
{
  semaphore_up(&bouncer);
}

void place_action(Action* action) //ABB
{
  BB_put(&ABB, action);
}

Action* get_action() //ABB
{
  return BB_pop(&ABB);
}

void serve_drink(Cup*) //DrinkBB
{
  BB_put(&DrinkBB,cup);
}

Cup* get_drink() //DrinkBB
{
  return BB_pop(&DrinkBB);
}

Cup* get_clean_cup() //CBB
{
  return BB_pop(&CBB);
}

void add_clean_cup(Cup* cup) //CBB
{
  BB_put(&CBB,cup);
}

void return_cup(Cup* cup) //DBB
{
  BB_put(&DBB,cup);
}

Cup* wash_dirty() //DBB
{
  return BB_pop(&DBB);
}

void getconf(void)
{
  int fdin,rd;
  char buf[512];
  memset(&buf,0,512);
  
  if((fdin = open("con.conf",O_RDONLY)) < 0)
  {
    printf(1,"Couldn't open the conf file\n");
    return;
  }
  
  if((rd = read(fdin, &buf, 512)) <= 0)
  {
    printf(1,"Couldn't read from conf file\n");
    return;
  }
  
  int i = 0;
  for(;i<rd;i++)
    if(buf[i] == '\n')
      buf[i] = 0;
    
  for(;i<rd;i++)
    if(buf[i] == '=')
    {
      switch(buf[i-1])
      {
	case M:
	  M = atoi(buf[i+1]);
	  break;
	case A:
	   A = atoi(buf[i+1]);
	  break;
	case C:
	   C = atoi(buf[i+1]);
	  break;
	case S:
	   S = atoi(buf[i+1]);
	  break;
	case B:
	   B = atoi(buf[i+1]);
	  break;
      }
    }
}

void student_func(void)
{
  int tid = thread_getId();
  int i = 0;
  
  enter_bar();
  for(;i < tid%5;i++)
  {
    struct Action get={1,0,tid};
    place_action(&act);
    Cup * cup = get_drink();
    printf(fd,"Student %d is having his %d drink, with cup %d\n",tid,i,cup->id);
    sleep(1);
    struct Action put={2,cup,tid};
    place_action(&put);
  }
  printf(fd,"Student %d is drunk, and trying to go home\n",tid);
  leave_bar();  
}

void bartender_func(void)
{
  double n,bufSize;
  int tid = thread_getId();
  for(;;)
  {
    Action * act = get_action();
    if(act->type == GET_DRINK)
    {
      Cup * cup = get_clean_cup();
      printf(fd,"Bartender %d is making drink with cup #%d\n",tid,cup->id);
      serve_drink(cup);
    }
    else if(act->type == PUT_DRINK)
    {
      Cup * cup = act->cup;
      return_cup(cup);
      printf(fd,"Bartender %d returned cup #%d\n",tid,cup->id);
      
      semaphore_down(DBB.full);
      n = DBB.full->value;
      semaphore_up(DBB.full);
      bufSize = DBB.BUFFER_SIZE;
      if(n/bufSize >= 0.6)
	semaphore_up(cupsem);
    }
  }
}

void cupboy_func(void)
{
  int i = 0, n;
  
  for(;;)
  {
    semaphore_down(DBB.full);
    n = DBB.full->value;
    semaphore_up(DBB.full);
    
    for(;i<n;i++)
    {
      Cup * cup = wash_dirty();
      sleep(1);
      add_clean_cup(cup);
      printf(fd,"Cup boy added clean cup #%d\n",cup->id);    
    }
    semaphore_down(cupsem);
  }
}


int 
main(void)
{
  
  
  if((fd = open("Synch_problem_log.txt",(O_WRONLY | O_CREATE))) < 0)
  {
    printf(1,"Couldn't open the log file\n");
    return;
  }
  
  bouncer = semaphore_create(M);
  cupsem = semaphore_create(1);
  ABB = BB_create(A);
  DrinkBB = BB_create(A);
  CBB = BB_create(C);
  DBB = BB_create(C);
  
  
}



