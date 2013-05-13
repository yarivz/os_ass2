#include "semaphore.h"

struct semaphore* 
semaphore_create(int initial_semaphore_value, char* name)
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
      s->name = name;
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
 binary_semaphore_down(sem->s2);
 binary_semaphore_down(sem->s1);
 sem->value--;
 if(sem->value>0)
  binary_semaphore_up(sem->s2);
 binary_semaphore_up(sem->s1);
}

void 
semaphore_up(struct semaphore* sem )
{
  binary_semaphore_down(sem->s1);
  sem->value++;
  if(sem->value == 1)
    binary_semaphore_up(sem->s2);
  binary_semaphore_up(sem->s1);
}

