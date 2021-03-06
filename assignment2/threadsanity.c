// Test that fork fails gracefully.
// Tiny executable so that the limit can be filling the proc table.

#include "types.h"
#include "stat.h"
#include "user.h"

#define N  1000
/*
void
printf(int fd, char *s, ...)
{
  write(fd, s, strlen(s));
}
*/

void
foo()
{
  int i;
  int pid = getpid();
  for (i=0;i<50;i++)
     printf(2, "process %d is printing for the %d time\n",pid,i+1);
}

void
threadsanity(void)
{
  printf(1, "threadsanity test\n");
  printf(1, "Father pid is %d\n",getpid());
  sleep(1000);

  if(fork() == 0)
  {
    foo();
    exit();      
  }
  foo();
  wait();
}
int
main(void)
{
  threadsanity();
  exit();
}
