#include "types.h"
#include "stat.h"
#include "user.h"

int lock;

void *print(void)
{
  int b=0;
  for(;;)
  {
    int i=0;
    b = binary_semaphore_down(lock);
    if(b == -1)
    {
      printf(1,"the requested semaphore does not exist\n");
      exit();
    }
    for(;i<3;i++)
      printf(1,"Process %d Thread %d is running.\n",thread_getProcId(),thread_getId());
    binary_semaphore_up(lock);
    sleep(1);
  }
  thread_exit(0);
  return 0;
}


void
threadTest(char* n)
{
  int value = 0;
  lock = binary_semaphore_create(1);
  if(n)
  {
    int num = atoi(n);
    for(;num>0;num--)
    {
      int stack_size = 4096;
      void* stack = malloc(stack_size);
      memset(stack,0,stack_size);
      value = thread_create((void*)print,stack,stack_size);
      if(value == -1)
	printf(1,"Failed to create thread number %d\n",num);
    }
  }
}



int
main(int argc, char** argv)
{
  threadTest(argv[1]);
  thread_exit(0);
  return 0;
}