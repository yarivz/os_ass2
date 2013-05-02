#include "boundedbuffer.h"

struct BB* 
BB_create(int max_capacity)
{
  struct BB* buf = malloc(sizeof(struct BB));
  if((buf->mutex = binary_semaphore_create(1)) != -1)
  {
    buf->BUFFER_SIZE = max_capacity;
    if((buf->empty = create_semaphore(max_capacity))!= 0 && (buf->full = create_semaphore(0))!= 0)
      return buf;
  }
  free(buf);
  buf = 0;
  return buf;
}

void 
BB_put(struct BB* bb, void* element)
{
  void *item;
  semaphore_down(bb->empty);
  binary_semaphore_down(bb->mutex);
  for(item = bb->elements; item < &bb->elements[bb->BUFFER_SIZE]; item++)
  {
    if(item)
      continue;
    item = element;
  }
  binary_semaphore_up(bb->mutex);
  semaphore_up(bb->empty);
}

void* 
BB_pop(struct BB* bb)
{
  void* item;
  int count = 0;
  semaphore_down(bb->full);
  binary_semaphore_down(bb->mutex);
  for(item = bb->elements; item < &bb->elements[bb->BUFFER_SIZE]; item++)
  {
    if(!item)
    {
      count++;
      continue;
    }
    bb->elements[count] = 0;
    break;
  }
  binary_semaphore_up(bb->mutex);
  semaphore_up(bb->full);
  return item;
}


