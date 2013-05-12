#include "types.h"
#include "param.h"
#include "user.h"
#include "semaphore.h"

struct BB{
  int BUFFER_SIZE;
  int mutex;		/* access control to critical section */
  struct semaphore *empty;	/* counts empty buffer slots */
  struct semaphore *full;	/* counts full slots */
  int start,end;
  char* name;
  void** elements;
};

struct BB* BB_create(int max_capacity,char* name);
void BB_put(struct BB* bb, void* element);
void* BB_pop(struct BB* bb);