#include "types.h"
#include "param.h"
#include "user.h"

struct semaphore{
  volatile int value;
  volatile int s1;
  volatile int s2;
  char* name;
};

struct semaphore* semaphore_create(int initial_semaphore_value, char* name);
void semaphore_down(struct semaphore* sem );
void semaphore_up(struct semaphore* sem );

