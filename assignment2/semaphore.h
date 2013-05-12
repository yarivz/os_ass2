#include "types.h"
#include "param.h"
#include "user.h"

struct semaphore{
  int value;
  int s1;
  int s2;
};

struct semaphore* semaphore_create(int initial_semaphore_value);
void semaphore_down(struct semaphore* sem );
void semaphore_up(struct semaphore* sem );

