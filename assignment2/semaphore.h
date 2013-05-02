#include "types.h"
#include "mmu.h"
#include "param.h"
#include "proc.h"
#include "user.h"

struct {
  int value;
  struct b_semaphore s1;
  struct b_semaphore s2;
} semaphore;

struct semaphore* semaphore_create(int initial_semaphore_value);
void semaphore_down(struct semaphore* sem );
void semaphore_up(struct semaphore* sem );

