#include "boundedbuffer.h"
#include "types.h"
#include "user.h"
#include "fcntl.h"


#define GET_DRINK 1
#define PUT_DRINK 2


struct Action {
 int type;
 struct Cup * cup;
 int tid;
};

struct Cup {
 int id;  
};

