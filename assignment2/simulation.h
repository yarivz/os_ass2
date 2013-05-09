#include "semaphore.h"
#include "boundedbuffer.h"
#include "proc.h"
#include "types.h"
#include "user.h"


#define GET_DRINK 1
#define PUT_DRINK 2


struct Action {
 int type;
 struct cup * cup;
 int tid;
};

struct cup {
 int id;  
};

