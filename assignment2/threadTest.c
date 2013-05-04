#include "types.h"
#include "stat.h"
#include "user.h"

int lock;

void *print(void)
{
  for(;;)
  {
    int i=0;
    binary_semaphore_down(lock);
    for(;i<3;i++)
      printf(1,"Process %d Thread %d is running.\n",thread_getProcId(),thread_getId());
    binary_semaphore_up(lock);
  }
}


void
threadTest(char* n)
{
  int value = 0;
  lock = binary_semaphore_create(1);
  int num = atoi(n);
  for(;num>0;num--)
  {
    uint stack_size = 1024;
    void* stack = malloc(stack_size);
    value = thread_create((void*)print,stack,stack_size);
    if(value == -1)
      printf(1,"Failed to create thread number %d\n",num);
  }
}



int
main(int argc, char** argv)
{
  threadTest(argv[1]);
  thread_exit(0);
  return 0;
}