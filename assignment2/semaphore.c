#include "semaphore.h"

struct semaphore* 
semaphore_create(int initial_semaphore_value)
{
  int min = 1;
  struct semaphore* s = malloc(sizeof(struct semaphore));
  if((s->s1 = binary_semaphore_create(1)) != -1)
  {
    if(initial_semaphore_value < 1)
      min = initial_semaphore_value;
    if((s->s2 = binary_semaphore_create(min)) != -1)
    {
      s->value = initial_semaphore_value;
      return s;
    }
  }
  free(s);
  s = 0;
  return s;
}

void 
semaphore_down(struct semaphore* sem )
{
 //printf(1,"semaphore_down for tid = %d\n",thread_getId());
 binary_semaphore_down(sem->s2);
 binary_semaphore_down(sem->s1);
 sem->value--;
 //printf(1,"semaphore_value = %d for tid = %d\n",sem->value,thread_getId());
 if(sem->value>0)
  binary_semaphore_up(sem->s2);
 binary_semaphore_up(sem->s1);
}

void 
semaphore_up(struct semaphore* sem )
{
  //printf(1,"semaphore_up for tid = %d\n",thread_getId());
  binary_semaphore_down(sem->s1);
  sem->value++;
  //printf(1,"semaphore_value = %d for tid = %d\n",sem->value,thread_getId());
  if(sem->value == 1)
    binary_semaphore_up(sem->s2);
  binary_semaphore_up(sem->s1);
}

