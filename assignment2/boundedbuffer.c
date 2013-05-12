#include "boundedbuffer.h"

struct BB* 
BB_create(int max_capacity,char* name)
{
  struct BB* buf = malloc(sizeof(struct BB));
  memset(buf,0,sizeof(struct BB));
  buf->elements = malloc(sizeof(void*)*max_capacity);
  memset(buf->elements,0,sizeof(void*)*max_capacity);
  buf->name = name;
  if((buf->mutex = binary_semaphore_create(1)) != -1)
  {
    buf->BUFFER_SIZE = max_capacity;
    if((buf->empty = semaphore_create(max_capacity))!= 0 && (buf->full = semaphore_create(0))!= 0)
      return buf;
  }
  free(buf->elements);
  free(buf);
  buf = 0;
  return buf;
}

void 
BB_put(struct BB* bb, void* element)
{
  //printf(1,"bb name = %s, tid = %d\n",bb->name,thread_getId());
  semaphore_down(bb->empty);
  binary_semaphore_down(bb->mutex);
  bb->elements[bb->end] = element;
  ++bb->end;
  bb->end = bb->end%bb->BUFFER_SIZE;
  binary_semaphore_up(bb->mutex);
  semaphore_up(bb->full);
}

void* 
BB_pop(struct BB* bb)
{
  void* item;
  //printf(1,"bb name = %s, tid = %d\n",bb->name,thread_getId());
  semaphore_down(bb->full);
  binary_semaphore_down(bb->mutex);
  item = bb->elements[bb->start];
  bb->elements[bb->start] = 0;
  ++bb->start;
  bb->start = bb->start%bb->BUFFER_SIZE;
  binary_semaphore_up(bb->mutex);
  semaphore_up(bb->empty);
  return item;
}


