#include "types.h"
#include "param.h"
#include "user.h"
#include "semaphore.h"

struct BB{
  volatile int BUFFER_SIZE;
  volatile int mutex;		/* access control to critical section */
  struct semaphore *empty;	/* counts empty buffer slots */
  struct semaphore *full;	/* counts full slots */
  volatile int start;
  volatile int end;
  char* name;
  void** elements;
};

struct BB* BB_create(int max_capacity,char* name);
void BB_put(struct BB* bb, void* element);
void* BB_pop(struct BB* bb);