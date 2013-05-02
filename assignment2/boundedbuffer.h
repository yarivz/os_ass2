#include "types.h"
#include "mmu.h"
#include "param.h"
#include "proc.h"
#include "user.h"

struct BB{
  int BUFFER_SIZE;
  int mutex;		/* access control to critical section */
  struct semaphore *empty;	/* counts empty buffer slots */
  struct semaphore *full;	/* counts full slots */
  void* elements[BUFFER_SIZE];
}

struct BB* BB_create(int max_capacity);
void BB_put(struct BB* bb, void* element);
void* BB_pop(struct BB* bb);