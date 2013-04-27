
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 50 c6 10 80       	mov    $0x8010c650,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 07 34 10 80       	mov    $0x80103407,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 84 85 10 	movl   $0x80108584,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100049:	e8 18 4f 00 00       	call   80104f66 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 90 db 10 80 84 	movl   $0x8010db84,0x8010db90
80100055:	db 10 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 94 db 10 80 84 	movl   $0x8010db84,0x8010db94
8010005f:	db 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 94 c6 10 80 	movl   $0x8010c694,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 94 db 10 80       	mov    0x8010db94,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 94 db 10 80       	mov    %eax,0x8010db94

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate fresh block.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801000bd:	e8 c5 4e 00 00       	call   80104f87 <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 94 db 10 80       	mov    0x8010db94,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	89 c2                	mov    %eax,%edx
801000f5:	83 ca 01             	or     $0x1,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
80100104:	e8 e0 4e 00 00       	call   80104fe9 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 60 c6 10 	movl   $0x8010c660,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 d5 47 00 00       	call   801048f9 <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 90 db 10 80       	mov    0x8010db90,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010017c:	e8 68 4e 00 00       	call   80104fe9 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
      goto loop;
    }
  }

  // Not cached; recycle some non-busy and clean buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 84 db 10 80 	cmpl   $0x8010db84,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 8b 85 10 80 	movl   $0x8010858b,(%esp)
8010019f:	e8 99 03 00 00       	call   8010053d <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 dc 25 00 00       	call   801027b4 <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 9c 85 10 80 	movl   $0x8010859c,(%esp)
801001f6:	e8 42 03 00 00       	call   8010053d <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	89 c2                	mov    %eax,%edx
80100202:	83 ca 04             	or     $0x4,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 9f 25 00 00       	call   801027b4 <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 a3 85 10 80 	movl   $0x801085a3,(%esp)
80100230:	e8 08 03 00 00       	call   8010053d <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
8010023c:	e8 46 4d 00 00       	call   80104f87 <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 94 db 10 80    	mov    0x8010db94,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c 84 db 10 80 	movl   $0x8010db84,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 94 db 10 80       	mov    0x8010db94,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 94 db 10 80       	mov    %eax,0x8010db94

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	89 c2                	mov    %eax,%edx
8010028f:	83 e2 fe             	and    $0xfffffffe,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 33 47 00 00       	call   801049d5 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 60 c6 10 80 	movl   $0x8010c660,(%esp)
801002a9:	e8 3b 4d 00 00       	call   80104fe9 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	53                   	push   %ebx
801002b4:	83 ec 14             	sub    $0x14,%esp
801002b7:	8b 45 08             	mov    0x8(%ebp),%eax
801002ba:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002be:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
801002c2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
801002c6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
801002ca:	ec                   	in     (%dx),%al
801002cb:	89 c3                	mov    %eax,%ebx
801002cd:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
801002d0:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
801002d4:	83 c4 14             	add    $0x14,%esp
801002d7:	5b                   	pop    %ebx
801002d8:	5d                   	pop    %ebp
801002d9:	c3                   	ret    

801002da <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002da:	55                   	push   %ebp
801002db:	89 e5                	mov    %esp,%ebp
801002dd:	83 ec 08             	sub    $0x8,%esp
801002e0:	8b 55 08             	mov    0x8(%ebp),%edx
801002e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801002e6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002ea:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002ed:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002f1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002f5:	ee                   	out    %al,(%dx)
}
801002f6:	c9                   	leave  
801002f7:	c3                   	ret    

801002f8 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002f8:	55                   	push   %ebp
801002f9:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002fb:	fa                   	cli    
}
801002fc:	5d                   	pop    %ebp
801002fd:	c3                   	ret    

801002fe <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002fe:	55                   	push   %ebp
801002ff:	89 e5                	mov    %esp,%ebp
80100301:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100304:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100308:	74 19                	je     80100323 <printint+0x25>
8010030a:	8b 45 08             	mov    0x8(%ebp),%eax
8010030d:	c1 e8 1f             	shr    $0x1f,%eax
80100310:	89 45 10             	mov    %eax,0x10(%ebp)
80100313:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100317:	74 0a                	je     80100323 <printint+0x25>
    x = -xx;
80100319:	8b 45 08             	mov    0x8(%ebp),%eax
8010031c:	f7 d8                	neg    %eax
8010031e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100321:	eb 06                	jmp    80100329 <printint+0x2b>
  else
    x = xx;
80100323:	8b 45 08             	mov    0x8(%ebp),%eax
80100326:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100329:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100330:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100333:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100336:	ba 00 00 00 00       	mov    $0x0,%edx
8010033b:	f7 f1                	div    %ecx
8010033d:	89 d0                	mov    %edx,%eax
8010033f:	0f b6 90 04 90 10 80 	movzbl -0x7fef6ffc(%eax),%edx
80100346:	8d 45 e0             	lea    -0x20(%ebp),%eax
80100349:	03 45 f4             	add    -0xc(%ebp),%eax
8010034c:	88 10                	mov    %dl,(%eax)
8010034e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
80100352:	8b 55 0c             	mov    0xc(%ebp),%edx
80100355:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80100358:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010035b:	ba 00 00 00 00       	mov    $0x0,%edx
80100360:	f7 75 d4             	divl   -0x2c(%ebp)
80100363:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100366:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010036a:	75 c4                	jne    80100330 <printint+0x32>

  if(sign)
8010036c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100370:	74 23                	je     80100395 <printint+0x97>
    buf[i++] = '-';
80100372:	8d 45 e0             	lea    -0x20(%ebp),%eax
80100375:	03 45 f4             	add    -0xc(%ebp),%eax
80100378:	c6 00 2d             	movb   $0x2d,(%eax)
8010037b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
8010037f:	eb 14                	jmp    80100395 <printint+0x97>
    consputc(buf[i]);
80100381:	8d 45 e0             	lea    -0x20(%ebp),%eax
80100384:	03 45 f4             	add    -0xc(%ebp),%eax
80100387:	0f b6 00             	movzbl (%eax),%eax
8010038a:	0f be c0             	movsbl %al,%eax
8010038d:	89 04 24             	mov    %eax,(%esp)
80100390:	e8 bb 03 00 00       	call   80100750 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
80100395:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100399:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010039d:	79 e2                	jns    80100381 <printint+0x83>
    consputc(buf[i]);
}
8010039f:	c9                   	leave  
801003a0:	c3                   	ret    

801003a1 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a1:	55                   	push   %ebp
801003a2:	89 e5                	mov    %esp,%ebp
801003a4:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a7:	a1 f4 b5 10 80       	mov    0x8010b5f4,%eax
801003ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b3:	74 0c                	je     801003c1 <cprintf+0x20>
    acquire(&cons.lock);
801003b5:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801003bc:	e8 c6 4b 00 00       	call   80104f87 <acquire>

  if (fmt == 0)
801003c1:	8b 45 08             	mov    0x8(%ebp),%eax
801003c4:	85 c0                	test   %eax,%eax
801003c6:	75 0c                	jne    801003d4 <cprintf+0x33>
    panic("null fmt");
801003c8:	c7 04 24 aa 85 10 80 	movl   $0x801085aa,(%esp)
801003cf:	e8 69 01 00 00       	call   8010053d <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d4:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e1:	e9 20 01 00 00       	jmp    80100506 <cprintf+0x165>
    if(c != '%'){
801003e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003ea:	74 10                	je     801003fc <cprintf+0x5b>
      consputc(c);
801003ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ef:	89 04 24             	mov    %eax,(%esp)
801003f2:	e8 59 03 00 00       	call   80100750 <consputc>
      continue;
801003f7:	e9 06 01 00 00       	jmp    80100502 <cprintf+0x161>
    }
    c = fmt[++i] & 0xff;
801003fc:	8b 55 08             	mov    0x8(%ebp),%edx
801003ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100403:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100406:	01 d0                	add    %edx,%eax
80100408:	0f b6 00             	movzbl (%eax),%eax
8010040b:	0f be c0             	movsbl %al,%eax
8010040e:	25 ff 00 00 00       	and    $0xff,%eax
80100413:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100416:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
8010041a:	0f 84 08 01 00 00    	je     80100528 <cprintf+0x187>
      break;
    switch(c){
80100420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100423:	83 f8 70             	cmp    $0x70,%eax
80100426:	74 4d                	je     80100475 <cprintf+0xd4>
80100428:	83 f8 70             	cmp    $0x70,%eax
8010042b:	7f 13                	jg     80100440 <cprintf+0x9f>
8010042d:	83 f8 25             	cmp    $0x25,%eax
80100430:	0f 84 a6 00 00 00    	je     801004dc <cprintf+0x13b>
80100436:	83 f8 64             	cmp    $0x64,%eax
80100439:	74 14                	je     8010044f <cprintf+0xae>
8010043b:	e9 aa 00 00 00       	jmp    801004ea <cprintf+0x149>
80100440:	83 f8 73             	cmp    $0x73,%eax
80100443:	74 53                	je     80100498 <cprintf+0xf7>
80100445:	83 f8 78             	cmp    $0x78,%eax
80100448:	74 2b                	je     80100475 <cprintf+0xd4>
8010044a:	e9 9b 00 00 00       	jmp    801004ea <cprintf+0x149>
    case 'd':
      printint(*argp++, 10, 1);
8010044f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100452:	8b 00                	mov    (%eax),%eax
80100454:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
80100458:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
8010045f:	00 
80100460:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100467:	00 
80100468:	89 04 24             	mov    %eax,(%esp)
8010046b:	e8 8e fe ff ff       	call   801002fe <printint>
      break;
80100470:	e9 8d 00 00 00       	jmp    80100502 <cprintf+0x161>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100475:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100478:	8b 00                	mov    (%eax),%eax
8010047a:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
8010047e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100485:	00 
80100486:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
8010048d:	00 
8010048e:	89 04 24             	mov    %eax,(%esp)
80100491:	e8 68 fe ff ff       	call   801002fe <printint>
      break;
80100496:	eb 6a                	jmp    80100502 <cprintf+0x161>
    case 's':
      if((s = (char*)*argp++) == 0)
80100498:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049b:	8b 00                	mov    (%eax),%eax
8010049d:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004a0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004a4:	0f 94 c0             	sete   %al
801004a7:	83 45 f0 04          	addl   $0x4,-0x10(%ebp)
801004ab:	84 c0                	test   %al,%al
801004ad:	74 20                	je     801004cf <cprintf+0x12e>
        s = "(null)";
801004af:	c7 45 ec b3 85 10 80 	movl   $0x801085b3,-0x14(%ebp)
      for(; *s; s++)
801004b6:	eb 17                	jmp    801004cf <cprintf+0x12e>
        consputc(*s);
801004b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004bb:	0f b6 00             	movzbl (%eax),%eax
801004be:	0f be c0             	movsbl %al,%eax
801004c1:	89 04 24             	mov    %eax,(%esp)
801004c4:	e8 87 02 00 00       	call   80100750 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004c9:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004cd:	eb 01                	jmp    801004d0 <cprintf+0x12f>
801004cf:	90                   	nop
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	84 c0                	test   %al,%al
801004d8:	75 de                	jne    801004b8 <cprintf+0x117>
        consputc(*s);
      break;
801004da:	eb 26                	jmp    80100502 <cprintf+0x161>
    case '%':
      consputc('%');
801004dc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e3:	e8 68 02 00 00       	call   80100750 <consputc>
      break;
801004e8:	eb 18                	jmp    80100502 <cprintf+0x161>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004f1:	e8 5a 02 00 00       	call   80100750 <consputc>
      consputc(c);
801004f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f9:	89 04 24             	mov    %eax,(%esp)
801004fc:	e8 4f 02 00 00       	call   80100750 <consputc>
      break;
80100501:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100502:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100506:	8b 55 08             	mov    0x8(%ebp),%edx
80100509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010050c:	01 d0                	add    %edx,%eax
8010050e:	0f b6 00             	movzbl (%eax),%eax
80100511:	0f be c0             	movsbl %al,%eax
80100514:	25 ff 00 00 00       	and    $0xff,%eax
80100519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010051c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100520:	0f 85 c0 fe ff ff    	jne    801003e6 <cprintf+0x45>
80100526:	eb 01                	jmp    80100529 <cprintf+0x188>
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
80100528:	90                   	nop
      consputc(c);
      break;
    }
  }

  if(locking)
80100529:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010052d:	74 0c                	je     8010053b <cprintf+0x19a>
    release(&cons.lock);
8010052f:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100536:	e8 ae 4a 00 00       	call   80104fe9 <release>
}
8010053b:	c9                   	leave  
8010053c:	c3                   	ret    

8010053d <panic>:

void
panic(char *s)
{
8010053d:	55                   	push   %ebp
8010053e:	89 e5                	mov    %esp,%ebp
80100540:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100543:	e8 b0 fd ff ff       	call   801002f8 <cli>
  cons.locking = 0;
80100548:	c7 05 f4 b5 10 80 00 	movl   $0x0,0x8010b5f4
8010054f:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
80100552:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100558:	0f b6 00             	movzbl (%eax),%eax
8010055b:	0f b6 c0             	movzbl %al,%eax
8010055e:	89 44 24 04          	mov    %eax,0x4(%esp)
80100562:	c7 04 24 ba 85 10 80 	movl   $0x801085ba,(%esp)
80100569:	e8 33 fe ff ff       	call   801003a1 <cprintf>
  cprintf(s);
8010056e:	8b 45 08             	mov    0x8(%ebp),%eax
80100571:	89 04 24             	mov    %eax,(%esp)
80100574:	e8 28 fe ff ff       	call   801003a1 <cprintf>
  cprintf("\n");
80100579:	c7 04 24 c9 85 10 80 	movl   $0x801085c9,(%esp)
80100580:	e8 1c fe ff ff       	call   801003a1 <cprintf>
  getcallerpcs(&s, pcs);
80100585:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100588:	89 44 24 04          	mov    %eax,0x4(%esp)
8010058c:	8d 45 08             	lea    0x8(%ebp),%eax
8010058f:	89 04 24             	mov    %eax,(%esp)
80100592:	e8 a1 4a 00 00       	call   80105038 <getcallerpcs>
  for(i=0; i<10; i++)
80100597:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059e:	eb 1b                	jmp    801005bb <panic+0x7e>
    cprintf(" %p", pcs[i]);
801005a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a3:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801005ab:	c7 04 24 cb 85 10 80 	movl   $0x801085cb,(%esp)
801005b2:	e8 ea fd ff ff       	call   801003a1 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005bb:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bf:	7e df                	jle    801005a0 <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005c1:	c7 05 a0 b5 10 80 01 	movl   $0x1,0x8010b5a0
801005c8:	00 00 00 
  for(;;)
    ;
801005cb:	eb fe                	jmp    801005cb <panic+0x8e>

801005cd <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005cd:	55                   	push   %ebp
801005ce:	89 e5                	mov    %esp,%ebp
801005d0:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d3:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005da:	00 
801005db:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005e2:	e8 f3 fc ff ff       	call   801002da <outb>
  pos = inb(CRTPORT+1) << 8;
801005e7:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005ee:	e8 bd fc ff ff       	call   801002b0 <inb>
801005f3:	0f b6 c0             	movzbl %al,%eax
801005f6:	c1 e0 08             	shl    $0x8,%eax
801005f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005fc:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100603:	00 
80100604:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
8010060b:	e8 ca fc ff ff       	call   801002da <outb>
  pos |= inb(CRTPORT+1);
80100610:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100617:	e8 94 fc ff ff       	call   801002b0 <inb>
8010061c:	0f b6 c0             	movzbl %al,%eax
8010061f:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100622:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100626:	75 30                	jne    80100658 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100628:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010062b:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100630:	89 c8                	mov    %ecx,%eax
80100632:	f7 ea                	imul   %edx
80100634:	c1 fa 05             	sar    $0x5,%edx
80100637:	89 c8                	mov    %ecx,%eax
80100639:	c1 f8 1f             	sar    $0x1f,%eax
8010063c:	29 c2                	sub    %eax,%edx
8010063e:	89 d0                	mov    %edx,%eax
80100640:	c1 e0 02             	shl    $0x2,%eax
80100643:	01 d0                	add    %edx,%eax
80100645:	c1 e0 04             	shl    $0x4,%eax
80100648:	89 ca                	mov    %ecx,%edx
8010064a:	29 c2                	sub    %eax,%edx
8010064c:	b8 50 00 00 00       	mov    $0x50,%eax
80100651:	29 d0                	sub    %edx,%eax
80100653:	01 45 f4             	add    %eax,-0xc(%ebp)
80100656:	eb 32                	jmp    8010068a <cgaputc+0xbd>
  else if(c == BACKSPACE){
80100658:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065f:	75 0c                	jne    8010066d <cgaputc+0xa0>
    if(pos > 0) --pos;
80100661:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100665:	7e 23                	jle    8010068a <cgaputc+0xbd>
80100667:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
8010066b:	eb 1d                	jmp    8010068a <cgaputc+0xbd>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066d:	a1 00 90 10 80       	mov    0x80109000,%eax
80100672:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100675:	01 d2                	add    %edx,%edx
80100677:	01 c2                	add    %eax,%edx
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	66 25 ff 00          	and    $0xff,%ax
80100680:	80 cc 07             	or     $0x7,%ah
80100683:	66 89 02             	mov    %ax,(%edx)
80100686:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  if((pos/80) >= 24){  // Scroll up.
8010068a:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100691:	7e 53                	jle    801006e6 <cgaputc+0x119>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100693:	a1 00 90 10 80       	mov    0x80109000,%eax
80100698:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069e:	a1 00 90 10 80       	mov    0x80109000,%eax
801006a3:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006aa:	00 
801006ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801006af:	89 04 24             	mov    %eax,(%esp)
801006b2:	e8 f2 4b 00 00       	call   801052a9 <memmove>
    pos -= 80;
801006b7:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006bb:	b8 80 07 00 00       	mov    $0x780,%eax
801006c0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c3:	01 c0                	add    %eax,%eax
801006c5:	8b 15 00 90 10 80    	mov    0x80109000,%edx
801006cb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006ce:	01 c9                	add    %ecx,%ecx
801006d0:	01 ca                	add    %ecx,%edx
801006d2:	89 44 24 08          	mov    %eax,0x8(%esp)
801006d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006dd:	00 
801006de:	89 14 24             	mov    %edx,(%esp)
801006e1:	e8 f0 4a 00 00       	call   801051d6 <memset>
  }
  
  outb(CRTPORT, 14);
801006e6:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006ed:	00 
801006ee:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006f5:	e8 e0 fb ff ff       	call   801002da <outb>
  outb(CRTPORT+1, pos>>8);
801006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006fd:	c1 f8 08             	sar    $0x8,%eax
80100700:	0f b6 c0             	movzbl %al,%eax
80100703:	89 44 24 04          	mov    %eax,0x4(%esp)
80100707:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010070e:	e8 c7 fb ff ff       	call   801002da <outb>
  outb(CRTPORT, 15);
80100713:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010071a:	00 
8010071b:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100722:	e8 b3 fb ff ff       	call   801002da <outb>
  outb(CRTPORT+1, pos);
80100727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010072a:	0f b6 c0             	movzbl %al,%eax
8010072d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100731:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100738:	e8 9d fb ff ff       	call   801002da <outb>
  crt[pos] = ' ' | 0x0700;
8010073d:	a1 00 90 10 80       	mov    0x80109000,%eax
80100742:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100745:	01 d2                	add    %edx,%edx
80100747:	01 d0                	add    %edx,%eax
80100749:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010074e:	c9                   	leave  
8010074f:	c3                   	ret    

80100750 <consputc>:

void
consputc(int c)
{
80100750:	55                   	push   %ebp
80100751:	89 e5                	mov    %esp,%ebp
80100753:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100756:	a1 a0 b5 10 80       	mov    0x8010b5a0,%eax
8010075b:	85 c0                	test   %eax,%eax
8010075d:	74 07                	je     80100766 <consputc+0x16>
    cli();
8010075f:	e8 94 fb ff ff       	call   801002f8 <cli>
    for(;;)
      ;
80100764:	eb fe                	jmp    80100764 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100766:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010076d:	75 26                	jne    80100795 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010076f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100776:	e8 6e 64 00 00       	call   80106be9 <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 62 64 00 00       	call   80106be9 <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 56 64 00 00       	call   80106be9 <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 49 64 00 00       	call   80106be9 <uartputc>
  cgaputc(c);
801007a0:	8b 45 08             	mov    0x8(%ebp),%eax
801007a3:	89 04 24             	mov    %eax,(%esp)
801007a6:	e8 22 fe ff ff       	call   801005cd <cgaputc>
}
801007ab:	c9                   	leave  
801007ac:	c3                   	ret    

801007ad <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007ad:	55                   	push   %ebp
801007ae:	89 e5                	mov    %esp,%ebp
801007b0:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007b3:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
801007ba:	e8 c8 47 00 00       	call   80104f87 <acquire>
  while((c = getc()) >= 0){
801007bf:	e9 41 01 00 00       	jmp    80100905 <consoleintr+0x158>
    switch(c){
801007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007c7:	83 f8 10             	cmp    $0x10,%eax
801007ca:	74 1e                	je     801007ea <consoleintr+0x3d>
801007cc:	83 f8 10             	cmp    $0x10,%eax
801007cf:	7f 0a                	jg     801007db <consoleintr+0x2e>
801007d1:	83 f8 08             	cmp    $0x8,%eax
801007d4:	74 68                	je     8010083e <consoleintr+0x91>
801007d6:	e9 94 00 00 00       	jmp    8010086f <consoleintr+0xc2>
801007db:	83 f8 15             	cmp    $0x15,%eax
801007de:	74 2f                	je     8010080f <consoleintr+0x62>
801007e0:	83 f8 7f             	cmp    $0x7f,%eax
801007e3:	74 59                	je     8010083e <consoleintr+0x91>
801007e5:	e9 85 00 00 00       	jmp    8010086f <consoleintr+0xc2>
    case C('P'):  // Process listing.
      procdump();
801007ea:	e8 8c 42 00 00       	call   80104a7b <procdump>
      break;
801007ef:	e9 11 01 00 00       	jmp    80100905 <consoleintr+0x158>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f4:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801007f9:	83 e8 01             	sub    $0x1,%eax
801007fc:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
80100801:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100808:	e8 43 ff ff ff       	call   80100750 <consputc>
8010080d:	eb 01                	jmp    80100810 <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010080f:	90                   	nop
80100810:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
80100816:	a1 58 de 10 80       	mov    0x8010de58,%eax
8010081b:	39 c2                	cmp    %eax,%edx
8010081d:	0f 84 db 00 00 00    	je     801008fe <consoleintr+0x151>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100823:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100828:	83 e8 01             	sub    $0x1,%eax
8010082b:	83 e0 7f             	and    $0x7f,%eax
8010082e:	0f b6 80 d4 dd 10 80 	movzbl -0x7fef222c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100835:	3c 0a                	cmp    $0xa,%al
80100837:	75 bb                	jne    801007f4 <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100839:	e9 c0 00 00 00       	jmp    801008fe <consoleintr+0x151>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010083e:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
80100844:	a1 58 de 10 80       	mov    0x8010de58,%eax
80100849:	39 c2                	cmp    %eax,%edx
8010084b:	0f 84 b0 00 00 00    	je     80100901 <consoleintr+0x154>
        input.e--;
80100851:	a1 5c de 10 80       	mov    0x8010de5c,%eax
80100856:	83 e8 01             	sub    $0x1,%eax
80100859:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(BACKSPACE);
8010085e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100865:	e8 e6 fe ff ff       	call   80100750 <consputc>
      }
      break;
8010086a:	e9 92 00 00 00       	jmp    80100901 <consoleintr+0x154>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010086f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100873:	0f 84 8b 00 00 00    	je     80100904 <consoleintr+0x157>
80100879:	8b 15 5c de 10 80    	mov    0x8010de5c,%edx
8010087f:	a1 54 de 10 80       	mov    0x8010de54,%eax
80100884:	89 d1                	mov    %edx,%ecx
80100886:	29 c1                	sub    %eax,%ecx
80100888:	89 c8                	mov    %ecx,%eax
8010088a:	83 f8 7f             	cmp    $0x7f,%eax
8010088d:	77 75                	ja     80100904 <consoleintr+0x157>
        c = (c == '\r') ? '\n' : c;
8010088f:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
80100893:	74 05                	je     8010089a <consoleintr+0xed>
80100895:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100898:	eb 05                	jmp    8010089f <consoleintr+0xf2>
8010089a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010089f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
801008a2:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008a7:	89 c1                	mov    %eax,%ecx
801008a9:	83 e1 7f             	and    $0x7f,%ecx
801008ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
801008af:	88 91 d4 dd 10 80    	mov    %dl,-0x7fef222c(%ecx)
801008b5:	83 c0 01             	add    $0x1,%eax
801008b8:	a3 5c de 10 80       	mov    %eax,0x8010de5c
        consputc(c);
801008bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008c0:	89 04 24             	mov    %eax,(%esp)
801008c3:	e8 88 fe ff ff       	call   80100750 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c8:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008cc:	74 18                	je     801008e6 <consoleintr+0x139>
801008ce:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008d2:	74 12                	je     801008e6 <consoleintr+0x139>
801008d4:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008d9:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
801008df:	83 ea 80             	sub    $0xffffff80,%edx
801008e2:	39 d0                	cmp    %edx,%eax
801008e4:	75 1e                	jne    80100904 <consoleintr+0x157>
          input.w = input.e;
801008e6:	a1 5c de 10 80       	mov    0x8010de5c,%eax
801008eb:	a3 58 de 10 80       	mov    %eax,0x8010de58
          wakeup(&input.r);
801008f0:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
801008f7:	e8 d9 40 00 00       	call   801049d5 <wakeup>
        }
      }
      break;
801008fc:	eb 06                	jmp    80100904 <consoleintr+0x157>
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
801008fe:	90                   	nop
801008ff:	eb 04                	jmp    80100905 <consoleintr+0x158>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100901:	90                   	nop
80100902:	eb 01                	jmp    80100905 <consoleintr+0x158>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
          wakeup(&input.r);
        }
      }
      break;
80100904:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
80100905:	8b 45 08             	mov    0x8(%ebp),%eax
80100908:	ff d0                	call   *%eax
8010090a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010090d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100911:	0f 89 ad fe ff ff    	jns    801007c4 <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
80100917:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
8010091e:	e8 c6 46 00 00       	call   80104fe9 <release>
}
80100923:	c9                   	leave  
80100924:	c3                   	ret    

80100925 <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
80100925:	55                   	push   %ebp
80100926:	89 e5                	mov    %esp,%ebp
80100928:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
8010092b:	8b 45 08             	mov    0x8(%ebp),%eax
8010092e:	89 04 24             	mov    %eax,(%esp)
80100931:	e8 80 10 00 00       	call   801019b6 <iunlock>
  target = n;
80100936:	8b 45 10             	mov    0x10(%ebp),%eax
80100939:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
8010093c:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100943:	e8 3f 46 00 00       	call   80104f87 <acquire>
  while(n > 0){
80100948:	e9 a8 00 00 00       	jmp    801009f5 <consoleread+0xd0>
    while(input.r == input.w){
      if(proc->killed){
8010094d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100953:	8b 40 24             	mov    0x24(%eax),%eax
80100956:	85 c0                	test   %eax,%eax
80100958:	74 21                	je     8010097b <consoleread+0x56>
        release(&input.lock);
8010095a:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100961:	e8 83 46 00 00       	call   80104fe9 <release>
        ilock(ip);
80100966:	8b 45 08             	mov    0x8(%ebp),%eax
80100969:	89 04 24             	mov    %eax,(%esp)
8010096c:	e8 f7 0e 00 00       	call   80101868 <ilock>
        return -1;
80100971:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100976:	e9 a9 00 00 00       	jmp    80100a24 <consoleread+0xff>
      }
      sleep(&input.r, &input.lock);
8010097b:	c7 44 24 04 a0 dd 10 	movl   $0x8010dda0,0x4(%esp)
80100982:	80 
80100983:	c7 04 24 54 de 10 80 	movl   $0x8010de54,(%esp)
8010098a:	e8 6a 3f 00 00       	call   801048f9 <sleep>
8010098f:	eb 01                	jmp    80100992 <consoleread+0x6d>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100991:	90                   	nop
80100992:	8b 15 54 de 10 80    	mov    0x8010de54,%edx
80100998:	a1 58 de 10 80       	mov    0x8010de58,%eax
8010099d:	39 c2                	cmp    %eax,%edx
8010099f:	74 ac                	je     8010094d <consoleread+0x28>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801009a1:	a1 54 de 10 80       	mov    0x8010de54,%eax
801009a6:	89 c2                	mov    %eax,%edx
801009a8:	83 e2 7f             	and    $0x7f,%edx
801009ab:	0f b6 92 d4 dd 10 80 	movzbl -0x7fef222c(%edx),%edx
801009b2:	0f be d2             	movsbl %dl,%edx
801009b5:	89 55 f0             	mov    %edx,-0x10(%ebp)
801009b8:	83 c0 01             	add    $0x1,%eax
801009bb:	a3 54 de 10 80       	mov    %eax,0x8010de54
    if(c == C('D')){  // EOF
801009c0:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009c4:	75 17                	jne    801009dd <consoleread+0xb8>
      if(n < target){
801009c6:	8b 45 10             	mov    0x10(%ebp),%eax
801009c9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009cc:	73 2f                	jae    801009fd <consoleread+0xd8>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009ce:	a1 54 de 10 80       	mov    0x8010de54,%eax
801009d3:	83 e8 01             	sub    $0x1,%eax
801009d6:	a3 54 de 10 80       	mov    %eax,0x8010de54
      }
      break;
801009db:	eb 20                	jmp    801009fd <consoleread+0xd8>
    }
    *dst++ = c;
801009dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801009e0:	89 c2                	mov    %eax,%edx
801009e2:	8b 45 0c             	mov    0xc(%ebp),%eax
801009e5:	88 10                	mov    %dl,(%eax)
801009e7:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
    --n;
801009eb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009ef:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009f3:	74 0b                	je     80100a00 <consoleread+0xdb>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009f9:	7f 96                	jg     80100991 <consoleread+0x6c>
801009fb:	eb 04                	jmp    80100a01 <consoleread+0xdc>
      if(n < target){
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
801009fd:	90                   	nop
801009fe:	eb 01                	jmp    80100a01 <consoleread+0xdc>
    }
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
80100a00:	90                   	nop
  }
  release(&input.lock);
80100a01:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100a08:	e8 dc 45 00 00       	call   80104fe9 <release>
  ilock(ip);
80100a0d:	8b 45 08             	mov    0x8(%ebp),%eax
80100a10:	89 04 24             	mov    %eax,(%esp)
80100a13:	e8 50 0e 00 00       	call   80101868 <ilock>

  return target - n;
80100a18:	8b 45 10             	mov    0x10(%ebp),%eax
80100a1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a1e:	89 d1                	mov    %edx,%ecx
80100a20:	29 c1                	sub    %eax,%ecx
80100a22:	89 c8                	mov    %ecx,%eax
}
80100a24:	c9                   	leave  
80100a25:	c3                   	ret    

80100a26 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a26:	55                   	push   %ebp
80100a27:	89 e5                	mov    %esp,%ebp
80100a29:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a2c:	8b 45 08             	mov    0x8(%ebp),%eax
80100a2f:	89 04 24             	mov    %eax,(%esp)
80100a32:	e8 7f 0f 00 00       	call   801019b6 <iunlock>
  acquire(&cons.lock);
80100a37:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a3e:	e8 44 45 00 00       	call   80104f87 <acquire>
  for(i = 0; i < n; i++)
80100a43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a4a:	eb 1d                	jmp    80100a69 <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a4f:	03 45 0c             	add    0xc(%ebp),%eax
80100a52:	0f b6 00             	movzbl (%eax),%eax
80100a55:	0f be c0             	movsbl %al,%eax
80100a58:	25 ff 00 00 00       	and    $0xff,%eax
80100a5d:	89 04 24             	mov    %eax,(%esp)
80100a60:	e8 eb fc ff ff       	call   80100750 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a65:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a6c:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a6f:	7c db                	jl     80100a4c <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a71:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100a78:	e8 6c 45 00 00       	call   80104fe9 <release>
  ilock(ip);
80100a7d:	8b 45 08             	mov    0x8(%ebp),%eax
80100a80:	89 04 24             	mov    %eax,(%esp)
80100a83:	e8 e0 0d 00 00       	call   80101868 <ilock>

  return n;
80100a88:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a8b:	c9                   	leave  
80100a8c:	c3                   	ret    

80100a8d <consoleinit>:

void
consoleinit(void)
{
80100a8d:	55                   	push   %ebp
80100a8e:	89 e5                	mov    %esp,%ebp
80100a90:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a93:	c7 44 24 04 cf 85 10 	movl   $0x801085cf,0x4(%esp)
80100a9a:	80 
80100a9b:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100aa2:	e8 bf 44 00 00       	call   80104f66 <initlock>
  initlock(&input.lock, "input");
80100aa7:	c7 44 24 04 d7 85 10 	movl   $0x801085d7,0x4(%esp)
80100aae:	80 
80100aaf:	c7 04 24 a0 dd 10 80 	movl   $0x8010dda0,(%esp)
80100ab6:	e8 ab 44 00 00       	call   80104f66 <initlock>

  devsw[CONSOLE].write = consolewrite;
80100abb:	c7 05 0c e8 10 80 26 	movl   $0x80100a26,0x8010e80c
80100ac2:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ac5:	c7 05 08 e8 10 80 25 	movl   $0x80100925,0x8010e808
80100acc:	09 10 80 
  cons.locking = 1;
80100acf:	c7 05 f4 b5 10 80 01 	movl   $0x1,0x8010b5f4
80100ad6:	00 00 00 

  picenable(IRQ_KBD);
80100ad9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ae0:	e8 dc 2f 00 00       	call   80103ac1 <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ae5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100aec:	00 
80100aed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100af4:	e8 7d 1e 00 00       	call   80102976 <ioapicenable>
}
80100af9:	c9                   	leave  
80100afa:	c3                   	ret    
	...

80100afc <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100afc:	55                   	push   %ebp
80100afd:	89 e5                	mov    %esp,%ebp
80100aff:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  if((ip = namei(path)) == 0)
80100b05:	8b 45 08             	mov    0x8(%ebp),%eax
80100b08:	89 04 24             	mov    %eax,(%esp)
80100b0b:	e8 fa 18 00 00       	call   8010240a <namei>
80100b10:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b13:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b17:	75 0a                	jne    80100b23 <exec+0x27>
    return -1;
80100b19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b1e:	e9 da 03 00 00       	jmp    80100efd <exec+0x401>
  ilock(ip);
80100b23:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 3a 0d 00 00       	call   80101868 <ilock>
  pgdir = 0;
80100b2e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b35:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b3c:	00 
80100b3d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b44:	00 
80100b45:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100b4b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b4f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b52:	89 04 24             	mov    %eax,(%esp)
80100b55:	e8 04 12 00 00       	call   80101d5e <readi>
80100b5a:	83 f8 33             	cmp    $0x33,%eax
80100b5d:	0f 86 54 03 00 00    	jbe    80100eb7 <exec+0x3bb>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100b63:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b69:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b6e:	0f 85 46 03 00 00    	jne    80100eba <exec+0x3be>
    goto bad;

  if((pgdir = setupkvm(kalloc)) == 0)
80100b74:	c7 04 24 ff 2a 10 80 	movl   $0x80102aff,(%esp)
80100b7b:	e8 ad 71 00 00       	call   80107d2d <setupkvm>
80100b80:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b83:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b87:	0f 84 30 03 00 00    	je     80100ebd <exec+0x3c1>
    goto bad;

  // Load program into memory.
  sz = 0;
80100b8d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b94:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100b9b:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100ba1:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ba4:	e9 c5 00 00 00       	jmp    80100c6e <exec+0x172>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100ba9:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100bac:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bb3:	00 
80100bb4:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bb8:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bc2:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 91 11 00 00       	call   80101d5e <readi>
80100bcd:	83 f8 20             	cmp    $0x20,%eax
80100bd0:	0f 85 ea 02 00 00    	jne    80100ec0 <exec+0x3c4>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100bd6:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100bdc:	83 f8 01             	cmp    $0x1,%eax
80100bdf:	75 7f                	jne    80100c60 <exec+0x164>
      continue;
    if(ph.memsz < ph.filesz)
80100be1:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100be7:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100bed:	39 c2                	cmp    %eax,%edx
80100bef:	0f 82 ce 02 00 00    	jb     80100ec3 <exec+0x3c7>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bf5:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100bfb:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c01:	01 d0                	add    %edx,%eax
80100c03:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c07:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c0a:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c0e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c11:	89 04 24             	mov    %eax,(%esp)
80100c14:	e8 e6 74 00 00       	call   801080ff <allocuvm>
80100c19:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c1c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c20:	0f 84 a0 02 00 00    	je     80100ec6 <exec+0x3ca>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c26:	8b 8d fc fe ff ff    	mov    -0x104(%ebp),%ecx
80100c2c:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c32:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c38:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c3c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c40:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c43:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c47:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c4b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c4e:	89 04 24             	mov    %eax,(%esp)
80100c51:	e8 ba 73 00 00       	call   80108010 <loaduvm>
80100c56:	85 c0                	test   %eax,%eax
80100c58:	0f 88 6b 02 00 00    	js     80100ec9 <exec+0x3cd>
80100c5e:	eb 01                	jmp    80100c61 <exec+0x165>
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
      continue;
80100c60:	90                   	nop
  if((pgdir = setupkvm(kalloc)) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c61:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c65:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c68:	83 c0 20             	add    $0x20,%eax
80100c6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c6e:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100c75:	0f b7 c0             	movzwl %ax,%eax
80100c78:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c7b:	0f 8f 28 ff ff ff    	jg     80100ba9 <exec+0xad>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100c81:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c84:	89 04 24             	mov    %eax,(%esp)
80100c87:	e8 60 0e 00 00       	call   80101aec <iunlockput>
  ip = 0;
80100c8c:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100c93:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c96:	05 ff 0f 00 00       	add    $0xfff,%eax
80100c9b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100ca0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ca3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ca6:	05 00 20 00 00       	add    $0x2000,%eax
80100cab:	89 44 24 08          	mov    %eax,0x8(%esp)
80100caf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cb2:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cb6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cb9:	89 04 24             	mov    %eax,(%esp)
80100cbc:	e8 3e 74 00 00       	call   801080ff <allocuvm>
80100cc1:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cc4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cc8:	0f 84 fe 01 00 00    	je     80100ecc <exec+0x3d0>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cce:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cd1:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cda:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cdd:	89 04 24             	mov    %eax,(%esp)
80100ce0:	e8 3e 76 00 00       	call   80108323 <clearpteu>
  sp = sz;
80100ce5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ce8:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100ceb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100cf2:	e9 81 00 00 00       	jmp    80100d78 <exec+0x27c>
    if(argc >= MAXARG)
80100cf7:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100cfb:	0f 87 ce 01 00 00    	ja     80100ecf <exec+0x3d3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d01:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d04:	c1 e0 02             	shl    $0x2,%eax
80100d07:	03 45 0c             	add    0xc(%ebp),%eax
80100d0a:	8b 00                	mov    (%eax),%eax
80100d0c:	89 04 24             	mov    %eax,(%esp)
80100d0f:	e8 40 47 00 00       	call   80105454 <strlen>
80100d14:	f7 d0                	not    %eax
80100d16:	03 45 dc             	add    -0x24(%ebp),%eax
80100d19:	83 e0 fc             	and    $0xfffffffc,%eax
80100d1c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d22:	c1 e0 02             	shl    $0x2,%eax
80100d25:	03 45 0c             	add    0xc(%ebp),%eax
80100d28:	8b 00                	mov    (%eax),%eax
80100d2a:	89 04 24             	mov    %eax,(%esp)
80100d2d:	e8 22 47 00 00       	call   80105454 <strlen>
80100d32:	83 c0 01             	add    $0x1,%eax
80100d35:	89 c2                	mov    %eax,%edx
80100d37:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d3a:	c1 e0 02             	shl    $0x2,%eax
80100d3d:	03 45 0c             	add    0xc(%ebp),%eax
80100d40:	8b 00                	mov    (%eax),%eax
80100d42:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d46:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d51:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d54:	89 04 24             	mov    %eax,(%esp)
80100d57:	e8 7b 77 00 00       	call   801084d7 <copyout>
80100d5c:	85 c0                	test   %eax,%eax
80100d5e:	0f 88 6e 01 00 00    	js     80100ed2 <exec+0x3d6>
      goto bad;
    ustack[3+argc] = sp;
80100d64:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d67:	8d 50 03             	lea    0x3(%eax),%edx
80100d6a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d6d:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d74:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100d78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d7b:	c1 e0 02             	shl    $0x2,%eax
80100d7e:	03 45 0c             	add    0xc(%ebp),%eax
80100d81:	8b 00                	mov    (%eax),%eax
80100d83:	85 c0                	test   %eax,%eax
80100d85:	0f 85 6c ff ff ff    	jne    80100cf7 <exec+0x1fb>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100d8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d8e:	83 c0 03             	add    $0x3,%eax
80100d91:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100d98:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100d9c:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100da3:	ff ff ff 
  ustack[1] = argc;
80100da6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100da9:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100daf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db2:	83 c0 01             	add    $0x1,%eax
80100db5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dbc:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100dbf:	29 d0                	sub    %edx,%eax
80100dc1:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100dc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dca:	83 c0 04             	add    $0x4,%eax
80100dcd:	c1 e0 02             	shl    $0x2,%eax
80100dd0:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dd3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd6:	83 c0 04             	add    $0x4,%eax
80100dd9:	c1 e0 02             	shl    $0x2,%eax
80100ddc:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100de0:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100de6:	89 44 24 08          	mov    %eax,0x8(%esp)
80100dea:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100ded:	89 44 24 04          	mov    %eax,0x4(%esp)
80100df1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100df4:	89 04 24             	mov    %eax,(%esp)
80100df7:	e8 db 76 00 00       	call   801084d7 <copyout>
80100dfc:	85 c0                	test   %eax,%eax
80100dfe:	0f 88 d1 00 00 00    	js     80100ed5 <exec+0x3d9>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e04:	8b 45 08             	mov    0x8(%ebp),%eax
80100e07:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e10:	eb 17                	jmp    80100e29 <exec+0x32d>
    if(*s == '/')
80100e12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e15:	0f b6 00             	movzbl (%eax),%eax
80100e18:	3c 2f                	cmp    $0x2f,%al
80100e1a:	75 09                	jne    80100e25 <exec+0x329>
      last = s+1;
80100e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e1f:	83 c0 01             	add    $0x1,%eax
80100e22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e25:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e29:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e2c:	0f b6 00             	movzbl (%eax),%eax
80100e2f:	84 c0                	test   %al,%al
80100e31:	75 df                	jne    80100e12 <exec+0x316>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e33:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e39:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e3c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100e43:	00 
80100e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100e47:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e4b:	89 14 24             	mov    %edx,(%esp)
80100e4e:	e8 b3 45 00 00       	call   80105406 <safestrcpy>

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100e53:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e59:	8b 40 04             	mov    0x4(%eax),%eax
80100e5c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100e5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e65:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100e68:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100e6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e71:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100e74:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100e76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e7c:	8b 40 18             	mov    0x18(%eax),%eax
80100e7f:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100e85:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100e88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e8e:	8b 40 18             	mov    0x18(%eax),%eax
80100e91:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100e94:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100e97:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e9d:	89 04 24             	mov    %eax,(%esp)
80100ea0:	e8 79 6f 00 00       	call   80107e1e <switchuvm>
  freevm(oldpgdir);
80100ea5:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ea8:	89 04 24             	mov    %eax,(%esp)
80100eab:	e8 e5 73 00 00       	call   80108295 <freevm>
  return 0;
80100eb0:	b8 00 00 00 00       	mov    $0x0,%eax
80100eb5:	eb 46                	jmp    80100efd <exec+0x401>
  ilock(ip);
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
    goto bad;
80100eb7:	90                   	nop
80100eb8:	eb 1c                	jmp    80100ed6 <exec+0x3da>
  if(elf.magic != ELF_MAGIC)
    goto bad;
80100eba:	90                   	nop
80100ebb:	eb 19                	jmp    80100ed6 <exec+0x3da>

  if((pgdir = setupkvm(kalloc)) == 0)
    goto bad;
80100ebd:	90                   	nop
80100ebe:	eb 16                	jmp    80100ed6 <exec+0x3da>

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
      goto bad;
80100ec0:	90                   	nop
80100ec1:	eb 13                	jmp    80100ed6 <exec+0x3da>
    if(ph.type != ELF_PROG_LOAD)
      continue;
    if(ph.memsz < ph.filesz)
      goto bad;
80100ec3:	90                   	nop
80100ec4:	eb 10                	jmp    80100ed6 <exec+0x3da>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
      goto bad;
80100ec6:	90                   	nop
80100ec7:	eb 0d                	jmp    80100ed6 <exec+0x3da>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
80100ec9:	90                   	nop
80100eca:	eb 0a                	jmp    80100ed6 <exec+0x3da>

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
80100ecc:	90                   	nop
80100ecd:	eb 07                	jmp    80100ed6 <exec+0x3da>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
80100ecf:	90                   	nop
80100ed0:	eb 04                	jmp    80100ed6 <exec+0x3da>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
80100ed2:	90                   	nop
80100ed3:	eb 01                	jmp    80100ed6 <exec+0x3da>
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;
80100ed5:	90                   	nop
  switchuvm(proc);
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
80100ed6:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100eda:	74 0b                	je     80100ee7 <exec+0x3eb>
    freevm(pgdir);
80100edc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100edf:	89 04 24             	mov    %eax,(%esp)
80100ee2:	e8 ae 73 00 00       	call   80108295 <freevm>
  if(ip)
80100ee7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100eeb:	74 0b                	je     80100ef8 <exec+0x3fc>
    iunlockput(ip);
80100eed:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100ef0:	89 04 24             	mov    %eax,(%esp)
80100ef3:	e8 f4 0b 00 00       	call   80101aec <iunlockput>
  return -1;
80100ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100efd:	c9                   	leave  
80100efe:	c3                   	ret    
	...

80100f00 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f06:	c7 44 24 04 dd 85 10 	movl   $0x801085dd,0x4(%esp)
80100f0d:	80 
80100f0e:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f15:	e8 4c 40 00 00       	call   80104f66 <initlock>
}
80100f1a:	c9                   	leave  
80100f1b:	c3                   	ret    

80100f1c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f1c:	55                   	push   %ebp
80100f1d:	89 e5                	mov    %esp,%ebp
80100f1f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f22:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f29:	e8 59 40 00 00       	call   80104f87 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f2e:	c7 45 f4 94 de 10 80 	movl   $0x8010de94,-0xc(%ebp)
80100f35:	eb 29                	jmp    80100f60 <filealloc+0x44>
    if(f->ref == 0){
80100f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f3a:	8b 40 04             	mov    0x4(%eax),%eax
80100f3d:	85 c0                	test   %eax,%eax
80100f3f:	75 1b                	jne    80100f5c <filealloc+0x40>
      f->ref = 1;
80100f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f44:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f4b:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f52:	e8 92 40 00 00       	call   80104fe9 <release>
      return f;
80100f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f5a:	eb 1e                	jmp    80100f7a <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f5c:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100f60:	81 7d f4 f4 e7 10 80 	cmpl   $0x8010e7f4,-0xc(%ebp)
80100f67:	72 ce                	jb     80100f37 <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100f69:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f70:	e8 74 40 00 00       	call   80104fe9 <release>
  return 0;
80100f75:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100f7a:	c9                   	leave  
80100f7b:	c3                   	ret    

80100f7c <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f7c:	55                   	push   %ebp
80100f7d:	89 e5                	mov    %esp,%ebp
80100f7f:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100f82:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100f89:	e8 f9 3f 00 00       	call   80104f87 <acquire>
  if(f->ref < 1)
80100f8e:	8b 45 08             	mov    0x8(%ebp),%eax
80100f91:	8b 40 04             	mov    0x4(%eax),%eax
80100f94:	85 c0                	test   %eax,%eax
80100f96:	7f 0c                	jg     80100fa4 <filedup+0x28>
    panic("filedup");
80100f98:	c7 04 24 e4 85 10 80 	movl   $0x801085e4,(%esp)
80100f9f:	e8 99 f5 ff ff       	call   8010053d <panic>
  f->ref++;
80100fa4:	8b 45 08             	mov    0x8(%ebp),%eax
80100fa7:	8b 40 04             	mov    0x4(%eax),%eax
80100faa:	8d 50 01             	lea    0x1(%eax),%edx
80100fad:	8b 45 08             	mov    0x8(%ebp),%eax
80100fb0:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100fb3:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fba:	e8 2a 40 00 00       	call   80104fe9 <release>
  return f;
80100fbf:	8b 45 08             	mov    0x8(%ebp),%eax
}
80100fc2:	c9                   	leave  
80100fc3:	c3                   	ret    

80100fc4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100fc4:	55                   	push   %ebp
80100fc5:	89 e5                	mov    %esp,%ebp
80100fc7:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
80100fca:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80100fd1:	e8 b1 3f 00 00       	call   80104f87 <acquire>
  if(f->ref < 1)
80100fd6:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd9:	8b 40 04             	mov    0x4(%eax),%eax
80100fdc:	85 c0                	test   %eax,%eax
80100fde:	7f 0c                	jg     80100fec <fileclose+0x28>
    panic("fileclose");
80100fe0:	c7 04 24 ec 85 10 80 	movl   $0x801085ec,(%esp)
80100fe7:	e8 51 f5 ff ff       	call   8010053d <panic>
  if(--f->ref > 0){
80100fec:	8b 45 08             	mov    0x8(%ebp),%eax
80100fef:	8b 40 04             	mov    0x4(%eax),%eax
80100ff2:	8d 50 ff             	lea    -0x1(%eax),%edx
80100ff5:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff8:	89 50 04             	mov    %edx,0x4(%eax)
80100ffb:	8b 45 08             	mov    0x8(%ebp),%eax
80100ffe:	8b 40 04             	mov    0x4(%eax),%eax
80101001:	85 c0                	test   %eax,%eax
80101003:	7e 11                	jle    80101016 <fileclose+0x52>
    release(&ftable.lock);
80101005:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
8010100c:	e8 d8 3f 00 00       	call   80104fe9 <release>
    return;
80101011:	e9 82 00 00 00       	jmp    80101098 <fileclose+0xd4>
  }
  ff = *f;
80101016:	8b 45 08             	mov    0x8(%ebp),%eax
80101019:	8b 10                	mov    (%eax),%edx
8010101b:	89 55 e0             	mov    %edx,-0x20(%ebp)
8010101e:	8b 50 04             	mov    0x4(%eax),%edx
80101021:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101024:	8b 50 08             	mov    0x8(%eax),%edx
80101027:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010102a:	8b 50 0c             	mov    0xc(%eax),%edx
8010102d:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101030:	8b 50 10             	mov    0x10(%eax),%edx
80101033:	89 55 f0             	mov    %edx,-0x10(%ebp)
80101036:	8b 40 14             	mov    0x14(%eax),%eax
80101039:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
8010103c:	8b 45 08             	mov    0x8(%ebp),%eax
8010103f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101046:	8b 45 08             	mov    0x8(%ebp),%eax
80101049:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
8010104f:	c7 04 24 60 de 10 80 	movl   $0x8010de60,(%esp)
80101056:	e8 8e 3f 00 00       	call   80104fe9 <release>
  
  if(ff.type == FD_PIPE)
8010105b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010105e:	83 f8 01             	cmp    $0x1,%eax
80101061:	75 18                	jne    8010107b <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
80101063:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
80101067:	0f be d0             	movsbl %al,%edx
8010106a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010106d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101071:	89 04 24             	mov    %eax,(%esp)
80101074:	e8 02 2d 00 00       	call   80103d7b <pipeclose>
80101079:	eb 1d                	jmp    80101098 <fileclose+0xd4>
  else if(ff.type == FD_INODE){
8010107b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010107e:	83 f8 02             	cmp    $0x2,%eax
80101081:	75 15                	jne    80101098 <fileclose+0xd4>
    begin_trans();
80101083:	e8 95 21 00 00       	call   8010321d <begin_trans>
    iput(ff.ip);
80101088:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010108b:	89 04 24             	mov    %eax,(%esp)
8010108e:	e8 88 09 00 00       	call   80101a1b <iput>
    commit_trans();
80101093:	e8 ce 21 00 00       	call   80103266 <commit_trans>
  }
}
80101098:	c9                   	leave  
80101099:	c3                   	ret    

8010109a <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
8010109a:	55                   	push   %ebp
8010109b:	89 e5                	mov    %esp,%ebp
8010109d:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010a0:	8b 45 08             	mov    0x8(%ebp),%eax
801010a3:	8b 00                	mov    (%eax),%eax
801010a5:	83 f8 02             	cmp    $0x2,%eax
801010a8:	75 38                	jne    801010e2 <filestat+0x48>
    ilock(f->ip);
801010aa:	8b 45 08             	mov    0x8(%ebp),%eax
801010ad:	8b 40 10             	mov    0x10(%eax),%eax
801010b0:	89 04 24             	mov    %eax,(%esp)
801010b3:	e8 b0 07 00 00       	call   80101868 <ilock>
    stati(f->ip, st);
801010b8:	8b 45 08             	mov    0x8(%ebp),%eax
801010bb:	8b 40 10             	mov    0x10(%eax),%eax
801010be:	8b 55 0c             	mov    0xc(%ebp),%edx
801010c1:	89 54 24 04          	mov    %edx,0x4(%esp)
801010c5:	89 04 24             	mov    %eax,(%esp)
801010c8:	e8 4c 0c 00 00       	call   80101d19 <stati>
    iunlock(f->ip);
801010cd:	8b 45 08             	mov    0x8(%ebp),%eax
801010d0:	8b 40 10             	mov    0x10(%eax),%eax
801010d3:	89 04 24             	mov    %eax,(%esp)
801010d6:	e8 db 08 00 00       	call   801019b6 <iunlock>
    return 0;
801010db:	b8 00 00 00 00       	mov    $0x0,%eax
801010e0:	eb 05                	jmp    801010e7 <filestat+0x4d>
  }
  return -1;
801010e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010e7:	c9                   	leave  
801010e8:	c3                   	ret    

801010e9 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010e9:	55                   	push   %ebp
801010ea:	89 e5                	mov    %esp,%ebp
801010ec:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
801010ef:	8b 45 08             	mov    0x8(%ebp),%eax
801010f2:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801010f6:	84 c0                	test   %al,%al
801010f8:	75 0a                	jne    80101104 <fileread+0x1b>
    return -1;
801010fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801010ff:	e9 9f 00 00 00       	jmp    801011a3 <fileread+0xba>
  if(f->type == FD_PIPE)
80101104:	8b 45 08             	mov    0x8(%ebp),%eax
80101107:	8b 00                	mov    (%eax),%eax
80101109:	83 f8 01             	cmp    $0x1,%eax
8010110c:	75 1e                	jne    8010112c <fileread+0x43>
    return piperead(f->pipe, addr, n);
8010110e:	8b 45 08             	mov    0x8(%ebp),%eax
80101111:	8b 40 0c             	mov    0xc(%eax),%eax
80101114:	8b 55 10             	mov    0x10(%ebp),%edx
80101117:	89 54 24 08          	mov    %edx,0x8(%esp)
8010111b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010111e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101122:	89 04 24             	mov    %eax,(%esp)
80101125:	e8 d3 2d 00 00       	call   80103efd <piperead>
8010112a:	eb 77                	jmp    801011a3 <fileread+0xba>
  if(f->type == FD_INODE){
8010112c:	8b 45 08             	mov    0x8(%ebp),%eax
8010112f:	8b 00                	mov    (%eax),%eax
80101131:	83 f8 02             	cmp    $0x2,%eax
80101134:	75 61                	jne    80101197 <fileread+0xae>
    ilock(f->ip);
80101136:	8b 45 08             	mov    0x8(%ebp),%eax
80101139:	8b 40 10             	mov    0x10(%eax),%eax
8010113c:	89 04 24             	mov    %eax,(%esp)
8010113f:	e8 24 07 00 00       	call   80101868 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101144:	8b 4d 10             	mov    0x10(%ebp),%ecx
80101147:	8b 45 08             	mov    0x8(%ebp),%eax
8010114a:	8b 50 14             	mov    0x14(%eax),%edx
8010114d:	8b 45 08             	mov    0x8(%ebp),%eax
80101150:	8b 40 10             	mov    0x10(%eax),%eax
80101153:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80101157:	89 54 24 08          	mov    %edx,0x8(%esp)
8010115b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010115e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101162:	89 04 24             	mov    %eax,(%esp)
80101165:	e8 f4 0b 00 00       	call   80101d5e <readi>
8010116a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010116d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101171:	7e 11                	jle    80101184 <fileread+0x9b>
      f->off += r;
80101173:	8b 45 08             	mov    0x8(%ebp),%eax
80101176:	8b 50 14             	mov    0x14(%eax),%edx
80101179:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010117c:	01 c2                	add    %eax,%edx
8010117e:	8b 45 08             	mov    0x8(%ebp),%eax
80101181:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
80101184:	8b 45 08             	mov    0x8(%ebp),%eax
80101187:	8b 40 10             	mov    0x10(%eax),%eax
8010118a:	89 04 24             	mov    %eax,(%esp)
8010118d:	e8 24 08 00 00       	call   801019b6 <iunlock>
    return r;
80101192:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101195:	eb 0c                	jmp    801011a3 <fileread+0xba>
  }
  panic("fileread");
80101197:	c7 04 24 f6 85 10 80 	movl   $0x801085f6,(%esp)
8010119e:	e8 9a f3 ff ff       	call   8010053d <panic>
}
801011a3:	c9                   	leave  
801011a4:	c3                   	ret    

801011a5 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011a5:	55                   	push   %ebp
801011a6:	89 e5                	mov    %esp,%ebp
801011a8:	53                   	push   %ebx
801011a9:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011ac:	8b 45 08             	mov    0x8(%ebp),%eax
801011af:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011b3:	84 c0                	test   %al,%al
801011b5:	75 0a                	jne    801011c1 <filewrite+0x1c>
    return -1;
801011b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011bc:	e9 23 01 00 00       	jmp    801012e4 <filewrite+0x13f>
  if(f->type == FD_PIPE)
801011c1:	8b 45 08             	mov    0x8(%ebp),%eax
801011c4:	8b 00                	mov    (%eax),%eax
801011c6:	83 f8 01             	cmp    $0x1,%eax
801011c9:	75 21                	jne    801011ec <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
801011cb:	8b 45 08             	mov    0x8(%ebp),%eax
801011ce:	8b 40 0c             	mov    0xc(%eax),%eax
801011d1:	8b 55 10             	mov    0x10(%ebp),%edx
801011d4:	89 54 24 08          	mov    %edx,0x8(%esp)
801011d8:	8b 55 0c             	mov    0xc(%ebp),%edx
801011db:	89 54 24 04          	mov    %edx,0x4(%esp)
801011df:	89 04 24             	mov    %eax,(%esp)
801011e2:	e8 26 2c 00 00       	call   80103e0d <pipewrite>
801011e7:	e9 f8 00 00 00       	jmp    801012e4 <filewrite+0x13f>
  if(f->type == FD_INODE){
801011ec:	8b 45 08             	mov    0x8(%ebp),%eax
801011ef:	8b 00                	mov    (%eax),%eax
801011f1:	83 f8 02             	cmp    $0x2,%eax
801011f4:	0f 85 de 00 00 00    	jne    801012d8 <filewrite+0x133>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801011fa:	c7 45 ec 00 06 00 00 	movl   $0x600,-0x14(%ebp)
    int i = 0;
80101201:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
80101208:	e9 a8 00 00 00       	jmp    801012b5 <filewrite+0x110>
      int n1 = n - i;
8010120d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101210:	8b 55 10             	mov    0x10(%ebp),%edx
80101213:	89 d1                	mov    %edx,%ecx
80101215:	29 c1                	sub    %eax,%ecx
80101217:	89 c8                	mov    %ecx,%eax
80101219:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010121c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010121f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101222:	7e 06                	jle    8010122a <filewrite+0x85>
        n1 = max;
80101224:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101227:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_trans();
8010122a:	e8 ee 1f 00 00       	call   8010321d <begin_trans>
      ilock(f->ip);
8010122f:	8b 45 08             	mov    0x8(%ebp),%eax
80101232:	8b 40 10             	mov    0x10(%eax),%eax
80101235:	89 04 24             	mov    %eax,(%esp)
80101238:	e8 2b 06 00 00       	call   80101868 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010123d:	8b 5d f0             	mov    -0x10(%ebp),%ebx
80101240:	8b 45 08             	mov    0x8(%ebp),%eax
80101243:	8b 48 14             	mov    0x14(%eax),%ecx
80101246:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101249:	89 c2                	mov    %eax,%edx
8010124b:	03 55 0c             	add    0xc(%ebp),%edx
8010124e:	8b 45 08             	mov    0x8(%ebp),%eax
80101251:	8b 40 10             	mov    0x10(%eax),%eax
80101254:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80101258:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010125c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101260:	89 04 24             	mov    %eax,(%esp)
80101263:	e8 61 0c 00 00       	call   80101ec9 <writei>
80101268:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010126b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010126f:	7e 11                	jle    80101282 <filewrite+0xdd>
        f->off += r;
80101271:	8b 45 08             	mov    0x8(%ebp),%eax
80101274:	8b 50 14             	mov    0x14(%eax),%edx
80101277:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010127a:	01 c2                	add    %eax,%edx
8010127c:	8b 45 08             	mov    0x8(%ebp),%eax
8010127f:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101282:	8b 45 08             	mov    0x8(%ebp),%eax
80101285:	8b 40 10             	mov    0x10(%eax),%eax
80101288:	89 04 24             	mov    %eax,(%esp)
8010128b:	e8 26 07 00 00       	call   801019b6 <iunlock>
      commit_trans();
80101290:	e8 d1 1f 00 00       	call   80103266 <commit_trans>

      if(r < 0)
80101295:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101299:	78 28                	js     801012c3 <filewrite+0x11e>
        break;
      if(r != n1)
8010129b:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010129e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012a1:	74 0c                	je     801012af <filewrite+0x10a>
        panic("short filewrite");
801012a3:	c7 04 24 ff 85 10 80 	movl   $0x801085ff,(%esp)
801012aa:	e8 8e f2 ff ff       	call   8010053d <panic>
      i += r;
801012af:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012b2:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012b8:	3b 45 10             	cmp    0x10(%ebp),%eax
801012bb:	0f 8c 4c ff ff ff    	jl     8010120d <filewrite+0x68>
801012c1:	eb 01                	jmp    801012c4 <filewrite+0x11f>
        f->off += r;
      iunlock(f->ip);
      commit_trans();

      if(r < 0)
        break;
801012c3:	90                   	nop
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801012c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012c7:	3b 45 10             	cmp    0x10(%ebp),%eax
801012ca:	75 05                	jne    801012d1 <filewrite+0x12c>
801012cc:	8b 45 10             	mov    0x10(%ebp),%eax
801012cf:	eb 05                	jmp    801012d6 <filewrite+0x131>
801012d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801012d6:	eb 0c                	jmp    801012e4 <filewrite+0x13f>
  }
  panic("filewrite");
801012d8:	c7 04 24 0f 86 10 80 	movl   $0x8010860f,(%esp)
801012df:	e8 59 f2 ff ff       	call   8010053d <panic>
}
801012e4:	83 c4 24             	add    $0x24,%esp
801012e7:	5b                   	pop    %ebx
801012e8:	5d                   	pop    %ebp
801012e9:	c3                   	ret    
	...

801012ec <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801012ec:	55                   	push   %ebp
801012ed:	89 e5                	mov    %esp,%ebp
801012ef:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801012f2:	8b 45 08             	mov    0x8(%ebp),%eax
801012f5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801012fc:	00 
801012fd:	89 04 24             	mov    %eax,(%esp)
80101300:	e8 a1 ee ff ff       	call   801001a6 <bread>
80101305:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101308:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010130b:	83 c0 18             	add    $0x18,%eax
8010130e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80101315:	00 
80101316:	89 44 24 04          	mov    %eax,0x4(%esp)
8010131a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010131d:	89 04 24             	mov    %eax,(%esp)
80101320:	e8 84 3f 00 00       	call   801052a9 <memmove>
  brelse(bp);
80101325:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101328:	89 04 24             	mov    %eax,(%esp)
8010132b:	e8 e7 ee ff ff       	call   80100217 <brelse>
}
80101330:	c9                   	leave  
80101331:	c3                   	ret    

80101332 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101332:	55                   	push   %ebp
80101333:	89 e5                	mov    %esp,%ebp
80101335:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101338:	8b 55 0c             	mov    0xc(%ebp),%edx
8010133b:	8b 45 08             	mov    0x8(%ebp),%eax
8010133e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101342:	89 04 24             	mov    %eax,(%esp)
80101345:	e8 5c ee ff ff       	call   801001a6 <bread>
8010134a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010134d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101350:	83 c0 18             	add    $0x18,%eax
80101353:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010135a:	00 
8010135b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101362:	00 
80101363:	89 04 24             	mov    %eax,(%esp)
80101366:	e8 6b 3e 00 00       	call   801051d6 <memset>
  log_write(bp);
8010136b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010136e:	89 04 24             	mov    %eax,(%esp)
80101371:	e8 48 1f 00 00       	call   801032be <log_write>
  brelse(bp);
80101376:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101379:	89 04 24             	mov    %eax,(%esp)
8010137c:	e8 96 ee ff ff       	call   80100217 <brelse>
}
80101381:	c9                   	leave  
80101382:	c3                   	ret    

80101383 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101383:	55                   	push   %ebp
80101384:	89 e5                	mov    %esp,%ebp
80101386:	53                   	push   %ebx
80101387:	83 ec 34             	sub    $0x34,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
8010138a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
80101391:	8b 45 08             	mov    0x8(%ebp),%eax
80101394:	8d 55 d8             	lea    -0x28(%ebp),%edx
80101397:	89 54 24 04          	mov    %edx,0x4(%esp)
8010139b:	89 04 24             	mov    %eax,(%esp)
8010139e:	e8 49 ff ff ff       	call   801012ec <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013a3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013aa:	e9 11 01 00 00       	jmp    801014c0 <balloc+0x13d>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013b2:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013b8:	85 c0                	test   %eax,%eax
801013ba:	0f 48 c2             	cmovs  %edx,%eax
801013bd:	c1 f8 0c             	sar    $0xc,%eax
801013c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
801013c3:	c1 ea 03             	shr    $0x3,%edx
801013c6:	01 d0                	add    %edx,%eax
801013c8:	83 c0 03             	add    $0x3,%eax
801013cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801013cf:	8b 45 08             	mov    0x8(%ebp),%eax
801013d2:	89 04 24             	mov    %eax,(%esp)
801013d5:	e8 cc ed ff ff       	call   801001a6 <bread>
801013da:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801013e4:	e9 a7 00 00 00       	jmp    80101490 <balloc+0x10d>
      m = 1 << (bi % 8);
801013e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801013ec:	89 c2                	mov    %eax,%edx
801013ee:	c1 fa 1f             	sar    $0x1f,%edx
801013f1:	c1 ea 1d             	shr    $0x1d,%edx
801013f4:	01 d0                	add    %edx,%eax
801013f6:	83 e0 07             	and    $0x7,%eax
801013f9:	29 d0                	sub    %edx,%eax
801013fb:	ba 01 00 00 00       	mov    $0x1,%edx
80101400:	89 d3                	mov    %edx,%ebx
80101402:	89 c1                	mov    %eax,%ecx
80101404:	d3 e3                	shl    %cl,%ebx
80101406:	89 d8                	mov    %ebx,%eax
80101408:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010140b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010140e:	8d 50 07             	lea    0x7(%eax),%edx
80101411:	85 c0                	test   %eax,%eax
80101413:	0f 48 c2             	cmovs  %edx,%eax
80101416:	c1 f8 03             	sar    $0x3,%eax
80101419:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010141c:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101421:	0f b6 c0             	movzbl %al,%eax
80101424:	23 45 e8             	and    -0x18(%ebp),%eax
80101427:	85 c0                	test   %eax,%eax
80101429:	75 61                	jne    8010148c <balloc+0x109>
        bp->data[bi/8] |= m;  // Mark block in use.
8010142b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010142e:	8d 50 07             	lea    0x7(%eax),%edx
80101431:	85 c0                	test   %eax,%eax
80101433:	0f 48 c2             	cmovs  %edx,%eax
80101436:	c1 f8 03             	sar    $0x3,%eax
80101439:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010143c:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101441:	89 d1                	mov    %edx,%ecx
80101443:	8b 55 e8             	mov    -0x18(%ebp),%edx
80101446:	09 ca                	or     %ecx,%edx
80101448:	89 d1                	mov    %edx,%ecx
8010144a:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010144d:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101451:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101454:	89 04 24             	mov    %eax,(%esp)
80101457:	e8 62 1e 00 00       	call   801032be <log_write>
        brelse(bp);
8010145c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010145f:	89 04 24             	mov    %eax,(%esp)
80101462:	e8 b0 ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
80101467:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010146a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010146d:	01 c2                	add    %eax,%edx
8010146f:	8b 45 08             	mov    0x8(%ebp),%eax
80101472:	89 54 24 04          	mov    %edx,0x4(%esp)
80101476:	89 04 24             	mov    %eax,(%esp)
80101479:	e8 b4 fe ff ff       	call   80101332 <bzero>
        return b + bi;
8010147e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101481:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101484:	01 d0                	add    %edx,%eax
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
80101486:	83 c4 34             	add    $0x34,%esp
80101489:	5b                   	pop    %ebx
8010148a:	5d                   	pop    %ebp
8010148b:	c3                   	ret    

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010148c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101490:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
80101497:	7f 15                	jg     801014ae <balloc+0x12b>
80101499:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010149c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010149f:	01 d0                	add    %edx,%eax
801014a1:	89 c2                	mov    %eax,%edx
801014a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014a6:	39 c2                	cmp    %eax,%edx
801014a8:	0f 82 3b ff ff ff    	jb     801013e9 <balloc+0x66>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014b1:	89 04 24             	mov    %eax,(%esp)
801014b4:	e8 5e ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014b9:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014c6:	39 c2                	cmp    %eax,%edx
801014c8:	0f 82 e1 fe ff ff    	jb     801013af <balloc+0x2c>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801014ce:	c7 04 24 19 86 10 80 	movl   $0x80108619,(%esp)
801014d5:	e8 63 f0 ff ff       	call   8010053d <panic>

801014da <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801014da:	55                   	push   %ebp
801014db:	89 e5                	mov    %esp,%ebp
801014dd:	53                   	push   %ebx
801014de:	83 ec 34             	sub    $0x34,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
801014e1:	8d 45 dc             	lea    -0x24(%ebp),%eax
801014e4:	89 44 24 04          	mov    %eax,0x4(%esp)
801014e8:	8b 45 08             	mov    0x8(%ebp),%eax
801014eb:	89 04 24             	mov    %eax,(%esp)
801014ee:	e8 f9 fd ff ff       	call   801012ec <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
801014f3:	8b 45 0c             	mov    0xc(%ebp),%eax
801014f6:	89 c2                	mov    %eax,%edx
801014f8:	c1 ea 0c             	shr    $0xc,%edx
801014fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801014fe:	c1 e8 03             	shr    $0x3,%eax
80101501:	01 d0                	add    %edx,%eax
80101503:	8d 50 03             	lea    0x3(%eax),%edx
80101506:	8b 45 08             	mov    0x8(%ebp),%eax
80101509:	89 54 24 04          	mov    %edx,0x4(%esp)
8010150d:	89 04 24             	mov    %eax,(%esp)
80101510:	e8 91 ec ff ff       	call   801001a6 <bread>
80101515:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
80101518:	8b 45 0c             	mov    0xc(%ebp),%eax
8010151b:	25 ff 0f 00 00       	and    $0xfff,%eax
80101520:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101523:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101526:	89 c2                	mov    %eax,%edx
80101528:	c1 fa 1f             	sar    $0x1f,%edx
8010152b:	c1 ea 1d             	shr    $0x1d,%edx
8010152e:	01 d0                	add    %edx,%eax
80101530:	83 e0 07             	and    $0x7,%eax
80101533:	29 d0                	sub    %edx,%eax
80101535:	ba 01 00 00 00       	mov    $0x1,%edx
8010153a:	89 d3                	mov    %edx,%ebx
8010153c:	89 c1                	mov    %eax,%ecx
8010153e:	d3 e3                	shl    %cl,%ebx
80101540:	89 d8                	mov    %ebx,%eax
80101542:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101545:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101548:	8d 50 07             	lea    0x7(%eax),%edx
8010154b:	85 c0                	test   %eax,%eax
8010154d:	0f 48 c2             	cmovs  %edx,%eax
80101550:	c1 f8 03             	sar    $0x3,%eax
80101553:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101556:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010155b:	0f b6 c0             	movzbl %al,%eax
8010155e:	23 45 ec             	and    -0x14(%ebp),%eax
80101561:	85 c0                	test   %eax,%eax
80101563:	75 0c                	jne    80101571 <bfree+0x97>
    panic("freeing free block");
80101565:	c7 04 24 2f 86 10 80 	movl   $0x8010862f,(%esp)
8010156c:	e8 cc ef ff ff       	call   8010053d <panic>
  bp->data[bi/8] &= ~m;
80101571:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101574:	8d 50 07             	lea    0x7(%eax),%edx
80101577:	85 c0                	test   %eax,%eax
80101579:	0f 48 c2             	cmovs  %edx,%eax
8010157c:	c1 f8 03             	sar    $0x3,%eax
8010157f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101582:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101587:	8b 4d ec             	mov    -0x14(%ebp),%ecx
8010158a:	f7 d1                	not    %ecx
8010158c:	21 ca                	and    %ecx,%edx
8010158e:	89 d1                	mov    %edx,%ecx
80101590:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101593:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
80101597:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010159a:	89 04 24             	mov    %eax,(%esp)
8010159d:	e8 1c 1d 00 00       	call   801032be <log_write>
  brelse(bp);
801015a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015a5:	89 04 24             	mov    %eax,(%esp)
801015a8:	e8 6a ec ff ff       	call   80100217 <brelse>
}
801015ad:	83 c4 34             	add    $0x34,%esp
801015b0:	5b                   	pop    %ebx
801015b1:	5d                   	pop    %ebp
801015b2:	c3                   	ret    

801015b3 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015b3:	55                   	push   %ebp
801015b4:	89 e5                	mov    %esp,%ebp
801015b6:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015b9:	c7 44 24 04 42 86 10 	movl   $0x80108642,0x4(%esp)
801015c0:	80 
801015c1:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801015c8:	e8 99 39 00 00       	call   80104f66 <initlock>
}
801015cd:	c9                   	leave  
801015ce:	c3                   	ret    

801015cf <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015cf:	55                   	push   %ebp
801015d0:	89 e5                	mov    %esp,%ebp
801015d2:	83 ec 48             	sub    $0x48,%esp
801015d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801015d8:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
801015dc:	8b 45 08             	mov    0x8(%ebp),%eax
801015df:	8d 55 dc             	lea    -0x24(%ebp),%edx
801015e2:	89 54 24 04          	mov    %edx,0x4(%esp)
801015e6:	89 04 24             	mov    %eax,(%esp)
801015e9:	e8 fe fc ff ff       	call   801012ec <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
801015ee:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801015f5:	e9 98 00 00 00       	jmp    80101692 <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
801015fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015fd:	c1 e8 03             	shr    $0x3,%eax
80101600:	83 c0 02             	add    $0x2,%eax
80101603:	89 44 24 04          	mov    %eax,0x4(%esp)
80101607:	8b 45 08             	mov    0x8(%ebp),%eax
8010160a:	89 04 24             	mov    %eax,(%esp)
8010160d:	e8 94 eb ff ff       	call   801001a6 <bread>
80101612:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101615:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101618:	8d 50 18             	lea    0x18(%eax),%edx
8010161b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010161e:	83 e0 07             	and    $0x7,%eax
80101621:	c1 e0 06             	shl    $0x6,%eax
80101624:	01 d0                	add    %edx,%eax
80101626:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101629:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010162c:	0f b7 00             	movzwl (%eax),%eax
8010162f:	66 85 c0             	test   %ax,%ax
80101632:	75 4f                	jne    80101683 <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
80101634:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010163b:	00 
8010163c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101643:	00 
80101644:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101647:	89 04 24             	mov    %eax,(%esp)
8010164a:	e8 87 3b 00 00       	call   801051d6 <memset>
      dip->type = type;
8010164f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101652:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
80101656:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101659:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010165c:	89 04 24             	mov    %eax,(%esp)
8010165f:	e8 5a 1c 00 00       	call   801032be <log_write>
      brelse(bp);
80101664:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101667:	89 04 24             	mov    %eax,(%esp)
8010166a:	e8 a8 eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
8010166f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101672:	89 44 24 04          	mov    %eax,0x4(%esp)
80101676:	8b 45 08             	mov    0x8(%ebp),%eax
80101679:	89 04 24             	mov    %eax,(%esp)
8010167c:	e8 e3 00 00 00       	call   80101764 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
80101681:	c9                   	leave  
80101682:	c3                   	ret    
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101683:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101686:	89 04 24             	mov    %eax,(%esp)
80101689:	e8 89 eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
8010168e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101692:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101695:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101698:	39 c2                	cmp    %eax,%edx
8010169a:	0f 82 5a ff ff ff    	jb     801015fa <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016a0:	c7 04 24 49 86 10 80 	movl   $0x80108649,(%esp)
801016a7:	e8 91 ee ff ff       	call   8010053d <panic>

801016ac <iupdate>:
}

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016ac:	55                   	push   %ebp
801016ad:	89 e5                	mov    %esp,%ebp
801016af:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016b2:	8b 45 08             	mov    0x8(%ebp),%eax
801016b5:	8b 40 04             	mov    0x4(%eax),%eax
801016b8:	c1 e8 03             	shr    $0x3,%eax
801016bb:	8d 50 02             	lea    0x2(%eax),%edx
801016be:	8b 45 08             	mov    0x8(%ebp),%eax
801016c1:	8b 00                	mov    (%eax),%eax
801016c3:	89 54 24 04          	mov    %edx,0x4(%esp)
801016c7:	89 04 24             	mov    %eax,(%esp)
801016ca:	e8 d7 ea ff ff       	call   801001a6 <bread>
801016cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016d5:	8d 50 18             	lea    0x18(%eax),%edx
801016d8:	8b 45 08             	mov    0x8(%ebp),%eax
801016db:	8b 40 04             	mov    0x4(%eax),%eax
801016de:	83 e0 07             	and    $0x7,%eax
801016e1:	c1 e0 06             	shl    $0x6,%eax
801016e4:	01 d0                	add    %edx,%eax
801016e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801016e9:	8b 45 08             	mov    0x8(%ebp),%eax
801016ec:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801016f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016f3:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801016f6:	8b 45 08             	mov    0x8(%ebp),%eax
801016f9:	0f b7 50 12          	movzwl 0x12(%eax),%edx
801016fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101700:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101704:	8b 45 08             	mov    0x8(%ebp),%eax
80101707:	0f b7 50 14          	movzwl 0x14(%eax),%edx
8010170b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010170e:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
80101712:	8b 45 08             	mov    0x8(%ebp),%eax
80101715:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101719:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010171c:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101720:	8b 45 08             	mov    0x8(%ebp),%eax
80101723:	8b 50 18             	mov    0x18(%eax),%edx
80101726:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101729:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172c:	8b 45 08             	mov    0x8(%ebp),%eax
8010172f:	8d 50 1c             	lea    0x1c(%eax),%edx
80101732:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101735:	83 c0 0c             	add    $0xc,%eax
80101738:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010173f:	00 
80101740:	89 54 24 04          	mov    %edx,0x4(%esp)
80101744:	89 04 24             	mov    %eax,(%esp)
80101747:	e8 5d 3b 00 00       	call   801052a9 <memmove>
  log_write(bp);
8010174c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010174f:	89 04 24             	mov    %eax,(%esp)
80101752:	e8 67 1b 00 00       	call   801032be <log_write>
  brelse(bp);
80101757:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010175a:	89 04 24             	mov    %eax,(%esp)
8010175d:	e8 b5 ea ff ff       	call   80100217 <brelse>
}
80101762:	c9                   	leave  
80101763:	c3                   	ret    

80101764 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101764:	55                   	push   %ebp
80101765:	89 e5                	mov    %esp,%ebp
80101767:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010176a:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101771:	e8 11 38 00 00       	call   80104f87 <acquire>

  // Is the inode already cached?
  empty = 0;
80101776:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010177d:	c7 45 f4 94 e8 10 80 	movl   $0x8010e894,-0xc(%ebp)
80101784:	eb 59                	jmp    801017df <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101786:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101789:	8b 40 08             	mov    0x8(%eax),%eax
8010178c:	85 c0                	test   %eax,%eax
8010178e:	7e 35                	jle    801017c5 <iget+0x61>
80101790:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101793:	8b 00                	mov    (%eax),%eax
80101795:	3b 45 08             	cmp    0x8(%ebp),%eax
80101798:	75 2b                	jne    801017c5 <iget+0x61>
8010179a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010179d:	8b 40 04             	mov    0x4(%eax),%eax
801017a0:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017a3:	75 20                	jne    801017c5 <iget+0x61>
      ip->ref++;
801017a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017a8:	8b 40 08             	mov    0x8(%eax),%eax
801017ab:	8d 50 01             	lea    0x1(%eax),%edx
801017ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b1:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017b4:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801017bb:	e8 29 38 00 00       	call   80104fe9 <release>
      return ip;
801017c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c3:	eb 6f                	jmp    80101834 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017c9:	75 10                	jne    801017db <iget+0x77>
801017cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ce:	8b 40 08             	mov    0x8(%eax),%eax
801017d1:	85 c0                	test   %eax,%eax
801017d3:	75 06                	jne    801017db <iget+0x77>
      empty = ip;
801017d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d8:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017db:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801017df:	81 7d f4 34 f8 10 80 	cmpl   $0x8010f834,-0xc(%ebp)
801017e6:	72 9e                	jb     80101786 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801017e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017ec:	75 0c                	jne    801017fa <iget+0x96>
    panic("iget: no inodes");
801017ee:	c7 04 24 5b 86 10 80 	movl   $0x8010865b,(%esp)
801017f5:	e8 43 ed ff ff       	call   8010053d <panic>

  ip = empty;
801017fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101800:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101803:	8b 55 08             	mov    0x8(%ebp),%edx
80101806:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101808:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010180b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010180e:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101811:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101814:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
8010181b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010181e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101825:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
8010182c:	e8 b8 37 00 00       	call   80104fe9 <release>

  return ip;
80101831:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101834:	c9                   	leave  
80101835:	c3                   	ret    

80101836 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101836:	55                   	push   %ebp
80101837:	89 e5                	mov    %esp,%ebp
80101839:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
8010183c:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101843:	e8 3f 37 00 00       	call   80104f87 <acquire>
  ip->ref++;
80101848:	8b 45 08             	mov    0x8(%ebp),%eax
8010184b:	8b 40 08             	mov    0x8(%eax),%eax
8010184e:	8d 50 01             	lea    0x1(%eax),%edx
80101851:	8b 45 08             	mov    0x8(%ebp),%eax
80101854:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101857:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
8010185e:	e8 86 37 00 00       	call   80104fe9 <release>
  return ip;
80101863:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101866:	c9                   	leave  
80101867:	c3                   	ret    

80101868 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101868:	55                   	push   %ebp
80101869:	89 e5                	mov    %esp,%ebp
8010186b:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010186e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101872:	74 0a                	je     8010187e <ilock+0x16>
80101874:	8b 45 08             	mov    0x8(%ebp),%eax
80101877:	8b 40 08             	mov    0x8(%eax),%eax
8010187a:	85 c0                	test   %eax,%eax
8010187c:	7f 0c                	jg     8010188a <ilock+0x22>
    panic("ilock");
8010187e:	c7 04 24 6b 86 10 80 	movl   $0x8010866b,(%esp)
80101885:	e8 b3 ec ff ff       	call   8010053d <panic>

  acquire(&icache.lock);
8010188a:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101891:	e8 f1 36 00 00       	call   80104f87 <acquire>
  while(ip->flags & I_BUSY)
80101896:	eb 13                	jmp    801018ab <ilock+0x43>
    sleep(ip, &icache.lock);
80101898:	c7 44 24 04 60 e8 10 	movl   $0x8010e860,0x4(%esp)
8010189f:	80 
801018a0:	8b 45 08             	mov    0x8(%ebp),%eax
801018a3:	89 04 24             	mov    %eax,(%esp)
801018a6:	e8 4e 30 00 00       	call   801048f9 <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018ab:	8b 45 08             	mov    0x8(%ebp),%eax
801018ae:	8b 40 0c             	mov    0xc(%eax),%eax
801018b1:	83 e0 01             	and    $0x1,%eax
801018b4:	84 c0                	test   %al,%al
801018b6:	75 e0                	jne    80101898 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018b8:	8b 45 08             	mov    0x8(%ebp),%eax
801018bb:	8b 40 0c             	mov    0xc(%eax),%eax
801018be:	89 c2                	mov    %eax,%edx
801018c0:	83 ca 01             	or     $0x1,%edx
801018c3:	8b 45 08             	mov    0x8(%ebp),%eax
801018c6:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018c9:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801018d0:	e8 14 37 00 00       	call   80104fe9 <release>

  if(!(ip->flags & I_VALID)){
801018d5:	8b 45 08             	mov    0x8(%ebp),%eax
801018d8:	8b 40 0c             	mov    0xc(%eax),%eax
801018db:	83 e0 02             	and    $0x2,%eax
801018de:	85 c0                	test   %eax,%eax
801018e0:	0f 85 ce 00 00 00    	jne    801019b4 <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
801018e6:	8b 45 08             	mov    0x8(%ebp),%eax
801018e9:	8b 40 04             	mov    0x4(%eax),%eax
801018ec:	c1 e8 03             	shr    $0x3,%eax
801018ef:	8d 50 02             	lea    0x2(%eax),%edx
801018f2:	8b 45 08             	mov    0x8(%ebp),%eax
801018f5:	8b 00                	mov    (%eax),%eax
801018f7:	89 54 24 04          	mov    %edx,0x4(%esp)
801018fb:	89 04 24             	mov    %eax,(%esp)
801018fe:	e8 a3 e8 ff ff       	call   801001a6 <bread>
80101903:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101906:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101909:	8d 50 18             	lea    0x18(%eax),%edx
8010190c:	8b 45 08             	mov    0x8(%ebp),%eax
8010190f:	8b 40 04             	mov    0x4(%eax),%eax
80101912:	83 e0 07             	and    $0x7,%eax
80101915:	c1 e0 06             	shl    $0x6,%eax
80101918:	01 d0                	add    %edx,%eax
8010191a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
8010191d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101920:	0f b7 10             	movzwl (%eax),%edx
80101923:	8b 45 08             	mov    0x8(%ebp),%eax
80101926:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
8010192a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010192d:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101931:	8b 45 08             	mov    0x8(%ebp),%eax
80101934:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101938:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010193b:	0f b7 50 04          	movzwl 0x4(%eax),%edx
8010193f:	8b 45 08             	mov    0x8(%ebp),%eax
80101942:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101946:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101949:	0f b7 50 06          	movzwl 0x6(%eax),%edx
8010194d:	8b 45 08             	mov    0x8(%ebp),%eax
80101950:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101954:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101957:	8b 50 08             	mov    0x8(%eax),%edx
8010195a:	8b 45 08             	mov    0x8(%ebp),%eax
8010195d:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101960:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101963:	8d 50 0c             	lea    0xc(%eax),%edx
80101966:	8b 45 08             	mov    0x8(%ebp),%eax
80101969:	83 c0 1c             	add    $0x1c,%eax
8010196c:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101973:	00 
80101974:	89 54 24 04          	mov    %edx,0x4(%esp)
80101978:	89 04 24             	mov    %eax,(%esp)
8010197b:	e8 29 39 00 00       	call   801052a9 <memmove>
    brelse(bp);
80101980:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101983:	89 04 24             	mov    %eax,(%esp)
80101986:	e8 8c e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
8010198b:	8b 45 08             	mov    0x8(%ebp),%eax
8010198e:	8b 40 0c             	mov    0xc(%eax),%eax
80101991:	89 c2                	mov    %eax,%edx
80101993:	83 ca 02             	or     $0x2,%edx
80101996:	8b 45 08             	mov    0x8(%ebp),%eax
80101999:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
8010199c:	8b 45 08             	mov    0x8(%ebp),%eax
8010199f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019a3:	66 85 c0             	test   %ax,%ax
801019a6:	75 0c                	jne    801019b4 <ilock+0x14c>
      panic("ilock: no type");
801019a8:	c7 04 24 71 86 10 80 	movl   $0x80108671,(%esp)
801019af:	e8 89 eb ff ff       	call   8010053d <panic>
  }
}
801019b4:	c9                   	leave  
801019b5:	c3                   	ret    

801019b6 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019b6:	55                   	push   %ebp
801019b7:	89 e5                	mov    %esp,%ebp
801019b9:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019c0:	74 17                	je     801019d9 <iunlock+0x23>
801019c2:	8b 45 08             	mov    0x8(%ebp),%eax
801019c5:	8b 40 0c             	mov    0xc(%eax),%eax
801019c8:	83 e0 01             	and    $0x1,%eax
801019cb:	85 c0                	test   %eax,%eax
801019cd:	74 0a                	je     801019d9 <iunlock+0x23>
801019cf:	8b 45 08             	mov    0x8(%ebp),%eax
801019d2:	8b 40 08             	mov    0x8(%eax),%eax
801019d5:	85 c0                	test   %eax,%eax
801019d7:	7f 0c                	jg     801019e5 <iunlock+0x2f>
    panic("iunlock");
801019d9:	c7 04 24 80 86 10 80 	movl   $0x80108680,(%esp)
801019e0:	e8 58 eb ff ff       	call   8010053d <panic>

  acquire(&icache.lock);
801019e5:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
801019ec:	e8 96 35 00 00       	call   80104f87 <acquire>
  ip->flags &= ~I_BUSY;
801019f1:	8b 45 08             	mov    0x8(%ebp),%eax
801019f4:	8b 40 0c             	mov    0xc(%eax),%eax
801019f7:	89 c2                	mov    %eax,%edx
801019f9:	83 e2 fe             	and    $0xfffffffe,%edx
801019fc:	8b 45 08             	mov    0x8(%ebp),%eax
801019ff:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a02:	8b 45 08             	mov    0x8(%ebp),%eax
80101a05:	89 04 24             	mov    %eax,(%esp)
80101a08:	e8 c8 2f 00 00       	call   801049d5 <wakeup>
  release(&icache.lock);
80101a0d:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a14:	e8 d0 35 00 00       	call   80104fe9 <release>
}
80101a19:	c9                   	leave  
80101a1a:	c3                   	ret    

80101a1b <iput>:
// be recycled.
// If that was the last reference and the inode has no links
// to it, free the inode (and its content) on disk.
void
iput(struct inode *ip)
{
80101a1b:	55                   	push   %ebp
80101a1c:	89 e5                	mov    %esp,%ebp
80101a1e:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a21:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a28:	e8 5a 35 00 00       	call   80104f87 <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a30:	8b 40 08             	mov    0x8(%eax),%eax
80101a33:	83 f8 01             	cmp    $0x1,%eax
80101a36:	0f 85 93 00 00 00    	jne    80101acf <iput+0xb4>
80101a3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3f:	8b 40 0c             	mov    0xc(%eax),%eax
80101a42:	83 e0 02             	and    $0x2,%eax
80101a45:	85 c0                	test   %eax,%eax
80101a47:	0f 84 82 00 00 00    	je     80101acf <iput+0xb4>
80101a4d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a50:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a54:	66 85 c0             	test   %ax,%ax
80101a57:	75 76                	jne    80101acf <iput+0xb4>
    // inode has no links: truncate and free inode.
    if(ip->flags & I_BUSY)
80101a59:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5c:	8b 40 0c             	mov    0xc(%eax),%eax
80101a5f:	83 e0 01             	and    $0x1,%eax
80101a62:	84 c0                	test   %al,%al
80101a64:	74 0c                	je     80101a72 <iput+0x57>
      panic("iput busy");
80101a66:	c7 04 24 88 86 10 80 	movl   $0x80108688,(%esp)
80101a6d:	e8 cb ea ff ff       	call   8010053d <panic>
    ip->flags |= I_BUSY;
80101a72:	8b 45 08             	mov    0x8(%ebp),%eax
80101a75:	8b 40 0c             	mov    0xc(%eax),%eax
80101a78:	89 c2                	mov    %eax,%edx
80101a7a:	83 ca 01             	or     $0x1,%edx
80101a7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101a80:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101a83:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101a8a:	e8 5a 35 00 00       	call   80104fe9 <release>
    itrunc(ip);
80101a8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a92:	89 04 24             	mov    %eax,(%esp)
80101a95:	e8 72 01 00 00       	call   80101c0c <itrunc>
    ip->type = 0;
80101a9a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9d:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa6:	89 04 24             	mov    %eax,(%esp)
80101aa9:	e8 fe fb ff ff       	call   801016ac <iupdate>
    acquire(&icache.lock);
80101aae:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101ab5:	e8 cd 34 00 00       	call   80104f87 <acquire>
    ip->flags = 0;
80101aba:	8b 45 08             	mov    0x8(%ebp),%eax
80101abd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac7:	89 04 24             	mov    %eax,(%esp)
80101aca:	e8 06 2f 00 00       	call   801049d5 <wakeup>
  }
  ip->ref--;
80101acf:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad2:	8b 40 08             	mov    0x8(%eax),%eax
80101ad5:	8d 50 ff             	lea    -0x1(%eax),%edx
80101ad8:	8b 45 08             	mov    0x8(%ebp),%eax
80101adb:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101ade:	c7 04 24 60 e8 10 80 	movl   $0x8010e860,(%esp)
80101ae5:	e8 ff 34 00 00       	call   80104fe9 <release>
}
80101aea:	c9                   	leave  
80101aeb:	c3                   	ret    

80101aec <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101aec:	55                   	push   %ebp
80101aed:	89 e5                	mov    %esp,%ebp
80101aef:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101af2:	8b 45 08             	mov    0x8(%ebp),%eax
80101af5:	89 04 24             	mov    %eax,(%esp)
80101af8:	e8 b9 fe ff ff       	call   801019b6 <iunlock>
  iput(ip);
80101afd:	8b 45 08             	mov    0x8(%ebp),%eax
80101b00:	89 04 24             	mov    %eax,(%esp)
80101b03:	e8 13 ff ff ff       	call   80101a1b <iput>
}
80101b08:	c9                   	leave  
80101b09:	c3                   	ret    

80101b0a <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b0a:	55                   	push   %ebp
80101b0b:	89 e5                	mov    %esp,%ebp
80101b0d:	53                   	push   %ebx
80101b0e:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b11:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b15:	77 3e                	ja     80101b55 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b17:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b1d:	83 c2 04             	add    $0x4,%edx
80101b20:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b24:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b27:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b2b:	75 20                	jne    80101b4d <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b2d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b30:	8b 00                	mov    (%eax),%eax
80101b32:	89 04 24             	mov    %eax,(%esp)
80101b35:	e8 49 f8 ff ff       	call   80101383 <balloc>
80101b3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b40:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b43:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b46:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b49:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b50:	e9 b1 00 00 00       	jmp    80101c06 <bmap+0xfc>
  }
  bn -= NDIRECT;
80101b55:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b59:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b5d:	0f 87 97 00 00 00    	ja     80101bfa <bmap+0xf0>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b63:	8b 45 08             	mov    0x8(%ebp),%eax
80101b66:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b69:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b70:	75 19                	jne    80101b8b <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b72:	8b 45 08             	mov    0x8(%ebp),%eax
80101b75:	8b 00                	mov    (%eax),%eax
80101b77:	89 04 24             	mov    %eax,(%esp)
80101b7a:	e8 04 f8 ff ff       	call   80101383 <balloc>
80101b7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b82:	8b 45 08             	mov    0x8(%ebp),%eax
80101b85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b88:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101b8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101b8e:	8b 00                	mov    (%eax),%eax
80101b90:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b93:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b97:	89 04 24             	mov    %eax,(%esp)
80101b9a:	e8 07 e6 ff ff       	call   801001a6 <bread>
80101b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ba5:	83 c0 18             	add    $0x18,%eax
80101ba8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101bab:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bae:	c1 e0 02             	shl    $0x2,%eax
80101bb1:	03 45 ec             	add    -0x14(%ebp),%eax
80101bb4:	8b 00                	mov    (%eax),%eax
80101bb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bb9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bbd:	75 2b                	jne    80101bea <bmap+0xe0>
      a[bn] = addr = balloc(ip->dev);
80101bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bc2:	c1 e0 02             	shl    $0x2,%eax
80101bc5:	89 c3                	mov    %eax,%ebx
80101bc7:	03 5d ec             	add    -0x14(%ebp),%ebx
80101bca:	8b 45 08             	mov    0x8(%ebp),%eax
80101bcd:	8b 00                	mov    (%eax),%eax
80101bcf:	89 04 24             	mov    %eax,(%esp)
80101bd2:	e8 ac f7 ff ff       	call   80101383 <balloc>
80101bd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bdd:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101bdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101be2:	89 04 24             	mov    %eax,(%esp)
80101be5:	e8 d4 16 00 00       	call   801032be <log_write>
    }
    brelse(bp);
80101bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bed:	89 04 24             	mov    %eax,(%esp)
80101bf0:	e8 22 e6 ff ff       	call   80100217 <brelse>
    return addr;
80101bf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101bf8:	eb 0c                	jmp    80101c06 <bmap+0xfc>
  }

  panic("bmap: out of range");
80101bfa:	c7 04 24 92 86 10 80 	movl   $0x80108692,(%esp)
80101c01:	e8 37 e9 ff ff       	call   8010053d <panic>
}
80101c06:	83 c4 24             	add    $0x24,%esp
80101c09:	5b                   	pop    %ebx
80101c0a:	5d                   	pop    %ebp
80101c0b:	c3                   	ret    

80101c0c <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c0c:	55                   	push   %ebp
80101c0d:	89 e5                	mov    %esp,%ebp
80101c0f:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c19:	eb 44                	jmp    80101c5f <itrunc+0x53>
    if(ip->addrs[i]){
80101c1b:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c21:	83 c2 04             	add    $0x4,%edx
80101c24:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c28:	85 c0                	test   %eax,%eax
80101c2a:	74 2f                	je     80101c5b <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c2c:	8b 45 08             	mov    0x8(%ebp),%eax
80101c2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c32:	83 c2 04             	add    $0x4,%edx
80101c35:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c39:	8b 45 08             	mov    0x8(%ebp),%eax
80101c3c:	8b 00                	mov    (%eax),%eax
80101c3e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c42:	89 04 24             	mov    %eax,(%esp)
80101c45:	e8 90 f8 ff ff       	call   801014da <bfree>
      ip->addrs[i] = 0;
80101c4a:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c50:	83 c2 04             	add    $0x4,%edx
80101c53:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c5a:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c5b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101c5f:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101c63:	7e b6                	jle    80101c1b <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101c65:	8b 45 08             	mov    0x8(%ebp),%eax
80101c68:	8b 40 4c             	mov    0x4c(%eax),%eax
80101c6b:	85 c0                	test   %eax,%eax
80101c6d:	0f 84 8f 00 00 00    	je     80101d02 <itrunc+0xf6>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101c73:	8b 45 08             	mov    0x8(%ebp),%eax
80101c76:	8b 50 4c             	mov    0x4c(%eax),%edx
80101c79:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7c:	8b 00                	mov    (%eax),%eax
80101c7e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c82:	89 04 24             	mov    %eax,(%esp)
80101c85:	e8 1c e5 ff ff       	call   801001a6 <bread>
80101c8a:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101c90:	83 c0 18             	add    $0x18,%eax
80101c93:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101c96:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101c9d:	eb 2f                	jmp    80101cce <itrunc+0xc2>
      if(a[j])
80101c9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ca2:	c1 e0 02             	shl    $0x2,%eax
80101ca5:	03 45 e8             	add    -0x18(%ebp),%eax
80101ca8:	8b 00                	mov    (%eax),%eax
80101caa:	85 c0                	test   %eax,%eax
80101cac:	74 1c                	je     80101cca <itrunc+0xbe>
        bfree(ip->dev, a[j]);
80101cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cb1:	c1 e0 02             	shl    $0x2,%eax
80101cb4:	03 45 e8             	add    -0x18(%ebp),%eax
80101cb7:	8b 10                	mov    (%eax),%edx
80101cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cbc:	8b 00                	mov    (%eax),%eax
80101cbe:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cc2:	89 04 24             	mov    %eax,(%esp)
80101cc5:	e8 10 f8 ff ff       	call   801014da <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101cca:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cd1:	83 f8 7f             	cmp    $0x7f,%eax
80101cd4:	76 c9                	jbe    80101c9f <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101cd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cd9:	89 04 24             	mov    %eax,(%esp)
80101cdc:	e8 36 e5 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101ce1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ce4:	8b 50 4c             	mov    0x4c(%eax),%edx
80101ce7:	8b 45 08             	mov    0x8(%ebp),%eax
80101cea:	8b 00                	mov    (%eax),%eax
80101cec:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cf0:	89 04 24             	mov    %eax,(%esp)
80101cf3:	e8 e2 f7 ff ff       	call   801014da <bfree>
    ip->addrs[NDIRECT] = 0;
80101cf8:	8b 45 08             	mov    0x8(%ebp),%eax
80101cfb:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d02:	8b 45 08             	mov    0x8(%ebp),%eax
80101d05:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d0f:	89 04 24             	mov    %eax,(%esp)
80101d12:	e8 95 f9 ff ff       	call   801016ac <iupdate>
}
80101d17:	c9                   	leave  
80101d18:	c3                   	ret    

80101d19 <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d19:	55                   	push   %ebp
80101d1a:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d1f:	8b 00                	mov    (%eax),%eax
80101d21:	89 c2                	mov    %eax,%edx
80101d23:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d26:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d29:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2c:	8b 50 04             	mov    0x4(%eax),%edx
80101d2f:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d32:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d35:	8b 45 08             	mov    0x8(%ebp),%eax
80101d38:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d3f:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d42:	8b 45 08             	mov    0x8(%ebp),%eax
80101d45:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d49:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d4c:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d50:	8b 45 08             	mov    0x8(%ebp),%eax
80101d53:	8b 50 18             	mov    0x18(%eax),%edx
80101d56:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d59:	89 50 10             	mov    %edx,0x10(%eax)
}
80101d5c:	5d                   	pop    %ebp
80101d5d:	c3                   	ret    

80101d5e <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101d5e:	55                   	push   %ebp
80101d5f:	89 e5                	mov    %esp,%ebp
80101d61:	53                   	push   %ebx
80101d62:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101d65:	8b 45 08             	mov    0x8(%ebp),%eax
80101d68:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101d6c:	66 83 f8 03          	cmp    $0x3,%ax
80101d70:	75 60                	jne    80101dd2 <readi+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101d72:	8b 45 08             	mov    0x8(%ebp),%eax
80101d75:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d79:	66 85 c0             	test   %ax,%ax
80101d7c:	78 20                	js     80101d9e <readi+0x40>
80101d7e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d81:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d85:	66 83 f8 09          	cmp    $0x9,%ax
80101d89:	7f 13                	jg     80101d9e <readi+0x40>
80101d8b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d8e:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101d92:	98                   	cwtl   
80101d93:	8b 04 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%eax
80101d9a:	85 c0                	test   %eax,%eax
80101d9c:	75 0a                	jne    80101da8 <readi+0x4a>
      return -1;
80101d9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101da3:	e9 1b 01 00 00       	jmp    80101ec3 <readi+0x165>
    return devsw[ip->major].read(ip, dst, n);
80101da8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dab:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101daf:	98                   	cwtl   
80101db0:	8b 14 c5 00 e8 10 80 	mov    -0x7fef1800(,%eax,8),%edx
80101db7:	8b 45 14             	mov    0x14(%ebp),%eax
80101dba:	89 44 24 08          	mov    %eax,0x8(%esp)
80101dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
80101dc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101dc5:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc8:	89 04 24             	mov    %eax,(%esp)
80101dcb:	ff d2                	call   *%edx
80101dcd:	e9 f1 00 00 00       	jmp    80101ec3 <readi+0x165>
  }

  if(off > ip->size || off + n < off)
80101dd2:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd5:	8b 40 18             	mov    0x18(%eax),%eax
80101dd8:	3b 45 10             	cmp    0x10(%ebp),%eax
80101ddb:	72 0d                	jb     80101dea <readi+0x8c>
80101ddd:	8b 45 14             	mov    0x14(%ebp),%eax
80101de0:	8b 55 10             	mov    0x10(%ebp),%edx
80101de3:	01 d0                	add    %edx,%eax
80101de5:	3b 45 10             	cmp    0x10(%ebp),%eax
80101de8:	73 0a                	jae    80101df4 <readi+0x96>
    return -1;
80101dea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101def:	e9 cf 00 00 00       	jmp    80101ec3 <readi+0x165>
  if(off + n > ip->size)
80101df4:	8b 45 14             	mov    0x14(%ebp),%eax
80101df7:	8b 55 10             	mov    0x10(%ebp),%edx
80101dfa:	01 c2                	add    %eax,%edx
80101dfc:	8b 45 08             	mov    0x8(%ebp),%eax
80101dff:	8b 40 18             	mov    0x18(%eax),%eax
80101e02:	39 c2                	cmp    %eax,%edx
80101e04:	76 0c                	jbe    80101e12 <readi+0xb4>
    n = ip->size - off;
80101e06:	8b 45 08             	mov    0x8(%ebp),%eax
80101e09:	8b 40 18             	mov    0x18(%eax),%eax
80101e0c:	2b 45 10             	sub    0x10(%ebp),%eax
80101e0f:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e12:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e19:	e9 96 00 00 00       	jmp    80101eb4 <readi+0x156>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e1e:	8b 45 10             	mov    0x10(%ebp),%eax
80101e21:	c1 e8 09             	shr    $0x9,%eax
80101e24:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e28:	8b 45 08             	mov    0x8(%ebp),%eax
80101e2b:	89 04 24             	mov    %eax,(%esp)
80101e2e:	e8 d7 fc ff ff       	call   80101b0a <bmap>
80101e33:	8b 55 08             	mov    0x8(%ebp),%edx
80101e36:	8b 12                	mov    (%edx),%edx
80101e38:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e3c:	89 14 24             	mov    %edx,(%esp)
80101e3f:	e8 62 e3 ff ff       	call   801001a6 <bread>
80101e44:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e47:	8b 45 10             	mov    0x10(%ebp),%eax
80101e4a:	89 c2                	mov    %eax,%edx
80101e4c:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101e52:	b8 00 02 00 00       	mov    $0x200,%eax
80101e57:	89 c1                	mov    %eax,%ecx
80101e59:	29 d1                	sub    %edx,%ecx
80101e5b:	89 ca                	mov    %ecx,%edx
80101e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101e60:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101e63:	89 cb                	mov    %ecx,%ebx
80101e65:	29 c3                	sub    %eax,%ebx
80101e67:	89 d8                	mov    %ebx,%eax
80101e69:	39 c2                	cmp    %eax,%edx
80101e6b:	0f 46 c2             	cmovbe %edx,%eax
80101e6e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101e71:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e74:	8d 50 18             	lea    0x18(%eax),%edx
80101e77:	8b 45 10             	mov    0x10(%ebp),%eax
80101e7a:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e7f:	01 c2                	add    %eax,%edx
80101e81:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e84:	89 44 24 08          	mov    %eax,0x8(%esp)
80101e88:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e8c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e8f:	89 04 24             	mov    %eax,(%esp)
80101e92:	e8 12 34 00 00       	call   801052a9 <memmove>
    brelse(bp);
80101e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e9a:	89 04 24             	mov    %eax,(%esp)
80101e9d:	e8 75 e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ea2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ea5:	01 45 f4             	add    %eax,-0xc(%ebp)
80101ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eab:	01 45 10             	add    %eax,0x10(%ebp)
80101eae:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eb1:	01 45 0c             	add    %eax,0xc(%ebp)
80101eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101eb7:	3b 45 14             	cmp    0x14(%ebp),%eax
80101eba:	0f 82 5e ff ff ff    	jb     80101e1e <readi+0xc0>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101ec0:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101ec3:	83 c4 24             	add    $0x24,%esp
80101ec6:	5b                   	pop    %ebx
80101ec7:	5d                   	pop    %ebp
80101ec8:	c3                   	ret    

80101ec9 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ec9:	55                   	push   %ebp
80101eca:	89 e5                	mov    %esp,%ebp
80101ecc:	53                   	push   %ebx
80101ecd:	83 ec 24             	sub    $0x24,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ed0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed3:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ed7:	66 83 f8 03          	cmp    $0x3,%ax
80101edb:	75 60                	jne    80101f3d <writei+0x74>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101edd:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee0:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ee4:	66 85 c0             	test   %ax,%ax
80101ee7:	78 20                	js     80101f09 <writei+0x40>
80101ee9:	8b 45 08             	mov    0x8(%ebp),%eax
80101eec:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101ef0:	66 83 f8 09          	cmp    $0x9,%ax
80101ef4:	7f 13                	jg     80101f09 <writei+0x40>
80101ef6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef9:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101efd:	98                   	cwtl   
80101efe:	8b 04 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%eax
80101f05:	85 c0                	test   %eax,%eax
80101f07:	75 0a                	jne    80101f13 <writei+0x4a>
      return -1;
80101f09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f0e:	e9 46 01 00 00       	jmp    80102059 <writei+0x190>
    return devsw[ip->major].write(ip, src, n);
80101f13:	8b 45 08             	mov    0x8(%ebp),%eax
80101f16:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f1a:	98                   	cwtl   
80101f1b:	8b 14 c5 04 e8 10 80 	mov    -0x7fef17fc(,%eax,8),%edx
80101f22:	8b 45 14             	mov    0x14(%ebp),%eax
80101f25:	89 44 24 08          	mov    %eax,0x8(%esp)
80101f29:	8b 45 0c             	mov    0xc(%ebp),%eax
80101f2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f30:	8b 45 08             	mov    0x8(%ebp),%eax
80101f33:	89 04 24             	mov    %eax,(%esp)
80101f36:	ff d2                	call   *%edx
80101f38:	e9 1c 01 00 00       	jmp    80102059 <writei+0x190>
  }

  if(off > ip->size || off + n < off)
80101f3d:	8b 45 08             	mov    0x8(%ebp),%eax
80101f40:	8b 40 18             	mov    0x18(%eax),%eax
80101f43:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f46:	72 0d                	jb     80101f55 <writei+0x8c>
80101f48:	8b 45 14             	mov    0x14(%ebp),%eax
80101f4b:	8b 55 10             	mov    0x10(%ebp),%edx
80101f4e:	01 d0                	add    %edx,%eax
80101f50:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f53:	73 0a                	jae    80101f5f <writei+0x96>
    return -1;
80101f55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f5a:	e9 fa 00 00 00       	jmp    80102059 <writei+0x190>
  if(off + n > MAXFILE*BSIZE)
80101f5f:	8b 45 14             	mov    0x14(%ebp),%eax
80101f62:	8b 55 10             	mov    0x10(%ebp),%edx
80101f65:	01 d0                	add    %edx,%eax
80101f67:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101f6c:	76 0a                	jbe    80101f78 <writei+0xaf>
    return -1;
80101f6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f73:	e9 e1 00 00 00       	jmp    80102059 <writei+0x190>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101f78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101f7f:	e9 a1 00 00 00       	jmp    80102025 <writei+0x15c>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101f84:	8b 45 10             	mov    0x10(%ebp),%eax
80101f87:	c1 e8 09             	shr    $0x9,%eax
80101f8a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101f8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101f91:	89 04 24             	mov    %eax,(%esp)
80101f94:	e8 71 fb ff ff       	call   80101b0a <bmap>
80101f99:	8b 55 08             	mov    0x8(%ebp),%edx
80101f9c:	8b 12                	mov    (%edx),%edx
80101f9e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fa2:	89 14 24             	mov    %edx,(%esp)
80101fa5:	e8 fc e1 ff ff       	call   801001a6 <bread>
80101faa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fad:	8b 45 10             	mov    0x10(%ebp),%eax
80101fb0:	89 c2                	mov    %eax,%edx
80101fb2:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80101fb8:	b8 00 02 00 00       	mov    $0x200,%eax
80101fbd:	89 c1                	mov    %eax,%ecx
80101fbf:	29 d1                	sub    %edx,%ecx
80101fc1:	89 ca                	mov    %ecx,%edx
80101fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fc6:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101fc9:	89 cb                	mov    %ecx,%ebx
80101fcb:	29 c3                	sub    %eax,%ebx
80101fcd:	89 d8                	mov    %ebx,%eax
80101fcf:	39 c2                	cmp    %eax,%edx
80101fd1:	0f 46 c2             	cmovbe %edx,%eax
80101fd4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80101fd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101fda:	8d 50 18             	lea    0x18(%eax),%edx
80101fdd:	8b 45 10             	mov    0x10(%ebp),%eax
80101fe0:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fe5:	01 c2                	add    %eax,%edx
80101fe7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101fea:	89 44 24 08          	mov    %eax,0x8(%esp)
80101fee:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ff1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ff5:	89 14 24             	mov    %edx,(%esp)
80101ff8:	e8 ac 32 00 00       	call   801052a9 <memmove>
    log_write(bp);
80101ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102000:	89 04 24             	mov    %eax,(%esp)
80102003:	e8 b6 12 00 00       	call   801032be <log_write>
    brelse(bp);
80102008:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010200b:	89 04 24             	mov    %eax,(%esp)
8010200e:	e8 04 e2 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102013:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102016:	01 45 f4             	add    %eax,-0xc(%ebp)
80102019:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010201c:	01 45 10             	add    %eax,0x10(%ebp)
8010201f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102022:	01 45 0c             	add    %eax,0xc(%ebp)
80102025:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102028:	3b 45 14             	cmp    0x14(%ebp),%eax
8010202b:	0f 82 53 ff ff ff    	jb     80101f84 <writei+0xbb>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80102031:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80102035:	74 1f                	je     80102056 <writei+0x18d>
80102037:	8b 45 08             	mov    0x8(%ebp),%eax
8010203a:	8b 40 18             	mov    0x18(%eax),%eax
8010203d:	3b 45 10             	cmp    0x10(%ebp),%eax
80102040:	73 14                	jae    80102056 <writei+0x18d>
    ip->size = off;
80102042:	8b 45 08             	mov    0x8(%ebp),%eax
80102045:	8b 55 10             	mov    0x10(%ebp),%edx
80102048:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
8010204b:	8b 45 08             	mov    0x8(%ebp),%eax
8010204e:	89 04 24             	mov    %eax,(%esp)
80102051:	e8 56 f6 ff ff       	call   801016ac <iupdate>
  }
  return n;
80102056:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102059:	83 c4 24             	add    $0x24,%esp
8010205c:	5b                   	pop    %ebx
8010205d:	5d                   	pop    %ebp
8010205e:	c3                   	ret    

8010205f <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
8010205f:	55                   	push   %ebp
80102060:	89 e5                	mov    %esp,%ebp
80102062:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80102065:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
8010206c:	00 
8010206d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102070:	89 44 24 04          	mov    %eax,0x4(%esp)
80102074:	8b 45 08             	mov    0x8(%ebp),%eax
80102077:	89 04 24             	mov    %eax,(%esp)
8010207a:	e8 ce 32 00 00       	call   8010534d <strncmp>
}
8010207f:	c9                   	leave  
80102080:	c3                   	ret    

80102081 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80102081:	55                   	push   %ebp
80102082:	89 e5                	mov    %esp,%ebp
80102084:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80102087:	8b 45 08             	mov    0x8(%ebp),%eax
8010208a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010208e:	66 83 f8 01          	cmp    $0x1,%ax
80102092:	74 0c                	je     801020a0 <dirlookup+0x1f>
    panic("dirlookup not DIR");
80102094:	c7 04 24 a5 86 10 80 	movl   $0x801086a5,(%esp)
8010209b:	e8 9d e4 ff ff       	call   8010053d <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801020a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020a7:	e9 87 00 00 00       	jmp    80102133 <dirlookup+0xb2>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020ac:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020b3:	00 
801020b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020b7:	89 44 24 08          	mov    %eax,0x8(%esp)
801020bb:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020be:	89 44 24 04          	mov    %eax,0x4(%esp)
801020c2:	8b 45 08             	mov    0x8(%ebp),%eax
801020c5:	89 04 24             	mov    %eax,(%esp)
801020c8:	e8 91 fc ff ff       	call   80101d5e <readi>
801020cd:	83 f8 10             	cmp    $0x10,%eax
801020d0:	74 0c                	je     801020de <dirlookup+0x5d>
      panic("dirlink read");
801020d2:	c7 04 24 b7 86 10 80 	movl   $0x801086b7,(%esp)
801020d9:	e8 5f e4 ff ff       	call   8010053d <panic>
    if(de.inum == 0)
801020de:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801020e2:	66 85 c0             	test   %ax,%ax
801020e5:	74 47                	je     8010212e <dirlookup+0xad>
      continue;
    if(namecmp(name, de.name) == 0){
801020e7:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020ea:	83 c0 02             	add    $0x2,%eax
801020ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801020f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801020f4:	89 04 24             	mov    %eax,(%esp)
801020f7:	e8 63 ff ff ff       	call   8010205f <namecmp>
801020fc:	85 c0                	test   %eax,%eax
801020fe:	75 2f                	jne    8010212f <dirlookup+0xae>
      // entry matches path element
      if(poff)
80102100:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80102104:	74 08                	je     8010210e <dirlookup+0x8d>
        *poff = off;
80102106:	8b 45 10             	mov    0x10(%ebp),%eax
80102109:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010210c:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
8010210e:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102112:	0f b7 c0             	movzwl %ax,%eax
80102115:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102118:	8b 45 08             	mov    0x8(%ebp),%eax
8010211b:	8b 00                	mov    (%eax),%eax
8010211d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102120:	89 54 24 04          	mov    %edx,0x4(%esp)
80102124:	89 04 24             	mov    %eax,(%esp)
80102127:	e8 38 f6 ff ff       	call   80101764 <iget>
8010212c:	eb 19                	jmp    80102147 <dirlookup+0xc6>

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      continue;
8010212e:	90                   	nop
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
8010212f:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80102133:	8b 45 08             	mov    0x8(%ebp),%eax
80102136:	8b 40 18             	mov    0x18(%eax),%eax
80102139:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010213c:	0f 87 6a ff ff ff    	ja     801020ac <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102142:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102147:	c9                   	leave  
80102148:	c3                   	ret    

80102149 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102149:	55                   	push   %ebp
8010214a:	89 e5                	mov    %esp,%ebp
8010214c:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
8010214f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80102156:	00 
80102157:	8b 45 0c             	mov    0xc(%ebp),%eax
8010215a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010215e:	8b 45 08             	mov    0x8(%ebp),%eax
80102161:	89 04 24             	mov    %eax,(%esp)
80102164:	e8 18 ff ff ff       	call   80102081 <dirlookup>
80102169:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010216c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80102170:	74 15                	je     80102187 <dirlink+0x3e>
    iput(ip);
80102172:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102175:	89 04 24             	mov    %eax,(%esp)
80102178:	e8 9e f8 ff ff       	call   80101a1b <iput>
    return -1;
8010217d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102182:	e9 b8 00 00 00       	jmp    8010223f <dirlink+0xf6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102187:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010218e:	eb 44                	jmp    801021d4 <dirlink+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102190:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102193:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010219a:	00 
8010219b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010219f:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801021a6:	8b 45 08             	mov    0x8(%ebp),%eax
801021a9:	89 04 24             	mov    %eax,(%esp)
801021ac:	e8 ad fb ff ff       	call   80101d5e <readi>
801021b1:	83 f8 10             	cmp    $0x10,%eax
801021b4:	74 0c                	je     801021c2 <dirlink+0x79>
      panic("dirlink read");
801021b6:	c7 04 24 b7 86 10 80 	movl   $0x801086b7,(%esp)
801021bd:	e8 7b e3 ff ff       	call   8010053d <panic>
    if(de.inum == 0)
801021c2:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021c6:	66 85 c0             	test   %ax,%ax
801021c9:	74 18                	je     801021e3 <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021ce:	83 c0 10             	add    $0x10,%eax
801021d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801021d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801021d7:	8b 45 08             	mov    0x8(%ebp),%eax
801021da:	8b 40 18             	mov    0x18(%eax),%eax
801021dd:	39 c2                	cmp    %eax,%edx
801021df:	72 af                	jb     80102190 <dirlink+0x47>
801021e1:	eb 01                	jmp    801021e4 <dirlink+0x9b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
    if(de.inum == 0)
      break;
801021e3:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
801021e4:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801021eb:	00 
801021ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801021ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801021f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021f6:	83 c0 02             	add    $0x2,%eax
801021f9:	89 04 24             	mov    %eax,(%esp)
801021fc:	e8 a4 31 00 00       	call   801053a5 <strncpy>
  de.inum = inum;
80102201:	8b 45 10             	mov    0x10(%ebp),%eax
80102204:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102208:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010220b:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102212:	00 
80102213:	89 44 24 08          	mov    %eax,0x8(%esp)
80102217:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010221a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010221e:	8b 45 08             	mov    0x8(%ebp),%eax
80102221:	89 04 24             	mov    %eax,(%esp)
80102224:	e8 a0 fc ff ff       	call   80101ec9 <writei>
80102229:	83 f8 10             	cmp    $0x10,%eax
8010222c:	74 0c                	je     8010223a <dirlink+0xf1>
    panic("dirlink");
8010222e:	c7 04 24 c4 86 10 80 	movl   $0x801086c4,(%esp)
80102235:	e8 03 e3 ff ff       	call   8010053d <panic>
  
  return 0;
8010223a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010223f:	c9                   	leave  
80102240:	c3                   	ret    

80102241 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102241:	55                   	push   %ebp
80102242:	89 e5                	mov    %esp,%ebp
80102244:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
80102247:	eb 04                	jmp    8010224d <skipelem+0xc>
    path++;
80102249:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
8010224d:	8b 45 08             	mov    0x8(%ebp),%eax
80102250:	0f b6 00             	movzbl (%eax),%eax
80102253:	3c 2f                	cmp    $0x2f,%al
80102255:	74 f2                	je     80102249 <skipelem+0x8>
    path++;
  if(*path == 0)
80102257:	8b 45 08             	mov    0x8(%ebp),%eax
8010225a:	0f b6 00             	movzbl (%eax),%eax
8010225d:	84 c0                	test   %al,%al
8010225f:	75 0a                	jne    8010226b <skipelem+0x2a>
    return 0;
80102261:	b8 00 00 00 00       	mov    $0x0,%eax
80102266:	e9 86 00 00 00       	jmp    801022f1 <skipelem+0xb0>
  s = path;
8010226b:	8b 45 08             	mov    0x8(%ebp),%eax
8010226e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
80102271:	eb 04                	jmp    80102277 <skipelem+0x36>
    path++;
80102273:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80102277:	8b 45 08             	mov    0x8(%ebp),%eax
8010227a:	0f b6 00             	movzbl (%eax),%eax
8010227d:	3c 2f                	cmp    $0x2f,%al
8010227f:	74 0a                	je     8010228b <skipelem+0x4a>
80102281:	8b 45 08             	mov    0x8(%ebp),%eax
80102284:	0f b6 00             	movzbl (%eax),%eax
80102287:	84 c0                	test   %al,%al
80102289:	75 e8                	jne    80102273 <skipelem+0x32>
    path++;
  len = path - s;
8010228b:	8b 55 08             	mov    0x8(%ebp),%edx
8010228e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102291:	89 d1                	mov    %edx,%ecx
80102293:	29 c1                	sub    %eax,%ecx
80102295:	89 c8                	mov    %ecx,%eax
80102297:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
8010229a:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010229e:	7e 1c                	jle    801022bc <skipelem+0x7b>
    memmove(name, s, DIRSIZ);
801022a0:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022a7:	00 
801022a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801022af:	8b 45 0c             	mov    0xc(%ebp),%eax
801022b2:	89 04 24             	mov    %eax,(%esp)
801022b5:	e8 ef 2f 00 00       	call   801052a9 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022ba:	eb 28                	jmp    801022e4 <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022bf:	89 44 24 08          	mov    %eax,0x8(%esp)
801022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801022ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801022cd:	89 04 24             	mov    %eax,(%esp)
801022d0:	e8 d4 2f 00 00       	call   801052a9 <memmove>
    name[len] = 0;
801022d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022d8:	03 45 0c             	add    0xc(%ebp),%eax
801022db:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
801022de:	eb 04                	jmp    801022e4 <skipelem+0xa3>
    path++;
801022e0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022e4:	8b 45 08             	mov    0x8(%ebp),%eax
801022e7:	0f b6 00             	movzbl (%eax),%eax
801022ea:	3c 2f                	cmp    $0x2f,%al
801022ec:	74 f2                	je     801022e0 <skipelem+0x9f>
    path++;
  return path;
801022ee:	8b 45 08             	mov    0x8(%ebp),%eax
}
801022f1:	c9                   	leave  
801022f2:	c3                   	ret    

801022f3 <namex>:
// Look up and return the inode for a path name.
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
static struct inode*
namex(char *path, int nameiparent, char *name)
{
801022f3:	55                   	push   %ebp
801022f4:	89 e5                	mov    %esp,%ebp
801022f6:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
801022f9:	8b 45 08             	mov    0x8(%ebp),%eax
801022fc:	0f b6 00             	movzbl (%eax),%eax
801022ff:	3c 2f                	cmp    $0x2f,%al
80102301:	75 1c                	jne    8010231f <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102303:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010230a:	00 
8010230b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102312:	e8 4d f4 ff ff       	call   80101764 <iget>
80102317:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
8010231a:	e9 af 00 00 00       	jmp    801023ce <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
8010231f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102325:	8b 40 68             	mov    0x68(%eax),%eax
80102328:	89 04 24             	mov    %eax,(%esp)
8010232b:	e8 06 f5 ff ff       	call   80101836 <idup>
80102330:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102333:	e9 96 00 00 00       	jmp    801023ce <namex+0xdb>
    ilock(ip);
80102338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010233b:	89 04 24             	mov    %eax,(%esp)
8010233e:	e8 25 f5 ff ff       	call   80101868 <ilock>
    if(ip->type != T_DIR){
80102343:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102346:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010234a:	66 83 f8 01          	cmp    $0x1,%ax
8010234e:	74 15                	je     80102365 <namex+0x72>
      iunlockput(ip);
80102350:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102353:	89 04 24             	mov    %eax,(%esp)
80102356:	e8 91 f7 ff ff       	call   80101aec <iunlockput>
      return 0;
8010235b:	b8 00 00 00 00       	mov    $0x0,%eax
80102360:	e9 a3 00 00 00       	jmp    80102408 <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
80102365:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102369:	74 1d                	je     80102388 <namex+0x95>
8010236b:	8b 45 08             	mov    0x8(%ebp),%eax
8010236e:	0f b6 00             	movzbl (%eax),%eax
80102371:	84 c0                	test   %al,%al
80102373:	75 13                	jne    80102388 <namex+0x95>
      // Stop one level early.
      iunlock(ip);
80102375:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102378:	89 04 24             	mov    %eax,(%esp)
8010237b:	e8 36 f6 ff ff       	call   801019b6 <iunlock>
      return ip;
80102380:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102383:	e9 80 00 00 00       	jmp    80102408 <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80102388:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010238f:	00 
80102390:	8b 45 10             	mov    0x10(%ebp),%eax
80102393:	89 44 24 04          	mov    %eax,0x4(%esp)
80102397:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010239a:	89 04 24             	mov    %eax,(%esp)
8010239d:	e8 df fc ff ff       	call   80102081 <dirlookup>
801023a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023a9:	75 12                	jne    801023bd <namex+0xca>
      iunlockput(ip);
801023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ae:	89 04 24             	mov    %eax,(%esp)
801023b1:	e8 36 f7 ff ff       	call   80101aec <iunlockput>
      return 0;
801023b6:	b8 00 00 00 00       	mov    $0x0,%eax
801023bb:	eb 4b                	jmp    80102408 <namex+0x115>
    }
    iunlockput(ip);
801023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023c0:	89 04 24             	mov    %eax,(%esp)
801023c3:	e8 24 f7 ff ff       	call   80101aec <iunlockput>
    ip = next;
801023c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
801023ce:	8b 45 10             	mov    0x10(%ebp),%eax
801023d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801023d5:	8b 45 08             	mov    0x8(%ebp),%eax
801023d8:	89 04 24             	mov    %eax,(%esp)
801023db:	e8 61 fe ff ff       	call   80102241 <skipelem>
801023e0:	89 45 08             	mov    %eax,0x8(%ebp)
801023e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801023e7:	0f 85 4b ff ff ff    	jne    80102338 <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
801023ed:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801023f1:	74 12                	je     80102405 <namex+0x112>
    iput(ip);
801023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023f6:	89 04 24             	mov    %eax,(%esp)
801023f9:	e8 1d f6 ff ff       	call   80101a1b <iput>
    return 0;
801023fe:	b8 00 00 00 00       	mov    $0x0,%eax
80102403:	eb 03                	jmp    80102408 <namex+0x115>
  }
  return ip;
80102405:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102408:	c9                   	leave  
80102409:	c3                   	ret    

8010240a <namei>:

struct inode*
namei(char *path)
{
8010240a:	55                   	push   %ebp
8010240b:	89 e5                	mov    %esp,%ebp
8010240d:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102410:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102413:	89 44 24 08          	mov    %eax,0x8(%esp)
80102417:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010241e:	00 
8010241f:	8b 45 08             	mov    0x8(%ebp),%eax
80102422:	89 04 24             	mov    %eax,(%esp)
80102425:	e8 c9 fe ff ff       	call   801022f3 <namex>
}
8010242a:	c9                   	leave  
8010242b:	c3                   	ret    

8010242c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
8010242c:	55                   	push   %ebp
8010242d:	89 e5                	mov    %esp,%ebp
8010242f:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102432:	8b 45 0c             	mov    0xc(%ebp),%eax
80102435:	89 44 24 08          	mov    %eax,0x8(%esp)
80102439:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102440:	00 
80102441:	8b 45 08             	mov    0x8(%ebp),%eax
80102444:	89 04 24             	mov    %eax,(%esp)
80102447:	e8 a7 fe ff ff       	call   801022f3 <namex>
}
8010244c:	c9                   	leave  
8010244d:	c3                   	ret    
	...

80102450 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102450:	55                   	push   %ebp
80102451:	89 e5                	mov    %esp,%ebp
80102453:	53                   	push   %ebx
80102454:	83 ec 14             	sub    $0x14,%esp
80102457:	8b 45 08             	mov    0x8(%ebp),%eax
8010245a:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010245e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
80102462:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80102466:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
8010246a:	ec                   	in     (%dx),%al
8010246b:	89 c3                	mov    %eax,%ebx
8010246d:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80102470:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
80102474:	83 c4 14             	add    $0x14,%esp
80102477:	5b                   	pop    %ebx
80102478:	5d                   	pop    %ebp
80102479:	c3                   	ret    

8010247a <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
8010247a:	55                   	push   %ebp
8010247b:	89 e5                	mov    %esp,%ebp
8010247d:	57                   	push   %edi
8010247e:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
8010247f:	8b 55 08             	mov    0x8(%ebp),%edx
80102482:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102485:	8b 45 10             	mov    0x10(%ebp),%eax
80102488:	89 cb                	mov    %ecx,%ebx
8010248a:	89 df                	mov    %ebx,%edi
8010248c:	89 c1                	mov    %eax,%ecx
8010248e:	fc                   	cld    
8010248f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102491:	89 c8                	mov    %ecx,%eax
80102493:	89 fb                	mov    %edi,%ebx
80102495:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102498:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
8010249b:	5b                   	pop    %ebx
8010249c:	5f                   	pop    %edi
8010249d:	5d                   	pop    %ebp
8010249e:	c3                   	ret    

8010249f <outb>:

static inline void
outb(ushort port, uchar data)
{
8010249f:	55                   	push   %ebp
801024a0:	89 e5                	mov    %esp,%ebp
801024a2:	83 ec 08             	sub    $0x8,%esp
801024a5:	8b 55 08             	mov    0x8(%ebp),%edx
801024a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801024ab:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801024af:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024b2:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801024b6:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801024ba:	ee                   	out    %al,(%dx)
}
801024bb:	c9                   	leave  
801024bc:	c3                   	ret    

801024bd <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024bd:	55                   	push   %ebp
801024be:	89 e5                	mov    %esp,%ebp
801024c0:	56                   	push   %esi
801024c1:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024c2:	8b 55 08             	mov    0x8(%ebp),%edx
801024c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024c8:	8b 45 10             	mov    0x10(%ebp),%eax
801024cb:	89 cb                	mov    %ecx,%ebx
801024cd:	89 de                	mov    %ebx,%esi
801024cf:	89 c1                	mov    %eax,%ecx
801024d1:	fc                   	cld    
801024d2:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801024d4:	89 c8                	mov    %ecx,%eax
801024d6:	89 f3                	mov    %esi,%ebx
801024d8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024db:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
801024de:	5b                   	pop    %ebx
801024df:	5e                   	pop    %esi
801024e0:	5d                   	pop    %ebp
801024e1:	c3                   	ret    

801024e2 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801024e2:	55                   	push   %ebp
801024e3:	89 e5                	mov    %esp,%ebp
801024e5:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801024e8:	90                   	nop
801024e9:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801024f0:	e8 5b ff ff ff       	call   80102450 <inb>
801024f5:	0f b6 c0             	movzbl %al,%eax
801024f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
801024fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801024fe:	25 c0 00 00 00       	and    $0xc0,%eax
80102503:	83 f8 40             	cmp    $0x40,%eax
80102506:	75 e1                	jne    801024e9 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102508:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010250c:	74 11                	je     8010251f <idewait+0x3d>
8010250e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102511:	83 e0 21             	and    $0x21,%eax
80102514:	85 c0                	test   %eax,%eax
80102516:	74 07                	je     8010251f <idewait+0x3d>
    return -1;
80102518:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010251d:	eb 05                	jmp    80102524 <idewait+0x42>
  return 0;
8010251f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102524:	c9                   	leave  
80102525:	c3                   	ret    

80102526 <ideinit>:

void
ideinit(void)
{
80102526:	55                   	push   %ebp
80102527:	89 e5                	mov    %esp,%ebp
80102529:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
8010252c:	c7 44 24 04 cc 86 10 	movl   $0x801086cc,0x4(%esp)
80102533:	80 
80102534:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
8010253b:	e8 26 2a 00 00       	call   80104f66 <initlock>
  picenable(IRQ_IDE);
80102540:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102547:	e8 75 15 00 00       	call   80103ac1 <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010254c:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80102551:	83 e8 01             	sub    $0x1,%eax
80102554:	89 44 24 04          	mov    %eax,0x4(%esp)
80102558:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010255f:	e8 12 04 00 00       	call   80102976 <ioapicenable>
  idewait(0);
80102564:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010256b:	e8 72 ff ff ff       	call   801024e2 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102570:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
80102577:	00 
80102578:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
8010257f:	e8 1b ff ff ff       	call   8010249f <outb>
  for(i=0; i<1000; i++){
80102584:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010258b:	eb 20                	jmp    801025ad <ideinit+0x87>
    if(inb(0x1f7) != 0){
8010258d:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102594:	e8 b7 fe ff ff       	call   80102450 <inb>
80102599:	84 c0                	test   %al,%al
8010259b:	74 0c                	je     801025a9 <ideinit+0x83>
      havedisk1 = 1;
8010259d:	c7 05 38 b6 10 80 01 	movl   $0x1,0x8010b638
801025a4:	00 00 00 
      break;
801025a7:	eb 0d                	jmp    801025b6 <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025a9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025ad:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025b4:	7e d7                	jle    8010258d <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025b6:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801025bd:	00 
801025be:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025c5:	e8 d5 fe ff ff       	call   8010249f <outb>
}
801025ca:	c9                   	leave  
801025cb:	c3                   	ret    

801025cc <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025cc:	55                   	push   %ebp
801025cd:	89 e5                	mov    %esp,%ebp
801025cf:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801025d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025d6:	75 0c                	jne    801025e4 <idestart+0x18>
    panic("idestart");
801025d8:	c7 04 24 d0 86 10 80 	movl   $0x801086d0,(%esp)
801025df:	e8 59 df ff ff       	call   8010053d <panic>

  idewait(0);
801025e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801025eb:	e8 f2 fe ff ff       	call   801024e2 <idewait>
  outb(0x3f6, 0);  // generate interrupt
801025f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801025f7:	00 
801025f8:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
801025ff:	e8 9b fe ff ff       	call   8010249f <outb>
  outb(0x1f2, 1);  // number of sectors
80102604:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010260b:	00 
8010260c:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
80102613:	e8 87 fe ff ff       	call   8010249f <outb>
  outb(0x1f3, b->sector & 0xff);
80102618:	8b 45 08             	mov    0x8(%ebp),%eax
8010261b:	8b 40 08             	mov    0x8(%eax),%eax
8010261e:	0f b6 c0             	movzbl %al,%eax
80102621:	89 44 24 04          	mov    %eax,0x4(%esp)
80102625:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
8010262c:	e8 6e fe ff ff       	call   8010249f <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
80102631:	8b 45 08             	mov    0x8(%ebp),%eax
80102634:	8b 40 08             	mov    0x8(%eax),%eax
80102637:	c1 e8 08             	shr    $0x8,%eax
8010263a:	0f b6 c0             	movzbl %al,%eax
8010263d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102641:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
80102648:	e8 52 fe ff ff       	call   8010249f <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
8010264d:	8b 45 08             	mov    0x8(%ebp),%eax
80102650:	8b 40 08             	mov    0x8(%eax),%eax
80102653:	c1 e8 10             	shr    $0x10,%eax
80102656:	0f b6 c0             	movzbl %al,%eax
80102659:	89 44 24 04          	mov    %eax,0x4(%esp)
8010265d:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
80102664:	e8 36 fe ff ff       	call   8010249f <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102669:	8b 45 08             	mov    0x8(%ebp),%eax
8010266c:	8b 40 04             	mov    0x4(%eax),%eax
8010266f:	83 e0 01             	and    $0x1,%eax
80102672:	89 c2                	mov    %eax,%edx
80102674:	c1 e2 04             	shl    $0x4,%edx
80102677:	8b 45 08             	mov    0x8(%ebp),%eax
8010267a:	8b 40 08             	mov    0x8(%eax),%eax
8010267d:	c1 e8 18             	shr    $0x18,%eax
80102680:	83 e0 0f             	and    $0xf,%eax
80102683:	09 d0                	or     %edx,%eax
80102685:	83 c8 e0             	or     $0xffffffe0,%eax
80102688:	0f b6 c0             	movzbl %al,%eax
8010268b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010268f:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
80102696:	e8 04 fe ff ff       	call   8010249f <outb>
  if(b->flags & B_DIRTY){
8010269b:	8b 45 08             	mov    0x8(%ebp),%eax
8010269e:	8b 00                	mov    (%eax),%eax
801026a0:	83 e0 04             	and    $0x4,%eax
801026a3:	85 c0                	test   %eax,%eax
801026a5:	74 34                	je     801026db <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
801026a7:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
801026ae:	00 
801026af:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026b6:	e8 e4 fd ff ff       	call   8010249f <outb>
    outsl(0x1f0, b->data, 512/4);
801026bb:	8b 45 08             	mov    0x8(%ebp),%eax
801026be:	83 c0 18             	add    $0x18,%eax
801026c1:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801026c8:	00 
801026c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801026cd:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801026d4:	e8 e4 fd ff ff       	call   801024bd <outsl>
801026d9:	eb 14                	jmp    801026ef <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
801026db:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
801026e2:	00 
801026e3:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026ea:	e8 b0 fd ff ff       	call   8010249f <outb>
  }
}
801026ef:	c9                   	leave  
801026f0:	c3                   	ret    

801026f1 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801026f1:	55                   	push   %ebp
801026f2:	89 e5                	mov    %esp,%ebp
801026f4:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801026f7:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801026fe:	e8 84 28 00 00       	call   80104f87 <acquire>
  if((b = idequeue) == 0){
80102703:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102708:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010270b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010270f:	75 11                	jne    80102722 <ideintr+0x31>
    release(&idelock);
80102711:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102718:	e8 cc 28 00 00       	call   80104fe9 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
8010271d:	e9 90 00 00 00       	jmp    801027b2 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102722:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102725:	8b 40 14             	mov    0x14(%eax),%eax
80102728:	a3 34 b6 10 80       	mov    %eax,0x8010b634

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010272d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102730:	8b 00                	mov    (%eax),%eax
80102732:	83 e0 04             	and    $0x4,%eax
80102735:	85 c0                	test   %eax,%eax
80102737:	75 2e                	jne    80102767 <ideintr+0x76>
80102739:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102740:	e8 9d fd ff ff       	call   801024e2 <idewait>
80102745:	85 c0                	test   %eax,%eax
80102747:	78 1e                	js     80102767 <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
80102749:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010274c:	83 c0 18             	add    $0x18,%eax
8010274f:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80102756:	00 
80102757:	89 44 24 04          	mov    %eax,0x4(%esp)
8010275b:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102762:	e8 13 fd ff ff       	call   8010247a <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010276a:	8b 00                	mov    (%eax),%eax
8010276c:	89 c2                	mov    %eax,%edx
8010276e:	83 ca 02             	or     $0x2,%edx
80102771:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102774:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102776:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102779:	8b 00                	mov    (%eax),%eax
8010277b:	89 c2                	mov    %eax,%edx
8010277d:	83 e2 fb             	and    $0xfffffffb,%edx
80102780:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102783:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102785:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102788:	89 04 24             	mov    %eax,(%esp)
8010278b:	e8 45 22 00 00       	call   801049d5 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102790:	a1 34 b6 10 80       	mov    0x8010b634,%eax
80102795:	85 c0                	test   %eax,%eax
80102797:	74 0d                	je     801027a6 <ideintr+0xb5>
    idestart(idequeue);
80102799:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010279e:	89 04 24             	mov    %eax,(%esp)
801027a1:	e8 26 fe ff ff       	call   801025cc <idestart>

  release(&idelock);
801027a6:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
801027ad:	e8 37 28 00 00       	call   80104fe9 <release>
}
801027b2:	c9                   	leave  
801027b3:	c3                   	ret    

801027b4 <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027b4:	55                   	push   %ebp
801027b5:	89 e5                	mov    %esp,%ebp
801027b7:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801027ba:	8b 45 08             	mov    0x8(%ebp),%eax
801027bd:	8b 00                	mov    (%eax),%eax
801027bf:	83 e0 01             	and    $0x1,%eax
801027c2:	85 c0                	test   %eax,%eax
801027c4:	75 0c                	jne    801027d2 <iderw+0x1e>
    panic("iderw: buf not busy");
801027c6:	c7 04 24 d9 86 10 80 	movl   $0x801086d9,(%esp)
801027cd:	e8 6b dd ff ff       	call   8010053d <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027d2:	8b 45 08             	mov    0x8(%ebp),%eax
801027d5:	8b 00                	mov    (%eax),%eax
801027d7:	83 e0 06             	and    $0x6,%eax
801027da:	83 f8 02             	cmp    $0x2,%eax
801027dd:	75 0c                	jne    801027eb <iderw+0x37>
    panic("iderw: nothing to do");
801027df:	c7 04 24 ed 86 10 80 	movl   $0x801086ed,(%esp)
801027e6:	e8 52 dd ff ff       	call   8010053d <panic>
  if(b->dev != 0 && !havedisk1)
801027eb:	8b 45 08             	mov    0x8(%ebp),%eax
801027ee:	8b 40 04             	mov    0x4(%eax),%eax
801027f1:	85 c0                	test   %eax,%eax
801027f3:	74 15                	je     8010280a <iderw+0x56>
801027f5:	a1 38 b6 10 80       	mov    0x8010b638,%eax
801027fa:	85 c0                	test   %eax,%eax
801027fc:	75 0c                	jne    8010280a <iderw+0x56>
    panic("iderw: ide disk 1 not present");
801027fe:	c7 04 24 02 87 10 80 	movl   $0x80108702,(%esp)
80102805:	e8 33 dd ff ff       	call   8010053d <panic>

  acquire(&idelock);  //DOC: acquire-lock
8010280a:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102811:	e8 71 27 00 00       	call   80104f87 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80102816:	8b 45 08             	mov    0x8(%ebp),%eax
80102819:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC: insert-queue
80102820:	c7 45 f4 34 b6 10 80 	movl   $0x8010b634,-0xc(%ebp)
80102827:	eb 0b                	jmp    80102834 <iderw+0x80>
80102829:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010282c:	8b 00                	mov    (%eax),%eax
8010282e:	83 c0 14             	add    $0x14,%eax
80102831:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102834:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102837:	8b 00                	mov    (%eax),%eax
80102839:	85 c0                	test   %eax,%eax
8010283b:	75 ec                	jne    80102829 <iderw+0x75>
    ;
  *pp = b;
8010283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102840:	8b 55 08             	mov    0x8(%ebp),%edx
80102843:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102845:	a1 34 b6 10 80       	mov    0x8010b634,%eax
8010284a:	3b 45 08             	cmp    0x8(%ebp),%eax
8010284d:	75 22                	jne    80102871 <iderw+0xbd>
    idestart(b);
8010284f:	8b 45 08             	mov    0x8(%ebp),%eax
80102852:	89 04 24             	mov    %eax,(%esp)
80102855:	e8 72 fd ff ff       	call   801025cc <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010285a:	eb 15                	jmp    80102871 <iderw+0xbd>
    sleep(b, &idelock);
8010285c:	c7 44 24 04 00 b6 10 	movl   $0x8010b600,0x4(%esp)
80102863:	80 
80102864:	8b 45 08             	mov    0x8(%ebp),%eax
80102867:	89 04 24             	mov    %eax,(%esp)
8010286a:	e8 8a 20 00 00       	call   801048f9 <sleep>
8010286f:	eb 01                	jmp    80102872 <iderw+0xbe>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102871:	90                   	nop
80102872:	8b 45 08             	mov    0x8(%ebp),%eax
80102875:	8b 00                	mov    (%eax),%eax
80102877:	83 e0 06             	and    $0x6,%eax
8010287a:	83 f8 02             	cmp    $0x2,%eax
8010287d:	75 dd                	jne    8010285c <iderw+0xa8>
    sleep(b, &idelock);
  }

  release(&idelock);
8010287f:	c7 04 24 00 b6 10 80 	movl   $0x8010b600,(%esp)
80102886:	e8 5e 27 00 00       	call   80104fe9 <release>
}
8010288b:	c9                   	leave  
8010288c:	c3                   	ret    
8010288d:	00 00                	add    %al,(%eax)
	...

80102890 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102890:	55                   	push   %ebp
80102891:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102893:	a1 34 f8 10 80       	mov    0x8010f834,%eax
80102898:	8b 55 08             	mov    0x8(%ebp),%edx
8010289b:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
8010289d:	a1 34 f8 10 80       	mov    0x8010f834,%eax
801028a2:	8b 40 10             	mov    0x10(%eax),%eax
}
801028a5:	5d                   	pop    %ebp
801028a6:	c3                   	ret    

801028a7 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801028a7:	55                   	push   %ebp
801028a8:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028aa:	a1 34 f8 10 80       	mov    0x8010f834,%eax
801028af:	8b 55 08             	mov    0x8(%ebp),%edx
801028b2:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801028b4:	a1 34 f8 10 80       	mov    0x8010f834,%eax
801028b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801028bc:	89 50 10             	mov    %edx,0x10(%eax)
}
801028bf:	5d                   	pop    %ebp
801028c0:	c3                   	ret    

801028c1 <ioapicinit>:

void
ioapicinit(void)
{
801028c1:	55                   	push   %ebp
801028c2:	89 e5                	mov    %esp,%ebp
801028c4:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
801028c7:	a1 04 f9 10 80       	mov    0x8010f904,%eax
801028cc:	85 c0                	test   %eax,%eax
801028ce:	0f 84 9f 00 00 00    	je     80102973 <ioapicinit+0xb2>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
801028d4:	c7 05 34 f8 10 80 00 	movl   $0xfec00000,0x8010f834
801028db:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801028de:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801028e5:	e8 a6 ff ff ff       	call   80102890 <ioapicread>
801028ea:	c1 e8 10             	shr    $0x10,%eax
801028ed:	25 ff 00 00 00       	and    $0xff,%eax
801028f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
801028f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801028fc:	e8 8f ff ff ff       	call   80102890 <ioapicread>
80102901:	c1 e8 18             	shr    $0x18,%eax
80102904:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102907:	0f b6 05 00 f9 10 80 	movzbl 0x8010f900,%eax
8010290e:	0f b6 c0             	movzbl %al,%eax
80102911:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102914:	74 0c                	je     80102922 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102916:	c7 04 24 20 87 10 80 	movl   $0x80108720,(%esp)
8010291d:	e8 7f da ff ff       	call   801003a1 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102922:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102929:	eb 3e                	jmp    80102969 <ioapicinit+0xa8>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010292b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010292e:	83 c0 20             	add    $0x20,%eax
80102931:	0d 00 00 01 00       	or     $0x10000,%eax
80102936:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102939:	83 c2 08             	add    $0x8,%edx
8010293c:	01 d2                	add    %edx,%edx
8010293e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102942:	89 14 24             	mov    %edx,(%esp)
80102945:	e8 5d ff ff ff       	call   801028a7 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
8010294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010294d:	83 c0 08             	add    $0x8,%eax
80102950:	01 c0                	add    %eax,%eax
80102952:	83 c0 01             	add    $0x1,%eax
80102955:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010295c:	00 
8010295d:	89 04 24             	mov    %eax,(%esp)
80102960:	e8 42 ff ff ff       	call   801028a7 <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102965:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102969:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010296c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
8010296f:	7e ba                	jle    8010292b <ioapicinit+0x6a>
80102971:	eb 01                	jmp    80102974 <ioapicinit+0xb3>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102973:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102974:	c9                   	leave  
80102975:	c3                   	ret    

80102976 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102976:	55                   	push   %ebp
80102977:	89 e5                	mov    %esp,%ebp
80102979:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
8010297c:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80102981:	85 c0                	test   %eax,%eax
80102983:	74 39                	je     801029be <ioapicenable+0x48>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102985:	8b 45 08             	mov    0x8(%ebp),%eax
80102988:	83 c0 20             	add    $0x20,%eax
8010298b:	8b 55 08             	mov    0x8(%ebp),%edx
8010298e:	83 c2 08             	add    $0x8,%edx
80102991:	01 d2                	add    %edx,%edx
80102993:	89 44 24 04          	mov    %eax,0x4(%esp)
80102997:	89 14 24             	mov    %edx,(%esp)
8010299a:	e8 08 ff ff ff       	call   801028a7 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010299f:	8b 45 0c             	mov    0xc(%ebp),%eax
801029a2:	c1 e0 18             	shl    $0x18,%eax
801029a5:	8b 55 08             	mov    0x8(%ebp),%edx
801029a8:	83 c2 08             	add    $0x8,%edx
801029ab:	01 d2                	add    %edx,%edx
801029ad:	83 c2 01             	add    $0x1,%edx
801029b0:	89 44 24 04          	mov    %eax,0x4(%esp)
801029b4:	89 14 24             	mov    %edx,(%esp)
801029b7:	e8 eb fe ff ff       	call   801028a7 <ioapicwrite>
801029bc:	eb 01                	jmp    801029bf <ioapicenable+0x49>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
801029be:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801029bf:	c9                   	leave  
801029c0:	c3                   	ret    
801029c1:	00 00                	add    %al,(%eax)
	...

801029c4 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801029c4:	55                   	push   %ebp
801029c5:	89 e5                	mov    %esp,%ebp
801029c7:	8b 45 08             	mov    0x8(%ebp),%eax
801029ca:	05 00 00 00 80       	add    $0x80000000,%eax
801029cf:	5d                   	pop    %ebp
801029d0:	c3                   	ret    

801029d1 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801029d1:	55                   	push   %ebp
801029d2:	89 e5                	mov    %esp,%ebp
801029d4:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
801029d7:	c7 44 24 04 52 87 10 	movl   $0x80108752,0x4(%esp)
801029de:	80 
801029df:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
801029e6:	e8 7b 25 00 00       	call   80104f66 <initlock>
  kmem.use_lock = 0;
801029eb:	c7 05 74 f8 10 80 00 	movl   $0x0,0x8010f874
801029f2:	00 00 00 
  freerange(vstart, vend);
801029f5:	8b 45 0c             	mov    0xc(%ebp),%eax
801029f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801029fc:	8b 45 08             	mov    0x8(%ebp),%eax
801029ff:	89 04 24             	mov    %eax,(%esp)
80102a02:	e8 26 00 00 00       	call   80102a2d <freerange>
}
80102a07:	c9                   	leave  
80102a08:	c3                   	ret    

80102a09 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a09:	55                   	push   %ebp
80102a0a:	89 e5                	mov    %esp,%ebp
80102a0c:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a12:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a16:	8b 45 08             	mov    0x8(%ebp),%eax
80102a19:	89 04 24             	mov    %eax,(%esp)
80102a1c:	e8 0c 00 00 00       	call   80102a2d <freerange>
  kmem.use_lock = 1;
80102a21:	c7 05 74 f8 10 80 01 	movl   $0x1,0x8010f874
80102a28:	00 00 00 
}
80102a2b:	c9                   	leave  
80102a2c:	c3                   	ret    

80102a2d <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a2d:	55                   	push   %ebp
80102a2e:	89 e5                	mov    %esp,%ebp
80102a30:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a33:	8b 45 08             	mov    0x8(%ebp),%eax
80102a36:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a3b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a43:	eb 12                	jmp    80102a57 <freerange+0x2a>
    kfree(p);
80102a45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a48:	89 04 24             	mov    %eax,(%esp)
80102a4b:	e8 16 00 00 00       	call   80102a66 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a50:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a5a:	05 00 10 00 00       	add    $0x1000,%eax
80102a5f:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102a62:	76 e1                	jbe    80102a45 <freerange+0x18>
    kfree(p);
}
80102a64:	c9                   	leave  
80102a65:	c3                   	ret    

80102a66 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a66:	55                   	push   %ebp
80102a67:	89 e5                	mov    %esp,%ebp
80102a69:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a6c:	8b 45 08             	mov    0x8(%ebp),%eax
80102a6f:	25 ff 0f 00 00       	and    $0xfff,%eax
80102a74:	85 c0                	test   %eax,%eax
80102a76:	75 1b                	jne    80102a93 <kfree+0x2d>
80102a78:	81 7d 08 fc 2a 11 80 	cmpl   $0x80112afc,0x8(%ebp)
80102a7f:	72 12                	jb     80102a93 <kfree+0x2d>
80102a81:	8b 45 08             	mov    0x8(%ebp),%eax
80102a84:	89 04 24             	mov    %eax,(%esp)
80102a87:	e8 38 ff ff ff       	call   801029c4 <v2p>
80102a8c:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102a91:	76 0c                	jbe    80102a9f <kfree+0x39>
    panic("kfree");
80102a93:	c7 04 24 57 87 10 80 	movl   $0x80108757,(%esp)
80102a9a:	e8 9e da ff ff       	call   8010053d <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102a9f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102aa6:	00 
80102aa7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102aae:	00 
80102aaf:	8b 45 08             	mov    0x8(%ebp),%eax
80102ab2:	89 04 24             	mov    %eax,(%esp)
80102ab5:	e8 1c 27 00 00       	call   801051d6 <memset>

  if(kmem.use_lock)
80102aba:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102abf:	85 c0                	test   %eax,%eax
80102ac1:	74 0c                	je     80102acf <kfree+0x69>
    acquire(&kmem.lock);
80102ac3:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102aca:	e8 b8 24 00 00       	call   80104f87 <acquire>
  r = (struct run*)v;
80102acf:	8b 45 08             	mov    0x8(%ebp),%eax
80102ad2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102ad5:	8b 15 78 f8 10 80    	mov    0x8010f878,%edx
80102adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ade:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ae3:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102ae8:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102aed:	85 c0                	test   %eax,%eax
80102aef:	74 0c                	je     80102afd <kfree+0x97>
    release(&kmem.lock);
80102af1:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102af8:	e8 ec 24 00 00       	call   80104fe9 <release>
}
80102afd:	c9                   	leave  
80102afe:	c3                   	ret    

80102aff <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102aff:	55                   	push   %ebp
80102b00:	89 e5                	mov    %esp,%ebp
80102b02:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b05:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b0a:	85 c0                	test   %eax,%eax
80102b0c:	74 0c                	je     80102b1a <kalloc+0x1b>
    acquire(&kmem.lock);
80102b0e:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b15:	e8 6d 24 00 00       	call   80104f87 <acquire>
  r = kmem.freelist;
80102b1a:	a1 78 f8 10 80       	mov    0x8010f878,%eax
80102b1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b22:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b26:	74 0a                	je     80102b32 <kalloc+0x33>
    kmem.freelist = r->next;
80102b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b2b:	8b 00                	mov    (%eax),%eax
80102b2d:	a3 78 f8 10 80       	mov    %eax,0x8010f878
  if(kmem.use_lock)
80102b32:	a1 74 f8 10 80       	mov    0x8010f874,%eax
80102b37:	85 c0                	test   %eax,%eax
80102b39:	74 0c                	je     80102b47 <kalloc+0x48>
    release(&kmem.lock);
80102b3b:	c7 04 24 40 f8 10 80 	movl   $0x8010f840,(%esp)
80102b42:	e8 a2 24 00 00       	call   80104fe9 <release>
  return (char*)r;
80102b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b4a:	c9                   	leave  
80102b4b:	c3                   	ret    

80102b4c <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b4c:	55                   	push   %ebp
80102b4d:	89 e5                	mov    %esp,%ebp
80102b4f:	53                   	push   %ebx
80102b50:	83 ec 14             	sub    $0x14,%esp
80102b53:	8b 45 08             	mov    0x8(%ebp),%eax
80102b56:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5a:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
80102b5e:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80102b62:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
80102b66:	ec                   	in     (%dx),%al
80102b67:	89 c3                	mov    %eax,%ebx
80102b69:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80102b6c:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
80102b70:	83 c4 14             	add    $0x14,%esp
80102b73:	5b                   	pop    %ebx
80102b74:	5d                   	pop    %ebp
80102b75:	c3                   	ret    

80102b76 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b76:	55                   	push   %ebp
80102b77:	89 e5                	mov    %esp,%ebp
80102b79:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102b7c:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102b83:	e8 c4 ff ff ff       	call   80102b4c <inb>
80102b88:	0f b6 c0             	movzbl %al,%eax
80102b8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b91:	83 e0 01             	and    $0x1,%eax
80102b94:	85 c0                	test   %eax,%eax
80102b96:	75 0a                	jne    80102ba2 <kbdgetc+0x2c>
    return -1;
80102b98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102b9d:	e9 23 01 00 00       	jmp    80102cc5 <kbdgetc+0x14f>
  data = inb(KBDATAP);
80102ba2:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102ba9:	e8 9e ff ff ff       	call   80102b4c <inb>
80102bae:	0f b6 c0             	movzbl %al,%eax
80102bb1:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102bb4:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102bbb:	75 17                	jne    80102bd4 <kbdgetc+0x5e>
    shift |= E0ESC;
80102bbd:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102bc2:	83 c8 40             	or     $0x40,%eax
80102bc5:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102bca:	b8 00 00 00 00       	mov    $0x0,%eax
80102bcf:	e9 f1 00 00 00       	jmp    80102cc5 <kbdgetc+0x14f>
  } else if(data & 0x80){
80102bd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bd7:	25 80 00 00 00       	and    $0x80,%eax
80102bdc:	85 c0                	test   %eax,%eax
80102bde:	74 45                	je     80102c25 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102be0:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102be5:	83 e0 40             	and    $0x40,%eax
80102be8:	85 c0                	test   %eax,%eax
80102bea:	75 08                	jne    80102bf4 <kbdgetc+0x7e>
80102bec:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bef:	83 e0 7f             	and    $0x7f,%eax
80102bf2:	eb 03                	jmp    80102bf7 <kbdgetc+0x81>
80102bf4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bf7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102bfa:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bfd:	05 20 90 10 80       	add    $0x80109020,%eax
80102c02:	0f b6 00             	movzbl (%eax),%eax
80102c05:	83 c8 40             	or     $0x40,%eax
80102c08:	0f b6 c0             	movzbl %al,%eax
80102c0b:	f7 d0                	not    %eax
80102c0d:	89 c2                	mov    %eax,%edx
80102c0f:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c14:	21 d0                	and    %edx,%eax
80102c16:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
    return 0;
80102c1b:	b8 00 00 00 00       	mov    $0x0,%eax
80102c20:	e9 a0 00 00 00       	jmp    80102cc5 <kbdgetc+0x14f>
  } else if(shift & E0ESC){
80102c25:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c2a:	83 e0 40             	and    $0x40,%eax
80102c2d:	85 c0                	test   %eax,%eax
80102c2f:	74 14                	je     80102c45 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c31:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102c38:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c3d:	83 e0 bf             	and    $0xffffffbf,%eax
80102c40:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  }

  shift |= shiftcode[data];
80102c45:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c48:	05 20 90 10 80       	add    $0x80109020,%eax
80102c4d:	0f b6 00             	movzbl (%eax),%eax
80102c50:	0f b6 d0             	movzbl %al,%edx
80102c53:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c58:	09 d0                	or     %edx,%eax
80102c5a:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  shift ^= togglecode[data];
80102c5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c62:	05 20 91 10 80       	add    $0x80109120,%eax
80102c67:	0f b6 00             	movzbl (%eax),%eax
80102c6a:	0f b6 d0             	movzbl %al,%edx
80102c6d:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c72:	31 d0                	xor    %edx,%eax
80102c74:	a3 3c b6 10 80       	mov    %eax,0x8010b63c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c79:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c7e:	83 e0 03             	and    $0x3,%eax
80102c81:	8b 04 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%eax
80102c88:	03 45 fc             	add    -0x4(%ebp),%eax
80102c8b:	0f b6 00             	movzbl (%eax),%eax
80102c8e:	0f b6 c0             	movzbl %al,%eax
80102c91:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102c94:	a1 3c b6 10 80       	mov    0x8010b63c,%eax
80102c99:	83 e0 08             	and    $0x8,%eax
80102c9c:	85 c0                	test   %eax,%eax
80102c9e:	74 22                	je     80102cc2 <kbdgetc+0x14c>
    if('a' <= c && c <= 'z')
80102ca0:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102ca4:	76 0c                	jbe    80102cb2 <kbdgetc+0x13c>
80102ca6:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102caa:	77 06                	ja     80102cb2 <kbdgetc+0x13c>
      c += 'A' - 'a';
80102cac:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102cb0:	eb 10                	jmp    80102cc2 <kbdgetc+0x14c>
    else if('A' <= c && c <= 'Z')
80102cb2:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102cb6:	76 0a                	jbe    80102cc2 <kbdgetc+0x14c>
80102cb8:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102cbc:	77 04                	ja     80102cc2 <kbdgetc+0x14c>
      c += 'a' - 'A';
80102cbe:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102cc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102cc5:	c9                   	leave  
80102cc6:	c3                   	ret    

80102cc7 <kbdintr>:

void
kbdintr(void)
{
80102cc7:	55                   	push   %ebp
80102cc8:	89 e5                	mov    %esp,%ebp
80102cca:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102ccd:	c7 04 24 76 2b 10 80 	movl   $0x80102b76,(%esp)
80102cd4:	e8 d4 da ff ff       	call   801007ad <consoleintr>
}
80102cd9:	c9                   	leave  
80102cda:	c3                   	ret    
	...

80102cdc <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102cdc:	55                   	push   %ebp
80102cdd:	89 e5                	mov    %esp,%ebp
80102cdf:	83 ec 08             	sub    $0x8,%esp
80102ce2:	8b 55 08             	mov    0x8(%ebp),%edx
80102ce5:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ce8:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102cec:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cef:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102cf3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102cf7:	ee                   	out    %al,(%dx)
}
80102cf8:	c9                   	leave  
80102cf9:	c3                   	ret    

80102cfa <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102cfa:	55                   	push   %ebp
80102cfb:	89 e5                	mov    %esp,%ebp
80102cfd:	53                   	push   %ebx
80102cfe:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102d01:	9c                   	pushf  
80102d02:	5b                   	pop    %ebx
80102d03:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80102d06:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102d09:	83 c4 10             	add    $0x10,%esp
80102d0c:	5b                   	pop    %ebx
80102d0d:	5d                   	pop    %ebp
80102d0e:	c3                   	ret    

80102d0f <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102d0f:	55                   	push   %ebp
80102d10:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102d12:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d17:	8b 55 08             	mov    0x8(%ebp),%edx
80102d1a:	c1 e2 02             	shl    $0x2,%edx
80102d1d:	01 c2                	add    %eax,%edx
80102d1f:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d22:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d24:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d29:	83 c0 20             	add    $0x20,%eax
80102d2c:	8b 00                	mov    (%eax),%eax
}
80102d2e:	5d                   	pop    %ebp
80102d2f:	c3                   	ret    

80102d30 <lapicinit>:
//PAGEBREAK!

void
lapicinit(int c)
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102d36:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102d3b:	85 c0                	test   %eax,%eax
80102d3d:	0f 84 47 01 00 00    	je     80102e8a <lapicinit+0x15a>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d43:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d4a:	00 
80102d4b:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d52:	e8 b8 ff ff ff       	call   80102d0f <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d57:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d5e:	00 
80102d5f:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d66:	e8 a4 ff ff ff       	call   80102d0f <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102d6b:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102d72:	00 
80102d73:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102d7a:	e8 90 ff ff ff       	call   80102d0f <lapicw>
  lapicw(TICR, 10000000); 
80102d7f:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102d86:	00 
80102d87:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102d8e:	e8 7c ff ff ff       	call   80102d0f <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102d93:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102d9a:	00 
80102d9b:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102da2:	e8 68 ff ff ff       	call   80102d0f <lapicw>
  lapicw(LINT1, MASKED);
80102da7:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dae:	00 
80102daf:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102db6:	e8 54 ff ff ff       	call   80102d0f <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102dbb:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102dc0:	83 c0 30             	add    $0x30,%eax
80102dc3:	8b 00                	mov    (%eax),%eax
80102dc5:	c1 e8 10             	shr    $0x10,%eax
80102dc8:	25 ff 00 00 00       	and    $0xff,%eax
80102dcd:	83 f8 03             	cmp    $0x3,%eax
80102dd0:	76 14                	jbe    80102de6 <lapicinit+0xb6>
    lapicw(PCINT, MASKED);
80102dd2:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dd9:	00 
80102dda:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102de1:	e8 29 ff ff ff       	call   80102d0f <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102de6:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102ded:	00 
80102dee:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102df5:	e8 15 ff ff ff       	call   80102d0f <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102dfa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e01:	00 
80102e02:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e09:	e8 01 ff ff ff       	call   80102d0f <lapicw>
  lapicw(ESR, 0);
80102e0e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e15:	00 
80102e16:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e1d:	e8 ed fe ff ff       	call   80102d0f <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e22:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e29:	00 
80102e2a:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102e31:	e8 d9 fe ff ff       	call   80102d0f <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102e36:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e3d:	00 
80102e3e:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e45:	e8 c5 fe ff ff       	call   80102d0f <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e4a:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e51:	00 
80102e52:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e59:	e8 b1 fe ff ff       	call   80102d0f <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e5e:	90                   	nop
80102e5f:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102e64:	05 00 03 00 00       	add    $0x300,%eax
80102e69:	8b 00                	mov    (%eax),%eax
80102e6b:	25 00 10 00 00       	and    $0x1000,%eax
80102e70:	85 c0                	test   %eax,%eax
80102e72:	75 eb                	jne    80102e5f <lapicinit+0x12f>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e74:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e7b:	00 
80102e7c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102e83:	e8 87 fe ff ff       	call   80102d0f <lapicw>
80102e88:	eb 01                	jmp    80102e8b <lapicinit+0x15b>

void
lapicinit(int c)
{
  if(!lapic) 
    return;
80102e8a:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102e8b:	c9                   	leave  
80102e8c:	c3                   	ret    

80102e8d <cpunum>:

int
cpunum(void)
{
80102e8d:	55                   	push   %ebp
80102e8e:	89 e5                	mov    %esp,%ebp
80102e90:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102e93:	e8 62 fe ff ff       	call   80102cfa <readeflags>
80102e98:	25 00 02 00 00       	and    $0x200,%eax
80102e9d:	85 c0                	test   %eax,%eax
80102e9f:	74 29                	je     80102eca <cpunum+0x3d>
    static int n;
    if(n++ == 0)
80102ea1:	a1 40 b6 10 80       	mov    0x8010b640,%eax
80102ea6:	85 c0                	test   %eax,%eax
80102ea8:	0f 94 c2             	sete   %dl
80102eab:	83 c0 01             	add    $0x1,%eax
80102eae:	a3 40 b6 10 80       	mov    %eax,0x8010b640
80102eb3:	84 d2                	test   %dl,%dl
80102eb5:	74 13                	je     80102eca <cpunum+0x3d>
      cprintf("cpu called from %x with interrupts enabled\n",
80102eb7:	8b 45 04             	mov    0x4(%ebp),%eax
80102eba:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ebe:	c7 04 24 60 87 10 80 	movl   $0x80108760,(%esp)
80102ec5:	e8 d7 d4 ff ff       	call   801003a1 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102eca:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102ecf:	85 c0                	test   %eax,%eax
80102ed1:	74 0f                	je     80102ee2 <cpunum+0x55>
    return lapic[ID]>>24;
80102ed3:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102ed8:	83 c0 20             	add    $0x20,%eax
80102edb:	8b 00                	mov    (%eax),%eax
80102edd:	c1 e8 18             	shr    $0x18,%eax
80102ee0:	eb 05                	jmp    80102ee7 <cpunum+0x5a>
  return 0;
80102ee2:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102ee7:	c9                   	leave  
80102ee8:	c3                   	ret    

80102ee9 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102ee9:	55                   	push   %ebp
80102eea:	89 e5                	mov    %esp,%ebp
80102eec:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102eef:	a1 7c f8 10 80       	mov    0x8010f87c,%eax
80102ef4:	85 c0                	test   %eax,%eax
80102ef6:	74 14                	je     80102f0c <lapiceoi+0x23>
    lapicw(EOI, 0);
80102ef8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102eff:	00 
80102f00:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f07:	e8 03 fe ff ff       	call   80102d0f <lapicw>
}
80102f0c:	c9                   	leave  
80102f0d:	c3                   	ret    

80102f0e <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f0e:	55                   	push   %ebp
80102f0f:	89 e5                	mov    %esp,%ebp
}
80102f11:	5d                   	pop    %ebp
80102f12:	c3                   	ret    

80102f13 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f13:	55                   	push   %ebp
80102f14:	89 e5                	mov    %esp,%ebp
80102f16:	83 ec 1c             	sub    $0x1c,%esp
80102f19:	8b 45 08             	mov    0x8(%ebp),%eax
80102f1c:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
80102f1f:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f26:	00 
80102f27:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f2e:	e8 a9 fd ff ff       	call   80102cdc <outb>
  outb(IO_RTC+1, 0x0A);
80102f33:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102f3a:	00 
80102f3b:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102f42:	e8 95 fd ff ff       	call   80102cdc <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f47:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f51:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f56:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f59:	8d 50 02             	lea    0x2(%eax),%edx
80102f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f5f:	c1 e8 04             	shr    $0x4,%eax
80102f62:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f65:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f69:	c1 e0 18             	shl    $0x18,%eax
80102f6c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f70:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f77:	e8 93 fd ff ff       	call   80102d0f <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f7c:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102f83:	00 
80102f84:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102f8b:	e8 7f fd ff ff       	call   80102d0f <lapicw>
  microdelay(200);
80102f90:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102f97:	e8 72 ff ff ff       	call   80102f0e <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102f9c:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102fa3:	00 
80102fa4:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fab:	e8 5f fd ff ff       	call   80102d0f <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102fb0:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102fb7:	e8 52 ff ff ff       	call   80102f0e <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fbc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102fc3:	eb 40                	jmp    80103005 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80102fc5:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fc9:	c1 e0 18             	shl    $0x18,%eax
80102fcc:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fd0:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102fd7:	e8 33 fd ff ff       	call   80102d0f <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102fdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80102fdf:	c1 e8 0c             	shr    $0xc,%eax
80102fe2:	80 cc 06             	or     $0x6,%ah
80102fe5:	89 44 24 04          	mov    %eax,0x4(%esp)
80102fe9:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102ff0:	e8 1a fd ff ff       	call   80102d0f <lapicw>
    microdelay(200);
80102ff5:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102ffc:	e8 0d ff ff ff       	call   80102f0e <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103001:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103005:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103009:	7e ba                	jle    80102fc5 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010300b:	c9                   	leave  
8010300c:	c3                   	ret    
8010300d:	00 00                	add    %al,(%eax)
	...

80103010 <initlog>:

static void recover_from_log(void);

void
initlog(void)
{
80103010:	55                   	push   %ebp
80103011:	89 e5                	mov    %esp,%ebp
80103013:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103016:	c7 44 24 04 8c 87 10 	movl   $0x8010878c,0x4(%esp)
8010301d:	80 
8010301e:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103025:	e8 3c 1f 00 00       	call   80104f66 <initlock>
  readsb(ROOTDEV, &sb);
8010302a:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010302d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103031:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103038:	e8 af e2 ff ff       	call   801012ec <readsb>
  log.start = sb.size - sb.nlog;
8010303d:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103040:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103043:	89 d1                	mov    %edx,%ecx
80103045:	29 c1                	sub    %eax,%ecx
80103047:	89 c8                	mov    %ecx,%eax
80103049:	a3 b4 f8 10 80       	mov    %eax,0x8010f8b4
  log.size = sb.nlog;
8010304e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103051:	a3 b8 f8 10 80       	mov    %eax,0x8010f8b8
  log.dev = ROOTDEV;
80103056:	c7 05 c0 f8 10 80 01 	movl   $0x1,0x8010f8c0
8010305d:	00 00 00 
  recover_from_log();
80103060:	e8 97 01 00 00       	call   801031fc <recover_from_log>
}
80103065:	c9                   	leave  
80103066:	c3                   	ret    

80103067 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103067:	55                   	push   %ebp
80103068:	89 e5                	mov    %esp,%ebp
8010306a:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010306d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103074:	e9 89 00 00 00       	jmp    80103102 <install_trans+0x9b>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80103079:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
8010307e:	03 45 f4             	add    -0xc(%ebp),%eax
80103081:	83 c0 01             	add    $0x1,%eax
80103084:	89 c2                	mov    %eax,%edx
80103086:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
8010308b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010308f:	89 04 24             	mov    %eax,(%esp)
80103092:	e8 0f d1 ff ff       	call   801001a6 <bread>
80103097:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
8010309a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010309d:	83 c0 10             	add    $0x10,%eax
801030a0:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
801030a7:	89 c2                	mov    %eax,%edx
801030a9:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
801030ae:	89 54 24 04          	mov    %edx,0x4(%esp)
801030b2:	89 04 24             	mov    %eax,(%esp)
801030b5:	e8 ec d0 ff ff       	call   801001a6 <bread>
801030ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801030bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030c0:	8d 50 18             	lea    0x18(%eax),%edx
801030c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030c6:	83 c0 18             	add    $0x18,%eax
801030c9:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801030d0:	00 
801030d1:	89 54 24 04          	mov    %edx,0x4(%esp)
801030d5:	89 04 24             	mov    %eax,(%esp)
801030d8:	e8 cc 21 00 00       	call   801052a9 <memmove>
    bwrite(dbuf);  // write dst to disk
801030dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030e0:	89 04 24             	mov    %eax,(%esp)
801030e3:	e8 f5 d0 ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
801030e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801030eb:	89 04 24             	mov    %eax,(%esp)
801030ee:	e8 24 d1 ff ff       	call   80100217 <brelse>
    brelse(dbuf);
801030f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801030f6:	89 04 24             	mov    %eax,(%esp)
801030f9:	e8 19 d1 ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801030fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103102:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103107:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010310a:	0f 8f 69 ff ff ff    	jg     80103079 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103110:	c9                   	leave  
80103111:	c3                   	ret    

80103112 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103112:	55                   	push   %ebp
80103113:	89 e5                	mov    %esp,%ebp
80103115:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103118:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
8010311d:	89 c2                	mov    %eax,%edx
8010311f:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103124:	89 54 24 04          	mov    %edx,0x4(%esp)
80103128:	89 04 24             	mov    %eax,(%esp)
8010312b:	e8 76 d0 ff ff       	call   801001a6 <bread>
80103130:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103133:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103136:	83 c0 18             	add    $0x18,%eax
80103139:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
8010313c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010313f:	8b 00                	mov    (%eax),%eax
80103141:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  for (i = 0; i < log.lh.n; i++) {
80103146:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010314d:	eb 1b                	jmp    8010316a <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
8010314f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103152:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103155:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103159:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010315c:	83 c2 10             	add    $0x10,%edx
8010315f:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103166:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010316a:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010316f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103172:	7f db                	jg     8010314f <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
80103174:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103177:	89 04 24             	mov    %eax,(%esp)
8010317a:	e8 98 d0 ff ff       	call   80100217 <brelse>
}
8010317f:	c9                   	leave  
80103180:	c3                   	ret    

80103181 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80103181:	55                   	push   %ebp
80103182:	89 e5                	mov    %esp,%ebp
80103184:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103187:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
8010318c:	89 c2                	mov    %eax,%edx
8010318e:	a1 c0 f8 10 80       	mov    0x8010f8c0,%eax
80103193:	89 54 24 04          	mov    %edx,0x4(%esp)
80103197:	89 04 24             	mov    %eax,(%esp)
8010319a:	e8 07 d0 ff ff       	call   801001a6 <bread>
8010319f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801031a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031a5:	83 c0 18             	add    $0x18,%eax
801031a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801031ab:	8b 15 c4 f8 10 80    	mov    0x8010f8c4,%edx
801031b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031b4:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801031b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801031bd:	eb 1b                	jmp    801031da <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
801031bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801031c2:	83 c0 10             	add    $0x10,%eax
801031c5:	8b 0c 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%ecx
801031cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801031d2:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
801031d6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801031da:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801031df:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801031e2:	7f db                	jg     801031bf <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
801031e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031e7:	89 04 24             	mov    %eax,(%esp)
801031ea:	e8 ee cf ff ff       	call   801001dd <bwrite>
  brelse(buf);
801031ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801031f2:	89 04 24             	mov    %eax,(%esp)
801031f5:	e8 1d d0 ff ff       	call   80100217 <brelse>
}
801031fa:	c9                   	leave  
801031fb:	c3                   	ret    

801031fc <recover_from_log>:

static void
recover_from_log(void)
{
801031fc:	55                   	push   %ebp
801031fd:	89 e5                	mov    %esp,%ebp
801031ff:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103202:	e8 0b ff ff ff       	call   80103112 <read_head>
  install_trans(); // if committed, copy from log to disk
80103207:	e8 5b fe ff ff       	call   80103067 <install_trans>
  log.lh.n = 0;
8010320c:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
80103213:	00 00 00 
  write_head(); // clear the log
80103216:	e8 66 ff ff ff       	call   80103181 <write_head>
}
8010321b:	c9                   	leave  
8010321c:	c3                   	ret    

8010321d <begin_trans>:

void
begin_trans(void)
{
8010321d:	55                   	push   %ebp
8010321e:	89 e5                	mov    %esp,%ebp
80103220:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103223:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010322a:	e8 58 1d 00 00       	call   80104f87 <acquire>
  while (log.busy) {
8010322f:	eb 14                	jmp    80103245 <begin_trans+0x28>
    sleep(&log, &log.lock);
80103231:	c7 44 24 04 80 f8 10 	movl   $0x8010f880,0x4(%esp)
80103238:	80 
80103239:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103240:	e8 b4 16 00 00       	call   801048f9 <sleep>

void
begin_trans(void)
{
  acquire(&log.lock);
  while (log.busy) {
80103245:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
8010324a:	85 c0                	test   %eax,%eax
8010324c:	75 e3                	jne    80103231 <begin_trans+0x14>
    sleep(&log, &log.lock);
  }
  log.busy = 1;
8010324e:	c7 05 bc f8 10 80 01 	movl   $0x1,0x8010f8bc
80103255:	00 00 00 
  release(&log.lock);
80103258:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
8010325f:	e8 85 1d 00 00       	call   80104fe9 <release>
}
80103264:	c9                   	leave  
80103265:	c3                   	ret    

80103266 <commit_trans>:

void
commit_trans(void)
{
80103266:	55                   	push   %ebp
80103267:	89 e5                	mov    %esp,%ebp
80103269:	83 ec 18             	sub    $0x18,%esp
  if (log.lh.n > 0) {
8010326c:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
80103271:	85 c0                	test   %eax,%eax
80103273:	7e 19                	jle    8010328e <commit_trans+0x28>
    write_head();    // Write header to disk -- the real commit
80103275:	e8 07 ff ff ff       	call   80103181 <write_head>
    install_trans(); // Now install writes to home locations
8010327a:	e8 e8 fd ff ff       	call   80103067 <install_trans>
    log.lh.n = 0; 
8010327f:	c7 05 c4 f8 10 80 00 	movl   $0x0,0x8010f8c4
80103286:	00 00 00 
    write_head();    // Erase the transaction from the log
80103289:	e8 f3 fe ff ff       	call   80103181 <write_head>
  }
  
  acquire(&log.lock);
8010328e:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
80103295:	e8 ed 1c 00 00       	call   80104f87 <acquire>
  log.busy = 0;
8010329a:	c7 05 bc f8 10 80 00 	movl   $0x0,0x8010f8bc
801032a1:	00 00 00 
  wakeup(&log);
801032a4:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801032ab:	e8 25 17 00 00       	call   801049d5 <wakeup>
  release(&log.lock);
801032b0:	c7 04 24 80 f8 10 80 	movl   $0x8010f880,(%esp)
801032b7:	e8 2d 1d 00 00       	call   80104fe9 <release>
}
801032bc:	c9                   	leave  
801032bd:	c3                   	ret    

801032be <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801032be:	55                   	push   %ebp
801032bf:	89 e5                	mov    %esp,%ebp
801032c1:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801032c4:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801032c9:	83 f8 09             	cmp    $0x9,%eax
801032cc:	7f 12                	jg     801032e0 <log_write+0x22>
801032ce:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801032d3:	8b 15 b8 f8 10 80    	mov    0x8010f8b8,%edx
801032d9:	83 ea 01             	sub    $0x1,%edx
801032dc:	39 d0                	cmp    %edx,%eax
801032de:	7c 0c                	jl     801032ec <log_write+0x2e>
    panic("too big a transaction");
801032e0:	c7 04 24 90 87 10 80 	movl   $0x80108790,(%esp)
801032e7:	e8 51 d2 ff ff       	call   8010053d <panic>
  if (!log.busy)
801032ec:	a1 bc f8 10 80       	mov    0x8010f8bc,%eax
801032f1:	85 c0                	test   %eax,%eax
801032f3:	75 0c                	jne    80103301 <log_write+0x43>
    panic("write outside of trans");
801032f5:	c7 04 24 a6 87 10 80 	movl   $0x801087a6,(%esp)
801032fc:	e8 3c d2 ff ff       	call   8010053d <panic>

  for (i = 0; i < log.lh.n; i++) {
80103301:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103308:	eb 1d                	jmp    80103327 <log_write+0x69>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
8010330a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010330d:	83 c0 10             	add    $0x10,%eax
80103310:	8b 04 85 88 f8 10 80 	mov    -0x7fef0778(,%eax,4),%eax
80103317:	89 c2                	mov    %eax,%edx
80103319:	8b 45 08             	mov    0x8(%ebp),%eax
8010331c:	8b 40 08             	mov    0x8(%eax),%eax
8010331f:	39 c2                	cmp    %eax,%edx
80103321:	74 10                	je     80103333 <log_write+0x75>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
  if (!log.busy)
    panic("write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
80103323:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103327:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
8010332c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010332f:	7f d9                	jg     8010330a <log_write+0x4c>
80103331:	eb 01                	jmp    80103334 <log_write+0x76>
    if (log.lh.sector[i] == b->sector)   // log absorbtion?
      break;
80103333:	90                   	nop
  }
  log.lh.sector[i] = b->sector;
80103334:	8b 45 08             	mov    0x8(%ebp),%eax
80103337:	8b 40 08             	mov    0x8(%eax),%eax
8010333a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010333d:	83 c2 10             	add    $0x10,%edx
80103340:	89 04 95 88 f8 10 80 	mov    %eax,-0x7fef0778(,%edx,4)
  struct buf *lbuf = bread(b->dev, log.start+i+1);
80103347:	a1 b4 f8 10 80       	mov    0x8010f8b4,%eax
8010334c:	03 45 f4             	add    -0xc(%ebp),%eax
8010334f:	83 c0 01             	add    $0x1,%eax
80103352:	89 c2                	mov    %eax,%edx
80103354:	8b 45 08             	mov    0x8(%ebp),%eax
80103357:	8b 40 04             	mov    0x4(%eax),%eax
8010335a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010335e:	89 04 24             	mov    %eax,(%esp)
80103361:	e8 40 ce ff ff       	call   801001a6 <bread>
80103366:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(lbuf->data, b->data, BSIZE);
80103369:	8b 45 08             	mov    0x8(%ebp),%eax
8010336c:	8d 50 18             	lea    0x18(%eax),%edx
8010336f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103372:	83 c0 18             	add    $0x18,%eax
80103375:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010337c:	00 
8010337d:	89 54 24 04          	mov    %edx,0x4(%esp)
80103381:	89 04 24             	mov    %eax,(%esp)
80103384:	e8 20 1f 00 00       	call   801052a9 <memmove>
  bwrite(lbuf);
80103389:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010338c:	89 04 24             	mov    %eax,(%esp)
8010338f:	e8 49 ce ff ff       	call   801001dd <bwrite>
  brelse(lbuf);
80103394:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103397:	89 04 24             	mov    %eax,(%esp)
8010339a:	e8 78 ce ff ff       	call   80100217 <brelse>
  if (i == log.lh.n)
8010339f:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801033a4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801033a7:	75 0d                	jne    801033b6 <log_write+0xf8>
    log.lh.n++;
801033a9:	a1 c4 f8 10 80       	mov    0x8010f8c4,%eax
801033ae:	83 c0 01             	add    $0x1,%eax
801033b1:	a3 c4 f8 10 80       	mov    %eax,0x8010f8c4
  b->flags |= B_DIRTY; // XXX prevent eviction
801033b6:	8b 45 08             	mov    0x8(%ebp),%eax
801033b9:	8b 00                	mov    (%eax),%eax
801033bb:	89 c2                	mov    %eax,%edx
801033bd:	83 ca 04             	or     $0x4,%edx
801033c0:	8b 45 08             	mov    0x8(%ebp),%eax
801033c3:	89 10                	mov    %edx,(%eax)
}
801033c5:	c9                   	leave  
801033c6:	c3                   	ret    
	...

801033c8 <v2p>:
801033c8:	55                   	push   %ebp
801033c9:	89 e5                	mov    %esp,%ebp
801033cb:	8b 45 08             	mov    0x8(%ebp),%eax
801033ce:	05 00 00 00 80       	add    $0x80000000,%eax
801033d3:	5d                   	pop    %ebp
801033d4:	c3                   	ret    

801033d5 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801033d5:	55                   	push   %ebp
801033d6:	89 e5                	mov    %esp,%ebp
801033d8:	8b 45 08             	mov    0x8(%ebp),%eax
801033db:	05 00 00 00 80       	add    $0x80000000,%eax
801033e0:	5d                   	pop    %ebp
801033e1:	c3                   	ret    

801033e2 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
801033e2:	55                   	push   %ebp
801033e3:	89 e5                	mov    %esp,%ebp
801033e5:	53                   	push   %ebx
801033e6:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
801033e9:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033ec:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
801033ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801033f2:	89 c3                	mov    %eax,%ebx
801033f4:	89 d8                	mov    %ebx,%eax
801033f6:	f0 87 02             	lock xchg %eax,(%edx)
801033f9:	89 c3                	mov    %eax,%ebx
801033fb:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801033fe:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103401:	83 c4 10             	add    $0x10,%esp
80103404:	5b                   	pop    %ebx
80103405:	5d                   	pop    %ebp
80103406:	c3                   	ret    

80103407 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103407:	55                   	push   %ebp
80103408:	89 e5                	mov    %esp,%ebp
8010340a:	83 e4 f0             	and    $0xfffffff0,%esp
8010340d:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103410:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103417:	80 
80103418:	c7 04 24 fc 2a 11 80 	movl   $0x80112afc,(%esp)
8010341f:	e8 ad f5 ff ff       	call   801029d1 <kinit1>
  kvmalloc();      // kernel page table
80103424:	e8 c1 49 00 00       	call   80107dea <kvmalloc>
  mpinit();        // collect info about this machine
80103429:	e8 63 04 00 00       	call   80103891 <mpinit>
  lapicinit(mpbcpu());
8010342e:	e8 2e 02 00 00       	call   80103661 <mpbcpu>
80103433:	89 04 24             	mov    %eax,(%esp)
80103436:	e8 f5 f8 ff ff       	call   80102d30 <lapicinit>
  seginit();       // set up segments
8010343b:	e8 4d 43 00 00       	call   8010778d <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103440:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103446:	0f b6 00             	movzbl (%eax),%eax
80103449:	0f b6 c0             	movzbl %al,%eax
8010344c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103450:	c7 04 24 bd 87 10 80 	movl   $0x801087bd,(%esp)
80103457:	e8 45 cf ff ff       	call   801003a1 <cprintf>
  picinit();       // interrupt controller
8010345c:	e8 95 06 00 00       	call   80103af6 <picinit>
  ioapicinit();    // another interrupt controller
80103461:	e8 5b f4 ff ff       	call   801028c1 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103466:	e8 22 d6 ff ff       	call   80100a8d <consoleinit>
  uartinit();      // serial port
8010346b:	e8 68 36 00 00       	call   80106ad8 <uartinit>
  pinit();         // process table
80103470:	e8 96 0b 00 00       	call   8010400b <pinit>
  tvinit();        // trap vectors
80103475:	e8 01 32 00 00       	call   8010667b <tvinit>
  binit();         // buffer cache
8010347a:	e8 b5 cb ff ff       	call   80100034 <binit>
  fileinit();      // file table
8010347f:	e8 7c da ff ff       	call   80100f00 <fileinit>
  iinit();         // inode cache
80103484:	e8 2a e1 ff ff       	call   801015b3 <iinit>
  ideinit();       // disk
80103489:	e8 98 f0 ff ff       	call   80102526 <ideinit>
  if(!ismp)
8010348e:	a1 04 f9 10 80       	mov    0x8010f904,%eax
80103493:	85 c0                	test   %eax,%eax
80103495:	75 05                	jne    8010349c <main+0x95>
    timerinit();   // uniprocessor timer
80103497:	e8 22 31 00 00       	call   801065be <timerinit>
  startothers();   // start other processors
8010349c:	e8 87 00 00 00       	call   80103528 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801034a1:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801034a8:	8e 
801034a9:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
801034b0:	e8 54 f5 ff ff       	call   80102a09 <kinit2>
  userinit();      // first user process
801034b5:	e8 6f 0c 00 00       	call   80104129 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801034ba:	e8 22 00 00 00       	call   801034e1 <mpmain>

801034bf <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
801034bf:	55                   	push   %ebp
801034c0:	89 e5                	mov    %esp,%ebp
801034c2:	83 ec 18             	sub    $0x18,%esp
  switchkvm(); 
801034c5:	e8 37 49 00 00       	call   80107e01 <switchkvm>
  seginit();
801034ca:	e8 be 42 00 00       	call   8010778d <seginit>
  lapicinit(cpunum());
801034cf:	e8 b9 f9 ff ff       	call   80102e8d <cpunum>
801034d4:	89 04 24             	mov    %eax,(%esp)
801034d7:	e8 54 f8 ff ff       	call   80102d30 <lapicinit>
  mpmain();
801034dc:	e8 00 00 00 00       	call   801034e1 <mpmain>

801034e1 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801034e1:	55                   	push   %ebp
801034e2:	89 e5                	mov    %esp,%ebp
801034e4:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
801034e7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801034ed:	0f b6 00             	movzbl (%eax),%eax
801034f0:	0f b6 c0             	movzbl %al,%eax
801034f3:	89 44 24 04          	mov    %eax,0x4(%esp)
801034f7:	c7 04 24 d4 87 10 80 	movl   $0x801087d4,(%esp)
801034fe:	e8 9e ce ff ff       	call   801003a1 <cprintf>
  idtinit();       // load idt register
80103503:	e8 e7 32 00 00       	call   801067ef <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103508:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010350e:	05 a8 00 00 00       	add    $0xa8,%eax
80103513:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010351a:	00 
8010351b:	89 04 24             	mov    %eax,(%esp)
8010351e:	e8 bf fe ff ff       	call   801033e2 <xchg>
  scheduler();     // start running processes
80103523:	e8 25 12 00 00       	call   8010474d <scheduler>

80103528 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103528:	55                   	push   %ebp
80103529:	89 e5                	mov    %esp,%ebp
8010352b:	53                   	push   %ebx
8010352c:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
8010352f:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
80103536:	e8 9a fe ff ff       	call   801033d5 <p2v>
8010353b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
8010353e:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103543:	89 44 24 08          	mov    %eax,0x8(%esp)
80103547:	c7 44 24 04 0c b5 10 	movl   $0x8010b50c,0x4(%esp)
8010354e:	80 
8010354f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103552:	89 04 24             	mov    %eax,(%esp)
80103555:	e8 4f 1d 00 00       	call   801052a9 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
8010355a:	c7 45 f4 20 f9 10 80 	movl   $0x8010f920,-0xc(%ebp)
80103561:	e9 86 00 00 00       	jmp    801035ec <startothers+0xc4>
    if(c == cpus+cpunum())  // We've started already.
80103566:	e8 22 f9 ff ff       	call   80102e8d <cpunum>
8010356b:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103571:	05 20 f9 10 80       	add    $0x8010f920,%eax
80103576:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103579:	74 69                	je     801035e4 <startothers+0xbc>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
8010357b:	e8 7f f5 ff ff       	call   80102aff <kalloc>
80103580:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103583:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103586:	83 e8 04             	sub    $0x4,%eax
80103589:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010358c:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103592:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103594:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103597:	83 e8 08             	sub    $0x8,%eax
8010359a:	c7 00 bf 34 10 80    	movl   $0x801034bf,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
801035a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035a3:	8d 58 f4             	lea    -0xc(%eax),%ebx
801035a6:	c7 04 24 00 a0 10 80 	movl   $0x8010a000,(%esp)
801035ad:	e8 16 fe ff ff       	call   801033c8 <v2p>
801035b2:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
801035b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035b7:	89 04 24             	mov    %eax,(%esp)
801035ba:	e8 09 fe ff ff       	call   801033c8 <v2p>
801035bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801035c2:	0f b6 12             	movzbl (%edx),%edx
801035c5:	0f b6 d2             	movzbl %dl,%edx
801035c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801035cc:	89 14 24             	mov    %edx,(%esp)
801035cf:	e8 3f f9 ff ff       	call   80102f13 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
801035d4:	90                   	nop
801035d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035d8:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801035de:	85 c0                	test   %eax,%eax
801035e0:	74 f3                	je     801035d5 <startothers+0xad>
801035e2:	eb 01                	jmp    801035e5 <startothers+0xbd>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
801035e4:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
801035e5:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
801035ec:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801035f1:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801035f7:	05 20 f9 10 80       	add    $0x8010f920,%eax
801035fc:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801035ff:	0f 87 61 ff ff ff    	ja     80103566 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103605:	83 c4 24             	add    $0x24,%esp
80103608:	5b                   	pop    %ebx
80103609:	5d                   	pop    %ebp
8010360a:	c3                   	ret    
	...

8010360c <p2v>:
8010360c:	55                   	push   %ebp
8010360d:	89 e5                	mov    %esp,%ebp
8010360f:	8b 45 08             	mov    0x8(%ebp),%eax
80103612:	05 00 00 00 80       	add    $0x80000000,%eax
80103617:	5d                   	pop    %ebp
80103618:	c3                   	ret    

80103619 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103619:	55                   	push   %ebp
8010361a:	89 e5                	mov    %esp,%ebp
8010361c:	53                   	push   %ebx
8010361d:	83 ec 14             	sub    $0x14,%esp
80103620:	8b 45 08             	mov    0x8(%ebp),%eax
80103623:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103627:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
8010362b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
8010362f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
80103633:	ec                   	in     (%dx),%al
80103634:	89 c3                	mov    %eax,%ebx
80103636:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80103639:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
8010363d:	83 c4 14             	add    $0x14,%esp
80103640:	5b                   	pop    %ebx
80103641:	5d                   	pop    %ebp
80103642:	c3                   	ret    

80103643 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103643:	55                   	push   %ebp
80103644:	89 e5                	mov    %esp,%ebp
80103646:	83 ec 08             	sub    $0x8,%esp
80103649:	8b 55 08             	mov    0x8(%ebp),%edx
8010364c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010364f:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103653:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103656:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010365a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010365e:	ee                   	out    %al,(%dx)
}
8010365f:	c9                   	leave  
80103660:	c3                   	ret    

80103661 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103661:	55                   	push   %ebp
80103662:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103664:	a1 44 b6 10 80       	mov    0x8010b644,%eax
80103669:	89 c2                	mov    %eax,%edx
8010366b:	b8 20 f9 10 80       	mov    $0x8010f920,%eax
80103670:	89 d1                	mov    %edx,%ecx
80103672:	29 c1                	sub    %eax,%ecx
80103674:	89 c8                	mov    %ecx,%eax
80103676:	c1 f8 02             	sar    $0x2,%eax
80103679:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
8010367f:	5d                   	pop    %ebp
80103680:	c3                   	ret    

80103681 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103681:	55                   	push   %ebp
80103682:	89 e5                	mov    %esp,%ebp
80103684:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103687:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
8010368e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103695:	eb 13                	jmp    801036aa <sum+0x29>
    sum += addr[i];
80103697:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010369a:	03 45 08             	add    0x8(%ebp),%eax
8010369d:	0f b6 00             	movzbl (%eax),%eax
801036a0:	0f b6 c0             	movzbl %al,%eax
801036a3:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
801036a6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801036aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
801036ad:	3b 45 0c             	cmp    0xc(%ebp),%eax
801036b0:	7c e5                	jl     80103697 <sum+0x16>
    sum += addr[i];
  return sum;
801036b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801036b5:	c9                   	leave  
801036b6:	c3                   	ret    

801036b7 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801036b7:	55                   	push   %ebp
801036b8:	89 e5                	mov    %esp,%ebp
801036ba:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
801036bd:	8b 45 08             	mov    0x8(%ebp),%eax
801036c0:	89 04 24             	mov    %eax,(%esp)
801036c3:	e8 44 ff ff ff       	call   8010360c <p2v>
801036c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
801036cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801036ce:	03 45 f0             	add    -0x10(%ebp),%eax
801036d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
801036d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801036d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801036da:	eb 3f                	jmp    8010371b <mpsearch1+0x64>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801036dc:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801036e3:	00 
801036e4:	c7 44 24 04 e8 87 10 	movl   $0x801087e8,0x4(%esp)
801036eb:	80 
801036ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036ef:	89 04 24             	mov    %eax,(%esp)
801036f2:	e8 56 1b 00 00       	call   8010524d <memcmp>
801036f7:	85 c0                	test   %eax,%eax
801036f9:	75 1c                	jne    80103717 <mpsearch1+0x60>
801036fb:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103702:	00 
80103703:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103706:	89 04 24             	mov    %eax,(%esp)
80103709:	e8 73 ff ff ff       	call   80103681 <sum>
8010370e:	84 c0                	test   %al,%al
80103710:	75 05                	jne    80103717 <mpsearch1+0x60>
      return (struct mp*)p;
80103712:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103715:	eb 11                	jmp    80103728 <mpsearch1+0x71>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103717:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010371b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010371e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103721:	72 b9                	jb     801036dc <mpsearch1+0x25>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103723:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103728:	c9                   	leave  
80103729:	c3                   	ret    

8010372a <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
8010372a:	55                   	push   %ebp
8010372b:	89 e5                	mov    %esp,%ebp
8010372d:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103730:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103737:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010373a:	83 c0 0f             	add    $0xf,%eax
8010373d:	0f b6 00             	movzbl (%eax),%eax
80103740:	0f b6 c0             	movzbl %al,%eax
80103743:	89 c2                	mov    %eax,%edx
80103745:	c1 e2 08             	shl    $0x8,%edx
80103748:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010374b:	83 c0 0e             	add    $0xe,%eax
8010374e:	0f b6 00             	movzbl (%eax),%eax
80103751:	0f b6 c0             	movzbl %al,%eax
80103754:	09 d0                	or     %edx,%eax
80103756:	c1 e0 04             	shl    $0x4,%eax
80103759:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010375c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103760:	74 21                	je     80103783 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103762:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103769:	00 
8010376a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010376d:	89 04 24             	mov    %eax,(%esp)
80103770:	e8 42 ff ff ff       	call   801036b7 <mpsearch1>
80103775:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103778:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010377c:	74 50                	je     801037ce <mpsearch+0xa4>
      return mp;
8010377e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103781:	eb 5f                	jmp    801037e2 <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103783:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103786:	83 c0 14             	add    $0x14,%eax
80103789:	0f b6 00             	movzbl (%eax),%eax
8010378c:	0f b6 c0             	movzbl %al,%eax
8010378f:	89 c2                	mov    %eax,%edx
80103791:	c1 e2 08             	shl    $0x8,%edx
80103794:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103797:	83 c0 13             	add    $0x13,%eax
8010379a:	0f b6 00             	movzbl (%eax),%eax
8010379d:	0f b6 c0             	movzbl %al,%eax
801037a0:	09 d0                	or     %edx,%eax
801037a2:	c1 e0 0a             	shl    $0xa,%eax
801037a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
801037a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801037ab:	2d 00 04 00 00       	sub    $0x400,%eax
801037b0:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
801037b7:	00 
801037b8:	89 04 24             	mov    %eax,(%esp)
801037bb:	e8 f7 fe ff ff       	call   801036b7 <mpsearch1>
801037c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
801037c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801037c7:	74 05                	je     801037ce <mpsearch+0xa4>
      return mp;
801037c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037cc:	eb 14                	jmp    801037e2 <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
801037ce:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
801037d5:	00 
801037d6:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
801037dd:	e8 d5 fe ff ff       	call   801036b7 <mpsearch1>
}
801037e2:	c9                   	leave  
801037e3:	c3                   	ret    

801037e4 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
801037e4:	55                   	push   %ebp
801037e5:	89 e5                	mov    %esp,%ebp
801037e7:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
801037ea:	e8 3b ff ff ff       	call   8010372a <mpsearch>
801037ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
801037f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801037f6:	74 0a                	je     80103802 <mpconfig+0x1e>
801037f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801037fb:	8b 40 04             	mov    0x4(%eax),%eax
801037fe:	85 c0                	test   %eax,%eax
80103800:	75 0a                	jne    8010380c <mpconfig+0x28>
    return 0;
80103802:	b8 00 00 00 00       	mov    $0x0,%eax
80103807:	e9 83 00 00 00       	jmp    8010388f <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
8010380c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010380f:	8b 40 04             	mov    0x4(%eax),%eax
80103812:	89 04 24             	mov    %eax,(%esp)
80103815:	e8 f2 fd ff ff       	call   8010360c <p2v>
8010381a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010381d:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103824:	00 
80103825:	c7 44 24 04 ed 87 10 	movl   $0x801087ed,0x4(%esp)
8010382c:	80 
8010382d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103830:	89 04 24             	mov    %eax,(%esp)
80103833:	e8 15 1a 00 00       	call   8010524d <memcmp>
80103838:	85 c0                	test   %eax,%eax
8010383a:	74 07                	je     80103843 <mpconfig+0x5f>
    return 0;
8010383c:	b8 00 00 00 00       	mov    $0x0,%eax
80103841:	eb 4c                	jmp    8010388f <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103843:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103846:	0f b6 40 06          	movzbl 0x6(%eax),%eax
8010384a:	3c 01                	cmp    $0x1,%al
8010384c:	74 12                	je     80103860 <mpconfig+0x7c>
8010384e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103851:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103855:	3c 04                	cmp    $0x4,%al
80103857:	74 07                	je     80103860 <mpconfig+0x7c>
    return 0;
80103859:	b8 00 00 00 00       	mov    $0x0,%eax
8010385e:	eb 2f                	jmp    8010388f <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103860:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103863:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103867:	0f b7 c0             	movzwl %ax,%eax
8010386a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010386e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103871:	89 04 24             	mov    %eax,(%esp)
80103874:	e8 08 fe ff ff       	call   80103681 <sum>
80103879:	84 c0                	test   %al,%al
8010387b:	74 07                	je     80103884 <mpconfig+0xa0>
    return 0;
8010387d:	b8 00 00 00 00       	mov    $0x0,%eax
80103882:	eb 0b                	jmp    8010388f <mpconfig+0xab>
  *pmp = mp;
80103884:	8b 45 08             	mov    0x8(%ebp),%eax
80103887:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010388a:	89 10                	mov    %edx,(%eax)
  return conf;
8010388c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
8010388f:	c9                   	leave  
80103890:	c3                   	ret    

80103891 <mpinit>:

void
mpinit(void)
{
80103891:	55                   	push   %ebp
80103892:	89 e5                	mov    %esp,%ebp
80103894:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103897:	c7 05 44 b6 10 80 20 	movl   $0x8010f920,0x8010b644
8010389e:	f9 10 80 
  if((conf = mpconfig(&mp)) == 0)
801038a1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801038a4:	89 04 24             	mov    %eax,(%esp)
801038a7:	e8 38 ff ff ff       	call   801037e4 <mpconfig>
801038ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
801038af:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801038b3:	0f 84 9c 01 00 00    	je     80103a55 <mpinit+0x1c4>
    return;
  ismp = 1;
801038b9:	c7 05 04 f9 10 80 01 	movl   $0x1,0x8010f904
801038c0:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
801038c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038c6:	8b 40 24             	mov    0x24(%eax),%eax
801038c9:	a3 7c f8 10 80       	mov    %eax,0x8010f87c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801038ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038d1:	83 c0 2c             	add    $0x2c,%eax
801038d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
801038d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038da:	0f b7 40 04          	movzwl 0x4(%eax),%eax
801038de:	0f b7 c0             	movzwl %ax,%eax
801038e1:	03 45 f0             	add    -0x10(%ebp),%eax
801038e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
801038e7:	e9 f4 00 00 00       	jmp    801039e0 <mpinit+0x14f>
    switch(*p){
801038ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801038ef:	0f b6 00             	movzbl (%eax),%eax
801038f2:	0f b6 c0             	movzbl %al,%eax
801038f5:	83 f8 04             	cmp    $0x4,%eax
801038f8:	0f 87 bf 00 00 00    	ja     801039bd <mpinit+0x12c>
801038fe:	8b 04 85 30 88 10 80 	mov    -0x7fef77d0(,%eax,4),%eax
80103905:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103907:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010390a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
8010390d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103910:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103914:	0f b6 d0             	movzbl %al,%edx
80103917:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010391c:	39 c2                	cmp    %eax,%edx
8010391e:	74 2d                	je     8010394d <mpinit+0xbc>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103920:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103923:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103927:	0f b6 d0             	movzbl %al,%edx
8010392a:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010392f:	89 54 24 08          	mov    %edx,0x8(%esp)
80103933:	89 44 24 04          	mov    %eax,0x4(%esp)
80103937:	c7 04 24 f2 87 10 80 	movl   $0x801087f2,(%esp)
8010393e:	e8 5e ca ff ff       	call   801003a1 <cprintf>
        ismp = 0;
80103943:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
8010394a:	00 00 00 
      }
      if(proc->flags & MPBOOT)
8010394d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103950:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103954:	0f b6 c0             	movzbl %al,%eax
80103957:	83 e0 02             	and    $0x2,%eax
8010395a:	85 c0                	test   %eax,%eax
8010395c:	74 15                	je     80103973 <mpinit+0xe2>
        bcpu = &cpus[ncpu];
8010395e:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103963:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103969:	05 20 f9 10 80       	add    $0x8010f920,%eax
8010396e:	a3 44 b6 10 80       	mov    %eax,0x8010b644
      cpus[ncpu].id = ncpu;
80103973:	8b 15 00 ff 10 80    	mov    0x8010ff00,%edx
80103979:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010397e:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103984:	81 c2 20 f9 10 80    	add    $0x8010f920,%edx
8010398a:	88 02                	mov    %al,(%edx)
      ncpu++;
8010398c:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
80103991:	83 c0 01             	add    $0x1,%eax
80103994:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
      p += sizeof(struct mpproc);
80103999:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
8010399d:	eb 41                	jmp    801039e0 <mpinit+0x14f>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
8010399f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039a2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
801039a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801039a8:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801039ac:	a2 00 f9 10 80       	mov    %al,0x8010f900
      p += sizeof(struct mpioapic);
801039b1:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
801039b5:	eb 29                	jmp    801039e0 <mpinit+0x14f>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801039b7:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
801039bb:	eb 23                	jmp    801039e0 <mpinit+0x14f>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
801039bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039c0:	0f b6 00             	movzbl (%eax),%eax
801039c3:	0f b6 c0             	movzbl %al,%eax
801039c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801039ca:	c7 04 24 10 88 10 80 	movl   $0x80108810,(%esp)
801039d1:	e8 cb c9 ff ff       	call   801003a1 <cprintf>
      ismp = 0;
801039d6:	c7 05 04 f9 10 80 00 	movl   $0x0,0x8010f904
801039dd:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801039e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039e3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801039e6:	0f 82 00 ff ff ff    	jb     801038ec <mpinit+0x5b>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
801039ec:	a1 04 f9 10 80       	mov    0x8010f904,%eax
801039f1:	85 c0                	test   %eax,%eax
801039f3:	75 1d                	jne    80103a12 <mpinit+0x181>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801039f5:	c7 05 00 ff 10 80 01 	movl   $0x1,0x8010ff00
801039fc:	00 00 00 
    lapic = 0;
801039ff:	c7 05 7c f8 10 80 00 	movl   $0x0,0x8010f87c
80103a06:	00 00 00 
    ioapicid = 0;
80103a09:	c6 05 00 f9 10 80 00 	movb   $0x0,0x8010f900
    return;
80103a10:	eb 44                	jmp    80103a56 <mpinit+0x1c5>
  }

  if(mp->imcrp){
80103a12:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103a15:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103a19:	84 c0                	test   %al,%al
80103a1b:	74 39                	je     80103a56 <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103a1d:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103a24:	00 
80103a25:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103a2c:	e8 12 fc ff ff       	call   80103643 <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103a31:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a38:	e8 dc fb ff ff       	call   80103619 <inb>
80103a3d:	83 c8 01             	or     $0x1,%eax
80103a40:	0f b6 c0             	movzbl %al,%eax
80103a43:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a47:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103a4e:	e8 f0 fb ff ff       	call   80103643 <outb>
80103a53:	eb 01                	jmp    80103a56 <mpinit+0x1c5>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80103a55:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80103a56:	c9                   	leave  
80103a57:	c3                   	ret    

80103a58 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103a58:	55                   	push   %ebp
80103a59:	89 e5                	mov    %esp,%ebp
80103a5b:	83 ec 08             	sub    $0x8,%esp
80103a5e:	8b 55 08             	mov    0x8(%ebp),%edx
80103a61:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a64:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103a68:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103a6b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103a6f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103a73:	ee                   	out    %al,(%dx)
}
80103a74:	c9                   	leave  
80103a75:	c3                   	ret    

80103a76 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103a76:	55                   	push   %ebp
80103a77:	89 e5                	mov    %esp,%ebp
80103a79:	83 ec 0c             	sub    $0xc,%esp
80103a7c:	8b 45 08             	mov    0x8(%ebp),%eax
80103a7f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103a83:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a87:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103a8d:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103a91:	0f b6 c0             	movzbl %al,%eax
80103a94:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a98:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103a9f:	e8 b4 ff ff ff       	call   80103a58 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103aa4:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103aa8:	66 c1 e8 08          	shr    $0x8,%ax
80103aac:	0f b6 c0             	movzbl %al,%eax
80103aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
80103ab3:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103aba:	e8 99 ff ff ff       	call   80103a58 <outb>
}
80103abf:	c9                   	leave  
80103ac0:	c3                   	ret    

80103ac1 <picenable>:

void
picenable(int irq)
{
80103ac1:	55                   	push   %ebp
80103ac2:	89 e5                	mov    %esp,%ebp
80103ac4:	53                   	push   %ebx
80103ac5:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103ac8:	8b 45 08             	mov    0x8(%ebp),%eax
80103acb:	ba 01 00 00 00       	mov    $0x1,%edx
80103ad0:	89 d3                	mov    %edx,%ebx
80103ad2:	89 c1                	mov    %eax,%ecx
80103ad4:	d3 e3                	shl    %cl,%ebx
80103ad6:	89 d8                	mov    %ebx,%eax
80103ad8:	89 c2                	mov    %eax,%edx
80103ada:	f7 d2                	not    %edx
80103adc:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103ae3:	21 d0                	and    %edx,%eax
80103ae5:	0f b7 c0             	movzwl %ax,%eax
80103ae8:	89 04 24             	mov    %eax,(%esp)
80103aeb:	e8 86 ff ff ff       	call   80103a76 <picsetmask>
}
80103af0:	83 c4 04             	add    $0x4,%esp
80103af3:	5b                   	pop    %ebx
80103af4:	5d                   	pop    %ebp
80103af5:	c3                   	ret    

80103af6 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103af6:	55                   	push   %ebp
80103af7:	89 e5                	mov    %esp,%ebp
80103af9:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103afc:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103b03:	00 
80103b04:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b0b:	e8 48 ff ff ff       	call   80103a58 <outb>
  outb(IO_PIC2+1, 0xFF);
80103b10:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103b17:	00 
80103b18:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b1f:	e8 34 ff ff ff       	call   80103a58 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103b24:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b2b:	00 
80103b2c:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103b33:	e8 20 ff ff ff       	call   80103a58 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103b38:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103b3f:	00 
80103b40:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b47:	e8 0c ff ff ff       	call   80103a58 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103b4c:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103b53:	00 
80103b54:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b5b:	e8 f8 fe ff ff       	call   80103a58 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103b60:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103b67:	00 
80103b68:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103b6f:	e8 e4 fe ff ff       	call   80103a58 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103b74:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103b7b:	00 
80103b7c:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103b83:	e8 d0 fe ff ff       	call   80103a58 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103b88:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103b8f:	00 
80103b90:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103b97:	e8 bc fe ff ff       	call   80103a58 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103b9c:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103ba3:	00 
80103ba4:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103bab:	e8 a8 fe ff ff       	call   80103a58 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103bb0:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103bb7:	00 
80103bb8:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103bbf:	e8 94 fe ff ff       	call   80103a58 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103bc4:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103bcb:	00 
80103bcc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103bd3:	e8 80 fe ff ff       	call   80103a58 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103bd8:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103bdf:	00 
80103be0:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103be7:	e8 6c fe ff ff       	call   80103a58 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103bec:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103bf3:	00 
80103bf4:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103bfb:	e8 58 fe ff ff       	call   80103a58 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103c00:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103c07:	00 
80103c08:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103c0f:	e8 44 fe ff ff       	call   80103a58 <outb>

  if(irqmask != 0xFFFF)
80103c14:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103c1b:	66 83 f8 ff          	cmp    $0xffff,%ax
80103c1f:	74 12                	je     80103c33 <picinit+0x13d>
    picsetmask(irqmask);
80103c21:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103c28:	0f b7 c0             	movzwl %ax,%eax
80103c2b:	89 04 24             	mov    %eax,(%esp)
80103c2e:	e8 43 fe ff ff       	call   80103a76 <picsetmask>
}
80103c33:	c9                   	leave  
80103c34:	c3                   	ret    
80103c35:	00 00                	add    %al,(%eax)
	...

80103c38 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103c38:	55                   	push   %ebp
80103c39:	89 e5                	mov    %esp,%ebp
80103c3b:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103c3e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103c45:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c51:	8b 10                	mov    (%eax),%edx
80103c53:	8b 45 08             	mov    0x8(%ebp),%eax
80103c56:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103c58:	e8 bf d2 ff ff       	call   80100f1c <filealloc>
80103c5d:	8b 55 08             	mov    0x8(%ebp),%edx
80103c60:	89 02                	mov    %eax,(%edx)
80103c62:	8b 45 08             	mov    0x8(%ebp),%eax
80103c65:	8b 00                	mov    (%eax),%eax
80103c67:	85 c0                	test   %eax,%eax
80103c69:	0f 84 c8 00 00 00    	je     80103d37 <pipealloc+0xff>
80103c6f:	e8 a8 d2 ff ff       	call   80100f1c <filealloc>
80103c74:	8b 55 0c             	mov    0xc(%ebp),%edx
80103c77:	89 02                	mov    %eax,(%edx)
80103c79:	8b 45 0c             	mov    0xc(%ebp),%eax
80103c7c:	8b 00                	mov    (%eax),%eax
80103c7e:	85 c0                	test   %eax,%eax
80103c80:	0f 84 b1 00 00 00    	je     80103d37 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103c86:	e8 74 ee ff ff       	call   80102aff <kalloc>
80103c8b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c8e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c92:	0f 84 9e 00 00 00    	je     80103d36 <pipealloc+0xfe>
    goto bad;
  p->readopen = 1;
80103c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c9b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103ca2:	00 00 00 
  p->writeopen = 1;
80103ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca8:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103caf:	00 00 00 
  p->nwrite = 0;
80103cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cb5:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103cbc:	00 00 00 
  p->nread = 0;
80103cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cc2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103cc9:	00 00 00 
  initlock(&p->lock, "pipe");
80103ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ccf:	c7 44 24 04 44 88 10 	movl   $0x80108844,0x4(%esp)
80103cd6:	80 
80103cd7:	89 04 24             	mov    %eax,(%esp)
80103cda:	e8 87 12 00 00       	call   80104f66 <initlock>
  (*f0)->type = FD_PIPE;
80103cdf:	8b 45 08             	mov    0x8(%ebp),%eax
80103ce2:	8b 00                	mov    (%eax),%eax
80103ce4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103cea:	8b 45 08             	mov    0x8(%ebp),%eax
80103ced:	8b 00                	mov    (%eax),%eax
80103cef:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80103cf3:	8b 45 08             	mov    0x8(%ebp),%eax
80103cf6:	8b 00                	mov    (%eax),%eax
80103cf8:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103cfc:	8b 45 08             	mov    0x8(%ebp),%eax
80103cff:	8b 00                	mov    (%eax),%eax
80103d01:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d04:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103d07:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d0a:	8b 00                	mov    (%eax),%eax
80103d0c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103d12:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d15:	8b 00                	mov    (%eax),%eax
80103d17:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d1e:	8b 00                	mov    (%eax),%eax
80103d20:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103d24:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d27:	8b 00                	mov    (%eax),%eax
80103d29:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d2c:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80103d2f:	b8 00 00 00 00       	mov    $0x0,%eax
80103d34:	eb 43                	jmp    80103d79 <pipealloc+0x141>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80103d36:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80103d37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103d3b:	74 0b                	je     80103d48 <pipealloc+0x110>
    kfree((char*)p);
80103d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d40:	89 04 24             	mov    %eax,(%esp)
80103d43:	e8 1e ed ff ff       	call   80102a66 <kfree>
  if(*f0)
80103d48:	8b 45 08             	mov    0x8(%ebp),%eax
80103d4b:	8b 00                	mov    (%eax),%eax
80103d4d:	85 c0                	test   %eax,%eax
80103d4f:	74 0d                	je     80103d5e <pipealloc+0x126>
    fileclose(*f0);
80103d51:	8b 45 08             	mov    0x8(%ebp),%eax
80103d54:	8b 00                	mov    (%eax),%eax
80103d56:	89 04 24             	mov    %eax,(%esp)
80103d59:	e8 66 d2 ff ff       	call   80100fc4 <fileclose>
  if(*f1)
80103d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d61:	8b 00                	mov    (%eax),%eax
80103d63:	85 c0                	test   %eax,%eax
80103d65:	74 0d                	je     80103d74 <pipealloc+0x13c>
    fileclose(*f1);
80103d67:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d6a:	8b 00                	mov    (%eax),%eax
80103d6c:	89 04 24             	mov    %eax,(%esp)
80103d6f:	e8 50 d2 ff ff       	call   80100fc4 <fileclose>
  return -1;
80103d74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103d79:	c9                   	leave  
80103d7a:	c3                   	ret    

80103d7b <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103d7b:	55                   	push   %ebp
80103d7c:	89 e5                	mov    %esp,%ebp
80103d7e:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
80103d81:	8b 45 08             	mov    0x8(%ebp),%eax
80103d84:	89 04 24             	mov    %eax,(%esp)
80103d87:	e8 fb 11 00 00       	call   80104f87 <acquire>
  if(writable){
80103d8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80103d90:	74 1f                	je     80103db1 <pipeclose+0x36>
    p->writeopen = 0;
80103d92:	8b 45 08             	mov    0x8(%ebp),%eax
80103d95:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
80103d9c:	00 00 00 
    wakeup(&p->nread);
80103d9f:	8b 45 08             	mov    0x8(%ebp),%eax
80103da2:	05 34 02 00 00       	add    $0x234,%eax
80103da7:	89 04 24             	mov    %eax,(%esp)
80103daa:	e8 26 0c 00 00       	call   801049d5 <wakeup>
80103daf:	eb 1d                	jmp    80103dce <pipeclose+0x53>
  } else {
    p->readopen = 0;
80103db1:	8b 45 08             	mov    0x8(%ebp),%eax
80103db4:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80103dbb:	00 00 00 
    wakeup(&p->nwrite);
80103dbe:	8b 45 08             	mov    0x8(%ebp),%eax
80103dc1:	05 38 02 00 00       	add    $0x238,%eax
80103dc6:	89 04 24             	mov    %eax,(%esp)
80103dc9:	e8 07 0c 00 00       	call   801049d5 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103dce:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd1:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103dd7:	85 c0                	test   %eax,%eax
80103dd9:	75 25                	jne    80103e00 <pipeclose+0x85>
80103ddb:	8b 45 08             	mov    0x8(%ebp),%eax
80103dde:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103de4:	85 c0                	test   %eax,%eax
80103de6:	75 18                	jne    80103e00 <pipeclose+0x85>
    release(&p->lock);
80103de8:	8b 45 08             	mov    0x8(%ebp),%eax
80103deb:	89 04 24             	mov    %eax,(%esp)
80103dee:	e8 f6 11 00 00       	call   80104fe9 <release>
    kfree((char*)p);
80103df3:	8b 45 08             	mov    0x8(%ebp),%eax
80103df6:	89 04 24             	mov    %eax,(%esp)
80103df9:	e8 68 ec ff ff       	call   80102a66 <kfree>
80103dfe:	eb 0b                	jmp    80103e0b <pipeclose+0x90>
  } else
    release(&p->lock);
80103e00:	8b 45 08             	mov    0x8(%ebp),%eax
80103e03:	89 04 24             	mov    %eax,(%esp)
80103e06:	e8 de 11 00 00       	call   80104fe9 <release>
}
80103e0b:	c9                   	leave  
80103e0c:	c3                   	ret    

80103e0d <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103e0d:	55                   	push   %ebp
80103e0e:	89 e5                	mov    %esp,%ebp
80103e10:	53                   	push   %ebx
80103e11:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103e14:	8b 45 08             	mov    0x8(%ebp),%eax
80103e17:	89 04 24             	mov    %eax,(%esp)
80103e1a:	e8 68 11 00 00       	call   80104f87 <acquire>
  for(i = 0; i < n; i++){
80103e1f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103e26:	e9 a6 00 00 00       	jmp    80103ed1 <pipewrite+0xc4>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
80103e2b:	8b 45 08             	mov    0x8(%ebp),%eax
80103e2e:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80103e34:	85 c0                	test   %eax,%eax
80103e36:	74 0d                	je     80103e45 <pipewrite+0x38>
80103e38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103e3e:	8b 40 24             	mov    0x24(%eax),%eax
80103e41:	85 c0                	test   %eax,%eax
80103e43:	74 15                	je     80103e5a <pipewrite+0x4d>
        release(&p->lock);
80103e45:	8b 45 08             	mov    0x8(%ebp),%eax
80103e48:	89 04 24             	mov    %eax,(%esp)
80103e4b:	e8 99 11 00 00       	call   80104fe9 <release>
        return -1;
80103e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103e55:	e9 9d 00 00 00       	jmp    80103ef7 <pipewrite+0xea>
      }
      wakeup(&p->nread);
80103e5a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e5d:	05 34 02 00 00       	add    $0x234,%eax
80103e62:	89 04 24             	mov    %eax,(%esp)
80103e65:	e8 6b 0b 00 00       	call   801049d5 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103e6a:	8b 45 08             	mov    0x8(%ebp),%eax
80103e6d:	8b 55 08             	mov    0x8(%ebp),%edx
80103e70:	81 c2 38 02 00 00    	add    $0x238,%edx
80103e76:	89 44 24 04          	mov    %eax,0x4(%esp)
80103e7a:	89 14 24             	mov    %edx,(%esp)
80103e7d:	e8 77 0a 00 00       	call   801048f9 <sleep>
80103e82:	eb 01                	jmp    80103e85 <pipewrite+0x78>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103e84:	90                   	nop
80103e85:	8b 45 08             	mov    0x8(%ebp),%eax
80103e88:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80103e8e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e91:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103e97:	05 00 02 00 00       	add    $0x200,%eax
80103e9c:	39 c2                	cmp    %eax,%edx
80103e9e:	74 8b                	je     80103e2b <pipewrite+0x1e>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103ea0:	8b 45 08             	mov    0x8(%ebp),%eax
80103ea3:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103ea9:	89 c3                	mov    %eax,%ebx
80103eab:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103eb1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103eb4:	03 55 0c             	add    0xc(%ebp),%edx
80103eb7:	0f b6 0a             	movzbl (%edx),%ecx
80103eba:	8b 55 08             	mov    0x8(%ebp),%edx
80103ebd:	88 4c 1a 34          	mov    %cl,0x34(%edx,%ebx,1)
80103ec1:	8d 50 01             	lea    0x1(%eax),%edx
80103ec4:	8b 45 08             	mov    0x8(%ebp),%eax
80103ec7:	89 90 38 02 00 00    	mov    %edx,0x238(%eax)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103ecd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed4:	3b 45 10             	cmp    0x10(%ebp),%eax
80103ed7:	7c ab                	jl     80103e84 <pipewrite+0x77>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103ed9:	8b 45 08             	mov    0x8(%ebp),%eax
80103edc:	05 34 02 00 00       	add    $0x234,%eax
80103ee1:	89 04 24             	mov    %eax,(%esp)
80103ee4:	e8 ec 0a 00 00       	call   801049d5 <wakeup>
  release(&p->lock);
80103ee9:	8b 45 08             	mov    0x8(%ebp),%eax
80103eec:	89 04 24             	mov    %eax,(%esp)
80103eef:	e8 f5 10 00 00       	call   80104fe9 <release>
  return n;
80103ef4:	8b 45 10             	mov    0x10(%ebp),%eax
}
80103ef7:	83 c4 24             	add    $0x24,%esp
80103efa:	5b                   	pop    %ebx
80103efb:	5d                   	pop    %ebp
80103efc:	c3                   	ret    

80103efd <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103efd:	55                   	push   %ebp
80103efe:	89 e5                	mov    %esp,%ebp
80103f00:	53                   	push   %ebx
80103f01:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80103f04:	8b 45 08             	mov    0x8(%ebp),%eax
80103f07:	89 04 24             	mov    %eax,(%esp)
80103f0a:	e8 78 10 00 00       	call   80104f87 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f0f:	eb 3a                	jmp    80103f4b <piperead+0x4e>
    if(proc->killed){
80103f11:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80103f17:	8b 40 24             	mov    0x24(%eax),%eax
80103f1a:	85 c0                	test   %eax,%eax
80103f1c:	74 15                	je     80103f33 <piperead+0x36>
      release(&p->lock);
80103f1e:	8b 45 08             	mov    0x8(%ebp),%eax
80103f21:	89 04 24             	mov    %eax,(%esp)
80103f24:	e8 c0 10 00 00       	call   80104fe9 <release>
      return -1;
80103f29:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f2e:	e9 b6 00 00 00       	jmp    80103fe9 <piperead+0xec>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103f33:	8b 45 08             	mov    0x8(%ebp),%eax
80103f36:	8b 55 08             	mov    0x8(%ebp),%edx
80103f39:	81 c2 34 02 00 00    	add    $0x234,%edx
80103f3f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f43:	89 14 24             	mov    %edx,(%esp)
80103f46:	e8 ae 09 00 00       	call   801048f9 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103f4b:	8b 45 08             	mov    0x8(%ebp),%eax
80103f4e:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f54:	8b 45 08             	mov    0x8(%ebp),%eax
80103f57:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f5d:	39 c2                	cmp    %eax,%edx
80103f5f:	75 0d                	jne    80103f6e <piperead+0x71>
80103f61:	8b 45 08             	mov    0x8(%ebp),%eax
80103f64:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80103f6a:	85 c0                	test   %eax,%eax
80103f6c:	75 a3                	jne    80103f11 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103f6e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103f75:	eb 49                	jmp    80103fc0 <piperead+0xc3>
    if(p->nread == p->nwrite)
80103f77:	8b 45 08             	mov    0x8(%ebp),%eax
80103f7a:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80103f80:	8b 45 08             	mov    0x8(%ebp),%eax
80103f83:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80103f89:	39 c2                	cmp    %eax,%edx
80103f8b:	74 3d                	je     80103fca <piperead+0xcd>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f90:	89 c2                	mov    %eax,%edx
80103f92:	03 55 0c             	add    0xc(%ebp),%edx
80103f95:	8b 45 08             	mov    0x8(%ebp),%eax
80103f98:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80103f9e:	89 c3                	mov    %eax,%ebx
80103fa0:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
80103fa6:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103fa9:	0f b6 4c 19 34       	movzbl 0x34(%ecx,%ebx,1),%ecx
80103fae:	88 0a                	mov    %cl,(%edx)
80103fb0:	8d 50 01             	lea    0x1(%eax),%edx
80103fb3:	8b 45 08             	mov    0x8(%ebp),%eax
80103fb6:	89 90 34 02 00 00    	mov    %edx,0x234(%eax)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103fbc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fc3:	3b 45 10             	cmp    0x10(%ebp),%eax
80103fc6:	7c af                	jl     80103f77 <piperead+0x7a>
80103fc8:	eb 01                	jmp    80103fcb <piperead+0xce>
    if(p->nread == p->nwrite)
      break;
80103fca:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103fcb:	8b 45 08             	mov    0x8(%ebp),%eax
80103fce:	05 38 02 00 00       	add    $0x238,%eax
80103fd3:	89 04 24             	mov    %eax,(%esp)
80103fd6:	e8 fa 09 00 00       	call   801049d5 <wakeup>
  release(&p->lock);
80103fdb:	8b 45 08             	mov    0x8(%ebp),%eax
80103fde:	89 04 24             	mov    %eax,(%esp)
80103fe1:	e8 03 10 00 00       	call   80104fe9 <release>
  return i;
80103fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80103fe9:	83 c4 24             	add    $0x24,%esp
80103fec:	5b                   	pop    %ebx
80103fed:	5d                   	pop    %ebp
80103fee:	c3                   	ret    
	...

80103ff0 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	53                   	push   %ebx
80103ff4:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103ff7:	9c                   	pushf  
80103ff8:	5b                   	pop    %ebx
80103ff9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80103ffc:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103fff:	83 c4 10             	add    $0x10,%esp
80104002:	5b                   	pop    %ebx
80104003:	5d                   	pop    %ebp
80104004:	c3                   	ret    

80104005 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104005:	55                   	push   %ebp
80104006:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104008:	fb                   	sti    
}
80104009:	5d                   	pop    %ebp
8010400a:	c3                   	ret    

8010400b <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
8010400b:	55                   	push   %ebp
8010400c:	89 e5                	mov    %esp,%ebp
8010400e:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80104011:	c7 44 24 04 49 88 10 	movl   $0x80108849,0x4(%esp)
80104018:	80 
80104019:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104020:	e8 41 0f 00 00       	call   80104f66 <initlock>
}
80104025:	c9                   	leave  
80104026:	c3                   	ret    

80104027 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104027:	55                   	push   %ebp
80104028:	89 e5                	mov    %esp,%ebp
8010402a:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
8010402d:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104034:	e8 4e 0f 00 00       	call   80104f87 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104039:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80104040:	eb 11                	jmp    80104053 <allocproc+0x2c>
    if(p->state == UNUSED)
80104042:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104045:	8b 40 0c             	mov    0xc(%eax),%eax
80104048:	85 c0                	test   %eax,%eax
8010404a:	74 26                	je     80104072 <allocproc+0x4b>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010404c:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104053:	81 7d f4 54 22 11 80 	cmpl   $0x80112254,-0xc(%ebp)
8010405a:	72 e6                	jb     80104042 <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
8010405c:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104063:	e8 81 0f 00 00       	call   80104fe9 <release>
  return 0;
80104068:	b8 00 00 00 00       	mov    $0x0,%eax
8010406d:	e9 b5 00 00 00       	jmp    80104127 <allocproc+0x100>
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;
80104072:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104073:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104076:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
8010407d:	a1 04 b0 10 80       	mov    0x8010b004,%eax
80104082:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104085:	89 42 10             	mov    %eax,0x10(%edx)
80104088:	83 c0 01             	add    $0x1,%eax
8010408b:	a3 04 b0 10 80       	mov    %eax,0x8010b004
  release(&ptable.lock);
80104090:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104097:	e8 4d 0f 00 00       	call   80104fe9 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010409c:	e8 5e ea ff ff       	call   80102aff <kalloc>
801040a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801040a4:	89 42 08             	mov    %eax,0x8(%edx)
801040a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040aa:	8b 40 08             	mov    0x8(%eax),%eax
801040ad:	85 c0                	test   %eax,%eax
801040af:	75 11                	jne    801040c2 <allocproc+0x9b>
    p->state = UNUSED;
801040b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040b4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801040bb:	b8 00 00 00 00       	mov    $0x0,%eax
801040c0:	eb 65                	jmp    80104127 <allocproc+0x100>
  }
  sp = p->kstack + KSTACKSIZE;
801040c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c5:	8b 40 08             	mov    0x8(%eax),%eax
801040c8:	05 00 10 00 00       	add    $0x1000,%eax
801040cd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801040d0:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801040d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
801040da:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801040dd:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801040e1:	ba 30 66 10 80       	mov    $0x80106630,%edx
801040e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801040e9:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801040eb:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801040ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
801040f5:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801040f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040fb:	8b 40 1c             	mov    0x1c(%eax),%eax
801040fe:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104105:	00 
80104106:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010410d:	00 
8010410e:	89 04 24             	mov    %eax,(%esp)
80104111:	e8 c0 10 00 00       	call   801051d6 <memset>
  p->context->eip = (uint)forkret;
80104116:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104119:	8b 40 1c             	mov    0x1c(%eax),%eax
8010411c:	ba cd 48 10 80       	mov    $0x801048cd,%edx
80104121:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
80104124:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104127:	c9                   	leave  
80104128:	c3                   	ret    

80104129 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104129:	55                   	push   %ebp
8010412a:	89 e5                	mov    %esp,%ebp
8010412c:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
8010412f:	e8 f3 fe ff ff       	call   80104027 <allocproc>
80104134:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104137:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010413a:	a3 48 b6 10 80       	mov    %eax,0x8010b648
  if((p->pgdir = setupkvm(kalloc)) == 0)
8010413f:	c7 04 24 ff 2a 10 80 	movl   $0x80102aff,(%esp)
80104146:	e8 e2 3b 00 00       	call   80107d2d <setupkvm>
8010414b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010414e:	89 42 04             	mov    %eax,0x4(%edx)
80104151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104154:	8b 40 04             	mov    0x4(%eax),%eax
80104157:	85 c0                	test   %eax,%eax
80104159:	75 0c                	jne    80104167 <userinit+0x3e>
    panic("userinit: out of memory?");
8010415b:	c7 04 24 50 88 10 80 	movl   $0x80108850,(%esp)
80104162:	e8 d6 c3 ff ff       	call   8010053d <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104167:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010416c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010416f:	8b 40 04             	mov    0x4(%eax),%eax
80104172:	89 54 24 08          	mov    %edx,0x8(%esp)
80104176:	c7 44 24 04 e0 b4 10 	movl   $0x8010b4e0,0x4(%esp)
8010417d:	80 
8010417e:	89 04 24             	mov    %eax,(%esp)
80104181:	e8 ff 3d 00 00       	call   80107f85 <inituvm>
  p->sz = PGSIZE;
80104186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104189:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
8010418f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104192:	8b 40 18             	mov    0x18(%eax),%eax
80104195:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
8010419c:	00 
8010419d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801041a4:	00 
801041a5:	89 04 24             	mov    %eax,(%esp)
801041a8:	e8 29 10 00 00       	call   801051d6 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801041ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041b0:	8b 40 18             	mov    0x18(%eax),%eax
801041b3:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801041b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041bc:	8b 40 18             	mov    0x18(%eax),%eax
801041bf:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
801041c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041c8:	8b 40 18             	mov    0x18(%eax),%eax
801041cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041ce:	8b 52 18             	mov    0x18(%edx),%edx
801041d1:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801041d5:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801041d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041dc:	8b 40 18             	mov    0x18(%eax),%eax
801041df:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041e2:	8b 52 18             	mov    0x18(%edx),%edx
801041e5:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801041e9:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801041ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041f0:	8b 40 18             	mov    0x18(%eax),%eax
801041f3:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801041fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041fd:	8b 40 18             	mov    0x18(%eax),%eax
80104200:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104207:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010420a:	8b 40 18             	mov    0x18(%eax),%eax
8010420d:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104214:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104217:	83 c0 6c             	add    $0x6c,%eax
8010421a:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104221:	00 
80104222:	c7 44 24 04 69 88 10 	movl   $0x80108869,0x4(%esp)
80104229:	80 
8010422a:	89 04 24             	mov    %eax,(%esp)
8010422d:	e8 d4 11 00 00       	call   80105406 <safestrcpy>
  p->cwd = namei("/");
80104232:	c7 04 24 72 88 10 80 	movl   $0x80108872,(%esp)
80104239:	e8 cc e1 ff ff       	call   8010240a <namei>
8010423e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104241:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
80104244:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104247:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
8010424e:	c9                   	leave  
8010424f:	c3                   	ret    

80104250 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104250:	55                   	push   %ebp
80104251:	89 e5                	mov    %esp,%ebp
80104253:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
80104256:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010425c:	8b 00                	mov    (%eax),%eax
8010425e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104261:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104265:	7e 34                	jle    8010429b <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104267:	8b 45 08             	mov    0x8(%ebp),%eax
8010426a:	89 c2                	mov    %eax,%edx
8010426c:	03 55 f4             	add    -0xc(%ebp),%edx
8010426f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104275:	8b 40 04             	mov    0x4(%eax),%eax
80104278:	89 54 24 08          	mov    %edx,0x8(%esp)
8010427c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010427f:	89 54 24 04          	mov    %edx,0x4(%esp)
80104283:	89 04 24             	mov    %eax,(%esp)
80104286:	e8 74 3e 00 00       	call   801080ff <allocuvm>
8010428b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010428e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104292:	75 41                	jne    801042d5 <growproc+0x85>
      return -1;
80104294:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104299:	eb 58                	jmp    801042f3 <growproc+0xa3>
  } else if(n < 0){
8010429b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010429f:	79 34                	jns    801042d5 <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
801042a1:	8b 45 08             	mov    0x8(%ebp),%eax
801042a4:	89 c2                	mov    %eax,%edx
801042a6:	03 55 f4             	add    -0xc(%ebp),%edx
801042a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042af:	8b 40 04             	mov    0x4(%eax),%eax
801042b2:	89 54 24 08          	mov    %edx,0x8(%esp)
801042b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042b9:	89 54 24 04          	mov    %edx,0x4(%esp)
801042bd:	89 04 24             	mov    %eax,(%esp)
801042c0:	e8 14 3f 00 00       	call   801081d9 <deallocuvm>
801042c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
801042c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801042cc:	75 07                	jne    801042d5 <growproc+0x85>
      return -1;
801042ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042d3:	eb 1e                	jmp    801042f3 <growproc+0xa3>
  }
  proc->sz = sz;
801042d5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042db:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042de:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801042e0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042e6:	89 04 24             	mov    %eax,(%esp)
801042e9:	e8 30 3b 00 00       	call   80107e1e <switchuvm>
  return 0;
801042ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
801042f3:	c9                   	leave  
801042f4:	c3                   	ret    

801042f5 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801042f5:	55                   	push   %ebp
801042f6:	89 e5                	mov    %esp,%ebp
801042f8:	57                   	push   %edi
801042f9:	56                   	push   %esi
801042fa:	53                   	push   %ebx
801042fb:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801042fe:	e8 24 fd ff ff       	call   80104027 <allocproc>
80104303:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104306:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010430a:	75 0a                	jne    80104316 <fork+0x21>
    return -1;
8010430c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104311:	e9 3a 01 00 00       	jmp    80104450 <fork+0x15b>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104316:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010431c:	8b 10                	mov    (%eax),%edx
8010431e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104324:	8b 40 04             	mov    0x4(%eax),%eax
80104327:	89 54 24 04          	mov    %edx,0x4(%esp)
8010432b:	89 04 24             	mov    %eax,(%esp)
8010432e:	e8 36 40 00 00       	call   80108369 <copyuvm>
80104333:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104336:	89 42 04             	mov    %eax,0x4(%edx)
80104339:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010433c:	8b 40 04             	mov    0x4(%eax),%eax
8010433f:	85 c0                	test   %eax,%eax
80104341:	75 2c                	jne    8010436f <fork+0x7a>
    kfree(np->kstack);
80104343:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104346:	8b 40 08             	mov    0x8(%eax),%eax
80104349:	89 04 24             	mov    %eax,(%esp)
8010434c:	e8 15 e7 ff ff       	call   80102a66 <kfree>
    np->kstack = 0;
80104351:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104354:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
8010435b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010435e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104365:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010436a:	e9 e1 00 00 00       	jmp    80104450 <fork+0x15b>
  }
  np->sz = proc->sz;
8010436f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104375:	8b 10                	mov    (%eax),%edx
80104377:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010437a:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
8010437c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104383:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104386:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104389:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010438c:	8b 50 18             	mov    0x18(%eax),%edx
8010438f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104395:	8b 40 18             	mov    0x18(%eax),%eax
80104398:	89 c3                	mov    %eax,%ebx
8010439a:	b8 13 00 00 00       	mov    $0x13,%eax
8010439f:	89 d7                	mov    %edx,%edi
801043a1:	89 de                	mov    %ebx,%esi
801043a3:	89 c1                	mov    %eax,%ecx
801043a5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801043a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801043aa:	8b 40 18             	mov    0x18(%eax),%eax
801043ad:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801043b4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801043bb:	eb 3d                	jmp    801043fa <fork+0x105>
    if(proc->ofile[i])
801043bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043c6:	83 c2 08             	add    $0x8,%edx
801043c9:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801043cd:	85 c0                	test   %eax,%eax
801043cf:	74 25                	je     801043f6 <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
801043d1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043d7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801043da:	83 c2 08             	add    $0x8,%edx
801043dd:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801043e1:	89 04 24             	mov    %eax,(%esp)
801043e4:	e8 93 cb ff ff       	call   80100f7c <filedup>
801043e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
801043ec:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801043ef:	83 c1 08             	add    $0x8,%ecx
801043f2:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;
  
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801043f6:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801043fa:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801043fe:	7e bd                	jle    801043bd <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104400:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104406:	8b 40 68             	mov    0x68(%eax),%eax
80104409:	89 04 24             	mov    %eax,(%esp)
8010440c:	e8 25 d4 ff ff       	call   80101836 <idup>
80104411:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104414:	89 42 68             	mov    %eax,0x68(%edx)
 
  pid = np->pid;
80104417:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010441a:	8b 40 10             	mov    0x10(%eax),%eax
8010441d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
80104420:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104423:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
8010442a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104430:	8d 50 6c             	lea    0x6c(%eax),%edx
80104433:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104436:	83 c0 6c             	add    $0x6c,%eax
80104439:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104440:	00 
80104441:	89 54 24 04          	mov    %edx,0x4(%esp)
80104445:	89 04 24             	mov    %eax,(%esp)
80104448:	e8 b9 0f 00 00       	call   80105406 <safestrcpy>
  return pid;
8010444d:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104450:	83 c4 2c             	add    $0x2c,%esp
80104453:	5b                   	pop    %ebx
80104454:	5e                   	pop    %esi
80104455:	5f                   	pop    %edi
80104456:	5d                   	pop    %ebp
80104457:	c3                   	ret    

80104458 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80104458:	55                   	push   %ebp
80104459:	89 e5                	mov    %esp,%ebp
8010445b:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
8010445e:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104465:	a1 48 b6 10 80       	mov    0x8010b648,%eax
8010446a:	39 c2                	cmp    %eax,%edx
8010446c:	75 0c                	jne    8010447a <exit+0x22>
    panic("init exiting");
8010446e:	c7 04 24 74 88 10 80 	movl   $0x80108874,(%esp)
80104475:	e8 c3 c0 ff ff       	call   8010053d <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010447a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104481:	eb 44                	jmp    801044c7 <exit+0x6f>
    if(proc->ofile[fd]){
80104483:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104489:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010448c:	83 c2 08             	add    $0x8,%edx
8010448f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104493:	85 c0                	test   %eax,%eax
80104495:	74 2c                	je     801044c3 <exit+0x6b>
      fileclose(proc->ofile[fd]);
80104497:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010449d:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044a0:	83 c2 08             	add    $0x8,%edx
801044a3:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801044a7:	89 04 24             	mov    %eax,(%esp)
801044aa:	e8 15 cb ff ff       	call   80100fc4 <fileclose>
      proc->ofile[fd] = 0;
801044af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
801044b8:	83 c2 08             	add    $0x8,%edx
801044bb:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801044c2:	00 

  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801044c3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801044c7:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801044cb:	7e b6                	jle    80104483 <exit+0x2b>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  iput(proc->cwd);
801044cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044d3:	8b 40 68             	mov    0x68(%eax),%eax
801044d6:	89 04 24             	mov    %eax,(%esp)
801044d9:	e8 3d d5 ff ff       	call   80101a1b <iput>
  proc->cwd = 0;
801044de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044e4:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801044eb:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801044f2:	e8 90 0a 00 00       	call   80104f87 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
801044f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801044fd:	8b 40 14             	mov    0x14(%eax),%eax
80104500:	89 04 24             	mov    %eax,(%esp)
80104503:	e8 8c 04 00 00       	call   80104994 <wakeup1>
  
  while(proc->threadnum > 0)
80104508:	eb 16                	jmp    80104520 <exit+0xc8>
    sleep(proc,&ptable.lock);
8010450a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104510:	c7 44 24 04 20 ff 10 	movl   $0x8010ff20,0x4(%esp)
80104517:	80 
80104518:	89 04 24             	mov    %eax,(%esp)
8010451b:	e8 d9 03 00 00       	call   801048f9 <sleep>
  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
  
  while(proc->threadnum > 0)
80104520:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104526:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
8010452c:	85 c0                	test   %eax,%eax
8010452e:	7f da                	jg     8010450a <exit+0xb2>
    sleep(proc,&ptable.lock);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104530:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80104537:	eb 3b                	jmp    80104574 <exit+0x11c>
    if(p->parent == proc){
80104539:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010453c:	8b 50 14             	mov    0x14(%eax),%edx
8010453f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104545:	39 c2                	cmp    %eax,%edx
80104547:	75 24                	jne    8010456d <exit+0x115>
      p->parent = initproc;
80104549:	8b 15 48 b6 10 80    	mov    0x8010b648,%edx
8010454f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104552:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104555:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104558:	8b 40 0c             	mov    0xc(%eax),%eax
8010455b:	83 f8 05             	cmp    $0x5,%eax
8010455e:	75 0d                	jne    8010456d <exit+0x115>
        wakeup1(initproc);
80104560:	a1 48 b6 10 80       	mov    0x8010b648,%eax
80104565:	89 04 24             	mov    %eax,(%esp)
80104568:	e8 27 04 00 00       	call   80104994 <wakeup1>
  
  while(proc->threadnum > 0)
    sleep(proc,&ptable.lock);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010456d:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104574:	81 7d f4 54 22 11 80 	cmpl   $0x80112254,-0xc(%ebp)
8010457b:	72 bc                	jb     80104539 <exit+0xe1>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
8010457d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104583:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010458a:	e8 5a 02 00 00       	call   801047e9 <sched>
  panic("zombie exit");
8010458f:	c7 04 24 81 88 10 80 	movl   $0x80108881,(%esp)
80104596:	e8 a2 bf ff ff       	call   8010053d <panic>

8010459b <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
8010459b:	55                   	push   %ebp
8010459c:	89 e5                	mov    %esp,%ebp
8010459e:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
801045a1:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801045a8:	e8 da 09 00 00       	call   80104f87 <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
801045ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801045b4:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
801045bb:	e9 9d 00 00 00       	jmp    8010465d <wait+0xc2>
      if(p->parent != proc)
801045c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045c3:	8b 50 14             	mov    0x14(%eax),%edx
801045c6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045cc:	39 c2                	cmp    %eax,%edx
801045ce:	0f 85 81 00 00 00    	jne    80104655 <wait+0xba>
        continue;
      havekids = 1;
801045d4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801045db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045de:	8b 40 0c             	mov    0xc(%eax),%eax
801045e1:	83 f8 05             	cmp    $0x5,%eax
801045e4:	75 70                	jne    80104656 <wait+0xbb>
        // Found one.
        pid = p->pid;
801045e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045e9:	8b 40 10             	mov    0x10(%eax),%eax
801045ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
801045ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f2:	8b 40 08             	mov    0x8(%eax),%eax
801045f5:	89 04 24             	mov    %eax,(%esp)
801045f8:	e8 69 e4 ff ff       	call   80102a66 <kfree>
        p->kstack = 0;
801045fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104600:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104607:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010460a:	8b 40 04             	mov    0x4(%eax),%eax
8010460d:	89 04 24             	mov    %eax,(%esp)
80104610:	e8 80 3c 00 00       	call   80108295 <freevm>
        p->state = UNUSED;
80104615:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104618:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
8010461f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104622:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104629:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010462c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104633:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104636:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
8010463a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010463d:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104644:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010464b:	e8 99 09 00 00       	call   80104fe9 <release>
        return pid;
80104650:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104653:	eb 56                	jmp    801046ab <wait+0x110>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != proc)
        continue;
80104655:	90                   	nop

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104656:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
8010465d:	81 7d f4 54 22 11 80 	cmpl   $0x80112254,-0xc(%ebp)
80104664:	0f 82 56 ff ff ff    	jb     801045c0 <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
8010466a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010466e:	74 0d                	je     8010467d <wait+0xe2>
80104670:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104676:	8b 40 24             	mov    0x24(%eax),%eax
80104679:	85 c0                	test   %eax,%eax
8010467b:	74 13                	je     80104690 <wait+0xf5>
      release(&ptable.lock);
8010467d:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104684:	e8 60 09 00 00       	call   80104fe9 <release>
      return -1;
80104689:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010468e:	eb 1b                	jmp    801046ab <wait+0x110>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104690:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104696:	c7 44 24 04 20 ff 10 	movl   $0x8010ff20,0x4(%esp)
8010469d:	80 
8010469e:	89 04 24             	mov    %eax,(%esp)
801046a1:	e8 53 02 00 00       	call   801048f9 <sleep>
  }
801046a6:	e9 02 ff ff ff       	jmp    801045ad <wait+0x12>
}
801046ab:	c9                   	leave  
801046ac:	c3                   	ret    

801046ad <register_handler>:

void
register_handler(sighandler_t sighandler)
{
801046ad:	55                   	push   %ebp
801046ae:	89 e5                	mov    %esp,%ebp
801046b0:	83 ec 28             	sub    $0x28,%esp
  char* addr = uva2ka(proc->pgdir, (char*)proc->tf->esp);
801046b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046b9:	8b 40 18             	mov    0x18(%eax),%eax
801046bc:	8b 40 44             	mov    0x44(%eax),%eax
801046bf:	89 c2                	mov    %eax,%edx
801046c1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046c7:	8b 40 04             	mov    0x4(%eax),%eax
801046ca:	89 54 24 04          	mov    %edx,0x4(%esp)
801046ce:	89 04 24             	mov    %eax,(%esp)
801046d1:	e8 a4 3d 00 00       	call   8010847a <uva2ka>
801046d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if ((proc->tf->esp & 0xFFF) == 0)
801046d9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046df:	8b 40 18             	mov    0x18(%eax),%eax
801046e2:	8b 40 44             	mov    0x44(%eax),%eax
801046e5:	25 ff 0f 00 00       	and    $0xfff,%eax
801046ea:	85 c0                	test   %eax,%eax
801046ec:	75 0c                	jne    801046fa <register_handler+0x4d>
    panic("esp_offset == 0");
801046ee:	c7 04 24 8d 88 10 80 	movl   $0x8010888d,(%esp)
801046f5:	e8 43 be ff ff       	call   8010053d <panic>

    /* open a new frame */
  *(int*)(addr + ((proc->tf->esp - 4) & 0xFFF))
801046fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104700:	8b 40 18             	mov    0x18(%eax),%eax
80104703:	8b 40 44             	mov    0x44(%eax),%eax
80104706:	83 e8 04             	sub    $0x4,%eax
80104709:	25 ff 0f 00 00       	and    $0xfff,%eax
8010470e:	03 45 f4             	add    -0xc(%ebp),%eax
          = proc->tf->eip;
80104711:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104718:	8b 52 18             	mov    0x18(%edx),%edx
8010471b:	8b 52 38             	mov    0x38(%edx),%edx
8010471e:	89 10                	mov    %edx,(%eax)
  proc->tf->esp -= 4;
80104720:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104726:	8b 40 18             	mov    0x18(%eax),%eax
80104729:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104730:	8b 52 18             	mov    0x18(%edx),%edx
80104733:	8b 52 44             	mov    0x44(%edx),%edx
80104736:	83 ea 04             	sub    $0x4,%edx
80104739:	89 50 44             	mov    %edx,0x44(%eax)

    /* update eip */
  proc->tf->eip = (uint)sighandler;
8010473c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104742:	8b 40 18             	mov    0x18(%eax),%eax
80104745:	8b 55 08             	mov    0x8(%ebp),%edx
80104748:	89 50 38             	mov    %edx,0x38(%eax)
}
8010474b:	c9                   	leave  
8010474c:	c3                   	ret    

8010474d <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
8010474d:	55                   	push   %ebp
8010474e:	89 e5                	mov    %esp,%ebp
80104750:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104753:	e8 ad f8 ff ff       	call   80104005 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104758:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010475f:	e8 23 08 00 00       	call   80104f87 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104764:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
8010476b:	eb 62                	jmp    801047cf <scheduler+0x82>
      if(p->state != RUNNABLE)
8010476d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104770:	8b 40 0c             	mov    0xc(%eax),%eax
80104773:	83 f8 03             	cmp    $0x3,%eax
80104776:	75 4f                	jne    801047c7 <scheduler+0x7a>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104778:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010477b:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104781:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104784:	89 04 24             	mov    %eax,(%esp)
80104787:	e8 92 36 00 00       	call   80107e1e <switchuvm>
      p->state = RUNNING;
8010478c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010478f:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104796:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010479c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010479f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801047a6:	83 c2 04             	add    $0x4,%edx
801047a9:	89 44 24 04          	mov    %eax,0x4(%esp)
801047ad:	89 14 24             	mov    %edx,(%esp)
801047b0:	e8 c7 0c 00 00       	call   8010547c <swtch>
      switchkvm();
801047b5:	e8 47 36 00 00       	call   80107e01 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
801047ba:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801047c1:	00 00 00 00 
801047c5:	eb 01                	jmp    801047c8 <scheduler+0x7b>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;
801047c7:	90                   	nop
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801047c8:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
801047cf:	81 7d f4 54 22 11 80 	cmpl   $0x80112254,-0xc(%ebp)
801047d6:	72 95                	jb     8010476d <scheduler+0x20>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
    }
    release(&ptable.lock);
801047d8:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801047df:	e8 05 08 00 00       	call   80104fe9 <release>

  }
801047e4:	e9 6a ff ff ff       	jmp    80104753 <scheduler+0x6>

801047e9 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
801047e9:	55                   	push   %ebp
801047ea:	89 e5                	mov    %esp,%ebp
801047ec:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
801047ef:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801047f6:	e8 aa 08 00 00       	call   801050a5 <holding>
801047fb:	85 c0                	test   %eax,%eax
801047fd:	75 0c                	jne    8010480b <sched+0x22>
    panic("sched ptable.lock");
801047ff:	c7 04 24 9d 88 10 80 	movl   $0x8010889d,(%esp)
80104806:	e8 32 bd ff ff       	call   8010053d <panic>
  if(cpu->ncli != 1)
8010480b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104811:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104817:	83 f8 01             	cmp    $0x1,%eax
8010481a:	74 0c                	je     80104828 <sched+0x3f>
    panic("sched locks");
8010481c:	c7 04 24 af 88 10 80 	movl   $0x801088af,(%esp)
80104823:	e8 15 bd ff ff       	call   8010053d <panic>
  if(proc->state == RUNNING)
80104828:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010482e:	8b 40 0c             	mov    0xc(%eax),%eax
80104831:	83 f8 04             	cmp    $0x4,%eax
80104834:	75 0c                	jne    80104842 <sched+0x59>
    panic("sched running");
80104836:	c7 04 24 bb 88 10 80 	movl   $0x801088bb,(%esp)
8010483d:	e8 fb bc ff ff       	call   8010053d <panic>
  if(readeflags()&FL_IF)
80104842:	e8 a9 f7 ff ff       	call   80103ff0 <readeflags>
80104847:	25 00 02 00 00       	and    $0x200,%eax
8010484c:	85 c0                	test   %eax,%eax
8010484e:	74 0c                	je     8010485c <sched+0x73>
    panic("sched interruptible");
80104850:	c7 04 24 c9 88 10 80 	movl   $0x801088c9,(%esp)
80104857:	e8 e1 bc ff ff       	call   8010053d <panic>
  intena = cpu->intena;
8010485c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104862:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104868:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
8010486b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104871:	8b 40 04             	mov    0x4(%eax),%eax
80104874:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010487b:	83 c2 1c             	add    $0x1c,%edx
8010487e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104882:	89 14 24             	mov    %edx,(%esp)
80104885:	e8 f2 0b 00 00       	call   8010547c <swtch>
  cpu->intena = intena;
8010488a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104890:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104893:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104899:	c9                   	leave  
8010489a:	c3                   	ret    

8010489b <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
8010489b:	55                   	push   %ebp
8010489c:	89 e5                	mov    %esp,%ebp
8010489e:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801048a1:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801048a8:	e8 da 06 00 00       	call   80104f87 <acquire>
  proc->state = RUNNABLE;
801048ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048b3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
801048ba:	e8 2a ff ff ff       	call   801047e9 <sched>
  release(&ptable.lock);
801048bf:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801048c6:	e8 1e 07 00 00       	call   80104fe9 <release>
}
801048cb:	c9                   	leave  
801048cc:	c3                   	ret    

801048cd <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801048cd:	55                   	push   %ebp
801048ce:	89 e5                	mov    %esp,%ebp
801048d0:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801048d3:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801048da:	e8 0a 07 00 00       	call   80104fe9 <release>

  if (first) {
801048df:	a1 20 b0 10 80       	mov    0x8010b020,%eax
801048e4:	85 c0                	test   %eax,%eax
801048e6:	74 0f                	je     801048f7 <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
801048e8:	c7 05 20 b0 10 80 00 	movl   $0x0,0x8010b020
801048ef:	00 00 00 
    initlog();
801048f2:	e8 19 e7 ff ff       	call   80103010 <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
801048f7:	c9                   	leave  
801048f8:	c3                   	ret    

801048f9 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
801048f9:	55                   	push   %ebp
801048fa:	89 e5                	mov    %esp,%ebp
801048fc:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
801048ff:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104905:	85 c0                	test   %eax,%eax
80104907:	75 0c                	jne    80104915 <sleep+0x1c>
    panic("sleep");
80104909:	c7 04 24 dd 88 10 80 	movl   $0x801088dd,(%esp)
80104910:	e8 28 bc ff ff       	call   8010053d <panic>

  if(lk == 0)
80104915:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104919:	75 0c                	jne    80104927 <sleep+0x2e>
    panic("sleep without lk");
8010491b:	c7 04 24 e3 88 10 80 	movl   $0x801088e3,(%esp)
80104922:	e8 16 bc ff ff       	call   8010053d <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104927:	81 7d 0c 20 ff 10 80 	cmpl   $0x8010ff20,0xc(%ebp)
8010492e:	74 17                	je     80104947 <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104930:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104937:	e8 4b 06 00 00       	call   80104f87 <acquire>
    release(lk);
8010493c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010493f:	89 04 24             	mov    %eax,(%esp)
80104942:	e8 a2 06 00 00       	call   80104fe9 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80104947:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010494d:	8b 55 08             	mov    0x8(%ebp),%edx
80104950:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104953:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104959:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104960:	e8 84 fe ff ff       	call   801047e9 <sched>

  // Tidy up.
  proc->chan = 0;
80104965:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010496b:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104972:	81 7d 0c 20 ff 10 80 	cmpl   $0x8010ff20,0xc(%ebp)
80104979:	74 17                	je     80104992 <sleep+0x99>
    release(&ptable.lock);
8010497b:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104982:	e8 62 06 00 00       	call   80104fe9 <release>
    acquire(lk);
80104987:	8b 45 0c             	mov    0xc(%ebp),%eax
8010498a:	89 04 24             	mov    %eax,(%esp)
8010498d:	e8 f5 05 00 00       	call   80104f87 <acquire>
  }
}
80104992:	c9                   	leave  
80104993:	c3                   	ret    

80104994 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104994:	55                   	push   %ebp
80104995:	89 e5                	mov    %esp,%ebp
80104997:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010499a:	c7 45 fc 54 ff 10 80 	movl   $0x8010ff54,-0x4(%ebp)
801049a1:	eb 27                	jmp    801049ca <wakeup1+0x36>
    if(p->state == SLEEPING && p->chan == chan)
801049a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801049a6:	8b 40 0c             	mov    0xc(%eax),%eax
801049a9:	83 f8 02             	cmp    $0x2,%eax
801049ac:	75 15                	jne    801049c3 <wakeup1+0x2f>
801049ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
801049b1:	8b 40 20             	mov    0x20(%eax),%eax
801049b4:	3b 45 08             	cmp    0x8(%ebp),%eax
801049b7:	75 0a                	jne    801049c3 <wakeup1+0x2f>
      p->state = RUNNABLE;
801049b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801049bc:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049c3:	81 45 fc 8c 00 00 00 	addl   $0x8c,-0x4(%ebp)
801049ca:	81 7d fc 54 22 11 80 	cmpl   $0x80112254,-0x4(%ebp)
801049d1:	72 d0                	jb     801049a3 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}
801049d3:	c9                   	leave  
801049d4:	c3                   	ret    

801049d5 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801049d5:	55                   	push   %ebp
801049d6:	89 e5                	mov    %esp,%ebp
801049d8:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
801049db:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801049e2:	e8 a0 05 00 00       	call   80104f87 <acquire>
  wakeup1(chan);
801049e7:	8b 45 08             	mov    0x8(%ebp),%eax
801049ea:	89 04 24             	mov    %eax,(%esp)
801049ed:	e8 a2 ff ff ff       	call   80104994 <wakeup1>
  release(&ptable.lock);
801049f2:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801049f9:	e8 eb 05 00 00       	call   80104fe9 <release>
}
801049fe:	c9                   	leave  
801049ff:	c3                   	ret    

80104a00 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104a00:	55                   	push   %ebp
80104a01:	89 e5                	mov    %esp,%ebp
80104a03:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104a06:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104a0d:	e8 75 05 00 00       	call   80104f87 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a12:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80104a19:	eb 44                	jmp    80104a5f <kill+0x5f>
    if(p->pid == pid){
80104a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a1e:	8b 40 10             	mov    0x10(%eax),%eax
80104a21:	3b 45 08             	cmp    0x8(%ebp),%eax
80104a24:	75 32                	jne    80104a58 <kill+0x58>
      p->killed = 1;
80104a26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a29:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a33:	8b 40 0c             	mov    0xc(%eax),%eax
80104a36:	83 f8 02             	cmp    $0x2,%eax
80104a39:	75 0a                	jne    80104a45 <kill+0x45>
        p->state = RUNNABLE;
80104a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a3e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104a45:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104a4c:	e8 98 05 00 00       	call   80104fe9 <release>
      return 0;
80104a51:	b8 00 00 00 00       	mov    $0x0,%eax
80104a56:	eb 21                	jmp    80104a79 <kill+0x79>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a58:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104a5f:	81 7d f4 54 22 11 80 	cmpl   $0x80112254,-0xc(%ebp)
80104a66:	72 b3                	jb     80104a1b <kill+0x1b>
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80104a68:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104a6f:	e8 75 05 00 00       	call   80104fe9 <release>
  return -1;
80104a74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a79:	c9                   	leave  
80104a7a:	c3                   	ret    

80104a7b <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104a7b:	55                   	push   %ebp
80104a7c:	89 e5                	mov    %esp,%ebp
80104a7e:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a81:	c7 45 f0 54 ff 10 80 	movl   $0x8010ff54,-0x10(%ebp)
80104a88:	e9 db 00 00 00       	jmp    80104b68 <procdump+0xed>
    if(p->state == UNUSED)
80104a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a90:	8b 40 0c             	mov    0xc(%eax),%eax
80104a93:	85 c0                	test   %eax,%eax
80104a95:	0f 84 c5 00 00 00    	je     80104b60 <procdump+0xe5>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a9e:	8b 40 0c             	mov    0xc(%eax),%eax
80104aa1:	83 f8 05             	cmp    $0x5,%eax
80104aa4:	77 23                	ja     80104ac9 <procdump+0x4e>
80104aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104aa9:	8b 40 0c             	mov    0xc(%eax),%eax
80104aac:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104ab3:	85 c0                	test   %eax,%eax
80104ab5:	74 12                	je     80104ac9 <procdump+0x4e>
      state = states[p->state];
80104ab7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104aba:	8b 40 0c             	mov    0xc(%eax),%eax
80104abd:	8b 04 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%eax
80104ac4:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104ac7:	eb 07                	jmp    80104ad0 <procdump+0x55>
    else
      state = "???";
80104ac9:	c7 45 ec f4 88 10 80 	movl   $0x801088f4,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104ad0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ad3:	8d 50 6c             	lea    0x6c(%eax),%edx
80104ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ad9:	8b 40 10             	mov    0x10(%eax),%eax
80104adc:	89 54 24 0c          	mov    %edx,0xc(%esp)
80104ae0:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104ae3:	89 54 24 08          	mov    %edx,0x8(%esp)
80104ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aeb:	c7 04 24 f8 88 10 80 	movl   $0x801088f8,(%esp)
80104af2:	e8 aa b8 ff ff       	call   801003a1 <cprintf>
    if(p->state == SLEEPING){
80104af7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104afa:	8b 40 0c             	mov    0xc(%eax),%eax
80104afd:	83 f8 02             	cmp    $0x2,%eax
80104b00:	75 50                	jne    80104b52 <procdump+0xd7>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b05:	8b 40 1c             	mov    0x1c(%eax),%eax
80104b08:	8b 40 0c             	mov    0xc(%eax),%eax
80104b0b:	83 c0 08             	add    $0x8,%eax
80104b0e:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80104b11:	89 54 24 04          	mov    %edx,0x4(%esp)
80104b15:	89 04 24             	mov    %eax,(%esp)
80104b18:	e8 1b 05 00 00       	call   80105038 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80104b1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104b24:	eb 1b                	jmp    80104b41 <procdump+0xc6>
        cprintf(" %p", pc[i]);
80104b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b29:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104b2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b31:	c7 04 24 01 89 10 80 	movl   $0x80108901,(%esp)
80104b38:	e8 64 b8 ff ff       	call   801003a1 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80104b3d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104b41:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80104b45:	7f 0b                	jg     80104b52 <procdump+0xd7>
80104b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b4a:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80104b4e:	85 c0                	test   %eax,%eax
80104b50:	75 d4                	jne    80104b26 <procdump+0xab>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104b52:	c7 04 24 05 89 10 80 	movl   $0x80108905,(%esp)
80104b59:	e8 43 b8 ff ff       	call   801003a1 <cprintf>
80104b5e:	eb 01                	jmp    80104b61 <procdump+0xe6>
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80104b60:	90                   	nop
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b61:	81 45 f0 8c 00 00 00 	addl   $0x8c,-0x10(%ebp)
80104b68:	81 7d f0 54 22 11 80 	cmpl   $0x80112254,-0x10(%ebp)
80104b6f:	0f 82 18 ff ff ff    	jb     80104a8d <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80104b75:	c9                   	leave  
80104b76:	c3                   	ret    

80104b77 <thread_create>:

int
thread_create(void*(*start_func)(), void* stack, uint stack_size)
{
80104b77:	55                   	push   %ebp
80104b78:	89 e5                	mov    %esp,%ebp
80104b7a:	57                   	push   %edi
80104b7b:	56                   	push   %esi
80104b7c:	53                   	push   %ebx
80104b7d:	83 ec 2c             	sub    $0x2c,%esp
  int i, tid;
  struct proc *np;

  // Allocate process.
  
  acquire(&ptable.lock);
80104b80:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104b87:	e8 fb 03 00 00       	call   80104f87 <acquire>
  for(np = ptable.proc; np < &ptable.proc[NPROC]; np++)
80104b8c:	c7 45 e0 54 ff 10 80 	movl   $0x8010ff54,-0x20(%ebp)
80104b93:	eb 11                	jmp    80104ba6 <thread_create+0x2f>
    if(np->state == UNUSED)
80104b95:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104b98:	8b 40 0c             	mov    0xc(%eax),%eax
80104b9b:	85 c0                	test   %eax,%eax
80104b9d:	74 26                	je     80104bc5 <thread_create+0x4e>
  struct proc *np;

  // Allocate process.
  
  acquire(&ptable.lock);
  for(np = ptable.proc; np < &ptable.proc[NPROC]; np++)
80104b9f:	81 45 e0 8c 00 00 00 	addl   $0x8c,-0x20(%ebp)
80104ba6:	81 7d e0 54 22 11 80 	cmpl   $0x80112254,-0x20(%ebp)
80104bad:	72 e6                	jb     80104b95 <thread_create+0x1e>
    if(np->state == UNUSED)
      goto found;
  release(&ptable.lock);
80104baf:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104bb6:	e8 2e 04 00 00       	call   80104fe9 <release>
  return -1;
80104bbb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bc0:	e9 80 01 00 00       	jmp    80104d45 <thread_create+0x1ce>
  // Allocate process.
  
  acquire(&ptable.lock);
  for(np = ptable.proc; np < &ptable.proc[NPROC]; np++)
    if(np->state == UNUSED)
      goto found;
80104bc5:	90                   	nop
  release(&ptable.lock);
  return -1;

found:
  np->state = EMBRYO;
80104bc6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bc9:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  np->pid = proc->pid;
80104bd0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bd6:	8b 50 10             	mov    0x10(%eax),%edx
80104bd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104bdc:	89 50 10             	mov    %edx,0x10(%eax)
  proc->threadnum++;
80104bdf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104be5:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80104beb:	83 c2 01             	add    $0x1,%edx
80104bee:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  release(&ptable.lock);
80104bf4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104bfb:	e8 e9 03 00 00       	call   80104fe9 <release>
  
  // Copy process state from p.
  np->pgdir = proc->pgdir;
80104c00:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c06:	8b 50 04             	mov    0x4(%eax),%edx
80104c09:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c0c:	89 50 04             	mov    %edx,0x4(%eax)
  np->kstack = stack;
80104c0f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c12:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c15:	89 50 08             	mov    %edx,0x8(%eax)
  np->sz = stack_size;
80104c18:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c1b:	8b 55 10             	mov    0x10(%ebp),%edx
80104c1e:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104c20:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c27:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c2a:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104c2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c30:	8b 50 18             	mov    0x18(%eax),%edx
80104c33:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c39:	8b 40 18             	mov    0x18(%eax),%eax
80104c3c:	89 c3                	mov    %eax,%ebx
80104c3e:	b8 13 00 00 00       	mov    $0x13,%eax
80104c43:	89 d7                	mov    %edx,%edi
80104c45:	89 de                	mov    %ebx,%esi
80104c47:	89 c1                	mov    %eax,%ecx
80104c49:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->isthread = 1;
80104c4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c4e:	c7 40 7c 01 00 00 00 	movl   $0x1,0x7c(%eax)
  np->isjoined = 0;
80104c55:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c58:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104c5f:	00 00 00 
  np->thread_id = ++(proc->thread_id);
80104c62:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104c69:	8b 82 84 00 00 00    	mov    0x84(%edx),%eax
80104c6f:	83 c0 01             	add    $0x1,%eax
80104c72:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
80104c78:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104c7b:	89 82 84 00 00 00    	mov    %eax,0x84(%edx)
  np->threadnum = 0;
80104c81:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c84:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
80104c8b:	00 00 00 
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104c8e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c91:	8b 40 18             	mov    0x18(%eax),%eax
80104c94:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  np->tf->esp = (uint)stack+stack_size;
80104c9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104c9e:	8b 40 18             	mov    0x18(%eax),%eax
80104ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
80104ca4:	03 55 10             	add    0x10(%ebp),%edx
80104ca7:	89 50 44             	mov    %edx,0x44(%eax)
  np->tf->eip = (uint)start_func;
80104caa:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104cad:	8b 40 18             	mov    0x18(%eax),%eax
80104cb0:	8b 55 08             	mov    0x8(%ebp),%edx
80104cb3:	89 50 38             	mov    %edx,0x38(%eax)
  
  for(i = 0; i < NOFILE; i++)
80104cb6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104cbd:	eb 35                	jmp    80104cf4 <thread_create+0x17d>
    if(proc->ofile[i])
80104cbf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cc5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104cc8:	83 c2 08             	add    $0x8,%edx
80104ccb:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104ccf:	85 c0                	test   %eax,%eax
80104cd1:	74 1d                	je     80104cf0 <thread_create+0x179>
      np->ofile[i] = proc->ofile[i];
80104cd3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cd9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104cdc:	83 c2 08             	add    $0x8,%edx
80104cdf:	8b 54 90 08          	mov    0x8(%eax,%edx,4),%edx
80104ce3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ce6:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80104ce9:	83 c1 08             	add    $0x8,%ecx
80104cec:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
  np->tf->esp = (uint)stack+stack_size;
  np->tf->eip = (uint)start_func;
  
  for(i = 0; i < NOFILE; i++)
80104cf0:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104cf4:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104cf8:	7e c5                	jle    80104cbf <thread_create+0x148>
    if(proc->ofile[i])
      np->ofile[i] = proc->ofile[i];
  np->cwd = proc->cwd;
80104cfa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d00:	8b 50 68             	mov    0x68(%eax),%edx
80104d03:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d06:	89 50 68             	mov    %edx,0x68(%eax)
  tid = np->thread_id;
80104d09:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d0c:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104d12:	89 45 dc             	mov    %eax,-0x24(%ebp)
  np->state = RUNNABLE;
80104d15:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d18:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104d1f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d25:	8d 50 6c             	lea    0x6c(%eax),%edx
80104d28:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d2b:	83 c0 6c             	add    $0x6c,%eax
80104d2e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104d35:	00 
80104d36:	89 54 24 04          	mov    %edx,0x4(%esp)
80104d3a:	89 04 24             	mov    %eax,(%esp)
80104d3d:	e8 c4 06 00 00       	call   80105406 <safestrcpy>
  return tid;
80104d42:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104d45:	83 c4 2c             	add    $0x2c,%esp
80104d48:	5b                   	pop    %ebx
80104d49:	5e                   	pop    %esi
80104d4a:	5f                   	pop    %edi
80104d4b:	5d                   	pop    %ebp
80104d4c:	c3                   	ret    

80104d4d <thread_getId>:

int 
thread_getId()
{
80104d4d:	55                   	push   %ebp
80104d4e:	89 e5                	mov    %esp,%ebp
  if(proc && proc->isthread)
80104d50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d56:	85 c0                	test   %eax,%eax
80104d58:	74 1b                	je     80104d75 <thread_getId+0x28>
80104d5a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d60:	8b 40 7c             	mov    0x7c(%eax),%eax
80104d63:	85 c0                	test   %eax,%eax
80104d65:	74 0e                	je     80104d75 <thread_getId+0x28>
    return proc->thread_id;
80104d67:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d6d:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104d73:	eb 05                	jmp    80104d7a <thread_getId+0x2d>
  else
    return -1; 
80104d75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d7a:	5d                   	pop    %ebp
80104d7b:	c3                   	ret    

80104d7c <thread_getProcId>:

int 
thread_getProcId()
{
80104d7c:	55                   	push   %ebp
80104d7d:	89 e5                	mov    %esp,%ebp
  if(proc)
80104d7f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d85:	85 c0                	test   %eax,%eax
80104d87:	74 0b                	je     80104d94 <thread_getProcId+0x18>
    return proc->pid;  
80104d89:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d8f:	8b 40 10             	mov    0x10(%eax),%eax
80104d92:	eb 05                	jmp    80104d99 <thread_getProcId+0x1d>
  else
    return -1;
80104d94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d99:	5d                   	pop    %ebp
80104d9a:	c3                   	ret    

80104d9b <thread_join>:

int 
thread_join(int thread_id, void** ret_val)
{
80104d9b:	55                   	push   %ebp
80104d9c:	89 e5                	mov    %esp,%ebp
80104d9e:	83 ec 28             	sub    $0x28,%esp
  struct proc *t = 0;
80104da1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  int found = 0;
80104da8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  acquire(&ptable.lock);
80104daf:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104db6:	e8 cc 01 00 00       	call   80104f87 <acquire>
  for(t = ptable.proc; t < &ptable.proc[NPROC]; t++)
80104dbb:	c7 45 f4 54 ff 10 80 	movl   $0x8010ff54,-0xc(%ebp)
80104dc2:	eb 74                	jmp    80104e38 <thread_join+0x9d>
  {
    if(t->isthread)
80104dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dc7:	8b 40 7c             	mov    0x7c(%eax),%eax
80104dca:	85 c0                	test   %eax,%eax
80104dcc:	74 63                	je     80104e31 <thread_join+0x96>
    {
      if(t->thread_id == thread_id)
80104dce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104dd1:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80104dd7:	3b 45 08             	cmp    0x8(%ebp),%eax
80104dda:	75 55                	jne    80104e31 <thread_join+0x96>
      {
	if(t->isjoined)
80104ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ddf:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104de5:	85 c0                	test   %eax,%eax
80104de7:	74 0a                	je     80104df3 <thread_join+0x58>
	  return -2;
80104de9:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80104dee:	e9 82 00 00 00       	jmp    80104e75 <thread_join+0xda>
	if(t->state == ZOMBIE){
80104df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df6:	8b 40 0c             	mov    0xc(%eax),%eax
80104df9:	83 f8 05             	cmp    $0x5,%eax
80104dfc:	75 1d                	jne    80104e1b <thread_join+0x80>
	  t->state = UNUSED;
80104dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e01:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	  ret_val =  (void**)t->tf->eax;
80104e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e0b:	8b 40 18             	mov    0x18(%eax),%eax
80104e0e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104e11:	89 45 ec             	mov    %eax,-0x14(%ebp)
	  return 0;
80104e14:	b8 00 00 00 00       	mov    $0x0,%eax
80104e19:	eb 5a                	jmp    80104e75 <thread_join+0xda>
	}      
	t->isjoined = 1;
80104e1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e1e:	c7 80 80 00 00 00 01 	movl   $0x1,0x80(%eax)
80104e25:	00 00 00 
	found = 1;
80104e28:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
	break;
80104e2f:	eb 10                	jmp    80104e41 <thread_join+0xa6>
{
  struct proc *t = 0;
  int found = 0;

  acquire(&ptable.lock);
  for(t = ptable.proc; t < &ptable.proc[NPROC]; t++)
80104e31:	81 45 f4 8c 00 00 00 	addl   $0x8c,-0xc(%ebp)
80104e38:	81 7d f4 54 22 11 80 	cmpl   $0x80112254,-0xc(%ebp)
80104e3f:	72 83                	jb     80104dc4 <thread_join+0x29>
	break;
      }
    }
  }

  if(!found)
80104e41:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104e45:	75 13                	jne    80104e5a <thread_join+0xbf>
  {
    release(&ptable.lock);
80104e47:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104e4e:	e8 96 01 00 00       	call   80104fe9 <release>
    return -1;
80104e53:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e58:	eb 1b                	jmp    80104e75 <thread_join+0xda>
  }

  sleep(proc,&ptable.lock);
80104e5a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e60:	c7 44 24 04 20 ff 10 	movl   $0x8010ff20,0x4(%esp)
80104e67:	80 
80104e68:	89 04 24             	mov    %eax,(%esp)
80104e6b:	e8 89 fa ff ff       	call   801048f9 <sleep>
  return 0;
80104e70:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e75:	c9                   	leave  
80104e76:	c3                   	ret    

80104e77 <thread_exit>:

void 
thread_exit(void * ret_val)
{
80104e77:	55                   	push   %ebp
80104e78:	89 e5                	mov    %esp,%ebp
80104e7a:	83 ec 28             	sub    $0x28,%esp
    acquire(&ptable.lock);
80104e7d:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104e84:	e8 fe 00 00 00       	call   80104f87 <acquire>
    
    while(proc->threadnum > 0)
80104e89:	eb 16                	jmp    80104ea1 <thread_exit+0x2a>
      sleep(proc,&ptable.lock);
80104e8b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e91:	c7 44 24 04 20 ff 10 	movl   $0x8010ff20,0x4(%esp)
80104e98:	80 
80104e99:	89 04 24             	mov    %eax,(%esp)
80104e9c:	e8 58 fa ff ff       	call   801048f9 <sleep>
void 
thread_exit(void * ret_val)
{
    acquire(&ptable.lock);
    
    while(proc->threadnum > 0)
80104ea1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ea7:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80104ead:	85 c0                	test   %eax,%eax
80104eaf:	7f da                	jg     80104e8b <thread_exit+0x14>
      sleep(proc,&ptable.lock);
    if(proc->isthread)
80104eb1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eb7:	8b 40 7c             	mov    0x7c(%eax),%eax
80104eba:	85 c0                	test   %eax,%eax
80104ebc:	74 4c                	je     80104f0a <thread_exit+0x93>
    {
      proc->parent->threadnum--;
80104ebe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ec4:	8b 40 14             	mov    0x14(%eax),%eax
80104ec7:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80104ecd:	83 ea 01             	sub    $0x1,%edx
80104ed0:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
      ret_val =  (void*)proc->tf->eax;
80104ed6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104edc:	8b 40 18             	mov    0x18(%eax),%eax
80104edf:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ee2:	89 45 f4             	mov    %eax,-0xc(%ebp)
      wakeup1(proc->parent);
80104ee5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104eeb:	8b 40 14             	mov    0x14(%eax),%eax
80104eee:	89 04 24             	mov    %eax,(%esp)
80104ef1:	e8 9e fa ff ff       	call   80104994 <wakeup1>
      proc->state = ZOMBIE;
80104ef6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104efc:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
      sched();
80104f03:	e8 e1 f8 ff ff       	call   801047e9 <sched>
80104f08:	eb 11                	jmp    80104f1b <thread_exit+0xa4>
    }
    else
    {
      release(&ptable.lock);
80104f0a:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
80104f11:	e8 d3 00 00 00       	call   80104fe9 <release>
      exit();
80104f16:	e8 3d f5 ff ff       	call   80104458 <exit>
    }
}
80104f1b:	c9                   	leave  
80104f1c:	c3                   	ret    
80104f1d:	00 00                	add    %al,(%eax)
	...

80104f20 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104f20:	55                   	push   %ebp
80104f21:	89 e5                	mov    %esp,%ebp
80104f23:	53                   	push   %ebx
80104f24:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104f27:	9c                   	pushf  
80104f28:	5b                   	pop    %ebx
80104f29:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return eflags;
80104f2c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104f2f:	83 c4 10             	add    $0x10,%esp
80104f32:	5b                   	pop    %ebx
80104f33:	5d                   	pop    %ebp
80104f34:	c3                   	ret    

80104f35 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80104f35:	55                   	push   %ebp
80104f36:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80104f38:	fa                   	cli    
}
80104f39:	5d                   	pop    %ebp
80104f3a:	c3                   	ret    

80104f3b <sti>:

static inline void
sti(void)
{
80104f3b:	55                   	push   %ebp
80104f3c:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104f3e:	fb                   	sti    
}
80104f3f:	5d                   	pop    %ebp
80104f40:	c3                   	ret    

80104f41 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
80104f41:	55                   	push   %ebp
80104f42:	89 e5                	mov    %esp,%ebp
80104f44:	53                   	push   %ebx
80104f45:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
               "+m" (*addr), "=a" (result) :
80104f48:	8b 55 08             	mov    0x8(%ebp),%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104f4b:	8b 45 0c             	mov    0xc(%ebp),%eax
               "+m" (*addr), "=a" (result) :
80104f4e:	8b 4d 08             	mov    0x8(%ebp),%ecx
xchg(volatile uint *addr, uint newval)
{
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104f51:	89 c3                	mov    %eax,%ebx
80104f53:	89 d8                	mov    %ebx,%eax
80104f55:	f0 87 02             	lock xchg %eax,(%edx)
80104f58:	89 c3                	mov    %eax,%ebx
80104f5a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80104f5d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80104f60:	83 c4 10             	add    $0x10,%esp
80104f63:	5b                   	pop    %ebx
80104f64:	5d                   	pop    %ebp
80104f65:	c3                   	ret    

80104f66 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104f66:	55                   	push   %ebp
80104f67:	89 e5                	mov    %esp,%ebp
  lk->name = name;
80104f69:	8b 45 08             	mov    0x8(%ebp),%eax
80104f6c:	8b 55 0c             	mov    0xc(%ebp),%edx
80104f6f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80104f72:	8b 45 08             	mov    0x8(%ebp),%eax
80104f75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80104f7b:	8b 45 08             	mov    0x8(%ebp),%eax
80104f7e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104f85:	5d                   	pop    %ebp
80104f86:	c3                   	ret    

80104f87 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104f87:	55                   	push   %ebp
80104f88:	89 e5                	mov    %esp,%ebp
80104f8a:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104f8d:	e8 3d 01 00 00       	call   801050cf <pushcli>
  if(holding(lk))
80104f92:	8b 45 08             	mov    0x8(%ebp),%eax
80104f95:	89 04 24             	mov    %eax,(%esp)
80104f98:	e8 08 01 00 00       	call   801050a5 <holding>
80104f9d:	85 c0                	test   %eax,%eax
80104f9f:	74 0c                	je     80104fad <acquire+0x26>
    panic("acquire");
80104fa1:	c7 04 24 31 89 10 80 	movl   $0x80108931,(%esp)
80104fa8:	e8 90 b5 ff ff       	call   8010053d <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80104fad:	90                   	nop
80104fae:	8b 45 08             	mov    0x8(%ebp),%eax
80104fb1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80104fb8:	00 
80104fb9:	89 04 24             	mov    %eax,(%esp)
80104fbc:	e8 80 ff ff ff       	call   80104f41 <xchg>
80104fc1:	85 c0                	test   %eax,%eax
80104fc3:	75 e9                	jne    80104fae <acquire+0x27>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80104fc5:	8b 45 08             	mov    0x8(%ebp),%eax
80104fc8:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104fcf:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80104fd2:	8b 45 08             	mov    0x8(%ebp),%eax
80104fd5:	83 c0 0c             	add    $0xc,%eax
80104fd8:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fdc:	8d 45 08             	lea    0x8(%ebp),%eax
80104fdf:	89 04 24             	mov    %eax,(%esp)
80104fe2:	e8 51 00 00 00       	call   80105038 <getcallerpcs>
}
80104fe7:	c9                   	leave  
80104fe8:	c3                   	ret    

80104fe9 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80104fe9:	55                   	push   %ebp
80104fea:	89 e5                	mov    %esp,%ebp
80104fec:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
80104fef:	8b 45 08             	mov    0x8(%ebp),%eax
80104ff2:	89 04 24             	mov    %eax,(%esp)
80104ff5:	e8 ab 00 00 00       	call   801050a5 <holding>
80104ffa:	85 c0                	test   %eax,%eax
80104ffc:	75 0c                	jne    8010500a <release+0x21>
    panic("release");
80104ffe:	c7 04 24 39 89 10 80 	movl   $0x80108939,(%esp)
80105005:	e8 33 b5 ff ff       	call   8010053d <panic>

  lk->pcs[0] = 0;
8010500a:	8b 45 08             	mov    0x8(%ebp),%eax
8010500d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105014:	8b 45 08             	mov    0x8(%ebp),%eax
80105017:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010501e:	8b 45 08             	mov    0x8(%ebp),%eax
80105021:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105028:	00 
80105029:	89 04 24             	mov    %eax,(%esp)
8010502c:	e8 10 ff ff ff       	call   80104f41 <xchg>

  popcli();
80105031:	e8 e1 00 00 00       	call   80105117 <popcli>
}
80105036:	c9                   	leave  
80105037:	c3                   	ret    

80105038 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105038:	55                   	push   %ebp
80105039:	89 e5                	mov    %esp,%ebp
8010503b:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010503e:	8b 45 08             	mov    0x8(%ebp),%eax
80105041:	83 e8 08             	sub    $0x8,%eax
80105044:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105047:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
8010504e:	eb 32                	jmp    80105082 <getcallerpcs+0x4a>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80105050:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80105054:	74 47                	je     8010509d <getcallerpcs+0x65>
80105056:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
8010505d:	76 3e                	jbe    8010509d <getcallerpcs+0x65>
8010505f:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
80105063:	74 38                	je     8010509d <getcallerpcs+0x65>
      break;
    pcs[i] = ebp[1];     // saved %eip
80105065:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105068:	c1 e0 02             	shl    $0x2,%eax
8010506b:	03 45 0c             	add    0xc(%ebp),%eax
8010506e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105071:	8b 52 04             	mov    0x4(%edx),%edx
80105074:	89 10                	mov    %edx,(%eax)
    ebp = (uint*)ebp[0]; // saved %ebp
80105076:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105079:	8b 00                	mov    (%eax),%eax
8010507b:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
8010507e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105082:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105086:	7e c8                	jle    80105050 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105088:	eb 13                	jmp    8010509d <getcallerpcs+0x65>
    pcs[i] = 0;
8010508a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010508d:	c1 e0 02             	shl    $0x2,%eax
80105090:	03 45 0c             	add    0xc(%ebp),%eax
80105093:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105099:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
8010509d:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801050a1:	7e e7                	jle    8010508a <getcallerpcs+0x52>
    pcs[i] = 0;
}
801050a3:	c9                   	leave  
801050a4:	c3                   	ret    

801050a5 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801050a5:	55                   	push   %ebp
801050a6:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
801050a8:	8b 45 08             	mov    0x8(%ebp),%eax
801050ab:	8b 00                	mov    (%eax),%eax
801050ad:	85 c0                	test   %eax,%eax
801050af:	74 17                	je     801050c8 <holding+0x23>
801050b1:	8b 45 08             	mov    0x8(%ebp),%eax
801050b4:	8b 50 08             	mov    0x8(%eax),%edx
801050b7:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050bd:	39 c2                	cmp    %eax,%edx
801050bf:	75 07                	jne    801050c8 <holding+0x23>
801050c1:	b8 01 00 00 00       	mov    $0x1,%eax
801050c6:	eb 05                	jmp    801050cd <holding+0x28>
801050c8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801050cd:	5d                   	pop    %ebp
801050ce:	c3                   	ret    

801050cf <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801050cf:	55                   	push   %ebp
801050d0:	89 e5                	mov    %esp,%ebp
801050d2:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
801050d5:	e8 46 fe ff ff       	call   80104f20 <readeflags>
801050da:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
801050dd:	e8 53 fe ff ff       	call   80104f35 <cli>
  if(cpu->ncli++ == 0)
801050e2:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801050e8:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801050ee:	85 d2                	test   %edx,%edx
801050f0:	0f 94 c1             	sete   %cl
801050f3:	83 c2 01             	add    $0x1,%edx
801050f6:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801050fc:	84 c9                	test   %cl,%cl
801050fe:	74 15                	je     80105115 <pushcli+0x46>
    cpu->intena = eflags & FL_IF;
80105100:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105106:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105109:	81 e2 00 02 00 00    	and    $0x200,%edx
8010510f:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105115:	c9                   	leave  
80105116:	c3                   	ret    

80105117 <popcli>:

void
popcli(void)
{
80105117:	55                   	push   %ebp
80105118:	89 e5                	mov    %esp,%ebp
8010511a:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
8010511d:	e8 fe fd ff ff       	call   80104f20 <readeflags>
80105122:	25 00 02 00 00       	and    $0x200,%eax
80105127:	85 c0                	test   %eax,%eax
80105129:	74 0c                	je     80105137 <popcli+0x20>
    panic("popcli - interruptible");
8010512b:	c7 04 24 41 89 10 80 	movl   $0x80108941,(%esp)
80105132:	e8 06 b4 ff ff       	call   8010053d <panic>
  if(--cpu->ncli < 0)
80105137:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010513d:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105143:	83 ea 01             	sub    $0x1,%edx
80105146:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
8010514c:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105152:	85 c0                	test   %eax,%eax
80105154:	79 0c                	jns    80105162 <popcli+0x4b>
    panic("popcli");
80105156:	c7 04 24 58 89 10 80 	movl   $0x80108958,(%esp)
8010515d:	e8 db b3 ff ff       	call   8010053d <panic>
  if(cpu->ncli == 0 && cpu->intena)
80105162:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105168:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
8010516e:	85 c0                	test   %eax,%eax
80105170:	75 15                	jne    80105187 <popcli+0x70>
80105172:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105178:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
8010517e:	85 c0                	test   %eax,%eax
80105180:	74 05                	je     80105187 <popcli+0x70>
    sti();
80105182:	e8 b4 fd ff ff       	call   80104f3b <sti>
}
80105187:	c9                   	leave  
80105188:	c3                   	ret    
80105189:	00 00                	add    %al,(%eax)
	...

8010518c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
8010518c:	55                   	push   %ebp
8010518d:	89 e5                	mov    %esp,%ebp
8010518f:	57                   	push   %edi
80105190:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105191:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105194:	8b 55 10             	mov    0x10(%ebp),%edx
80105197:	8b 45 0c             	mov    0xc(%ebp),%eax
8010519a:	89 cb                	mov    %ecx,%ebx
8010519c:	89 df                	mov    %ebx,%edi
8010519e:	89 d1                	mov    %edx,%ecx
801051a0:	fc                   	cld    
801051a1:	f3 aa                	rep stos %al,%es:(%edi)
801051a3:	89 ca                	mov    %ecx,%edx
801051a5:	89 fb                	mov    %edi,%ebx
801051a7:	89 5d 08             	mov    %ebx,0x8(%ebp)
801051aa:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801051ad:	5b                   	pop    %ebx
801051ae:	5f                   	pop    %edi
801051af:	5d                   	pop    %ebp
801051b0:	c3                   	ret    

801051b1 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
801051b1:	55                   	push   %ebp
801051b2:	89 e5                	mov    %esp,%ebp
801051b4:	57                   	push   %edi
801051b5:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
801051b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801051b9:	8b 55 10             	mov    0x10(%ebp),%edx
801051bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801051bf:	89 cb                	mov    %ecx,%ebx
801051c1:	89 df                	mov    %ebx,%edi
801051c3:	89 d1                	mov    %edx,%ecx
801051c5:	fc                   	cld    
801051c6:	f3 ab                	rep stos %eax,%es:(%edi)
801051c8:	89 ca                	mov    %ecx,%edx
801051ca:	89 fb                	mov    %edi,%ebx
801051cc:	89 5d 08             	mov    %ebx,0x8(%ebp)
801051cf:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
801051d2:	5b                   	pop    %ebx
801051d3:	5f                   	pop    %edi
801051d4:	5d                   	pop    %ebp
801051d5:	c3                   	ret    

801051d6 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801051d6:	55                   	push   %ebp
801051d7:	89 e5                	mov    %esp,%ebp
801051d9:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
801051dc:	8b 45 08             	mov    0x8(%ebp),%eax
801051df:	83 e0 03             	and    $0x3,%eax
801051e2:	85 c0                	test   %eax,%eax
801051e4:	75 49                	jne    8010522f <memset+0x59>
801051e6:	8b 45 10             	mov    0x10(%ebp),%eax
801051e9:	83 e0 03             	and    $0x3,%eax
801051ec:	85 c0                	test   %eax,%eax
801051ee:	75 3f                	jne    8010522f <memset+0x59>
    c &= 0xFF;
801051f0:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801051f7:	8b 45 10             	mov    0x10(%ebp),%eax
801051fa:	c1 e8 02             	shr    $0x2,%eax
801051fd:	89 c2                	mov    %eax,%edx
801051ff:	8b 45 0c             	mov    0xc(%ebp),%eax
80105202:	89 c1                	mov    %eax,%ecx
80105204:	c1 e1 18             	shl    $0x18,%ecx
80105207:	8b 45 0c             	mov    0xc(%ebp),%eax
8010520a:	c1 e0 10             	shl    $0x10,%eax
8010520d:	09 c1                	or     %eax,%ecx
8010520f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105212:	c1 e0 08             	shl    $0x8,%eax
80105215:	09 c8                	or     %ecx,%eax
80105217:	0b 45 0c             	or     0xc(%ebp),%eax
8010521a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010521e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105222:	8b 45 08             	mov    0x8(%ebp),%eax
80105225:	89 04 24             	mov    %eax,(%esp)
80105228:	e8 84 ff ff ff       	call   801051b1 <stosl>
8010522d:	eb 19                	jmp    80105248 <memset+0x72>
  } else
    stosb(dst, c, n);
8010522f:	8b 45 10             	mov    0x10(%ebp),%eax
80105232:	89 44 24 08          	mov    %eax,0x8(%esp)
80105236:	8b 45 0c             	mov    0xc(%ebp),%eax
80105239:	89 44 24 04          	mov    %eax,0x4(%esp)
8010523d:	8b 45 08             	mov    0x8(%ebp),%eax
80105240:	89 04 24             	mov    %eax,(%esp)
80105243:	e8 44 ff ff ff       	call   8010518c <stosb>
  return dst;
80105248:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010524b:	c9                   	leave  
8010524c:	c3                   	ret    

8010524d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
8010524d:	55                   	push   %ebp
8010524e:	89 e5                	mov    %esp,%ebp
80105250:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80105253:	8b 45 08             	mov    0x8(%ebp),%eax
80105256:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80105259:	8b 45 0c             	mov    0xc(%ebp),%eax
8010525c:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
8010525f:	eb 32                	jmp    80105293 <memcmp+0x46>
    if(*s1 != *s2)
80105261:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105264:	0f b6 10             	movzbl (%eax),%edx
80105267:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010526a:	0f b6 00             	movzbl (%eax),%eax
8010526d:	38 c2                	cmp    %al,%dl
8010526f:	74 1a                	je     8010528b <memcmp+0x3e>
      return *s1 - *s2;
80105271:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105274:	0f b6 00             	movzbl (%eax),%eax
80105277:	0f b6 d0             	movzbl %al,%edx
8010527a:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010527d:	0f b6 00             	movzbl (%eax),%eax
80105280:	0f b6 c0             	movzbl %al,%eax
80105283:	89 d1                	mov    %edx,%ecx
80105285:	29 c1                	sub    %eax,%ecx
80105287:	89 c8                	mov    %ecx,%eax
80105289:	eb 1c                	jmp    801052a7 <memcmp+0x5a>
    s1++, s2++;
8010528b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010528f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105293:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105297:	0f 95 c0             	setne  %al
8010529a:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010529e:	84 c0                	test   %al,%al
801052a0:	75 bf                	jne    80105261 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801052a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
801052a7:	c9                   	leave  
801052a8:	c3                   	ret    

801052a9 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801052a9:	55                   	push   %ebp
801052aa:	89 e5                	mov    %esp,%ebp
801052ac:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801052af:	8b 45 0c             	mov    0xc(%ebp),%eax
801052b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801052b5:	8b 45 08             	mov    0x8(%ebp),%eax
801052b8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801052bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052be:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801052c1:	73 54                	jae    80105317 <memmove+0x6e>
801052c3:	8b 45 10             	mov    0x10(%ebp),%eax
801052c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
801052c9:	01 d0                	add    %edx,%eax
801052cb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
801052ce:	76 47                	jbe    80105317 <memmove+0x6e>
    s += n;
801052d0:	8b 45 10             	mov    0x10(%ebp),%eax
801052d3:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
801052d6:	8b 45 10             	mov    0x10(%ebp),%eax
801052d9:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
801052dc:	eb 13                	jmp    801052f1 <memmove+0x48>
      *--d = *--s;
801052de:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
801052e2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
801052e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801052e9:	0f b6 10             	movzbl (%eax),%edx
801052ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
801052ef:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801052f1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801052f5:	0f 95 c0             	setne  %al
801052f8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801052fc:	84 c0                	test   %al,%al
801052fe:	75 de                	jne    801052de <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80105300:	eb 25                	jmp    80105327 <memmove+0x7e>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80105302:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105305:	0f b6 10             	movzbl (%eax),%edx
80105308:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010530b:	88 10                	mov    %dl,(%eax)
8010530d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105311:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105315:	eb 01                	jmp    80105318 <memmove+0x6f>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105317:	90                   	nop
80105318:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010531c:	0f 95 c0             	setne  %al
8010531f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105323:	84 c0                	test   %al,%al
80105325:	75 db                	jne    80105302 <memmove+0x59>
      *d++ = *s++;

  return dst;
80105327:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010532a:	c9                   	leave  
8010532b:	c3                   	ret    

8010532c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010532c:	55                   	push   %ebp
8010532d:	89 e5                	mov    %esp,%ebp
8010532f:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80105332:	8b 45 10             	mov    0x10(%ebp),%eax
80105335:	89 44 24 08          	mov    %eax,0x8(%esp)
80105339:	8b 45 0c             	mov    0xc(%ebp),%eax
8010533c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105340:	8b 45 08             	mov    0x8(%ebp),%eax
80105343:	89 04 24             	mov    %eax,(%esp)
80105346:	e8 5e ff ff ff       	call   801052a9 <memmove>
}
8010534b:	c9                   	leave  
8010534c:	c3                   	ret    

8010534d <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
8010534d:	55                   	push   %ebp
8010534e:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105350:	eb 0c                	jmp    8010535e <strncmp+0x11>
    n--, p++, q++;
80105352:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105356:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010535a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010535e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105362:	74 1a                	je     8010537e <strncmp+0x31>
80105364:	8b 45 08             	mov    0x8(%ebp),%eax
80105367:	0f b6 00             	movzbl (%eax),%eax
8010536a:	84 c0                	test   %al,%al
8010536c:	74 10                	je     8010537e <strncmp+0x31>
8010536e:	8b 45 08             	mov    0x8(%ebp),%eax
80105371:	0f b6 10             	movzbl (%eax),%edx
80105374:	8b 45 0c             	mov    0xc(%ebp),%eax
80105377:	0f b6 00             	movzbl (%eax),%eax
8010537a:	38 c2                	cmp    %al,%dl
8010537c:	74 d4                	je     80105352 <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
8010537e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105382:	75 07                	jne    8010538b <strncmp+0x3e>
    return 0;
80105384:	b8 00 00 00 00       	mov    $0x0,%eax
80105389:	eb 18                	jmp    801053a3 <strncmp+0x56>
  return (uchar)*p - (uchar)*q;
8010538b:	8b 45 08             	mov    0x8(%ebp),%eax
8010538e:	0f b6 00             	movzbl (%eax),%eax
80105391:	0f b6 d0             	movzbl %al,%edx
80105394:	8b 45 0c             	mov    0xc(%ebp),%eax
80105397:	0f b6 00             	movzbl (%eax),%eax
8010539a:	0f b6 c0             	movzbl %al,%eax
8010539d:	89 d1                	mov    %edx,%ecx
8010539f:	29 c1                	sub    %eax,%ecx
801053a1:	89 c8                	mov    %ecx,%eax
}
801053a3:	5d                   	pop    %ebp
801053a4:	c3                   	ret    

801053a5 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801053a5:	55                   	push   %ebp
801053a6:	89 e5                	mov    %esp,%ebp
801053a8:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801053ab:	8b 45 08             	mov    0x8(%ebp),%eax
801053ae:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801053b1:	90                   	nop
801053b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053b6:	0f 9f c0             	setg   %al
801053b9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801053bd:	84 c0                	test   %al,%al
801053bf:	74 30                	je     801053f1 <strncpy+0x4c>
801053c1:	8b 45 0c             	mov    0xc(%ebp),%eax
801053c4:	0f b6 10             	movzbl (%eax),%edx
801053c7:	8b 45 08             	mov    0x8(%ebp),%eax
801053ca:	88 10                	mov    %dl,(%eax)
801053cc:	8b 45 08             	mov    0x8(%ebp),%eax
801053cf:	0f b6 00             	movzbl (%eax),%eax
801053d2:	84 c0                	test   %al,%al
801053d4:	0f 95 c0             	setne  %al
801053d7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801053db:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
801053df:	84 c0                	test   %al,%al
801053e1:	75 cf                	jne    801053b2 <strncpy+0xd>
    ;
  while(n-- > 0)
801053e3:	eb 0c                	jmp    801053f1 <strncpy+0x4c>
    *s++ = 0;
801053e5:	8b 45 08             	mov    0x8(%ebp),%eax
801053e8:	c6 00 00             	movb   $0x0,(%eax)
801053eb:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801053ef:	eb 01                	jmp    801053f2 <strncpy+0x4d>
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801053f1:	90                   	nop
801053f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801053f6:	0f 9f c0             	setg   %al
801053f9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801053fd:	84 c0                	test   %al,%al
801053ff:	75 e4                	jne    801053e5 <strncpy+0x40>
    *s++ = 0;
  return os;
80105401:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105404:	c9                   	leave  
80105405:	c3                   	ret    

80105406 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105406:	55                   	push   %ebp
80105407:	89 e5                	mov    %esp,%ebp
80105409:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010540c:	8b 45 08             	mov    0x8(%ebp),%eax
8010540f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105412:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105416:	7f 05                	jg     8010541d <safestrcpy+0x17>
    return os;
80105418:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010541b:	eb 35                	jmp    80105452 <safestrcpy+0x4c>
  while(--n > 0 && (*s++ = *t++) != 0)
8010541d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105421:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105425:	7e 22                	jle    80105449 <safestrcpy+0x43>
80105427:	8b 45 0c             	mov    0xc(%ebp),%eax
8010542a:	0f b6 10             	movzbl (%eax),%edx
8010542d:	8b 45 08             	mov    0x8(%ebp),%eax
80105430:	88 10                	mov    %dl,(%eax)
80105432:	8b 45 08             	mov    0x8(%ebp),%eax
80105435:	0f b6 00             	movzbl (%eax),%eax
80105438:	84 c0                	test   %al,%al
8010543a:	0f 95 c0             	setne  %al
8010543d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80105441:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80105445:	84 c0                	test   %al,%al
80105447:	75 d4                	jne    8010541d <safestrcpy+0x17>
    ;
  *s = 0;
80105449:	8b 45 08             	mov    0x8(%ebp),%eax
8010544c:	c6 00 00             	movb   $0x0,(%eax)
  return os;
8010544f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105452:	c9                   	leave  
80105453:	c3                   	ret    

80105454 <strlen>:

int
strlen(const char *s)
{
80105454:	55                   	push   %ebp
80105455:	89 e5                	mov    %esp,%ebp
80105457:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
8010545a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105461:	eb 04                	jmp    80105467 <strlen+0x13>
80105463:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105467:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010546a:	03 45 08             	add    0x8(%ebp),%eax
8010546d:	0f b6 00             	movzbl (%eax),%eax
80105470:	84 c0                	test   %al,%al
80105472:	75 ef                	jne    80105463 <strlen+0xf>
    ;
  return n;
80105474:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105477:	c9                   	leave  
80105478:	c3                   	ret    
80105479:	00 00                	add    %al,(%eax)
	...

8010547c <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010547c:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80105480:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80105484:	55                   	push   %ebp
  pushl %ebx
80105485:	53                   	push   %ebx
  pushl %esi
80105486:	56                   	push   %esi
  pushl %edi
80105487:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105488:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
8010548a:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
8010548c:	5f                   	pop    %edi
  popl %esi
8010548d:	5e                   	pop    %esi
  popl %ebx
8010548e:	5b                   	pop    %ebx
  popl %ebp
8010548f:	5d                   	pop    %ebp
  ret
80105490:	c3                   	ret    
80105491:	00 00                	add    %al,(%eax)
	...

80105494 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from process p.
int
fetchint(struct proc *p, uint addr, int *ip)
{
80105494:	55                   	push   %ebp
80105495:	89 e5                	mov    %esp,%ebp
  if(addr >= p->sz || addr+4 > p->sz)
80105497:	8b 45 08             	mov    0x8(%ebp),%eax
8010549a:	8b 00                	mov    (%eax),%eax
8010549c:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010549f:	76 0f                	jbe    801054b0 <fetchint+0x1c>
801054a1:	8b 45 0c             	mov    0xc(%ebp),%eax
801054a4:	8d 50 04             	lea    0x4(%eax),%edx
801054a7:	8b 45 08             	mov    0x8(%ebp),%eax
801054aa:	8b 00                	mov    (%eax),%eax
801054ac:	39 c2                	cmp    %eax,%edx
801054ae:	76 07                	jbe    801054b7 <fetchint+0x23>
    return -1;
801054b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054b5:	eb 0f                	jmp    801054c6 <fetchint+0x32>
  *ip = *(int*)(addr);
801054b7:	8b 45 0c             	mov    0xc(%ebp),%eax
801054ba:	8b 10                	mov    (%eax),%edx
801054bc:	8b 45 10             	mov    0x10(%ebp),%eax
801054bf:	89 10                	mov    %edx,(%eax)
  return 0;
801054c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801054c6:	5d                   	pop    %ebp
801054c7:	c3                   	ret    

801054c8 <fetchstr>:
// Fetch the nul-terminated string at addr from process p.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(struct proc *p, uint addr, char **pp)
{
801054c8:	55                   	push   %ebp
801054c9:	89 e5                	mov    %esp,%ebp
801054cb:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= p->sz)
801054ce:	8b 45 08             	mov    0x8(%ebp),%eax
801054d1:	8b 00                	mov    (%eax),%eax
801054d3:	3b 45 0c             	cmp    0xc(%ebp),%eax
801054d6:	77 07                	ja     801054df <fetchstr+0x17>
    return -1;
801054d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054dd:	eb 45                	jmp    80105524 <fetchstr+0x5c>
  *pp = (char*)addr;
801054df:	8b 55 0c             	mov    0xc(%ebp),%edx
801054e2:	8b 45 10             	mov    0x10(%ebp),%eax
801054e5:	89 10                	mov    %edx,(%eax)
  ep = (char*)p->sz;
801054e7:	8b 45 08             	mov    0x8(%ebp),%eax
801054ea:	8b 00                	mov    (%eax),%eax
801054ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
801054ef:	8b 45 10             	mov    0x10(%ebp),%eax
801054f2:	8b 00                	mov    (%eax),%eax
801054f4:	89 45 fc             	mov    %eax,-0x4(%ebp)
801054f7:	eb 1e                	jmp    80105517 <fetchstr+0x4f>
    if(*s == 0)
801054f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
801054fc:	0f b6 00             	movzbl (%eax),%eax
801054ff:	84 c0                	test   %al,%al
80105501:	75 10                	jne    80105513 <fetchstr+0x4b>
      return s - *pp;
80105503:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105506:	8b 45 10             	mov    0x10(%ebp),%eax
80105509:	8b 00                	mov    (%eax),%eax
8010550b:	89 d1                	mov    %edx,%ecx
8010550d:	29 c1                	sub    %eax,%ecx
8010550f:	89 c8                	mov    %ecx,%eax
80105511:	eb 11                	jmp    80105524 <fetchstr+0x5c>

  if(addr >= p->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)p->sz;
  for(s = *pp; s < ep; s++)
80105513:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105517:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010551a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010551d:	72 da                	jb     801054f9 <fetchstr+0x31>
    if(*s == 0)
      return s - *pp;
  return -1;
8010551f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105524:	c9                   	leave  
80105525:	c3                   	ret    

80105526 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105526:	55                   	push   %ebp
80105527:	89 e5                	mov    %esp,%ebp
80105529:	83 ec 0c             	sub    $0xc,%esp
  return fetchint(proc, proc->tf->esp + 4 + 4*n, ip);
8010552c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105532:	8b 40 18             	mov    0x18(%eax),%eax
80105535:	8b 50 44             	mov    0x44(%eax),%edx
80105538:	8b 45 08             	mov    0x8(%ebp),%eax
8010553b:	c1 e0 02             	shl    $0x2,%eax
8010553e:	01 d0                	add    %edx,%eax
80105540:	8d 48 04             	lea    0x4(%eax),%ecx
80105543:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105549:	8b 55 0c             	mov    0xc(%ebp),%edx
8010554c:	89 54 24 08          	mov    %edx,0x8(%esp)
80105550:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80105554:	89 04 24             	mov    %eax,(%esp)
80105557:	e8 38 ff ff ff       	call   80105494 <fetchint>
}
8010555c:	c9                   	leave  
8010555d:	c3                   	ret    

8010555e <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
8010555e:	55                   	push   %ebp
8010555f:	89 e5                	mov    %esp,%ebp
80105561:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105564:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105567:	89 44 24 04          	mov    %eax,0x4(%esp)
8010556b:	8b 45 08             	mov    0x8(%ebp),%eax
8010556e:	89 04 24             	mov    %eax,(%esp)
80105571:	e8 b0 ff ff ff       	call   80105526 <argint>
80105576:	85 c0                	test   %eax,%eax
80105578:	79 07                	jns    80105581 <argptr+0x23>
    return -1;
8010557a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010557f:	eb 3d                	jmp    801055be <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105581:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105584:	89 c2                	mov    %eax,%edx
80105586:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010558c:	8b 00                	mov    (%eax),%eax
8010558e:	39 c2                	cmp    %eax,%edx
80105590:	73 16                	jae    801055a8 <argptr+0x4a>
80105592:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105595:	89 c2                	mov    %eax,%edx
80105597:	8b 45 10             	mov    0x10(%ebp),%eax
8010559a:	01 c2                	add    %eax,%edx
8010559c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055a2:	8b 00                	mov    (%eax),%eax
801055a4:	39 c2                	cmp    %eax,%edx
801055a6:	76 07                	jbe    801055af <argptr+0x51>
    return -1;
801055a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055ad:	eb 0f                	jmp    801055be <argptr+0x60>
  *pp = (char*)i;
801055af:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055b2:	89 c2                	mov    %eax,%edx
801055b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801055b7:	89 10                	mov    %edx,(%eax)
  return 0;
801055b9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055be:	c9                   	leave  
801055bf:	c3                   	ret    

801055c0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  if(argint(n, &addr) < 0)
801055c6:	8d 45 fc             	lea    -0x4(%ebp),%eax
801055c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801055cd:	8b 45 08             	mov    0x8(%ebp),%eax
801055d0:	89 04 24             	mov    %eax,(%esp)
801055d3:	e8 4e ff ff ff       	call   80105526 <argint>
801055d8:	85 c0                	test   %eax,%eax
801055da:	79 07                	jns    801055e3 <argstr+0x23>
    return -1;
801055dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055e1:	eb 1e                	jmp    80105601 <argstr+0x41>
  return fetchstr(proc, addr, pp);
801055e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055e6:	89 c2                	mov    %eax,%edx
801055e8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801055f1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801055f5:	89 54 24 04          	mov    %edx,0x4(%esp)
801055f9:	89 04 24             	mov    %eax,(%esp)
801055fc:	e8 c7 fe ff ff       	call   801054c8 <fetchstr>
}
80105601:	c9                   	leave  
80105602:	c3                   	ret    

80105603 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
80105603:	55                   	push   %ebp
80105604:	89 e5                	mov    %esp,%ebp
80105606:	53                   	push   %ebx
80105607:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
8010560a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105610:	8b 40 18             	mov    0x18(%eax),%eax
80105613:	8b 40 1c             	mov    0x1c(%eax),%eax
80105616:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num >= 0 && num < SYS_open && syscalls[num]) {
80105619:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010561d:	78 2e                	js     8010564d <syscall+0x4a>
8010561f:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
80105623:	7f 28                	jg     8010564d <syscall+0x4a>
80105625:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105628:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
8010562f:	85 c0                	test   %eax,%eax
80105631:	74 1a                	je     8010564d <syscall+0x4a>
    proc->tf->eax = syscalls[num]();
80105633:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105639:	8b 58 18             	mov    0x18(%eax),%ebx
8010563c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010563f:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105646:	ff d0                	call   *%eax
80105648:	89 43 1c             	mov    %eax,0x1c(%ebx)
8010564b:	eb 73                	jmp    801056c0 <syscall+0xbd>
  } else if (num >= SYS_open && num < NELEM(syscalls) && syscalls[num]) {
8010564d:	83 7d f4 0e          	cmpl   $0xe,-0xc(%ebp)
80105651:	7e 30                	jle    80105683 <syscall+0x80>
80105653:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105656:	83 f8 15             	cmp    $0x15,%eax
80105659:	77 28                	ja     80105683 <syscall+0x80>
8010565b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010565e:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105665:	85 c0                	test   %eax,%eax
80105667:	74 1a                	je     80105683 <syscall+0x80>
    proc->tf->eax = syscalls[num]();
80105669:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010566f:	8b 58 18             	mov    0x18(%eax),%ebx
80105672:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105675:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
8010567c:	ff d0                	call   *%eax
8010567e:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105681:	eb 3d                	jmp    801056c0 <syscall+0xbd>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105683:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105689:	8d 48 6c             	lea    0x6c(%eax),%ecx
8010568c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
  if(num >= 0 && num < SYS_open && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else if (num >= SYS_open && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105692:	8b 40 10             	mov    0x10(%eax),%eax
80105695:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105698:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010569c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801056a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801056a4:	c7 04 24 5f 89 10 80 	movl   $0x8010895f,(%esp)
801056ab:	e8 f1 ac ff ff       	call   801003a1 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
801056b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056b6:	8b 40 18             	mov    0x18(%eax),%eax
801056b9:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801056c0:	83 c4 24             	add    $0x24,%esp
801056c3:	5b                   	pop    %ebx
801056c4:	5d                   	pop    %ebp
801056c5:	c3                   	ret    
	...

801056c8 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
801056c8:	55                   	push   %ebp
801056c9:	89 e5                	mov    %esp,%ebp
801056cb:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801056ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
801056d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801056d5:	8b 45 08             	mov    0x8(%ebp),%eax
801056d8:	89 04 24             	mov    %eax,(%esp)
801056db:	e8 46 fe ff ff       	call   80105526 <argint>
801056e0:	85 c0                	test   %eax,%eax
801056e2:	79 07                	jns    801056eb <argfd+0x23>
    return -1;
801056e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056e9:	eb 50                	jmp    8010573b <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801056eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056ee:	85 c0                	test   %eax,%eax
801056f0:	78 21                	js     80105713 <argfd+0x4b>
801056f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801056f5:	83 f8 0f             	cmp    $0xf,%eax
801056f8:	7f 19                	jg     80105713 <argfd+0x4b>
801056fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105700:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105703:	83 c2 08             	add    $0x8,%edx
80105706:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010570a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010570d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105711:	75 07                	jne    8010571a <argfd+0x52>
    return -1;
80105713:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105718:	eb 21                	jmp    8010573b <argfd+0x73>
  if(pfd)
8010571a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010571e:	74 08                	je     80105728 <argfd+0x60>
    *pfd = fd;
80105720:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105723:	8b 45 0c             	mov    0xc(%ebp),%eax
80105726:	89 10                	mov    %edx,(%eax)
  if(pf)
80105728:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010572c:	74 08                	je     80105736 <argfd+0x6e>
    *pf = f;
8010572e:	8b 45 10             	mov    0x10(%ebp),%eax
80105731:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105734:	89 10                	mov    %edx,(%eax)
  return 0;
80105736:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010573b:	c9                   	leave  
8010573c:	c3                   	ret    

8010573d <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010573d:	55                   	push   %ebp
8010573e:	89 e5                	mov    %esp,%ebp
80105740:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105743:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010574a:	eb 30                	jmp    8010577c <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
8010574c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105752:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105755:	83 c2 08             	add    $0x8,%edx
80105758:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010575c:	85 c0                	test   %eax,%eax
8010575e:	75 18                	jne    80105778 <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105760:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105766:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105769:	8d 4a 08             	lea    0x8(%edx),%ecx
8010576c:	8b 55 08             	mov    0x8(%ebp),%edx
8010576f:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105773:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105776:	eb 0f                	jmp    80105787 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105778:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010577c:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105780:	7e ca                	jle    8010574c <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105782:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105787:	c9                   	leave  
80105788:	c3                   	ret    

80105789 <sys_dup>:

int
sys_dup(void)
{
80105789:	55                   	push   %ebp
8010578a:	89 e5                	mov    %esp,%ebp
8010578c:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
8010578f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105792:	89 44 24 08          	mov    %eax,0x8(%esp)
80105796:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010579d:	00 
8010579e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057a5:	e8 1e ff ff ff       	call   801056c8 <argfd>
801057aa:	85 c0                	test   %eax,%eax
801057ac:	79 07                	jns    801057b5 <sys_dup+0x2c>
    return -1;
801057ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057b3:	eb 29                	jmp    801057de <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
801057b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057b8:	89 04 24             	mov    %eax,(%esp)
801057bb:	e8 7d ff ff ff       	call   8010573d <fdalloc>
801057c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057c7:	79 07                	jns    801057d0 <sys_dup+0x47>
    return -1;
801057c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ce:	eb 0e                	jmp    801057de <sys_dup+0x55>
  filedup(f);
801057d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057d3:	89 04 24             	mov    %eax,(%esp)
801057d6:	e8 a1 b7 ff ff       	call   80100f7c <filedup>
  return fd;
801057db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801057de:	c9                   	leave  
801057df:	c3                   	ret    

801057e0 <sys_read>:

int
sys_read(void)
{
801057e0:	55                   	push   %ebp
801057e1:	89 e5                	mov    %esp,%ebp
801057e3:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801057e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057e9:	89 44 24 08          	mov    %eax,0x8(%esp)
801057ed:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801057f4:	00 
801057f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801057fc:	e8 c7 fe ff ff       	call   801056c8 <argfd>
80105801:	85 c0                	test   %eax,%eax
80105803:	78 35                	js     8010583a <sys_read+0x5a>
80105805:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105808:	89 44 24 04          	mov    %eax,0x4(%esp)
8010580c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105813:	e8 0e fd ff ff       	call   80105526 <argint>
80105818:	85 c0                	test   %eax,%eax
8010581a:	78 1e                	js     8010583a <sys_read+0x5a>
8010581c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010581f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105823:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105826:	89 44 24 04          	mov    %eax,0x4(%esp)
8010582a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105831:	e8 28 fd ff ff       	call   8010555e <argptr>
80105836:	85 c0                	test   %eax,%eax
80105838:	79 07                	jns    80105841 <sys_read+0x61>
    return -1;
8010583a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010583f:	eb 19                	jmp    8010585a <sys_read+0x7a>
  return fileread(f, p, n);
80105841:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105844:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105847:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010584a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010584e:	89 54 24 04          	mov    %edx,0x4(%esp)
80105852:	89 04 24             	mov    %eax,(%esp)
80105855:	e8 8f b8 ff ff       	call   801010e9 <fileread>
}
8010585a:	c9                   	leave  
8010585b:	c3                   	ret    

8010585c <sys_write>:

int
sys_write(void)
{
8010585c:	55                   	push   %ebp
8010585d:	89 e5                	mov    %esp,%ebp
8010585f:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105862:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105865:	89 44 24 08          	mov    %eax,0x8(%esp)
80105869:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105870:	00 
80105871:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105878:	e8 4b fe ff ff       	call   801056c8 <argfd>
8010587d:	85 c0                	test   %eax,%eax
8010587f:	78 35                	js     801058b6 <sys_write+0x5a>
80105881:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105884:	89 44 24 04          	mov    %eax,0x4(%esp)
80105888:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010588f:	e8 92 fc ff ff       	call   80105526 <argint>
80105894:	85 c0                	test   %eax,%eax
80105896:	78 1e                	js     801058b6 <sys_write+0x5a>
80105898:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010589b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010589f:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801058a6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801058ad:	e8 ac fc ff ff       	call   8010555e <argptr>
801058b2:	85 c0                	test   %eax,%eax
801058b4:	79 07                	jns    801058bd <sys_write+0x61>
    return -1;
801058b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058bb:	eb 19                	jmp    801058d6 <sys_write+0x7a>
  return filewrite(f, p, n);
801058bd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801058c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
801058c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058c6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801058ca:	89 54 24 04          	mov    %edx,0x4(%esp)
801058ce:	89 04 24             	mov    %eax,(%esp)
801058d1:	e8 cf b8 ff ff       	call   801011a5 <filewrite>
}
801058d6:	c9                   	leave  
801058d7:	c3                   	ret    

801058d8 <sys_close>:

int
sys_close(void)
{
801058d8:	55                   	push   %ebp
801058d9:	89 e5                	mov    %esp,%ebp
801058db:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
801058de:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058e1:	89 44 24 08          	mov    %eax,0x8(%esp)
801058e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058e8:	89 44 24 04          	mov    %eax,0x4(%esp)
801058ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801058f3:	e8 d0 fd ff ff       	call   801056c8 <argfd>
801058f8:	85 c0                	test   %eax,%eax
801058fa:	79 07                	jns    80105903 <sys_close+0x2b>
    return -1;
801058fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105901:	eb 24                	jmp    80105927 <sys_close+0x4f>
  proc->ofile[fd] = 0;
80105903:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105909:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010590c:	83 c2 08             	add    $0x8,%edx
8010590f:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105916:	00 
  fileclose(f);
80105917:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010591a:	89 04 24             	mov    %eax,(%esp)
8010591d:	e8 a2 b6 ff ff       	call   80100fc4 <fileclose>
  return 0;
80105922:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105927:	c9                   	leave  
80105928:	c3                   	ret    

80105929 <sys_fstat>:

int
sys_fstat(void)
{
80105929:	55                   	push   %ebp
8010592a:	89 e5                	mov    %esp,%ebp
8010592c:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
8010592f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105932:	89 44 24 08          	mov    %eax,0x8(%esp)
80105936:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010593d:	00 
8010593e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105945:	e8 7e fd ff ff       	call   801056c8 <argfd>
8010594a:	85 c0                	test   %eax,%eax
8010594c:	78 1f                	js     8010596d <sys_fstat+0x44>
8010594e:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105955:	00 
80105956:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105959:	89 44 24 04          	mov    %eax,0x4(%esp)
8010595d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105964:	e8 f5 fb ff ff       	call   8010555e <argptr>
80105969:	85 c0                	test   %eax,%eax
8010596b:	79 07                	jns    80105974 <sys_fstat+0x4b>
    return -1;
8010596d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105972:	eb 12                	jmp    80105986 <sys_fstat+0x5d>
  return filestat(f, st);
80105974:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105977:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010597a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010597e:	89 04 24             	mov    %eax,(%esp)
80105981:	e8 14 b7 ff ff       	call   8010109a <filestat>
}
80105986:	c9                   	leave  
80105987:	c3                   	ret    

80105988 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105988:	55                   	push   %ebp
80105989:	89 e5                	mov    %esp,%ebp
8010598b:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010598e:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105991:	89 44 24 04          	mov    %eax,0x4(%esp)
80105995:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010599c:	e8 1f fc ff ff       	call   801055c0 <argstr>
801059a1:	85 c0                	test   %eax,%eax
801059a3:	78 17                	js     801059bc <sys_link+0x34>
801059a5:	8d 45 dc             	lea    -0x24(%ebp),%eax
801059a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801059ac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801059b3:	e8 08 fc ff ff       	call   801055c0 <argstr>
801059b8:	85 c0                	test   %eax,%eax
801059ba:	79 0a                	jns    801059c6 <sys_link+0x3e>
    return -1;
801059bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059c1:	e9 3c 01 00 00       	jmp    80105b02 <sys_link+0x17a>
  if((ip = namei(old)) == 0)
801059c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
801059c9:	89 04 24             	mov    %eax,(%esp)
801059cc:	e8 39 ca ff ff       	call   8010240a <namei>
801059d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801059d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801059d8:	75 0a                	jne    801059e4 <sys_link+0x5c>
    return -1;
801059da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059df:	e9 1e 01 00 00       	jmp    80105b02 <sys_link+0x17a>

  begin_trans();
801059e4:	e8 34 d8 ff ff       	call   8010321d <begin_trans>

  ilock(ip);
801059e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059ec:	89 04 24             	mov    %eax,(%esp)
801059ef:	e8 74 be ff ff       	call   80101868 <ilock>
  if(ip->type == T_DIR){
801059f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059f7:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801059fb:	66 83 f8 01          	cmp    $0x1,%ax
801059ff:	75 1a                	jne    80105a1b <sys_link+0x93>
    iunlockput(ip);
80105a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a04:	89 04 24             	mov    %eax,(%esp)
80105a07:	e8 e0 c0 ff ff       	call   80101aec <iunlockput>
    commit_trans();
80105a0c:	e8 55 d8 ff ff       	call   80103266 <commit_trans>
    return -1;
80105a11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a16:	e9 e7 00 00 00       	jmp    80105b02 <sys_link+0x17a>
  }

  ip->nlink++;
80105a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a1e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105a22:	8d 50 01             	lea    0x1(%eax),%edx
80105a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a28:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a2f:	89 04 24             	mov    %eax,(%esp)
80105a32:	e8 75 bc ff ff       	call   801016ac <iupdate>
  iunlock(ip);
80105a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a3a:	89 04 24             	mov    %eax,(%esp)
80105a3d:	e8 74 bf ff ff       	call   801019b6 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105a42:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a45:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105a48:	89 54 24 04          	mov    %edx,0x4(%esp)
80105a4c:	89 04 24             	mov    %eax,(%esp)
80105a4f:	e8 d8 c9 ff ff       	call   8010242c <nameiparent>
80105a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105a57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105a5b:	74 68                	je     80105ac5 <sys_link+0x13d>
    goto bad;
  ilock(dp);
80105a5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a60:	89 04 24             	mov    %eax,(%esp)
80105a63:	e8 00 be ff ff       	call   80101868 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105a68:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a6b:	8b 10                	mov    (%eax),%edx
80105a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a70:	8b 00                	mov    (%eax),%eax
80105a72:	39 c2                	cmp    %eax,%edx
80105a74:	75 20                	jne    80105a96 <sys_link+0x10e>
80105a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a79:	8b 40 04             	mov    0x4(%eax),%eax
80105a7c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105a80:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105a83:	89 44 24 04          	mov    %eax,0x4(%esp)
80105a87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a8a:	89 04 24             	mov    %eax,(%esp)
80105a8d:	e8 b7 c6 ff ff       	call   80102149 <dirlink>
80105a92:	85 c0                	test   %eax,%eax
80105a94:	79 0d                	jns    80105aa3 <sys_link+0x11b>
    iunlockput(dp);
80105a96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a99:	89 04 24             	mov    %eax,(%esp)
80105a9c:	e8 4b c0 ff ff       	call   80101aec <iunlockput>
    goto bad;
80105aa1:	eb 23                	jmp    80105ac6 <sys_link+0x13e>
  }
  iunlockput(dp);
80105aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105aa6:	89 04 24             	mov    %eax,(%esp)
80105aa9:	e8 3e c0 ff ff       	call   80101aec <iunlockput>
  iput(ip);
80105aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ab1:	89 04 24             	mov    %eax,(%esp)
80105ab4:	e8 62 bf ff ff       	call   80101a1b <iput>

  commit_trans();
80105ab9:	e8 a8 d7 ff ff       	call   80103266 <commit_trans>

  return 0;
80105abe:	b8 00 00 00 00       	mov    $0x0,%eax
80105ac3:	eb 3d                	jmp    80105b02 <sys_link+0x17a>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
80105ac5:	90                   	nop
  commit_trans();

  return 0;

bad:
  ilock(ip);
80105ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac9:	89 04 24             	mov    %eax,(%esp)
80105acc:	e8 97 bd ff ff       	call   80101868 <ilock>
  ip->nlink--;
80105ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ad4:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ad8:	8d 50 ff             	lea    -0x1(%eax),%edx
80105adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ade:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ae5:	89 04 24             	mov    %eax,(%esp)
80105ae8:	e8 bf bb ff ff       	call   801016ac <iupdate>
  iunlockput(ip);
80105aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105af0:	89 04 24             	mov    %eax,(%esp)
80105af3:	e8 f4 bf ff ff       	call   80101aec <iunlockput>
  commit_trans();
80105af8:	e8 69 d7 ff ff       	call   80103266 <commit_trans>
  return -1;
80105afd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b02:	c9                   	leave  
80105b03:	c3                   	ret    

80105b04 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105b04:	55                   	push   %ebp
80105b05:	89 e5                	mov    %esp,%ebp
80105b07:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b0a:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105b11:	eb 4b                	jmp    80105b5e <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b16:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105b1d:	00 
80105b1e:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b22:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105b25:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b29:	8b 45 08             	mov    0x8(%ebp),%eax
80105b2c:	89 04 24             	mov    %eax,(%esp)
80105b2f:	e8 2a c2 ff ff       	call   80101d5e <readi>
80105b34:	83 f8 10             	cmp    $0x10,%eax
80105b37:	74 0c                	je     80105b45 <isdirempty+0x41>
      panic("isdirempty: readi");
80105b39:	c7 04 24 7b 89 10 80 	movl   $0x8010897b,(%esp)
80105b40:	e8 f8 a9 ff ff       	call   8010053d <panic>
    if(de.inum != 0)
80105b45:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105b49:	66 85 c0             	test   %ax,%ax
80105b4c:	74 07                	je     80105b55 <isdirempty+0x51>
      return 0;
80105b4e:	b8 00 00 00 00       	mov    $0x0,%eax
80105b53:	eb 1b                	jmp    80105b70 <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b58:	83 c0 10             	add    $0x10,%eax
80105b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105b5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105b61:	8b 45 08             	mov    0x8(%ebp),%eax
80105b64:	8b 40 18             	mov    0x18(%eax),%eax
80105b67:	39 c2                	cmp    %eax,%edx
80105b69:	72 a8                	jb     80105b13 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80105b6b:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105b70:	c9                   	leave  
80105b71:	c3                   	ret    

80105b72 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105b72:	55                   	push   %ebp
80105b73:	89 e5                	mov    %esp,%ebp
80105b75:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105b78:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105b86:	e8 35 fa ff ff       	call   801055c0 <argstr>
80105b8b:	85 c0                	test   %eax,%eax
80105b8d:	79 0a                	jns    80105b99 <sys_unlink+0x27>
    return -1;
80105b8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b94:	e9 aa 01 00 00       	jmp    80105d43 <sys_unlink+0x1d1>
  if((dp = nameiparent(path, name)) == 0)
80105b99:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105b9c:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105b9f:	89 54 24 04          	mov    %edx,0x4(%esp)
80105ba3:	89 04 24             	mov    %eax,(%esp)
80105ba6:	e8 81 c8 ff ff       	call   8010242c <nameiparent>
80105bab:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105bae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105bb2:	75 0a                	jne    80105bbe <sys_unlink+0x4c>
    return -1;
80105bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105bb9:	e9 85 01 00 00       	jmp    80105d43 <sys_unlink+0x1d1>

  begin_trans();
80105bbe:	e8 5a d6 ff ff       	call   8010321d <begin_trans>

  ilock(dp);
80105bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bc6:	89 04 24             	mov    %eax,(%esp)
80105bc9:	e8 9a bc ff ff       	call   80101868 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105bce:	c7 44 24 04 8d 89 10 	movl   $0x8010898d,0x4(%esp)
80105bd5:	80 
80105bd6:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105bd9:	89 04 24             	mov    %eax,(%esp)
80105bdc:	e8 7e c4 ff ff       	call   8010205f <namecmp>
80105be1:	85 c0                	test   %eax,%eax
80105be3:	0f 84 45 01 00 00    	je     80105d2e <sys_unlink+0x1bc>
80105be9:	c7 44 24 04 8f 89 10 	movl   $0x8010898f,0x4(%esp)
80105bf0:	80 
80105bf1:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105bf4:	89 04 24             	mov    %eax,(%esp)
80105bf7:	e8 63 c4 ff ff       	call   8010205f <namecmp>
80105bfc:	85 c0                	test   %eax,%eax
80105bfe:	0f 84 2a 01 00 00    	je     80105d2e <sys_unlink+0x1bc>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105c04:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105c07:	89 44 24 08          	mov    %eax,0x8(%esp)
80105c0b:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c15:	89 04 24             	mov    %eax,(%esp)
80105c18:	e8 64 c4 ff ff       	call   80102081 <dirlookup>
80105c1d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105c20:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105c24:	0f 84 03 01 00 00    	je     80105d2d <sys_unlink+0x1bb>
    goto bad;
  ilock(ip);
80105c2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c2d:	89 04 24             	mov    %eax,(%esp)
80105c30:	e8 33 bc ff ff       	call   80101868 <ilock>

  if(ip->nlink < 1)
80105c35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c38:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105c3c:	66 85 c0             	test   %ax,%ax
80105c3f:	7f 0c                	jg     80105c4d <sys_unlink+0xdb>
    panic("unlink: nlink < 1");
80105c41:	c7 04 24 92 89 10 80 	movl   $0x80108992,(%esp)
80105c48:	e8 f0 a8 ff ff       	call   8010053d <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c50:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105c54:	66 83 f8 01          	cmp    $0x1,%ax
80105c58:	75 1f                	jne    80105c79 <sys_unlink+0x107>
80105c5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c5d:	89 04 24             	mov    %eax,(%esp)
80105c60:	e8 9f fe ff ff       	call   80105b04 <isdirempty>
80105c65:	85 c0                	test   %eax,%eax
80105c67:	75 10                	jne    80105c79 <sys_unlink+0x107>
    iunlockput(ip);
80105c69:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c6c:	89 04 24             	mov    %eax,(%esp)
80105c6f:	e8 78 be ff ff       	call   80101aec <iunlockput>
    goto bad;
80105c74:	e9 b5 00 00 00       	jmp    80105d2e <sys_unlink+0x1bc>
  }

  memset(&de, 0, sizeof(de));
80105c79:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80105c80:	00 
80105c81:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105c88:	00 
80105c89:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105c8c:	89 04 24             	mov    %eax,(%esp)
80105c8f:	e8 42 f5 ff ff       	call   801051d6 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105c94:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105c97:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80105c9e:	00 
80105c9f:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ca3:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105ca6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cad:	89 04 24             	mov    %eax,(%esp)
80105cb0:	e8 14 c2 ff ff       	call   80101ec9 <writei>
80105cb5:	83 f8 10             	cmp    $0x10,%eax
80105cb8:	74 0c                	je     80105cc6 <sys_unlink+0x154>
    panic("unlink: writei");
80105cba:	c7 04 24 a4 89 10 80 	movl   $0x801089a4,(%esp)
80105cc1:	e8 77 a8 ff ff       	call   8010053d <panic>
  if(ip->type == T_DIR){
80105cc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cc9:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105ccd:	66 83 f8 01          	cmp    $0x1,%ax
80105cd1:	75 1c                	jne    80105cef <sys_unlink+0x17d>
    dp->nlink--;
80105cd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cd6:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105cda:	8d 50 ff             	lea    -0x1(%eax),%edx
80105cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce0:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce7:	89 04 24             	mov    %eax,(%esp)
80105cea:	e8 bd b9 ff ff       	call   801016ac <iupdate>
  }
  iunlockput(dp);
80105cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cf2:	89 04 24             	mov    %eax,(%esp)
80105cf5:	e8 f2 bd ff ff       	call   80101aec <iunlockput>

  ip->nlink--;
80105cfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cfd:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d01:	8d 50 ff             	lea    -0x1(%eax),%edx
80105d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d07:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d0e:	89 04 24             	mov    %eax,(%esp)
80105d11:	e8 96 b9 ff ff       	call   801016ac <iupdate>
  iunlockput(ip);
80105d16:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d19:	89 04 24             	mov    %eax,(%esp)
80105d1c:	e8 cb bd ff ff       	call   80101aec <iunlockput>

  commit_trans();
80105d21:	e8 40 d5 ff ff       	call   80103266 <commit_trans>

  return 0;
80105d26:	b8 00 00 00 00       	mov    $0x0,%eax
80105d2b:	eb 16                	jmp    80105d43 <sys_unlink+0x1d1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80105d2d:	90                   	nop
  commit_trans();

  return 0;

bad:
  iunlockput(dp);
80105d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d31:	89 04 24             	mov    %eax,(%esp)
80105d34:	e8 b3 bd ff ff       	call   80101aec <iunlockput>
  commit_trans();
80105d39:	e8 28 d5 ff ff       	call   80103266 <commit_trans>
  return -1;
80105d3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d43:	c9                   	leave  
80105d44:	c3                   	ret    

80105d45 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105d45:	55                   	push   %ebp
80105d46:	89 e5                	mov    %esp,%ebp
80105d48:	83 ec 48             	sub    $0x48,%esp
80105d4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105d4e:	8b 55 10             	mov    0x10(%ebp),%edx
80105d51:	8b 45 14             	mov    0x14(%ebp),%eax
80105d54:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105d58:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105d5c:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105d60:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d63:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d67:	8b 45 08             	mov    0x8(%ebp),%eax
80105d6a:	89 04 24             	mov    %eax,(%esp)
80105d6d:	e8 ba c6 ff ff       	call   8010242c <nameiparent>
80105d72:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105d75:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105d79:	75 0a                	jne    80105d85 <create+0x40>
    return 0;
80105d7b:	b8 00 00 00 00       	mov    $0x0,%eax
80105d80:	e9 7e 01 00 00       	jmp    80105f03 <create+0x1be>
  ilock(dp);
80105d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d88:	89 04 24             	mov    %eax,(%esp)
80105d8b:	e8 d8 ba ff ff       	call   80101868 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80105d90:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d93:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d97:	8d 45 de             	lea    -0x22(%ebp),%eax
80105d9a:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da1:	89 04 24             	mov    %eax,(%esp)
80105da4:	e8 d8 c2 ff ff       	call   80102081 <dirlookup>
80105da9:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105dac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105db0:	74 47                	je     80105df9 <create+0xb4>
    iunlockput(dp);
80105db2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105db5:	89 04 24             	mov    %eax,(%esp)
80105db8:	e8 2f bd ff ff       	call   80101aec <iunlockput>
    ilock(ip);
80105dbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dc0:	89 04 24             	mov    %eax,(%esp)
80105dc3:	e8 a0 ba ff ff       	call   80101868 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80105dc8:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105dcd:	75 15                	jne    80105de4 <create+0x9f>
80105dcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dd2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105dd6:	66 83 f8 02          	cmp    $0x2,%ax
80105dda:	75 08                	jne    80105de4 <create+0x9f>
      return ip;
80105ddc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ddf:	e9 1f 01 00 00       	jmp    80105f03 <create+0x1be>
    iunlockput(ip);
80105de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105de7:	89 04 24             	mov    %eax,(%esp)
80105dea:	e8 fd bc ff ff       	call   80101aec <iunlockput>
    return 0;
80105def:	b8 00 00 00 00       	mov    $0x0,%eax
80105df4:	e9 0a 01 00 00       	jmp    80105f03 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105df9:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e00:	8b 00                	mov    (%eax),%eax
80105e02:	89 54 24 04          	mov    %edx,0x4(%esp)
80105e06:	89 04 24             	mov    %eax,(%esp)
80105e09:	e8 c1 b7 ff ff       	call   801015cf <ialloc>
80105e0e:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e15:	75 0c                	jne    80105e23 <create+0xde>
    panic("create: ialloc");
80105e17:	c7 04 24 b3 89 10 80 	movl   $0x801089b3,(%esp)
80105e1e:	e8 1a a7 ff ff       	call   8010053d <panic>

  ilock(ip);
80105e23:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e26:	89 04 24             	mov    %eax,(%esp)
80105e29:	e8 3a ba ff ff       	call   80101868 <ilock>
  ip->major = major;
80105e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e31:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105e35:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105e39:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e3c:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105e40:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e47:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105e4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e50:	89 04 24             	mov    %eax,(%esp)
80105e53:	e8 54 b8 ff ff       	call   801016ac <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80105e58:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105e5d:	75 6a                	jne    80105ec9 <create+0x184>
    dp->nlink++;  // for ".."
80105e5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e62:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105e66:	8d 50 01             	lea    0x1(%eax),%edx
80105e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e6c:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e73:	89 04 24             	mov    %eax,(%esp)
80105e76:	e8 31 b8 ff ff       	call   801016ac <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105e7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e7e:	8b 40 04             	mov    0x4(%eax),%eax
80105e81:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e85:	c7 44 24 04 8d 89 10 	movl   $0x8010898d,0x4(%esp)
80105e8c:	80 
80105e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e90:	89 04 24             	mov    %eax,(%esp)
80105e93:	e8 b1 c2 ff ff       	call   80102149 <dirlink>
80105e98:	85 c0                	test   %eax,%eax
80105e9a:	78 21                	js     80105ebd <create+0x178>
80105e9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e9f:	8b 40 04             	mov    0x4(%eax),%eax
80105ea2:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ea6:	c7 44 24 04 8f 89 10 	movl   $0x8010898f,0x4(%esp)
80105ead:	80 
80105eae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105eb1:	89 04 24             	mov    %eax,(%esp)
80105eb4:	e8 90 c2 ff ff       	call   80102149 <dirlink>
80105eb9:	85 c0                	test   %eax,%eax
80105ebb:	79 0c                	jns    80105ec9 <create+0x184>
      panic("create dots");
80105ebd:	c7 04 24 c2 89 10 80 	movl   $0x801089c2,(%esp)
80105ec4:	e8 74 a6 ff ff       	call   8010053d <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105ec9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ecc:	8b 40 04             	mov    0x4(%eax),%eax
80105ecf:	89 44 24 08          	mov    %eax,0x8(%esp)
80105ed3:	8d 45 de             	lea    -0x22(%ebp),%eax
80105ed6:	89 44 24 04          	mov    %eax,0x4(%esp)
80105eda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105edd:	89 04 24             	mov    %eax,(%esp)
80105ee0:	e8 64 c2 ff ff       	call   80102149 <dirlink>
80105ee5:	85 c0                	test   %eax,%eax
80105ee7:	79 0c                	jns    80105ef5 <create+0x1b0>
    panic("create: dirlink");
80105ee9:	c7 04 24 ce 89 10 80 	movl   $0x801089ce,(%esp)
80105ef0:	e8 48 a6 ff ff       	call   8010053d <panic>

  iunlockput(dp);
80105ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ef8:	89 04 24             	mov    %eax,(%esp)
80105efb:	e8 ec bb ff ff       	call   80101aec <iunlockput>

  return ip;
80105f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105f03:	c9                   	leave  
80105f04:	c3                   	ret    

80105f05 <sys_open>:

int
sys_open(void)
{
80105f05:	55                   	push   %ebp
80105f06:	89 e5                	mov    %esp,%ebp
80105f08:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105f0b:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105f0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f12:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105f19:	e8 a2 f6 ff ff       	call   801055c0 <argstr>
80105f1e:	85 c0                	test   %eax,%eax
80105f20:	78 17                	js     80105f39 <sys_open+0x34>
80105f22:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105f25:	89 44 24 04          	mov    %eax,0x4(%esp)
80105f29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105f30:	e8 f1 f5 ff ff       	call   80105526 <argint>
80105f35:	85 c0                	test   %eax,%eax
80105f37:	79 0a                	jns    80105f43 <sys_open+0x3e>
    return -1;
80105f39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f3e:	e9 46 01 00 00       	jmp    80106089 <sys_open+0x184>
  if(omode & O_CREATE){
80105f43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105f46:	25 00 02 00 00       	and    $0x200,%eax
80105f4b:	85 c0                	test   %eax,%eax
80105f4d:	74 40                	je     80105f8f <sys_open+0x8a>
    begin_trans();
80105f4f:	e8 c9 d2 ff ff       	call   8010321d <begin_trans>
    ip = create(path, T_FILE, 0, 0);
80105f54:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f57:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80105f5e:	00 
80105f5f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80105f66:	00 
80105f67:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80105f6e:	00 
80105f6f:	89 04 24             	mov    %eax,(%esp)
80105f72:	e8 ce fd ff ff       	call   80105d45 <create>
80105f77:	89 45 f4             	mov    %eax,-0xc(%ebp)
    commit_trans();
80105f7a:	e8 e7 d2 ff ff       	call   80103266 <commit_trans>
    if(ip == 0)
80105f7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105f83:	75 5c                	jne    80105fe1 <sys_open+0xdc>
      return -1;
80105f85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f8a:	e9 fa 00 00 00       	jmp    80106089 <sys_open+0x184>
  } else {
    if((ip = namei(path)) == 0)
80105f8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80105f92:	89 04 24             	mov    %eax,(%esp)
80105f95:	e8 70 c4 ff ff       	call   8010240a <namei>
80105f9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105f9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105fa1:	75 0a                	jne    80105fad <sys_open+0xa8>
      return -1;
80105fa3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fa8:	e9 dc 00 00 00       	jmp    80106089 <sys_open+0x184>
    ilock(ip);
80105fad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fb0:	89 04 24             	mov    %eax,(%esp)
80105fb3:	e8 b0 b8 ff ff       	call   80101868 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fbb:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105fbf:	66 83 f8 01          	cmp    $0x1,%ax
80105fc3:	75 1c                	jne    80105fe1 <sys_open+0xdc>
80105fc5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fc8:	85 c0                	test   %eax,%eax
80105fca:	74 15                	je     80105fe1 <sys_open+0xdc>
      iunlockput(ip);
80105fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fcf:	89 04 24             	mov    %eax,(%esp)
80105fd2:	e8 15 bb ff ff       	call   80101aec <iunlockput>
      return -1;
80105fd7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105fdc:	e9 a8 00 00 00       	jmp    80106089 <sys_open+0x184>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105fe1:	e8 36 af ff ff       	call   80100f1c <filealloc>
80105fe6:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105fe9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fed:	74 14                	je     80106003 <sys_open+0xfe>
80105fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ff2:	89 04 24             	mov    %eax,(%esp)
80105ff5:	e8 43 f7 ff ff       	call   8010573d <fdalloc>
80105ffa:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105ffd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106001:	79 23                	jns    80106026 <sys_open+0x121>
    if(f)
80106003:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106007:	74 0b                	je     80106014 <sys_open+0x10f>
      fileclose(f);
80106009:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010600c:	89 04 24             	mov    %eax,(%esp)
8010600f:	e8 b0 af ff ff       	call   80100fc4 <fileclose>
    iunlockput(ip);
80106014:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106017:	89 04 24             	mov    %eax,(%esp)
8010601a:	e8 cd ba ff ff       	call   80101aec <iunlockput>
    return -1;
8010601f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106024:	eb 63                	jmp    80106089 <sys_open+0x184>
  }
  iunlock(ip);
80106026:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106029:	89 04 24             	mov    %eax,(%esp)
8010602c:	e8 85 b9 ff ff       	call   801019b6 <iunlock>

  f->type = FD_INODE;
80106031:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106034:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
8010603a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010603d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106040:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106043:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106046:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010604d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106050:	83 e0 01             	and    $0x1,%eax
80106053:	85 c0                	test   %eax,%eax
80106055:	0f 94 c2             	sete   %dl
80106058:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010605b:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010605e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106061:	83 e0 01             	and    $0x1,%eax
80106064:	84 c0                	test   %al,%al
80106066:	75 0a                	jne    80106072 <sys_open+0x16d>
80106068:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010606b:	83 e0 02             	and    $0x2,%eax
8010606e:	85 c0                	test   %eax,%eax
80106070:	74 07                	je     80106079 <sys_open+0x174>
80106072:	b8 01 00 00 00       	mov    $0x1,%eax
80106077:	eb 05                	jmp    8010607e <sys_open+0x179>
80106079:	b8 00 00 00 00       	mov    $0x0,%eax
8010607e:	89 c2                	mov    %eax,%edx
80106080:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106083:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106086:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106089:	c9                   	leave  
8010608a:	c3                   	ret    

8010608b <sys_mkdir>:

int
sys_mkdir(void)
{
8010608b:	55                   	push   %ebp
8010608c:	89 e5                	mov    %esp,%ebp
8010608e:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_trans();
80106091:	e8 87 d1 ff ff       	call   8010321d <begin_trans>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106096:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106099:	89 44 24 04          	mov    %eax,0x4(%esp)
8010609d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060a4:	e8 17 f5 ff ff       	call   801055c0 <argstr>
801060a9:	85 c0                	test   %eax,%eax
801060ab:	78 2c                	js     801060d9 <sys_mkdir+0x4e>
801060ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
801060b0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801060b7:	00 
801060b8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801060bf:	00 
801060c0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801060c7:	00 
801060c8:	89 04 24             	mov    %eax,(%esp)
801060cb:	e8 75 fc ff ff       	call   80105d45 <create>
801060d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060d7:	75 0c                	jne    801060e5 <sys_mkdir+0x5a>
    commit_trans();
801060d9:	e8 88 d1 ff ff       	call   80103266 <commit_trans>
    return -1;
801060de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060e3:	eb 15                	jmp    801060fa <sys_mkdir+0x6f>
  }
  iunlockput(ip);
801060e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e8:	89 04 24             	mov    %eax,(%esp)
801060eb:	e8 fc b9 ff ff       	call   80101aec <iunlockput>
  commit_trans();
801060f0:	e8 71 d1 ff ff       	call   80103266 <commit_trans>
  return 0;
801060f5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801060fa:	c9                   	leave  
801060fb:	c3                   	ret    

801060fc <sys_mknod>:

int
sys_mknod(void)
{
801060fc:	55                   	push   %ebp
801060fd:	89 e5                	mov    %esp,%ebp
801060ff:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
80106102:	e8 16 d1 ff ff       	call   8010321d <begin_trans>
  if((len=argstr(0, &path)) < 0 ||
80106107:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010610a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010610e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106115:	e8 a6 f4 ff ff       	call   801055c0 <argstr>
8010611a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010611d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106121:	78 5e                	js     80106181 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
80106123:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106126:	89 44 24 04          	mov    %eax,0x4(%esp)
8010612a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106131:	e8 f0 f3 ff ff       	call   80105526 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
80106136:	85 c0                	test   %eax,%eax
80106138:	78 47                	js     80106181 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
8010613a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010613d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106141:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106148:	e8 d9 f3 ff ff       	call   80105526 <argint>
  int len;
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
8010614d:	85 c0                	test   %eax,%eax
8010614f:	78 30                	js     80106181 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106151:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106154:	0f bf c8             	movswl %ax,%ecx
80106157:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010615a:	0f bf d0             	movswl %ax,%edx
8010615d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_trans();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106160:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
80106164:	89 54 24 08          	mov    %edx,0x8(%esp)
80106168:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
8010616f:	00 
80106170:	89 04 24             	mov    %eax,(%esp)
80106173:	e8 cd fb ff ff       	call   80105d45 <create>
80106178:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010617b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010617f:	75 0c                	jne    8010618d <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    commit_trans();
80106181:	e8 e0 d0 ff ff       	call   80103266 <commit_trans>
    return -1;
80106186:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010618b:	eb 15                	jmp    801061a2 <sys_mknod+0xa6>
  }
  iunlockput(ip);
8010618d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106190:	89 04 24             	mov    %eax,(%esp)
80106193:	e8 54 b9 ff ff       	call   80101aec <iunlockput>
  commit_trans();
80106198:	e8 c9 d0 ff ff       	call   80103266 <commit_trans>
  return 0;
8010619d:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061a2:	c9                   	leave  
801061a3:	c3                   	ret    

801061a4 <sys_chdir>:

int
sys_chdir(void)
{
801061a4:	55                   	push   %ebp
801061a5:	89 e5                	mov    %esp,%ebp
801061a7:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0)
801061aa:	8d 45 f0             	lea    -0x10(%ebp),%eax
801061ad:	89 44 24 04          	mov    %eax,0x4(%esp)
801061b1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801061b8:	e8 03 f4 ff ff       	call   801055c0 <argstr>
801061bd:	85 c0                	test   %eax,%eax
801061bf:	78 14                	js     801061d5 <sys_chdir+0x31>
801061c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061c4:	89 04 24             	mov    %eax,(%esp)
801061c7:	e8 3e c2 ff ff       	call   8010240a <namei>
801061cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061d3:	75 07                	jne    801061dc <sys_chdir+0x38>
    return -1;
801061d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061da:	eb 57                	jmp    80106233 <sys_chdir+0x8f>
  ilock(ip);
801061dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061df:	89 04 24             	mov    %eax,(%esp)
801061e2:	e8 81 b6 ff ff       	call   80101868 <ilock>
  if(ip->type != T_DIR){
801061e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061ea:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801061ee:	66 83 f8 01          	cmp    $0x1,%ax
801061f2:	74 12                	je     80106206 <sys_chdir+0x62>
    iunlockput(ip);
801061f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061f7:	89 04 24             	mov    %eax,(%esp)
801061fa:	e8 ed b8 ff ff       	call   80101aec <iunlockput>
    return -1;
801061ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106204:	eb 2d                	jmp    80106233 <sys_chdir+0x8f>
  }
  iunlock(ip);
80106206:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106209:	89 04 24             	mov    %eax,(%esp)
8010620c:	e8 a5 b7 ff ff       	call   801019b6 <iunlock>
  iput(proc->cwd);
80106211:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106217:	8b 40 68             	mov    0x68(%eax),%eax
8010621a:	89 04 24             	mov    %eax,(%esp)
8010621d:	e8 f9 b7 ff ff       	call   80101a1b <iput>
  proc->cwd = ip;
80106222:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106228:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010622b:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010622e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106233:	c9                   	leave  
80106234:	c3                   	ret    

80106235 <sys_exec>:

int
sys_exec(void)
{
80106235:	55                   	push   %ebp
80106236:	89 e5                	mov    %esp,%ebp
80106238:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010623e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106241:	89 44 24 04          	mov    %eax,0x4(%esp)
80106245:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010624c:	e8 6f f3 ff ff       	call   801055c0 <argstr>
80106251:	85 c0                	test   %eax,%eax
80106253:	78 1a                	js     8010626f <sys_exec+0x3a>
80106255:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010625b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010625f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106266:	e8 bb f2 ff ff       	call   80105526 <argint>
8010626b:	85 c0                	test   %eax,%eax
8010626d:	79 0a                	jns    80106279 <sys_exec+0x44>
    return -1;
8010626f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106274:	e9 e2 00 00 00       	jmp    8010635b <sys_exec+0x126>
  }
  memset(argv, 0, sizeof(argv));
80106279:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80106280:	00 
80106281:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106288:	00 
80106289:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010628f:	89 04 24             	mov    %eax,(%esp)
80106292:	e8 3f ef ff ff       	call   801051d6 <memset>
  for(i=0;; i++){
80106297:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
8010629e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062a1:	83 f8 1f             	cmp    $0x1f,%eax
801062a4:	76 0a                	jbe    801062b0 <sys_exec+0x7b>
      return -1;
801062a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062ab:	e9 ab 00 00 00       	jmp    8010635b <sys_exec+0x126>
    if(fetchint(proc, uargv+4*i, (int*)&uarg) < 0)
801062b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062b3:	c1 e0 02             	shl    $0x2,%eax
801062b6:	89 c2                	mov    %eax,%edx
801062b8:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801062be:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
801062c1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801062c7:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
801062cd:	89 54 24 08          	mov    %edx,0x8(%esp)
801062d1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801062d5:	89 04 24             	mov    %eax,(%esp)
801062d8:	e8 b7 f1 ff ff       	call   80105494 <fetchint>
801062dd:	85 c0                	test   %eax,%eax
801062df:	79 07                	jns    801062e8 <sys_exec+0xb3>
      return -1;
801062e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062e6:	eb 73                	jmp    8010635b <sys_exec+0x126>
    if(uarg == 0){
801062e8:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801062ee:	85 c0                	test   %eax,%eax
801062f0:	75 26                	jne    80106318 <sys_exec+0xe3>
      argv[i] = 0;
801062f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062f5:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801062fc:	00 00 00 00 
      break;
80106300:	90                   	nop
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106301:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106304:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010630a:	89 54 24 04          	mov    %edx,0x4(%esp)
8010630e:	89 04 24             	mov    %eax,(%esp)
80106311:	e8 e6 a7 ff ff       	call   80100afc <exec>
80106316:	eb 43                	jmp    8010635b <sys_exec+0x126>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
80106318:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010631b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80106322:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106328:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
8010632b:	8b 95 68 ff ff ff    	mov    -0x98(%ebp),%edx
80106331:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106337:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010633b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010633f:	89 04 24             	mov    %eax,(%esp)
80106342:	e8 81 f1 ff ff       	call   801054c8 <fetchstr>
80106347:	85 c0                	test   %eax,%eax
80106349:	79 07                	jns    80106352 <sys_exec+0x11d>
      return -1;
8010634b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106350:	eb 09                	jmp    8010635b <sys_exec+0x126>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106352:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(proc, uarg, &argv[i]) < 0)
      return -1;
  }
80106356:	e9 43 ff ff ff       	jmp    8010629e <sys_exec+0x69>
  return exec(path, argv);
}
8010635b:	c9                   	leave  
8010635c:	c3                   	ret    

8010635d <sys_pipe>:

int
sys_pipe(void)
{
8010635d:	55                   	push   %ebp
8010635e:	89 e5                	mov    %esp,%ebp
80106360:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106363:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
8010636a:	00 
8010636b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010636e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106372:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106379:	e8 e0 f1 ff ff       	call   8010555e <argptr>
8010637e:	85 c0                	test   %eax,%eax
80106380:	79 0a                	jns    8010638c <sys_pipe+0x2f>
    return -1;
80106382:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106387:	e9 9b 00 00 00       	jmp    80106427 <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
8010638c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010638f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106393:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106396:	89 04 24             	mov    %eax,(%esp)
80106399:	e8 9a d8 ff ff       	call   80103c38 <pipealloc>
8010639e:	85 c0                	test   %eax,%eax
801063a0:	79 07                	jns    801063a9 <sys_pipe+0x4c>
    return -1;
801063a2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063a7:	eb 7e                	jmp    80106427 <sys_pipe+0xca>
  fd0 = -1;
801063a9:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801063b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801063b3:	89 04 24             	mov    %eax,(%esp)
801063b6:	e8 82 f3 ff ff       	call   8010573d <fdalloc>
801063bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
801063be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063c2:	78 14                	js     801063d8 <sys_pipe+0x7b>
801063c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063c7:	89 04 24             	mov    %eax,(%esp)
801063ca:	e8 6e f3 ff ff       	call   8010573d <fdalloc>
801063cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
801063d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801063d6:	79 37                	jns    8010640f <sys_pipe+0xb2>
    if(fd0 >= 0)
801063d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801063dc:	78 14                	js     801063f2 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
801063de:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801063e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801063e7:	83 c2 08             	add    $0x8,%edx
801063ea:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801063f1:	00 
    fileclose(rf);
801063f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801063f5:	89 04 24             	mov    %eax,(%esp)
801063f8:	e8 c7 ab ff ff       	call   80100fc4 <fileclose>
    fileclose(wf);
801063fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106400:	89 04 24             	mov    %eax,(%esp)
80106403:	e8 bc ab ff ff       	call   80100fc4 <fileclose>
    return -1;
80106408:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010640d:	eb 18                	jmp    80106427 <sys_pipe+0xca>
  }
  fd[0] = fd0;
8010640f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106412:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106415:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106417:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010641a:	8d 50 04             	lea    0x4(%eax),%edx
8010641d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106420:	89 02                	mov    %eax,(%edx)
  return 0;
80106422:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106427:	c9                   	leave  
80106428:	c3                   	ret    
80106429:	00 00                	add    %al,(%eax)
	...

8010642c <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010642c:	55                   	push   %ebp
8010642d:	89 e5                	mov    %esp,%ebp
8010642f:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106432:	e8 be de ff ff       	call   801042f5 <fork>
}
80106437:	c9                   	leave  
80106438:	c3                   	ret    

80106439 <sys_exit>:

int
sys_exit(void)
{
80106439:	55                   	push   %ebp
8010643a:	89 e5                	mov    %esp,%ebp
8010643c:	83 ec 08             	sub    $0x8,%esp
  exit();
8010643f:	e8 14 e0 ff ff       	call   80104458 <exit>
  return 0;  // not reached
80106444:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106449:	c9                   	leave  
8010644a:	c3                   	ret    

8010644b <sys_wait>:

int
sys_wait(void)
{
8010644b:	55                   	push   %ebp
8010644c:	89 e5                	mov    %esp,%ebp
8010644e:	83 ec 08             	sub    $0x8,%esp
  return wait();
80106451:	e8 45 e1 ff ff       	call   8010459b <wait>
}
80106456:	c9                   	leave  
80106457:	c3                   	ret    

80106458 <sys_kill>:

int
sys_kill(void)
{
80106458:	55                   	push   %ebp
80106459:	89 e5                	mov    %esp,%ebp
8010645b:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
8010645e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106461:	89 44 24 04          	mov    %eax,0x4(%esp)
80106465:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010646c:	e8 b5 f0 ff ff       	call   80105526 <argint>
80106471:	85 c0                	test   %eax,%eax
80106473:	79 07                	jns    8010647c <sys_kill+0x24>
    return -1;
80106475:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010647a:	eb 0b                	jmp    80106487 <sys_kill+0x2f>
  return kill(pid);
8010647c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010647f:	89 04 24             	mov    %eax,(%esp)
80106482:	e8 79 e5 ff ff       	call   80104a00 <kill>
}
80106487:	c9                   	leave  
80106488:	c3                   	ret    

80106489 <sys_getpid>:

int
sys_getpid(void)
{
80106489:	55                   	push   %ebp
8010648a:	89 e5                	mov    %esp,%ebp
  return proc->pid;
8010648c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106492:	8b 40 10             	mov    0x10(%eax),%eax
}
80106495:	5d                   	pop    %ebp
80106496:	c3                   	ret    

80106497 <sys_sbrk>:

int
sys_sbrk(void)
{
80106497:	55                   	push   %ebp
80106498:	89 e5                	mov    %esp,%ebp
8010649a:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
8010649d:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801064a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801064ab:	e8 76 f0 ff ff       	call   80105526 <argint>
801064b0:	85 c0                	test   %eax,%eax
801064b2:	79 07                	jns    801064bb <sys_sbrk+0x24>
    return -1;
801064b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064b9:	eb 24                	jmp    801064df <sys_sbrk+0x48>
  addr = proc->sz;
801064bb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064c1:	8b 00                	mov    (%eax),%eax
801064c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
801064c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064c9:	89 04 24             	mov    %eax,(%esp)
801064cc:	e8 7f dd ff ff       	call   80104250 <growproc>
801064d1:	85 c0                	test   %eax,%eax
801064d3:	79 07                	jns    801064dc <sys_sbrk+0x45>
    return -1;
801064d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064da:	eb 03                	jmp    801064df <sys_sbrk+0x48>
  return addr;
801064dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801064df:	c9                   	leave  
801064e0:	c3                   	ret    

801064e1 <sys_sleep>:

int
sys_sleep(void)
{
801064e1:	55                   	push   %ebp
801064e2:	89 e5                	mov    %esp,%ebp
801064e4:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801064e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801064ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801064ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801064f5:	e8 2c f0 ff ff       	call   80105526 <argint>
801064fa:	85 c0                	test   %eax,%eax
801064fc:	79 07                	jns    80106505 <sys_sleep+0x24>
    return -1;
801064fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106503:	eb 6c                	jmp    80106571 <sys_sleep+0x90>
  acquire(&tickslock);
80106505:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010650c:	e8 76 ea ff ff       	call   80104f87 <acquire>
  ticks0 = ticks;
80106511:	a1 a0 2a 11 80       	mov    0x80112aa0,%eax
80106516:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106519:	eb 34                	jmp    8010654f <sys_sleep+0x6e>
    if(proc->killed){
8010651b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106521:	8b 40 24             	mov    0x24(%eax),%eax
80106524:	85 c0                	test   %eax,%eax
80106526:	74 13                	je     8010653b <sys_sleep+0x5a>
      release(&tickslock);
80106528:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010652f:	e8 b5 ea ff ff       	call   80104fe9 <release>
      return -1;
80106534:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106539:	eb 36                	jmp    80106571 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
8010653b:	c7 44 24 04 60 22 11 	movl   $0x80112260,0x4(%esp)
80106542:	80 
80106543:	c7 04 24 a0 2a 11 80 	movl   $0x80112aa0,(%esp)
8010654a:	e8 aa e3 ff ff       	call   801048f9 <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
8010654f:	a1 a0 2a 11 80       	mov    0x80112aa0,%eax
80106554:	89 c2                	mov    %eax,%edx
80106556:	2b 55 f4             	sub    -0xc(%ebp),%edx
80106559:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010655c:	39 c2                	cmp    %eax,%edx
8010655e:	72 bb                	jb     8010651b <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106560:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80106567:	e8 7d ea ff ff       	call   80104fe9 <release>
  return 0;
8010656c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106571:	c9                   	leave  
80106572:	c3                   	ret    

80106573 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106573:	55                   	push   %ebp
80106574:	89 e5                	mov    %esp,%ebp
80106576:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106579:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80106580:	e8 02 ea ff ff       	call   80104f87 <acquire>
  xticks = ticks;
80106585:	a1 a0 2a 11 80       	mov    0x80112aa0,%eax
8010658a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
8010658d:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80106594:	e8 50 ea ff ff       	call   80104fe9 <release>
  return xticks;
80106599:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010659c:	c9                   	leave  
8010659d:	c3                   	ret    
	...

801065a0 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801065a0:	55                   	push   %ebp
801065a1:	89 e5                	mov    %esp,%ebp
801065a3:	83 ec 08             	sub    $0x8,%esp
801065a6:	8b 55 08             	mov    0x8(%ebp),%edx
801065a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801065ac:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801065b0:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065b3:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801065b7:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801065bb:	ee                   	out    %al,(%dx)
}
801065bc:	c9                   	leave  
801065bd:	c3                   	ret    

801065be <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
801065be:	55                   	push   %ebp
801065bf:	89 e5                	mov    %esp,%ebp
801065c1:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
801065c4:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
801065cb:	00 
801065cc:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
801065d3:	e8 c8 ff ff ff       	call   801065a0 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
801065d8:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
801065df:	00 
801065e0:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801065e7:	e8 b4 ff ff ff       	call   801065a0 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801065ec:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
801065f3:	00 
801065f4:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
801065fb:	e8 a0 ff ff ff       	call   801065a0 <outb>
  picenable(IRQ_TIMER);
80106600:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106607:	e8 b5 d4 ff ff       	call   80103ac1 <picenable>
}
8010660c:	c9                   	leave  
8010660d:	c3                   	ret    
	...

80106610 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106610:	1e                   	push   %ds
  pushl %es
80106611:	06                   	push   %es
  pushl %fs
80106612:	0f a0                	push   %fs
  pushl %gs
80106614:	0f a8                	push   %gs
  pushal
80106616:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106617:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010661b:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010661d:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
8010661f:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106623:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106625:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106627:	54                   	push   %esp
  call trap
80106628:	e8 de 01 00 00       	call   8010680b <trap>
  addl $4, %esp
8010662d:	83 c4 04             	add    $0x4,%esp

80106630 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106630:	61                   	popa   
  popl %gs
80106631:	0f a9                	pop    %gs
  popl %fs
80106633:	0f a1                	pop    %fs
  popl %es
80106635:	07                   	pop    %es
  popl %ds
80106636:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106637:	83 c4 08             	add    $0x8,%esp
  iret
8010663a:	cf                   	iret   
	...

8010663c <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
8010663c:	55                   	push   %ebp
8010663d:	89 e5                	mov    %esp,%ebp
8010663f:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106642:	8b 45 0c             	mov    0xc(%ebp),%eax
80106645:	83 e8 01             	sub    $0x1,%eax
80106648:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010664c:	8b 45 08             	mov    0x8(%ebp),%eax
8010664f:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106653:	8b 45 08             	mov    0x8(%ebp),%eax
80106656:	c1 e8 10             	shr    $0x10,%eax
80106659:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010665d:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106660:	0f 01 18             	lidtl  (%eax)
}
80106663:	c9                   	leave  
80106664:	c3                   	ret    

80106665 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106665:	55                   	push   %ebp
80106666:	89 e5                	mov    %esp,%ebp
80106668:	53                   	push   %ebx
80106669:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010666c:	0f 20 d3             	mov    %cr2,%ebx
8010666f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  return val;
80106672:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80106675:	83 c4 10             	add    $0x10,%esp
80106678:	5b                   	pop    %ebx
80106679:	5d                   	pop    %ebp
8010667a:	c3                   	ret    

8010667b <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010667b:	55                   	push   %ebp
8010667c:	89 e5                	mov    %esp,%ebp
8010667e:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106681:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106688:	e9 c3 00 00 00       	jmp    80106750 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010668d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106690:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
80106697:	89 c2                	mov    %eax,%edx
80106699:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010669c:	66 89 14 c5 a0 22 11 	mov    %dx,-0x7feedd60(,%eax,8)
801066a3:	80 
801066a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066a7:	66 c7 04 c5 a2 22 11 	movw   $0x8,-0x7feedd5e(,%eax,8)
801066ae:	80 08 00 
801066b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066b4:	0f b6 14 c5 a4 22 11 	movzbl -0x7feedd5c(,%eax,8),%edx
801066bb:	80 
801066bc:	83 e2 e0             	and    $0xffffffe0,%edx
801066bf:	88 14 c5 a4 22 11 80 	mov    %dl,-0x7feedd5c(,%eax,8)
801066c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066c9:	0f b6 14 c5 a4 22 11 	movzbl -0x7feedd5c(,%eax,8),%edx
801066d0:	80 
801066d1:	83 e2 1f             	and    $0x1f,%edx
801066d4:	88 14 c5 a4 22 11 80 	mov    %dl,-0x7feedd5c(,%eax,8)
801066db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066de:	0f b6 14 c5 a5 22 11 	movzbl -0x7feedd5b(,%eax,8),%edx
801066e5:	80 
801066e6:	83 e2 f0             	and    $0xfffffff0,%edx
801066e9:	83 ca 0e             	or     $0xe,%edx
801066ec:	88 14 c5 a5 22 11 80 	mov    %dl,-0x7feedd5b(,%eax,8)
801066f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066f6:	0f b6 14 c5 a5 22 11 	movzbl -0x7feedd5b(,%eax,8),%edx
801066fd:	80 
801066fe:	83 e2 ef             	and    $0xffffffef,%edx
80106701:	88 14 c5 a5 22 11 80 	mov    %dl,-0x7feedd5b(,%eax,8)
80106708:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010670b:	0f b6 14 c5 a5 22 11 	movzbl -0x7feedd5b(,%eax,8),%edx
80106712:	80 
80106713:	83 e2 9f             	and    $0xffffff9f,%edx
80106716:	88 14 c5 a5 22 11 80 	mov    %dl,-0x7feedd5b(,%eax,8)
8010671d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106720:	0f b6 14 c5 a5 22 11 	movzbl -0x7feedd5b(,%eax,8),%edx
80106727:	80 
80106728:	83 ca 80             	or     $0xffffff80,%edx
8010672b:	88 14 c5 a5 22 11 80 	mov    %dl,-0x7feedd5b(,%eax,8)
80106732:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106735:	8b 04 85 98 b0 10 80 	mov    -0x7fef4f68(,%eax,4),%eax
8010673c:	c1 e8 10             	shr    $0x10,%eax
8010673f:	89 c2                	mov    %eax,%edx
80106741:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106744:	66 89 14 c5 a6 22 11 	mov    %dx,-0x7feedd5a(,%eax,8)
8010674b:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010674c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106750:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106757:	0f 8e 30 ff ff ff    	jle    8010668d <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010675d:	a1 98 b1 10 80       	mov    0x8010b198,%eax
80106762:	66 a3 a0 24 11 80    	mov    %ax,0x801124a0
80106768:	66 c7 05 a2 24 11 80 	movw   $0x8,0x801124a2
8010676f:	08 00 
80106771:	0f b6 05 a4 24 11 80 	movzbl 0x801124a4,%eax
80106778:	83 e0 e0             	and    $0xffffffe0,%eax
8010677b:	a2 a4 24 11 80       	mov    %al,0x801124a4
80106780:	0f b6 05 a4 24 11 80 	movzbl 0x801124a4,%eax
80106787:	83 e0 1f             	and    $0x1f,%eax
8010678a:	a2 a4 24 11 80       	mov    %al,0x801124a4
8010678f:	0f b6 05 a5 24 11 80 	movzbl 0x801124a5,%eax
80106796:	83 c8 0f             	or     $0xf,%eax
80106799:	a2 a5 24 11 80       	mov    %al,0x801124a5
8010679e:	0f b6 05 a5 24 11 80 	movzbl 0x801124a5,%eax
801067a5:	83 e0 ef             	and    $0xffffffef,%eax
801067a8:	a2 a5 24 11 80       	mov    %al,0x801124a5
801067ad:	0f b6 05 a5 24 11 80 	movzbl 0x801124a5,%eax
801067b4:	83 c8 60             	or     $0x60,%eax
801067b7:	a2 a5 24 11 80       	mov    %al,0x801124a5
801067bc:	0f b6 05 a5 24 11 80 	movzbl 0x801124a5,%eax
801067c3:	83 c8 80             	or     $0xffffff80,%eax
801067c6:	a2 a5 24 11 80       	mov    %al,0x801124a5
801067cb:	a1 98 b1 10 80       	mov    0x8010b198,%eax
801067d0:	c1 e8 10             	shr    $0x10,%eax
801067d3:	66 a3 a6 24 11 80    	mov    %ax,0x801124a6
  
  initlock(&tickslock, "time");
801067d9:	c7 44 24 04 e0 89 10 	movl   $0x801089e0,0x4(%esp)
801067e0:	80 
801067e1:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801067e8:	e8 79 e7 ff ff       	call   80104f66 <initlock>
}
801067ed:	c9                   	leave  
801067ee:	c3                   	ret    

801067ef <idtinit>:

void
idtinit(void)
{
801067ef:	55                   	push   %ebp
801067f0:	89 e5                	mov    %esp,%ebp
801067f2:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
801067f5:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
801067fc:	00 
801067fd:	c7 04 24 a0 22 11 80 	movl   $0x801122a0,(%esp)
80106804:	e8 33 fe ff ff       	call   8010663c <lidt>
}
80106809:	c9                   	leave  
8010680a:	c3                   	ret    

8010680b <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010680b:	55                   	push   %ebp
8010680c:	89 e5                	mov    %esp,%ebp
8010680e:	57                   	push   %edi
8010680f:	56                   	push   %esi
80106810:	53                   	push   %ebx
80106811:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106814:	8b 45 08             	mov    0x8(%ebp),%eax
80106817:	8b 40 30             	mov    0x30(%eax),%eax
8010681a:	83 f8 40             	cmp    $0x40,%eax
8010681d:	75 3e                	jne    8010685d <trap+0x52>
    if(proc->killed)
8010681f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106825:	8b 40 24             	mov    0x24(%eax),%eax
80106828:	85 c0                	test   %eax,%eax
8010682a:	74 05                	je     80106831 <trap+0x26>
      exit();
8010682c:	e8 27 dc ff ff       	call   80104458 <exit>
    proc->tf = tf;
80106831:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106837:	8b 55 08             	mov    0x8(%ebp),%edx
8010683a:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
8010683d:	e8 c1 ed ff ff       	call   80105603 <syscall>
    if(proc->killed)
80106842:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106848:	8b 40 24             	mov    0x24(%eax),%eax
8010684b:	85 c0                	test   %eax,%eax
8010684d:	0f 84 34 02 00 00    	je     80106a87 <trap+0x27c>
      exit();
80106853:	e8 00 dc ff ff       	call   80104458 <exit>
    return;
80106858:	e9 2a 02 00 00       	jmp    80106a87 <trap+0x27c>
  }

  switch(tf->trapno){
8010685d:	8b 45 08             	mov    0x8(%ebp),%eax
80106860:	8b 40 30             	mov    0x30(%eax),%eax
80106863:	83 e8 20             	sub    $0x20,%eax
80106866:	83 f8 1f             	cmp    $0x1f,%eax
80106869:	0f 87 bc 00 00 00    	ja     8010692b <trap+0x120>
8010686f:	8b 04 85 88 8a 10 80 	mov    -0x7fef7578(,%eax,4),%eax
80106876:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80106878:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010687e:	0f b6 00             	movzbl (%eax),%eax
80106881:	84 c0                	test   %al,%al
80106883:	75 31                	jne    801068b6 <trap+0xab>
      acquire(&tickslock);
80106885:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010688c:	e8 f6 e6 ff ff       	call   80104f87 <acquire>
      ticks++;
80106891:	a1 a0 2a 11 80       	mov    0x80112aa0,%eax
80106896:	83 c0 01             	add    $0x1,%eax
80106899:	a3 a0 2a 11 80       	mov    %eax,0x80112aa0
      wakeup(&ticks);
8010689e:	c7 04 24 a0 2a 11 80 	movl   $0x80112aa0,(%esp)
801068a5:	e8 2b e1 ff ff       	call   801049d5 <wakeup>
      release(&tickslock);
801068aa:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801068b1:	e8 33 e7 ff ff       	call   80104fe9 <release>
    }
    lapiceoi();
801068b6:	e8 2e c6 ff ff       	call   80102ee9 <lapiceoi>
    break;
801068bb:	e9 41 01 00 00       	jmp    80106a01 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
801068c0:	e8 2c be ff ff       	call   801026f1 <ideintr>
    lapiceoi();
801068c5:	e8 1f c6 ff ff       	call   80102ee9 <lapiceoi>
    break;
801068ca:	e9 32 01 00 00       	jmp    80106a01 <trap+0x1f6>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801068cf:	e8 f3 c3 ff ff       	call   80102cc7 <kbdintr>
    lapiceoi();
801068d4:	e8 10 c6 ff ff       	call   80102ee9 <lapiceoi>
    break;
801068d9:	e9 23 01 00 00       	jmp    80106a01 <trap+0x1f6>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801068de:	e8 a9 03 00 00       	call   80106c8c <uartintr>
    lapiceoi();
801068e3:	e8 01 c6 ff ff       	call   80102ee9 <lapiceoi>
    break;
801068e8:	e9 14 01 00 00       	jmp    80106a01 <trap+0x1f6>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpu->id, tf->cs, tf->eip);
801068ed:	8b 45 08             	mov    0x8(%ebp),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801068f0:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801068f3:	8b 45 08             	mov    0x8(%ebp),%eax
801068f6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801068fa:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801068fd:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106903:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106906:	0f b6 c0             	movzbl %al,%eax
80106909:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010690d:	89 54 24 08          	mov    %edx,0x8(%esp)
80106911:	89 44 24 04          	mov    %eax,0x4(%esp)
80106915:	c7 04 24 e8 89 10 80 	movl   $0x801089e8,(%esp)
8010691c:	e8 80 9a ff ff       	call   801003a1 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
80106921:	e8 c3 c5 ff ff       	call   80102ee9 <lapiceoi>
    break;
80106926:	e9 d6 00 00 00       	jmp    80106a01 <trap+0x1f6>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
8010692b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106931:	85 c0                	test   %eax,%eax
80106933:	74 11                	je     80106946 <trap+0x13b>
80106935:	8b 45 08             	mov    0x8(%ebp),%eax
80106938:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010693c:	0f b7 c0             	movzwl %ax,%eax
8010693f:	83 e0 03             	and    $0x3,%eax
80106942:	85 c0                	test   %eax,%eax
80106944:	75 46                	jne    8010698c <trap+0x181>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106946:	e8 1a fd ff ff       	call   80106665 <rcr2>
              tf->trapno, cpu->id, tf->eip, rcr2());
8010694b:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010694e:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80106951:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106958:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010695b:	0f b6 ca             	movzbl %dl,%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
8010695e:	8b 55 08             	mov    0x8(%ebp),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106961:	8b 52 30             	mov    0x30(%edx),%edx
80106964:	89 44 24 10          	mov    %eax,0x10(%esp)
80106968:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010696c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106970:	89 54 24 04          	mov    %edx,0x4(%esp)
80106974:	c7 04 24 0c 8a 10 80 	movl   $0x80108a0c,(%esp)
8010697b:	e8 21 9a ff ff       	call   801003a1 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80106980:	c7 04 24 3e 8a 10 80 	movl   $0x80108a3e,(%esp)
80106987:	e8 b1 9b ff ff       	call   8010053d <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010698c:	e8 d4 fc ff ff       	call   80106665 <rcr2>
80106991:	89 c2                	mov    %eax,%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106993:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106996:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80106999:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010699f:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069a2:	0f b6 f0             	movzbl %al,%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801069a5:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069a8:	8b 58 34             	mov    0x34(%eax),%ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801069ab:	8b 45 08             	mov    0x8(%ebp),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069ae:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
801069b1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069b7:	83 c0 6c             	add    $0x6c,%eax
801069ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801069bd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801069c3:	8b 40 10             	mov    0x10(%eax),%eax
801069c6:	89 54 24 1c          	mov    %edx,0x1c(%esp)
801069ca:	89 7c 24 18          	mov    %edi,0x18(%esp)
801069ce:	89 74 24 14          	mov    %esi,0x14(%esp)
801069d2:	89 5c 24 10          	mov    %ebx,0x10(%esp)
801069d6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801069da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801069dd:	89 54 24 08          	mov    %edx,0x8(%esp)
801069e1:	89 44 24 04          	mov    %eax,0x4(%esp)
801069e5:	c7 04 24 44 8a 10 80 	movl   $0x80108a44,(%esp)
801069ec:	e8 b0 99 ff ff       	call   801003a1 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
801069f1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801069f7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801069fe:	eb 01                	jmp    80106a01 <trap+0x1f6>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
80106a00:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106a01:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a07:	85 c0                	test   %eax,%eax
80106a09:	74 24                	je     80106a2f <trap+0x224>
80106a0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a11:	8b 40 24             	mov    0x24(%eax),%eax
80106a14:	85 c0                	test   %eax,%eax
80106a16:	74 17                	je     80106a2f <trap+0x224>
80106a18:	8b 45 08             	mov    0x8(%ebp),%eax
80106a1b:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106a1f:	0f b7 c0             	movzwl %ax,%eax
80106a22:	83 e0 03             	and    $0x3,%eax
80106a25:	83 f8 03             	cmp    $0x3,%eax
80106a28:	75 05                	jne    80106a2f <trap+0x224>
    exit();
80106a2a:	e8 29 da ff ff       	call   80104458 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
80106a2f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a35:	85 c0                	test   %eax,%eax
80106a37:	74 1e                	je     80106a57 <trap+0x24c>
80106a39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a3f:	8b 40 0c             	mov    0xc(%eax),%eax
80106a42:	83 f8 04             	cmp    $0x4,%eax
80106a45:	75 10                	jne    80106a57 <trap+0x24c>
80106a47:	8b 45 08             	mov    0x8(%ebp),%eax
80106a4a:	8b 40 30             	mov    0x30(%eax),%eax
80106a4d:	83 f8 20             	cmp    $0x20,%eax
80106a50:	75 05                	jne    80106a57 <trap+0x24c>
    yield();
80106a52:	e8 44 de ff ff       	call   8010489b <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80106a57:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a5d:	85 c0                	test   %eax,%eax
80106a5f:	74 27                	je     80106a88 <trap+0x27d>
80106a61:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106a67:	8b 40 24             	mov    0x24(%eax),%eax
80106a6a:	85 c0                	test   %eax,%eax
80106a6c:	74 1a                	je     80106a88 <trap+0x27d>
80106a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80106a71:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106a75:	0f b7 c0             	movzwl %ax,%eax
80106a78:	83 e0 03             	and    $0x3,%eax
80106a7b:	83 f8 03             	cmp    $0x3,%eax
80106a7e:	75 08                	jne    80106a88 <trap+0x27d>
    exit();
80106a80:	e8 d3 d9 ff ff       	call   80104458 <exit>
80106a85:	eb 01                	jmp    80106a88 <trap+0x27d>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
80106a87:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80106a88:	83 c4 3c             	add    $0x3c,%esp
80106a8b:	5b                   	pop    %ebx
80106a8c:	5e                   	pop    %esi
80106a8d:	5f                   	pop    %edi
80106a8e:	5d                   	pop    %ebp
80106a8f:	c3                   	ret    

80106a90 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80106a90:	55                   	push   %ebp
80106a91:	89 e5                	mov    %esp,%ebp
80106a93:	53                   	push   %ebx
80106a94:	83 ec 14             	sub    $0x14,%esp
80106a97:	8b 45 08             	mov    0x8(%ebp),%eax
80106a9a:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106a9e:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
80106aa2:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
80106aa6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
80106aaa:	ec                   	in     (%dx),%al
80106aab:	89 c3                	mov    %eax,%ebx
80106aad:	88 5d fb             	mov    %bl,-0x5(%ebp)
  return data;
80106ab0:	0f b6 45 fb          	movzbl -0x5(%ebp),%eax
}
80106ab4:	83 c4 14             	add    $0x14,%esp
80106ab7:	5b                   	pop    %ebx
80106ab8:	5d                   	pop    %ebp
80106ab9:	c3                   	ret    

80106aba <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106aba:	55                   	push   %ebp
80106abb:	89 e5                	mov    %esp,%ebp
80106abd:	83 ec 08             	sub    $0x8,%esp
80106ac0:	8b 55 08             	mov    0x8(%ebp),%edx
80106ac3:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ac6:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106aca:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106acd:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106ad1:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106ad5:	ee                   	out    %al,(%dx)
}
80106ad6:	c9                   	leave  
80106ad7:	c3                   	ret    

80106ad8 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106ad8:	55                   	push   %ebp
80106ad9:	89 e5                	mov    %esp,%ebp
80106adb:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106ade:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106ae5:	00 
80106ae6:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106aed:	e8 c8 ff ff ff       	call   80106aba <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106af2:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
80106af9:	00 
80106afa:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106b01:	e8 b4 ff ff ff       	call   80106aba <outb>
  outb(COM1+0, 115200/9600);
80106b06:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
80106b0d:	00 
80106b0e:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106b15:	e8 a0 ff ff ff       	call   80106aba <outb>
  outb(COM1+1, 0);
80106b1a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b21:	00 
80106b22:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106b29:	e8 8c ff ff ff       	call   80106aba <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106b2e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80106b35:	00 
80106b36:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
80106b3d:	e8 78 ff ff ff       	call   80106aba <outb>
  outb(COM1+4, 0);
80106b42:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b49:	00 
80106b4a:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80106b51:	e8 64 ff ff ff       	call   80106aba <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106b56:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80106b5d:	00 
80106b5e:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
80106b65:	e8 50 ff ff ff       	call   80106aba <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106b6a:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106b71:	e8 1a ff ff ff       	call   80106a90 <inb>
80106b76:	3c ff                	cmp    $0xff,%al
80106b78:	74 6c                	je     80106be6 <uartinit+0x10e>
    return;
  uart = 1;
80106b7a:	c7 05 4c b6 10 80 01 	movl   $0x1,0x8010b64c
80106b81:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106b84:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80106b8b:	e8 00 ff ff ff       	call   80106a90 <inb>
  inb(COM1+0);
80106b90:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106b97:	e8 f4 fe ff ff       	call   80106a90 <inb>
  picenable(IRQ_COM1);
80106b9c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106ba3:	e8 19 cf ff ff       	call   80103ac1 <picenable>
  ioapicenable(IRQ_COM1, 0);
80106ba8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106baf:	00 
80106bb0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80106bb7:	e8 ba bd ff ff       	call   80102976 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106bbc:	c7 45 f4 08 8b 10 80 	movl   $0x80108b08,-0xc(%ebp)
80106bc3:	eb 15                	jmp    80106bda <uartinit+0x102>
    uartputc(*p);
80106bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bc8:	0f b6 00             	movzbl (%eax),%eax
80106bcb:	0f be c0             	movsbl %al,%eax
80106bce:	89 04 24             	mov    %eax,(%esp)
80106bd1:	e8 13 00 00 00       	call   80106be9 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106bd6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106bdd:	0f b6 00             	movzbl (%eax),%eax
80106be0:	84 c0                	test   %al,%al
80106be2:	75 e1                	jne    80106bc5 <uartinit+0xed>
80106be4:	eb 01                	jmp    80106be7 <uartinit+0x10f>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
80106be6:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
80106be7:	c9                   	leave  
80106be8:	c3                   	ret    

80106be9 <uartputc>:

void
uartputc(int c)
{
80106be9:	55                   	push   %ebp
80106bea:	89 e5                	mov    %esp,%ebp
80106bec:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
80106bef:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106bf4:	85 c0                	test   %eax,%eax
80106bf6:	74 4d                	je     80106c45 <uartputc+0x5c>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106bf8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106bff:	eb 10                	jmp    80106c11 <uartputc+0x28>
    microdelay(10);
80106c01:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80106c08:	e8 01 c3 ff ff       	call   80102f0e <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106c0d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106c11:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106c15:	7f 16                	jg     80106c2d <uartputc+0x44>
80106c17:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106c1e:	e8 6d fe ff ff       	call   80106a90 <inb>
80106c23:	0f b6 c0             	movzbl %al,%eax
80106c26:	83 e0 20             	and    $0x20,%eax
80106c29:	85 c0                	test   %eax,%eax
80106c2b:	74 d4                	je     80106c01 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80106c2d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c30:	0f b6 c0             	movzbl %al,%eax
80106c33:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c37:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106c3e:	e8 77 fe ff ff       	call   80106aba <outb>
80106c43:	eb 01                	jmp    80106c46 <uartputc+0x5d>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80106c45:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80106c46:	c9                   	leave  
80106c47:	c3                   	ret    

80106c48 <uartgetc>:

static int
uartgetc(void)
{
80106c48:	55                   	push   %ebp
80106c49:	89 e5                	mov    %esp,%ebp
80106c4b:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80106c4e:	a1 4c b6 10 80       	mov    0x8010b64c,%eax
80106c53:	85 c0                	test   %eax,%eax
80106c55:	75 07                	jne    80106c5e <uartgetc+0x16>
    return -1;
80106c57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c5c:	eb 2c                	jmp    80106c8a <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80106c5e:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80106c65:	e8 26 fe ff ff       	call   80106a90 <inb>
80106c6a:	0f b6 c0             	movzbl %al,%eax
80106c6d:	83 e0 01             	and    $0x1,%eax
80106c70:	85 c0                	test   %eax,%eax
80106c72:	75 07                	jne    80106c7b <uartgetc+0x33>
    return -1;
80106c74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c79:	eb 0f                	jmp    80106c8a <uartgetc+0x42>
  return inb(COM1+0);
80106c7b:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80106c82:	e8 09 fe ff ff       	call   80106a90 <inb>
80106c87:	0f b6 c0             	movzbl %al,%eax
}
80106c8a:	c9                   	leave  
80106c8b:	c3                   	ret    

80106c8c <uartintr>:

void
uartintr(void)
{
80106c8c:	55                   	push   %ebp
80106c8d:	89 e5                	mov    %esp,%ebp
80106c8f:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80106c92:	c7 04 24 48 6c 10 80 	movl   $0x80106c48,(%esp)
80106c99:	e8 0f 9b ff ff       	call   801007ad <consoleintr>
}
80106c9e:	c9                   	leave  
80106c9f:	c3                   	ret    

80106ca0 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106ca0:	6a 00                	push   $0x0
  pushl $0
80106ca2:	6a 00                	push   $0x0
  jmp alltraps
80106ca4:	e9 67 f9 ff ff       	jmp    80106610 <alltraps>

80106ca9 <vector1>:
.globl vector1
vector1:
  pushl $0
80106ca9:	6a 00                	push   $0x0
  pushl $1
80106cab:	6a 01                	push   $0x1
  jmp alltraps
80106cad:	e9 5e f9 ff ff       	jmp    80106610 <alltraps>

80106cb2 <vector2>:
.globl vector2
vector2:
  pushl $0
80106cb2:	6a 00                	push   $0x0
  pushl $2
80106cb4:	6a 02                	push   $0x2
  jmp alltraps
80106cb6:	e9 55 f9 ff ff       	jmp    80106610 <alltraps>

80106cbb <vector3>:
.globl vector3
vector3:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $3
80106cbd:	6a 03                	push   $0x3
  jmp alltraps
80106cbf:	e9 4c f9 ff ff       	jmp    80106610 <alltraps>

80106cc4 <vector4>:
.globl vector4
vector4:
  pushl $0
80106cc4:	6a 00                	push   $0x0
  pushl $4
80106cc6:	6a 04                	push   $0x4
  jmp alltraps
80106cc8:	e9 43 f9 ff ff       	jmp    80106610 <alltraps>

80106ccd <vector5>:
.globl vector5
vector5:
  pushl $0
80106ccd:	6a 00                	push   $0x0
  pushl $5
80106ccf:	6a 05                	push   $0x5
  jmp alltraps
80106cd1:	e9 3a f9 ff ff       	jmp    80106610 <alltraps>

80106cd6 <vector6>:
.globl vector6
vector6:
  pushl $0
80106cd6:	6a 00                	push   $0x0
  pushl $6
80106cd8:	6a 06                	push   $0x6
  jmp alltraps
80106cda:	e9 31 f9 ff ff       	jmp    80106610 <alltraps>

80106cdf <vector7>:
.globl vector7
vector7:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $7
80106ce1:	6a 07                	push   $0x7
  jmp alltraps
80106ce3:	e9 28 f9 ff ff       	jmp    80106610 <alltraps>

80106ce8 <vector8>:
.globl vector8
vector8:
  pushl $8
80106ce8:	6a 08                	push   $0x8
  jmp alltraps
80106cea:	e9 21 f9 ff ff       	jmp    80106610 <alltraps>

80106cef <vector9>:
.globl vector9
vector9:
  pushl $0
80106cef:	6a 00                	push   $0x0
  pushl $9
80106cf1:	6a 09                	push   $0x9
  jmp alltraps
80106cf3:	e9 18 f9 ff ff       	jmp    80106610 <alltraps>

80106cf8 <vector10>:
.globl vector10
vector10:
  pushl $10
80106cf8:	6a 0a                	push   $0xa
  jmp alltraps
80106cfa:	e9 11 f9 ff ff       	jmp    80106610 <alltraps>

80106cff <vector11>:
.globl vector11
vector11:
  pushl $11
80106cff:	6a 0b                	push   $0xb
  jmp alltraps
80106d01:	e9 0a f9 ff ff       	jmp    80106610 <alltraps>

80106d06 <vector12>:
.globl vector12
vector12:
  pushl $12
80106d06:	6a 0c                	push   $0xc
  jmp alltraps
80106d08:	e9 03 f9 ff ff       	jmp    80106610 <alltraps>

80106d0d <vector13>:
.globl vector13
vector13:
  pushl $13
80106d0d:	6a 0d                	push   $0xd
  jmp alltraps
80106d0f:	e9 fc f8 ff ff       	jmp    80106610 <alltraps>

80106d14 <vector14>:
.globl vector14
vector14:
  pushl $14
80106d14:	6a 0e                	push   $0xe
  jmp alltraps
80106d16:	e9 f5 f8 ff ff       	jmp    80106610 <alltraps>

80106d1b <vector15>:
.globl vector15
vector15:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $15
80106d1d:	6a 0f                	push   $0xf
  jmp alltraps
80106d1f:	e9 ec f8 ff ff       	jmp    80106610 <alltraps>

80106d24 <vector16>:
.globl vector16
vector16:
  pushl $0
80106d24:	6a 00                	push   $0x0
  pushl $16
80106d26:	6a 10                	push   $0x10
  jmp alltraps
80106d28:	e9 e3 f8 ff ff       	jmp    80106610 <alltraps>

80106d2d <vector17>:
.globl vector17
vector17:
  pushl $17
80106d2d:	6a 11                	push   $0x11
  jmp alltraps
80106d2f:	e9 dc f8 ff ff       	jmp    80106610 <alltraps>

80106d34 <vector18>:
.globl vector18
vector18:
  pushl $0
80106d34:	6a 00                	push   $0x0
  pushl $18
80106d36:	6a 12                	push   $0x12
  jmp alltraps
80106d38:	e9 d3 f8 ff ff       	jmp    80106610 <alltraps>

80106d3d <vector19>:
.globl vector19
vector19:
  pushl $0
80106d3d:	6a 00                	push   $0x0
  pushl $19
80106d3f:	6a 13                	push   $0x13
  jmp alltraps
80106d41:	e9 ca f8 ff ff       	jmp    80106610 <alltraps>

80106d46 <vector20>:
.globl vector20
vector20:
  pushl $0
80106d46:	6a 00                	push   $0x0
  pushl $20
80106d48:	6a 14                	push   $0x14
  jmp alltraps
80106d4a:	e9 c1 f8 ff ff       	jmp    80106610 <alltraps>

80106d4f <vector21>:
.globl vector21
vector21:
  pushl $0
80106d4f:	6a 00                	push   $0x0
  pushl $21
80106d51:	6a 15                	push   $0x15
  jmp alltraps
80106d53:	e9 b8 f8 ff ff       	jmp    80106610 <alltraps>

80106d58 <vector22>:
.globl vector22
vector22:
  pushl $0
80106d58:	6a 00                	push   $0x0
  pushl $22
80106d5a:	6a 16                	push   $0x16
  jmp alltraps
80106d5c:	e9 af f8 ff ff       	jmp    80106610 <alltraps>

80106d61 <vector23>:
.globl vector23
vector23:
  pushl $0
80106d61:	6a 00                	push   $0x0
  pushl $23
80106d63:	6a 17                	push   $0x17
  jmp alltraps
80106d65:	e9 a6 f8 ff ff       	jmp    80106610 <alltraps>

80106d6a <vector24>:
.globl vector24
vector24:
  pushl $0
80106d6a:	6a 00                	push   $0x0
  pushl $24
80106d6c:	6a 18                	push   $0x18
  jmp alltraps
80106d6e:	e9 9d f8 ff ff       	jmp    80106610 <alltraps>

80106d73 <vector25>:
.globl vector25
vector25:
  pushl $0
80106d73:	6a 00                	push   $0x0
  pushl $25
80106d75:	6a 19                	push   $0x19
  jmp alltraps
80106d77:	e9 94 f8 ff ff       	jmp    80106610 <alltraps>

80106d7c <vector26>:
.globl vector26
vector26:
  pushl $0
80106d7c:	6a 00                	push   $0x0
  pushl $26
80106d7e:	6a 1a                	push   $0x1a
  jmp alltraps
80106d80:	e9 8b f8 ff ff       	jmp    80106610 <alltraps>

80106d85 <vector27>:
.globl vector27
vector27:
  pushl $0
80106d85:	6a 00                	push   $0x0
  pushl $27
80106d87:	6a 1b                	push   $0x1b
  jmp alltraps
80106d89:	e9 82 f8 ff ff       	jmp    80106610 <alltraps>

80106d8e <vector28>:
.globl vector28
vector28:
  pushl $0
80106d8e:	6a 00                	push   $0x0
  pushl $28
80106d90:	6a 1c                	push   $0x1c
  jmp alltraps
80106d92:	e9 79 f8 ff ff       	jmp    80106610 <alltraps>

80106d97 <vector29>:
.globl vector29
vector29:
  pushl $0
80106d97:	6a 00                	push   $0x0
  pushl $29
80106d99:	6a 1d                	push   $0x1d
  jmp alltraps
80106d9b:	e9 70 f8 ff ff       	jmp    80106610 <alltraps>

80106da0 <vector30>:
.globl vector30
vector30:
  pushl $0
80106da0:	6a 00                	push   $0x0
  pushl $30
80106da2:	6a 1e                	push   $0x1e
  jmp alltraps
80106da4:	e9 67 f8 ff ff       	jmp    80106610 <alltraps>

80106da9 <vector31>:
.globl vector31
vector31:
  pushl $0
80106da9:	6a 00                	push   $0x0
  pushl $31
80106dab:	6a 1f                	push   $0x1f
  jmp alltraps
80106dad:	e9 5e f8 ff ff       	jmp    80106610 <alltraps>

80106db2 <vector32>:
.globl vector32
vector32:
  pushl $0
80106db2:	6a 00                	push   $0x0
  pushl $32
80106db4:	6a 20                	push   $0x20
  jmp alltraps
80106db6:	e9 55 f8 ff ff       	jmp    80106610 <alltraps>

80106dbb <vector33>:
.globl vector33
vector33:
  pushl $0
80106dbb:	6a 00                	push   $0x0
  pushl $33
80106dbd:	6a 21                	push   $0x21
  jmp alltraps
80106dbf:	e9 4c f8 ff ff       	jmp    80106610 <alltraps>

80106dc4 <vector34>:
.globl vector34
vector34:
  pushl $0
80106dc4:	6a 00                	push   $0x0
  pushl $34
80106dc6:	6a 22                	push   $0x22
  jmp alltraps
80106dc8:	e9 43 f8 ff ff       	jmp    80106610 <alltraps>

80106dcd <vector35>:
.globl vector35
vector35:
  pushl $0
80106dcd:	6a 00                	push   $0x0
  pushl $35
80106dcf:	6a 23                	push   $0x23
  jmp alltraps
80106dd1:	e9 3a f8 ff ff       	jmp    80106610 <alltraps>

80106dd6 <vector36>:
.globl vector36
vector36:
  pushl $0
80106dd6:	6a 00                	push   $0x0
  pushl $36
80106dd8:	6a 24                	push   $0x24
  jmp alltraps
80106dda:	e9 31 f8 ff ff       	jmp    80106610 <alltraps>

80106ddf <vector37>:
.globl vector37
vector37:
  pushl $0
80106ddf:	6a 00                	push   $0x0
  pushl $37
80106de1:	6a 25                	push   $0x25
  jmp alltraps
80106de3:	e9 28 f8 ff ff       	jmp    80106610 <alltraps>

80106de8 <vector38>:
.globl vector38
vector38:
  pushl $0
80106de8:	6a 00                	push   $0x0
  pushl $38
80106dea:	6a 26                	push   $0x26
  jmp alltraps
80106dec:	e9 1f f8 ff ff       	jmp    80106610 <alltraps>

80106df1 <vector39>:
.globl vector39
vector39:
  pushl $0
80106df1:	6a 00                	push   $0x0
  pushl $39
80106df3:	6a 27                	push   $0x27
  jmp alltraps
80106df5:	e9 16 f8 ff ff       	jmp    80106610 <alltraps>

80106dfa <vector40>:
.globl vector40
vector40:
  pushl $0
80106dfa:	6a 00                	push   $0x0
  pushl $40
80106dfc:	6a 28                	push   $0x28
  jmp alltraps
80106dfe:	e9 0d f8 ff ff       	jmp    80106610 <alltraps>

80106e03 <vector41>:
.globl vector41
vector41:
  pushl $0
80106e03:	6a 00                	push   $0x0
  pushl $41
80106e05:	6a 29                	push   $0x29
  jmp alltraps
80106e07:	e9 04 f8 ff ff       	jmp    80106610 <alltraps>

80106e0c <vector42>:
.globl vector42
vector42:
  pushl $0
80106e0c:	6a 00                	push   $0x0
  pushl $42
80106e0e:	6a 2a                	push   $0x2a
  jmp alltraps
80106e10:	e9 fb f7 ff ff       	jmp    80106610 <alltraps>

80106e15 <vector43>:
.globl vector43
vector43:
  pushl $0
80106e15:	6a 00                	push   $0x0
  pushl $43
80106e17:	6a 2b                	push   $0x2b
  jmp alltraps
80106e19:	e9 f2 f7 ff ff       	jmp    80106610 <alltraps>

80106e1e <vector44>:
.globl vector44
vector44:
  pushl $0
80106e1e:	6a 00                	push   $0x0
  pushl $44
80106e20:	6a 2c                	push   $0x2c
  jmp alltraps
80106e22:	e9 e9 f7 ff ff       	jmp    80106610 <alltraps>

80106e27 <vector45>:
.globl vector45
vector45:
  pushl $0
80106e27:	6a 00                	push   $0x0
  pushl $45
80106e29:	6a 2d                	push   $0x2d
  jmp alltraps
80106e2b:	e9 e0 f7 ff ff       	jmp    80106610 <alltraps>

80106e30 <vector46>:
.globl vector46
vector46:
  pushl $0
80106e30:	6a 00                	push   $0x0
  pushl $46
80106e32:	6a 2e                	push   $0x2e
  jmp alltraps
80106e34:	e9 d7 f7 ff ff       	jmp    80106610 <alltraps>

80106e39 <vector47>:
.globl vector47
vector47:
  pushl $0
80106e39:	6a 00                	push   $0x0
  pushl $47
80106e3b:	6a 2f                	push   $0x2f
  jmp alltraps
80106e3d:	e9 ce f7 ff ff       	jmp    80106610 <alltraps>

80106e42 <vector48>:
.globl vector48
vector48:
  pushl $0
80106e42:	6a 00                	push   $0x0
  pushl $48
80106e44:	6a 30                	push   $0x30
  jmp alltraps
80106e46:	e9 c5 f7 ff ff       	jmp    80106610 <alltraps>

80106e4b <vector49>:
.globl vector49
vector49:
  pushl $0
80106e4b:	6a 00                	push   $0x0
  pushl $49
80106e4d:	6a 31                	push   $0x31
  jmp alltraps
80106e4f:	e9 bc f7 ff ff       	jmp    80106610 <alltraps>

80106e54 <vector50>:
.globl vector50
vector50:
  pushl $0
80106e54:	6a 00                	push   $0x0
  pushl $50
80106e56:	6a 32                	push   $0x32
  jmp alltraps
80106e58:	e9 b3 f7 ff ff       	jmp    80106610 <alltraps>

80106e5d <vector51>:
.globl vector51
vector51:
  pushl $0
80106e5d:	6a 00                	push   $0x0
  pushl $51
80106e5f:	6a 33                	push   $0x33
  jmp alltraps
80106e61:	e9 aa f7 ff ff       	jmp    80106610 <alltraps>

80106e66 <vector52>:
.globl vector52
vector52:
  pushl $0
80106e66:	6a 00                	push   $0x0
  pushl $52
80106e68:	6a 34                	push   $0x34
  jmp alltraps
80106e6a:	e9 a1 f7 ff ff       	jmp    80106610 <alltraps>

80106e6f <vector53>:
.globl vector53
vector53:
  pushl $0
80106e6f:	6a 00                	push   $0x0
  pushl $53
80106e71:	6a 35                	push   $0x35
  jmp alltraps
80106e73:	e9 98 f7 ff ff       	jmp    80106610 <alltraps>

80106e78 <vector54>:
.globl vector54
vector54:
  pushl $0
80106e78:	6a 00                	push   $0x0
  pushl $54
80106e7a:	6a 36                	push   $0x36
  jmp alltraps
80106e7c:	e9 8f f7 ff ff       	jmp    80106610 <alltraps>

80106e81 <vector55>:
.globl vector55
vector55:
  pushl $0
80106e81:	6a 00                	push   $0x0
  pushl $55
80106e83:	6a 37                	push   $0x37
  jmp alltraps
80106e85:	e9 86 f7 ff ff       	jmp    80106610 <alltraps>

80106e8a <vector56>:
.globl vector56
vector56:
  pushl $0
80106e8a:	6a 00                	push   $0x0
  pushl $56
80106e8c:	6a 38                	push   $0x38
  jmp alltraps
80106e8e:	e9 7d f7 ff ff       	jmp    80106610 <alltraps>

80106e93 <vector57>:
.globl vector57
vector57:
  pushl $0
80106e93:	6a 00                	push   $0x0
  pushl $57
80106e95:	6a 39                	push   $0x39
  jmp alltraps
80106e97:	e9 74 f7 ff ff       	jmp    80106610 <alltraps>

80106e9c <vector58>:
.globl vector58
vector58:
  pushl $0
80106e9c:	6a 00                	push   $0x0
  pushl $58
80106e9e:	6a 3a                	push   $0x3a
  jmp alltraps
80106ea0:	e9 6b f7 ff ff       	jmp    80106610 <alltraps>

80106ea5 <vector59>:
.globl vector59
vector59:
  pushl $0
80106ea5:	6a 00                	push   $0x0
  pushl $59
80106ea7:	6a 3b                	push   $0x3b
  jmp alltraps
80106ea9:	e9 62 f7 ff ff       	jmp    80106610 <alltraps>

80106eae <vector60>:
.globl vector60
vector60:
  pushl $0
80106eae:	6a 00                	push   $0x0
  pushl $60
80106eb0:	6a 3c                	push   $0x3c
  jmp alltraps
80106eb2:	e9 59 f7 ff ff       	jmp    80106610 <alltraps>

80106eb7 <vector61>:
.globl vector61
vector61:
  pushl $0
80106eb7:	6a 00                	push   $0x0
  pushl $61
80106eb9:	6a 3d                	push   $0x3d
  jmp alltraps
80106ebb:	e9 50 f7 ff ff       	jmp    80106610 <alltraps>

80106ec0 <vector62>:
.globl vector62
vector62:
  pushl $0
80106ec0:	6a 00                	push   $0x0
  pushl $62
80106ec2:	6a 3e                	push   $0x3e
  jmp alltraps
80106ec4:	e9 47 f7 ff ff       	jmp    80106610 <alltraps>

80106ec9 <vector63>:
.globl vector63
vector63:
  pushl $0
80106ec9:	6a 00                	push   $0x0
  pushl $63
80106ecb:	6a 3f                	push   $0x3f
  jmp alltraps
80106ecd:	e9 3e f7 ff ff       	jmp    80106610 <alltraps>

80106ed2 <vector64>:
.globl vector64
vector64:
  pushl $0
80106ed2:	6a 00                	push   $0x0
  pushl $64
80106ed4:	6a 40                	push   $0x40
  jmp alltraps
80106ed6:	e9 35 f7 ff ff       	jmp    80106610 <alltraps>

80106edb <vector65>:
.globl vector65
vector65:
  pushl $0
80106edb:	6a 00                	push   $0x0
  pushl $65
80106edd:	6a 41                	push   $0x41
  jmp alltraps
80106edf:	e9 2c f7 ff ff       	jmp    80106610 <alltraps>

80106ee4 <vector66>:
.globl vector66
vector66:
  pushl $0
80106ee4:	6a 00                	push   $0x0
  pushl $66
80106ee6:	6a 42                	push   $0x42
  jmp alltraps
80106ee8:	e9 23 f7 ff ff       	jmp    80106610 <alltraps>

80106eed <vector67>:
.globl vector67
vector67:
  pushl $0
80106eed:	6a 00                	push   $0x0
  pushl $67
80106eef:	6a 43                	push   $0x43
  jmp alltraps
80106ef1:	e9 1a f7 ff ff       	jmp    80106610 <alltraps>

80106ef6 <vector68>:
.globl vector68
vector68:
  pushl $0
80106ef6:	6a 00                	push   $0x0
  pushl $68
80106ef8:	6a 44                	push   $0x44
  jmp alltraps
80106efa:	e9 11 f7 ff ff       	jmp    80106610 <alltraps>

80106eff <vector69>:
.globl vector69
vector69:
  pushl $0
80106eff:	6a 00                	push   $0x0
  pushl $69
80106f01:	6a 45                	push   $0x45
  jmp alltraps
80106f03:	e9 08 f7 ff ff       	jmp    80106610 <alltraps>

80106f08 <vector70>:
.globl vector70
vector70:
  pushl $0
80106f08:	6a 00                	push   $0x0
  pushl $70
80106f0a:	6a 46                	push   $0x46
  jmp alltraps
80106f0c:	e9 ff f6 ff ff       	jmp    80106610 <alltraps>

80106f11 <vector71>:
.globl vector71
vector71:
  pushl $0
80106f11:	6a 00                	push   $0x0
  pushl $71
80106f13:	6a 47                	push   $0x47
  jmp alltraps
80106f15:	e9 f6 f6 ff ff       	jmp    80106610 <alltraps>

80106f1a <vector72>:
.globl vector72
vector72:
  pushl $0
80106f1a:	6a 00                	push   $0x0
  pushl $72
80106f1c:	6a 48                	push   $0x48
  jmp alltraps
80106f1e:	e9 ed f6 ff ff       	jmp    80106610 <alltraps>

80106f23 <vector73>:
.globl vector73
vector73:
  pushl $0
80106f23:	6a 00                	push   $0x0
  pushl $73
80106f25:	6a 49                	push   $0x49
  jmp alltraps
80106f27:	e9 e4 f6 ff ff       	jmp    80106610 <alltraps>

80106f2c <vector74>:
.globl vector74
vector74:
  pushl $0
80106f2c:	6a 00                	push   $0x0
  pushl $74
80106f2e:	6a 4a                	push   $0x4a
  jmp alltraps
80106f30:	e9 db f6 ff ff       	jmp    80106610 <alltraps>

80106f35 <vector75>:
.globl vector75
vector75:
  pushl $0
80106f35:	6a 00                	push   $0x0
  pushl $75
80106f37:	6a 4b                	push   $0x4b
  jmp alltraps
80106f39:	e9 d2 f6 ff ff       	jmp    80106610 <alltraps>

80106f3e <vector76>:
.globl vector76
vector76:
  pushl $0
80106f3e:	6a 00                	push   $0x0
  pushl $76
80106f40:	6a 4c                	push   $0x4c
  jmp alltraps
80106f42:	e9 c9 f6 ff ff       	jmp    80106610 <alltraps>

80106f47 <vector77>:
.globl vector77
vector77:
  pushl $0
80106f47:	6a 00                	push   $0x0
  pushl $77
80106f49:	6a 4d                	push   $0x4d
  jmp alltraps
80106f4b:	e9 c0 f6 ff ff       	jmp    80106610 <alltraps>

80106f50 <vector78>:
.globl vector78
vector78:
  pushl $0
80106f50:	6a 00                	push   $0x0
  pushl $78
80106f52:	6a 4e                	push   $0x4e
  jmp alltraps
80106f54:	e9 b7 f6 ff ff       	jmp    80106610 <alltraps>

80106f59 <vector79>:
.globl vector79
vector79:
  pushl $0
80106f59:	6a 00                	push   $0x0
  pushl $79
80106f5b:	6a 4f                	push   $0x4f
  jmp alltraps
80106f5d:	e9 ae f6 ff ff       	jmp    80106610 <alltraps>

80106f62 <vector80>:
.globl vector80
vector80:
  pushl $0
80106f62:	6a 00                	push   $0x0
  pushl $80
80106f64:	6a 50                	push   $0x50
  jmp alltraps
80106f66:	e9 a5 f6 ff ff       	jmp    80106610 <alltraps>

80106f6b <vector81>:
.globl vector81
vector81:
  pushl $0
80106f6b:	6a 00                	push   $0x0
  pushl $81
80106f6d:	6a 51                	push   $0x51
  jmp alltraps
80106f6f:	e9 9c f6 ff ff       	jmp    80106610 <alltraps>

80106f74 <vector82>:
.globl vector82
vector82:
  pushl $0
80106f74:	6a 00                	push   $0x0
  pushl $82
80106f76:	6a 52                	push   $0x52
  jmp alltraps
80106f78:	e9 93 f6 ff ff       	jmp    80106610 <alltraps>

80106f7d <vector83>:
.globl vector83
vector83:
  pushl $0
80106f7d:	6a 00                	push   $0x0
  pushl $83
80106f7f:	6a 53                	push   $0x53
  jmp alltraps
80106f81:	e9 8a f6 ff ff       	jmp    80106610 <alltraps>

80106f86 <vector84>:
.globl vector84
vector84:
  pushl $0
80106f86:	6a 00                	push   $0x0
  pushl $84
80106f88:	6a 54                	push   $0x54
  jmp alltraps
80106f8a:	e9 81 f6 ff ff       	jmp    80106610 <alltraps>

80106f8f <vector85>:
.globl vector85
vector85:
  pushl $0
80106f8f:	6a 00                	push   $0x0
  pushl $85
80106f91:	6a 55                	push   $0x55
  jmp alltraps
80106f93:	e9 78 f6 ff ff       	jmp    80106610 <alltraps>

80106f98 <vector86>:
.globl vector86
vector86:
  pushl $0
80106f98:	6a 00                	push   $0x0
  pushl $86
80106f9a:	6a 56                	push   $0x56
  jmp alltraps
80106f9c:	e9 6f f6 ff ff       	jmp    80106610 <alltraps>

80106fa1 <vector87>:
.globl vector87
vector87:
  pushl $0
80106fa1:	6a 00                	push   $0x0
  pushl $87
80106fa3:	6a 57                	push   $0x57
  jmp alltraps
80106fa5:	e9 66 f6 ff ff       	jmp    80106610 <alltraps>

80106faa <vector88>:
.globl vector88
vector88:
  pushl $0
80106faa:	6a 00                	push   $0x0
  pushl $88
80106fac:	6a 58                	push   $0x58
  jmp alltraps
80106fae:	e9 5d f6 ff ff       	jmp    80106610 <alltraps>

80106fb3 <vector89>:
.globl vector89
vector89:
  pushl $0
80106fb3:	6a 00                	push   $0x0
  pushl $89
80106fb5:	6a 59                	push   $0x59
  jmp alltraps
80106fb7:	e9 54 f6 ff ff       	jmp    80106610 <alltraps>

80106fbc <vector90>:
.globl vector90
vector90:
  pushl $0
80106fbc:	6a 00                	push   $0x0
  pushl $90
80106fbe:	6a 5a                	push   $0x5a
  jmp alltraps
80106fc0:	e9 4b f6 ff ff       	jmp    80106610 <alltraps>

80106fc5 <vector91>:
.globl vector91
vector91:
  pushl $0
80106fc5:	6a 00                	push   $0x0
  pushl $91
80106fc7:	6a 5b                	push   $0x5b
  jmp alltraps
80106fc9:	e9 42 f6 ff ff       	jmp    80106610 <alltraps>

80106fce <vector92>:
.globl vector92
vector92:
  pushl $0
80106fce:	6a 00                	push   $0x0
  pushl $92
80106fd0:	6a 5c                	push   $0x5c
  jmp alltraps
80106fd2:	e9 39 f6 ff ff       	jmp    80106610 <alltraps>

80106fd7 <vector93>:
.globl vector93
vector93:
  pushl $0
80106fd7:	6a 00                	push   $0x0
  pushl $93
80106fd9:	6a 5d                	push   $0x5d
  jmp alltraps
80106fdb:	e9 30 f6 ff ff       	jmp    80106610 <alltraps>

80106fe0 <vector94>:
.globl vector94
vector94:
  pushl $0
80106fe0:	6a 00                	push   $0x0
  pushl $94
80106fe2:	6a 5e                	push   $0x5e
  jmp alltraps
80106fe4:	e9 27 f6 ff ff       	jmp    80106610 <alltraps>

80106fe9 <vector95>:
.globl vector95
vector95:
  pushl $0
80106fe9:	6a 00                	push   $0x0
  pushl $95
80106feb:	6a 5f                	push   $0x5f
  jmp alltraps
80106fed:	e9 1e f6 ff ff       	jmp    80106610 <alltraps>

80106ff2 <vector96>:
.globl vector96
vector96:
  pushl $0
80106ff2:	6a 00                	push   $0x0
  pushl $96
80106ff4:	6a 60                	push   $0x60
  jmp alltraps
80106ff6:	e9 15 f6 ff ff       	jmp    80106610 <alltraps>

80106ffb <vector97>:
.globl vector97
vector97:
  pushl $0
80106ffb:	6a 00                	push   $0x0
  pushl $97
80106ffd:	6a 61                	push   $0x61
  jmp alltraps
80106fff:	e9 0c f6 ff ff       	jmp    80106610 <alltraps>

80107004 <vector98>:
.globl vector98
vector98:
  pushl $0
80107004:	6a 00                	push   $0x0
  pushl $98
80107006:	6a 62                	push   $0x62
  jmp alltraps
80107008:	e9 03 f6 ff ff       	jmp    80106610 <alltraps>

8010700d <vector99>:
.globl vector99
vector99:
  pushl $0
8010700d:	6a 00                	push   $0x0
  pushl $99
8010700f:	6a 63                	push   $0x63
  jmp alltraps
80107011:	e9 fa f5 ff ff       	jmp    80106610 <alltraps>

80107016 <vector100>:
.globl vector100
vector100:
  pushl $0
80107016:	6a 00                	push   $0x0
  pushl $100
80107018:	6a 64                	push   $0x64
  jmp alltraps
8010701a:	e9 f1 f5 ff ff       	jmp    80106610 <alltraps>

8010701f <vector101>:
.globl vector101
vector101:
  pushl $0
8010701f:	6a 00                	push   $0x0
  pushl $101
80107021:	6a 65                	push   $0x65
  jmp alltraps
80107023:	e9 e8 f5 ff ff       	jmp    80106610 <alltraps>

80107028 <vector102>:
.globl vector102
vector102:
  pushl $0
80107028:	6a 00                	push   $0x0
  pushl $102
8010702a:	6a 66                	push   $0x66
  jmp alltraps
8010702c:	e9 df f5 ff ff       	jmp    80106610 <alltraps>

80107031 <vector103>:
.globl vector103
vector103:
  pushl $0
80107031:	6a 00                	push   $0x0
  pushl $103
80107033:	6a 67                	push   $0x67
  jmp alltraps
80107035:	e9 d6 f5 ff ff       	jmp    80106610 <alltraps>

8010703a <vector104>:
.globl vector104
vector104:
  pushl $0
8010703a:	6a 00                	push   $0x0
  pushl $104
8010703c:	6a 68                	push   $0x68
  jmp alltraps
8010703e:	e9 cd f5 ff ff       	jmp    80106610 <alltraps>

80107043 <vector105>:
.globl vector105
vector105:
  pushl $0
80107043:	6a 00                	push   $0x0
  pushl $105
80107045:	6a 69                	push   $0x69
  jmp alltraps
80107047:	e9 c4 f5 ff ff       	jmp    80106610 <alltraps>

8010704c <vector106>:
.globl vector106
vector106:
  pushl $0
8010704c:	6a 00                	push   $0x0
  pushl $106
8010704e:	6a 6a                	push   $0x6a
  jmp alltraps
80107050:	e9 bb f5 ff ff       	jmp    80106610 <alltraps>

80107055 <vector107>:
.globl vector107
vector107:
  pushl $0
80107055:	6a 00                	push   $0x0
  pushl $107
80107057:	6a 6b                	push   $0x6b
  jmp alltraps
80107059:	e9 b2 f5 ff ff       	jmp    80106610 <alltraps>

8010705e <vector108>:
.globl vector108
vector108:
  pushl $0
8010705e:	6a 00                	push   $0x0
  pushl $108
80107060:	6a 6c                	push   $0x6c
  jmp alltraps
80107062:	e9 a9 f5 ff ff       	jmp    80106610 <alltraps>

80107067 <vector109>:
.globl vector109
vector109:
  pushl $0
80107067:	6a 00                	push   $0x0
  pushl $109
80107069:	6a 6d                	push   $0x6d
  jmp alltraps
8010706b:	e9 a0 f5 ff ff       	jmp    80106610 <alltraps>

80107070 <vector110>:
.globl vector110
vector110:
  pushl $0
80107070:	6a 00                	push   $0x0
  pushl $110
80107072:	6a 6e                	push   $0x6e
  jmp alltraps
80107074:	e9 97 f5 ff ff       	jmp    80106610 <alltraps>

80107079 <vector111>:
.globl vector111
vector111:
  pushl $0
80107079:	6a 00                	push   $0x0
  pushl $111
8010707b:	6a 6f                	push   $0x6f
  jmp alltraps
8010707d:	e9 8e f5 ff ff       	jmp    80106610 <alltraps>

80107082 <vector112>:
.globl vector112
vector112:
  pushl $0
80107082:	6a 00                	push   $0x0
  pushl $112
80107084:	6a 70                	push   $0x70
  jmp alltraps
80107086:	e9 85 f5 ff ff       	jmp    80106610 <alltraps>

8010708b <vector113>:
.globl vector113
vector113:
  pushl $0
8010708b:	6a 00                	push   $0x0
  pushl $113
8010708d:	6a 71                	push   $0x71
  jmp alltraps
8010708f:	e9 7c f5 ff ff       	jmp    80106610 <alltraps>

80107094 <vector114>:
.globl vector114
vector114:
  pushl $0
80107094:	6a 00                	push   $0x0
  pushl $114
80107096:	6a 72                	push   $0x72
  jmp alltraps
80107098:	e9 73 f5 ff ff       	jmp    80106610 <alltraps>

8010709d <vector115>:
.globl vector115
vector115:
  pushl $0
8010709d:	6a 00                	push   $0x0
  pushl $115
8010709f:	6a 73                	push   $0x73
  jmp alltraps
801070a1:	e9 6a f5 ff ff       	jmp    80106610 <alltraps>

801070a6 <vector116>:
.globl vector116
vector116:
  pushl $0
801070a6:	6a 00                	push   $0x0
  pushl $116
801070a8:	6a 74                	push   $0x74
  jmp alltraps
801070aa:	e9 61 f5 ff ff       	jmp    80106610 <alltraps>

801070af <vector117>:
.globl vector117
vector117:
  pushl $0
801070af:	6a 00                	push   $0x0
  pushl $117
801070b1:	6a 75                	push   $0x75
  jmp alltraps
801070b3:	e9 58 f5 ff ff       	jmp    80106610 <alltraps>

801070b8 <vector118>:
.globl vector118
vector118:
  pushl $0
801070b8:	6a 00                	push   $0x0
  pushl $118
801070ba:	6a 76                	push   $0x76
  jmp alltraps
801070bc:	e9 4f f5 ff ff       	jmp    80106610 <alltraps>

801070c1 <vector119>:
.globl vector119
vector119:
  pushl $0
801070c1:	6a 00                	push   $0x0
  pushl $119
801070c3:	6a 77                	push   $0x77
  jmp alltraps
801070c5:	e9 46 f5 ff ff       	jmp    80106610 <alltraps>

801070ca <vector120>:
.globl vector120
vector120:
  pushl $0
801070ca:	6a 00                	push   $0x0
  pushl $120
801070cc:	6a 78                	push   $0x78
  jmp alltraps
801070ce:	e9 3d f5 ff ff       	jmp    80106610 <alltraps>

801070d3 <vector121>:
.globl vector121
vector121:
  pushl $0
801070d3:	6a 00                	push   $0x0
  pushl $121
801070d5:	6a 79                	push   $0x79
  jmp alltraps
801070d7:	e9 34 f5 ff ff       	jmp    80106610 <alltraps>

801070dc <vector122>:
.globl vector122
vector122:
  pushl $0
801070dc:	6a 00                	push   $0x0
  pushl $122
801070de:	6a 7a                	push   $0x7a
  jmp alltraps
801070e0:	e9 2b f5 ff ff       	jmp    80106610 <alltraps>

801070e5 <vector123>:
.globl vector123
vector123:
  pushl $0
801070e5:	6a 00                	push   $0x0
  pushl $123
801070e7:	6a 7b                	push   $0x7b
  jmp alltraps
801070e9:	e9 22 f5 ff ff       	jmp    80106610 <alltraps>

801070ee <vector124>:
.globl vector124
vector124:
  pushl $0
801070ee:	6a 00                	push   $0x0
  pushl $124
801070f0:	6a 7c                	push   $0x7c
  jmp alltraps
801070f2:	e9 19 f5 ff ff       	jmp    80106610 <alltraps>

801070f7 <vector125>:
.globl vector125
vector125:
  pushl $0
801070f7:	6a 00                	push   $0x0
  pushl $125
801070f9:	6a 7d                	push   $0x7d
  jmp alltraps
801070fb:	e9 10 f5 ff ff       	jmp    80106610 <alltraps>

80107100 <vector126>:
.globl vector126
vector126:
  pushl $0
80107100:	6a 00                	push   $0x0
  pushl $126
80107102:	6a 7e                	push   $0x7e
  jmp alltraps
80107104:	e9 07 f5 ff ff       	jmp    80106610 <alltraps>

80107109 <vector127>:
.globl vector127
vector127:
  pushl $0
80107109:	6a 00                	push   $0x0
  pushl $127
8010710b:	6a 7f                	push   $0x7f
  jmp alltraps
8010710d:	e9 fe f4 ff ff       	jmp    80106610 <alltraps>

80107112 <vector128>:
.globl vector128
vector128:
  pushl $0
80107112:	6a 00                	push   $0x0
  pushl $128
80107114:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80107119:	e9 f2 f4 ff ff       	jmp    80106610 <alltraps>

8010711e <vector129>:
.globl vector129
vector129:
  pushl $0
8010711e:	6a 00                	push   $0x0
  pushl $129
80107120:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80107125:	e9 e6 f4 ff ff       	jmp    80106610 <alltraps>

8010712a <vector130>:
.globl vector130
vector130:
  pushl $0
8010712a:	6a 00                	push   $0x0
  pushl $130
8010712c:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80107131:	e9 da f4 ff ff       	jmp    80106610 <alltraps>

80107136 <vector131>:
.globl vector131
vector131:
  pushl $0
80107136:	6a 00                	push   $0x0
  pushl $131
80107138:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010713d:	e9 ce f4 ff ff       	jmp    80106610 <alltraps>

80107142 <vector132>:
.globl vector132
vector132:
  pushl $0
80107142:	6a 00                	push   $0x0
  pushl $132
80107144:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107149:	e9 c2 f4 ff ff       	jmp    80106610 <alltraps>

8010714e <vector133>:
.globl vector133
vector133:
  pushl $0
8010714e:	6a 00                	push   $0x0
  pushl $133
80107150:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80107155:	e9 b6 f4 ff ff       	jmp    80106610 <alltraps>

8010715a <vector134>:
.globl vector134
vector134:
  pushl $0
8010715a:	6a 00                	push   $0x0
  pushl $134
8010715c:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107161:	e9 aa f4 ff ff       	jmp    80106610 <alltraps>

80107166 <vector135>:
.globl vector135
vector135:
  pushl $0
80107166:	6a 00                	push   $0x0
  pushl $135
80107168:	68 87 00 00 00       	push   $0x87
  jmp alltraps
8010716d:	e9 9e f4 ff ff       	jmp    80106610 <alltraps>

80107172 <vector136>:
.globl vector136
vector136:
  pushl $0
80107172:	6a 00                	push   $0x0
  pushl $136
80107174:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107179:	e9 92 f4 ff ff       	jmp    80106610 <alltraps>

8010717e <vector137>:
.globl vector137
vector137:
  pushl $0
8010717e:	6a 00                	push   $0x0
  pushl $137
80107180:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80107185:	e9 86 f4 ff ff       	jmp    80106610 <alltraps>

8010718a <vector138>:
.globl vector138
vector138:
  pushl $0
8010718a:	6a 00                	push   $0x0
  pushl $138
8010718c:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107191:	e9 7a f4 ff ff       	jmp    80106610 <alltraps>

80107196 <vector139>:
.globl vector139
vector139:
  pushl $0
80107196:	6a 00                	push   $0x0
  pushl $139
80107198:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010719d:	e9 6e f4 ff ff       	jmp    80106610 <alltraps>

801071a2 <vector140>:
.globl vector140
vector140:
  pushl $0
801071a2:	6a 00                	push   $0x0
  pushl $140
801071a4:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801071a9:	e9 62 f4 ff ff       	jmp    80106610 <alltraps>

801071ae <vector141>:
.globl vector141
vector141:
  pushl $0
801071ae:	6a 00                	push   $0x0
  pushl $141
801071b0:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801071b5:	e9 56 f4 ff ff       	jmp    80106610 <alltraps>

801071ba <vector142>:
.globl vector142
vector142:
  pushl $0
801071ba:	6a 00                	push   $0x0
  pushl $142
801071bc:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801071c1:	e9 4a f4 ff ff       	jmp    80106610 <alltraps>

801071c6 <vector143>:
.globl vector143
vector143:
  pushl $0
801071c6:	6a 00                	push   $0x0
  pushl $143
801071c8:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801071cd:	e9 3e f4 ff ff       	jmp    80106610 <alltraps>

801071d2 <vector144>:
.globl vector144
vector144:
  pushl $0
801071d2:	6a 00                	push   $0x0
  pushl $144
801071d4:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801071d9:	e9 32 f4 ff ff       	jmp    80106610 <alltraps>

801071de <vector145>:
.globl vector145
vector145:
  pushl $0
801071de:	6a 00                	push   $0x0
  pushl $145
801071e0:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801071e5:	e9 26 f4 ff ff       	jmp    80106610 <alltraps>

801071ea <vector146>:
.globl vector146
vector146:
  pushl $0
801071ea:	6a 00                	push   $0x0
  pushl $146
801071ec:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801071f1:	e9 1a f4 ff ff       	jmp    80106610 <alltraps>

801071f6 <vector147>:
.globl vector147
vector147:
  pushl $0
801071f6:	6a 00                	push   $0x0
  pushl $147
801071f8:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801071fd:	e9 0e f4 ff ff       	jmp    80106610 <alltraps>

80107202 <vector148>:
.globl vector148
vector148:
  pushl $0
80107202:	6a 00                	push   $0x0
  pushl $148
80107204:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80107209:	e9 02 f4 ff ff       	jmp    80106610 <alltraps>

8010720e <vector149>:
.globl vector149
vector149:
  pushl $0
8010720e:	6a 00                	push   $0x0
  pushl $149
80107210:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80107215:	e9 f6 f3 ff ff       	jmp    80106610 <alltraps>

8010721a <vector150>:
.globl vector150
vector150:
  pushl $0
8010721a:	6a 00                	push   $0x0
  pushl $150
8010721c:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80107221:	e9 ea f3 ff ff       	jmp    80106610 <alltraps>

80107226 <vector151>:
.globl vector151
vector151:
  pushl $0
80107226:	6a 00                	push   $0x0
  pushl $151
80107228:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010722d:	e9 de f3 ff ff       	jmp    80106610 <alltraps>

80107232 <vector152>:
.globl vector152
vector152:
  pushl $0
80107232:	6a 00                	push   $0x0
  pushl $152
80107234:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80107239:	e9 d2 f3 ff ff       	jmp    80106610 <alltraps>

8010723e <vector153>:
.globl vector153
vector153:
  pushl $0
8010723e:	6a 00                	push   $0x0
  pushl $153
80107240:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80107245:	e9 c6 f3 ff ff       	jmp    80106610 <alltraps>

8010724a <vector154>:
.globl vector154
vector154:
  pushl $0
8010724a:	6a 00                	push   $0x0
  pushl $154
8010724c:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107251:	e9 ba f3 ff ff       	jmp    80106610 <alltraps>

80107256 <vector155>:
.globl vector155
vector155:
  pushl $0
80107256:	6a 00                	push   $0x0
  pushl $155
80107258:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
8010725d:	e9 ae f3 ff ff       	jmp    80106610 <alltraps>

80107262 <vector156>:
.globl vector156
vector156:
  pushl $0
80107262:	6a 00                	push   $0x0
  pushl $156
80107264:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107269:	e9 a2 f3 ff ff       	jmp    80106610 <alltraps>

8010726e <vector157>:
.globl vector157
vector157:
  pushl $0
8010726e:	6a 00                	push   $0x0
  pushl $157
80107270:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107275:	e9 96 f3 ff ff       	jmp    80106610 <alltraps>

8010727a <vector158>:
.globl vector158
vector158:
  pushl $0
8010727a:	6a 00                	push   $0x0
  pushl $158
8010727c:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107281:	e9 8a f3 ff ff       	jmp    80106610 <alltraps>

80107286 <vector159>:
.globl vector159
vector159:
  pushl $0
80107286:	6a 00                	push   $0x0
  pushl $159
80107288:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010728d:	e9 7e f3 ff ff       	jmp    80106610 <alltraps>

80107292 <vector160>:
.globl vector160
vector160:
  pushl $0
80107292:	6a 00                	push   $0x0
  pushl $160
80107294:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107299:	e9 72 f3 ff ff       	jmp    80106610 <alltraps>

8010729e <vector161>:
.globl vector161
vector161:
  pushl $0
8010729e:	6a 00                	push   $0x0
  pushl $161
801072a0:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801072a5:	e9 66 f3 ff ff       	jmp    80106610 <alltraps>

801072aa <vector162>:
.globl vector162
vector162:
  pushl $0
801072aa:	6a 00                	push   $0x0
  pushl $162
801072ac:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801072b1:	e9 5a f3 ff ff       	jmp    80106610 <alltraps>

801072b6 <vector163>:
.globl vector163
vector163:
  pushl $0
801072b6:	6a 00                	push   $0x0
  pushl $163
801072b8:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801072bd:	e9 4e f3 ff ff       	jmp    80106610 <alltraps>

801072c2 <vector164>:
.globl vector164
vector164:
  pushl $0
801072c2:	6a 00                	push   $0x0
  pushl $164
801072c4:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801072c9:	e9 42 f3 ff ff       	jmp    80106610 <alltraps>

801072ce <vector165>:
.globl vector165
vector165:
  pushl $0
801072ce:	6a 00                	push   $0x0
  pushl $165
801072d0:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801072d5:	e9 36 f3 ff ff       	jmp    80106610 <alltraps>

801072da <vector166>:
.globl vector166
vector166:
  pushl $0
801072da:	6a 00                	push   $0x0
  pushl $166
801072dc:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801072e1:	e9 2a f3 ff ff       	jmp    80106610 <alltraps>

801072e6 <vector167>:
.globl vector167
vector167:
  pushl $0
801072e6:	6a 00                	push   $0x0
  pushl $167
801072e8:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801072ed:	e9 1e f3 ff ff       	jmp    80106610 <alltraps>

801072f2 <vector168>:
.globl vector168
vector168:
  pushl $0
801072f2:	6a 00                	push   $0x0
  pushl $168
801072f4:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801072f9:	e9 12 f3 ff ff       	jmp    80106610 <alltraps>

801072fe <vector169>:
.globl vector169
vector169:
  pushl $0
801072fe:	6a 00                	push   $0x0
  pushl $169
80107300:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107305:	e9 06 f3 ff ff       	jmp    80106610 <alltraps>

8010730a <vector170>:
.globl vector170
vector170:
  pushl $0
8010730a:	6a 00                	push   $0x0
  pushl $170
8010730c:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107311:	e9 fa f2 ff ff       	jmp    80106610 <alltraps>

80107316 <vector171>:
.globl vector171
vector171:
  pushl $0
80107316:	6a 00                	push   $0x0
  pushl $171
80107318:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010731d:	e9 ee f2 ff ff       	jmp    80106610 <alltraps>

80107322 <vector172>:
.globl vector172
vector172:
  pushl $0
80107322:	6a 00                	push   $0x0
  pushl $172
80107324:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107329:	e9 e2 f2 ff ff       	jmp    80106610 <alltraps>

8010732e <vector173>:
.globl vector173
vector173:
  pushl $0
8010732e:	6a 00                	push   $0x0
  pushl $173
80107330:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107335:	e9 d6 f2 ff ff       	jmp    80106610 <alltraps>

8010733a <vector174>:
.globl vector174
vector174:
  pushl $0
8010733a:	6a 00                	push   $0x0
  pushl $174
8010733c:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107341:	e9 ca f2 ff ff       	jmp    80106610 <alltraps>

80107346 <vector175>:
.globl vector175
vector175:
  pushl $0
80107346:	6a 00                	push   $0x0
  pushl $175
80107348:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010734d:	e9 be f2 ff ff       	jmp    80106610 <alltraps>

80107352 <vector176>:
.globl vector176
vector176:
  pushl $0
80107352:	6a 00                	push   $0x0
  pushl $176
80107354:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107359:	e9 b2 f2 ff ff       	jmp    80106610 <alltraps>

8010735e <vector177>:
.globl vector177
vector177:
  pushl $0
8010735e:	6a 00                	push   $0x0
  pushl $177
80107360:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107365:	e9 a6 f2 ff ff       	jmp    80106610 <alltraps>

8010736a <vector178>:
.globl vector178
vector178:
  pushl $0
8010736a:	6a 00                	push   $0x0
  pushl $178
8010736c:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107371:	e9 9a f2 ff ff       	jmp    80106610 <alltraps>

80107376 <vector179>:
.globl vector179
vector179:
  pushl $0
80107376:	6a 00                	push   $0x0
  pushl $179
80107378:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
8010737d:	e9 8e f2 ff ff       	jmp    80106610 <alltraps>

80107382 <vector180>:
.globl vector180
vector180:
  pushl $0
80107382:	6a 00                	push   $0x0
  pushl $180
80107384:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107389:	e9 82 f2 ff ff       	jmp    80106610 <alltraps>

8010738e <vector181>:
.globl vector181
vector181:
  pushl $0
8010738e:	6a 00                	push   $0x0
  pushl $181
80107390:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107395:	e9 76 f2 ff ff       	jmp    80106610 <alltraps>

8010739a <vector182>:
.globl vector182
vector182:
  pushl $0
8010739a:	6a 00                	push   $0x0
  pushl $182
8010739c:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801073a1:	e9 6a f2 ff ff       	jmp    80106610 <alltraps>

801073a6 <vector183>:
.globl vector183
vector183:
  pushl $0
801073a6:	6a 00                	push   $0x0
  pushl $183
801073a8:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801073ad:	e9 5e f2 ff ff       	jmp    80106610 <alltraps>

801073b2 <vector184>:
.globl vector184
vector184:
  pushl $0
801073b2:	6a 00                	push   $0x0
  pushl $184
801073b4:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801073b9:	e9 52 f2 ff ff       	jmp    80106610 <alltraps>

801073be <vector185>:
.globl vector185
vector185:
  pushl $0
801073be:	6a 00                	push   $0x0
  pushl $185
801073c0:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801073c5:	e9 46 f2 ff ff       	jmp    80106610 <alltraps>

801073ca <vector186>:
.globl vector186
vector186:
  pushl $0
801073ca:	6a 00                	push   $0x0
  pushl $186
801073cc:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801073d1:	e9 3a f2 ff ff       	jmp    80106610 <alltraps>

801073d6 <vector187>:
.globl vector187
vector187:
  pushl $0
801073d6:	6a 00                	push   $0x0
  pushl $187
801073d8:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801073dd:	e9 2e f2 ff ff       	jmp    80106610 <alltraps>

801073e2 <vector188>:
.globl vector188
vector188:
  pushl $0
801073e2:	6a 00                	push   $0x0
  pushl $188
801073e4:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801073e9:	e9 22 f2 ff ff       	jmp    80106610 <alltraps>

801073ee <vector189>:
.globl vector189
vector189:
  pushl $0
801073ee:	6a 00                	push   $0x0
  pushl $189
801073f0:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801073f5:	e9 16 f2 ff ff       	jmp    80106610 <alltraps>

801073fa <vector190>:
.globl vector190
vector190:
  pushl $0
801073fa:	6a 00                	push   $0x0
  pushl $190
801073fc:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107401:	e9 0a f2 ff ff       	jmp    80106610 <alltraps>

80107406 <vector191>:
.globl vector191
vector191:
  pushl $0
80107406:	6a 00                	push   $0x0
  pushl $191
80107408:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
8010740d:	e9 fe f1 ff ff       	jmp    80106610 <alltraps>

80107412 <vector192>:
.globl vector192
vector192:
  pushl $0
80107412:	6a 00                	push   $0x0
  pushl $192
80107414:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107419:	e9 f2 f1 ff ff       	jmp    80106610 <alltraps>

8010741e <vector193>:
.globl vector193
vector193:
  pushl $0
8010741e:	6a 00                	push   $0x0
  pushl $193
80107420:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107425:	e9 e6 f1 ff ff       	jmp    80106610 <alltraps>

8010742a <vector194>:
.globl vector194
vector194:
  pushl $0
8010742a:	6a 00                	push   $0x0
  pushl $194
8010742c:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107431:	e9 da f1 ff ff       	jmp    80106610 <alltraps>

80107436 <vector195>:
.globl vector195
vector195:
  pushl $0
80107436:	6a 00                	push   $0x0
  pushl $195
80107438:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
8010743d:	e9 ce f1 ff ff       	jmp    80106610 <alltraps>

80107442 <vector196>:
.globl vector196
vector196:
  pushl $0
80107442:	6a 00                	push   $0x0
  pushl $196
80107444:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107449:	e9 c2 f1 ff ff       	jmp    80106610 <alltraps>

8010744e <vector197>:
.globl vector197
vector197:
  pushl $0
8010744e:	6a 00                	push   $0x0
  pushl $197
80107450:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107455:	e9 b6 f1 ff ff       	jmp    80106610 <alltraps>

8010745a <vector198>:
.globl vector198
vector198:
  pushl $0
8010745a:	6a 00                	push   $0x0
  pushl $198
8010745c:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107461:	e9 aa f1 ff ff       	jmp    80106610 <alltraps>

80107466 <vector199>:
.globl vector199
vector199:
  pushl $0
80107466:	6a 00                	push   $0x0
  pushl $199
80107468:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
8010746d:	e9 9e f1 ff ff       	jmp    80106610 <alltraps>

80107472 <vector200>:
.globl vector200
vector200:
  pushl $0
80107472:	6a 00                	push   $0x0
  pushl $200
80107474:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107479:	e9 92 f1 ff ff       	jmp    80106610 <alltraps>

8010747e <vector201>:
.globl vector201
vector201:
  pushl $0
8010747e:	6a 00                	push   $0x0
  pushl $201
80107480:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107485:	e9 86 f1 ff ff       	jmp    80106610 <alltraps>

8010748a <vector202>:
.globl vector202
vector202:
  pushl $0
8010748a:	6a 00                	push   $0x0
  pushl $202
8010748c:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107491:	e9 7a f1 ff ff       	jmp    80106610 <alltraps>

80107496 <vector203>:
.globl vector203
vector203:
  pushl $0
80107496:	6a 00                	push   $0x0
  pushl $203
80107498:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
8010749d:	e9 6e f1 ff ff       	jmp    80106610 <alltraps>

801074a2 <vector204>:
.globl vector204
vector204:
  pushl $0
801074a2:	6a 00                	push   $0x0
  pushl $204
801074a4:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801074a9:	e9 62 f1 ff ff       	jmp    80106610 <alltraps>

801074ae <vector205>:
.globl vector205
vector205:
  pushl $0
801074ae:	6a 00                	push   $0x0
  pushl $205
801074b0:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801074b5:	e9 56 f1 ff ff       	jmp    80106610 <alltraps>

801074ba <vector206>:
.globl vector206
vector206:
  pushl $0
801074ba:	6a 00                	push   $0x0
  pushl $206
801074bc:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801074c1:	e9 4a f1 ff ff       	jmp    80106610 <alltraps>

801074c6 <vector207>:
.globl vector207
vector207:
  pushl $0
801074c6:	6a 00                	push   $0x0
  pushl $207
801074c8:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801074cd:	e9 3e f1 ff ff       	jmp    80106610 <alltraps>

801074d2 <vector208>:
.globl vector208
vector208:
  pushl $0
801074d2:	6a 00                	push   $0x0
  pushl $208
801074d4:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801074d9:	e9 32 f1 ff ff       	jmp    80106610 <alltraps>

801074de <vector209>:
.globl vector209
vector209:
  pushl $0
801074de:	6a 00                	push   $0x0
  pushl $209
801074e0:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801074e5:	e9 26 f1 ff ff       	jmp    80106610 <alltraps>

801074ea <vector210>:
.globl vector210
vector210:
  pushl $0
801074ea:	6a 00                	push   $0x0
  pushl $210
801074ec:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801074f1:	e9 1a f1 ff ff       	jmp    80106610 <alltraps>

801074f6 <vector211>:
.globl vector211
vector211:
  pushl $0
801074f6:	6a 00                	push   $0x0
  pushl $211
801074f8:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801074fd:	e9 0e f1 ff ff       	jmp    80106610 <alltraps>

80107502 <vector212>:
.globl vector212
vector212:
  pushl $0
80107502:	6a 00                	push   $0x0
  pushl $212
80107504:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107509:	e9 02 f1 ff ff       	jmp    80106610 <alltraps>

8010750e <vector213>:
.globl vector213
vector213:
  pushl $0
8010750e:	6a 00                	push   $0x0
  pushl $213
80107510:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107515:	e9 f6 f0 ff ff       	jmp    80106610 <alltraps>

8010751a <vector214>:
.globl vector214
vector214:
  pushl $0
8010751a:	6a 00                	push   $0x0
  pushl $214
8010751c:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107521:	e9 ea f0 ff ff       	jmp    80106610 <alltraps>

80107526 <vector215>:
.globl vector215
vector215:
  pushl $0
80107526:	6a 00                	push   $0x0
  pushl $215
80107528:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
8010752d:	e9 de f0 ff ff       	jmp    80106610 <alltraps>

80107532 <vector216>:
.globl vector216
vector216:
  pushl $0
80107532:	6a 00                	push   $0x0
  pushl $216
80107534:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107539:	e9 d2 f0 ff ff       	jmp    80106610 <alltraps>

8010753e <vector217>:
.globl vector217
vector217:
  pushl $0
8010753e:	6a 00                	push   $0x0
  pushl $217
80107540:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107545:	e9 c6 f0 ff ff       	jmp    80106610 <alltraps>

8010754a <vector218>:
.globl vector218
vector218:
  pushl $0
8010754a:	6a 00                	push   $0x0
  pushl $218
8010754c:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107551:	e9 ba f0 ff ff       	jmp    80106610 <alltraps>

80107556 <vector219>:
.globl vector219
vector219:
  pushl $0
80107556:	6a 00                	push   $0x0
  pushl $219
80107558:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
8010755d:	e9 ae f0 ff ff       	jmp    80106610 <alltraps>

80107562 <vector220>:
.globl vector220
vector220:
  pushl $0
80107562:	6a 00                	push   $0x0
  pushl $220
80107564:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107569:	e9 a2 f0 ff ff       	jmp    80106610 <alltraps>

8010756e <vector221>:
.globl vector221
vector221:
  pushl $0
8010756e:	6a 00                	push   $0x0
  pushl $221
80107570:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107575:	e9 96 f0 ff ff       	jmp    80106610 <alltraps>

8010757a <vector222>:
.globl vector222
vector222:
  pushl $0
8010757a:	6a 00                	push   $0x0
  pushl $222
8010757c:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107581:	e9 8a f0 ff ff       	jmp    80106610 <alltraps>

80107586 <vector223>:
.globl vector223
vector223:
  pushl $0
80107586:	6a 00                	push   $0x0
  pushl $223
80107588:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
8010758d:	e9 7e f0 ff ff       	jmp    80106610 <alltraps>

80107592 <vector224>:
.globl vector224
vector224:
  pushl $0
80107592:	6a 00                	push   $0x0
  pushl $224
80107594:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107599:	e9 72 f0 ff ff       	jmp    80106610 <alltraps>

8010759e <vector225>:
.globl vector225
vector225:
  pushl $0
8010759e:	6a 00                	push   $0x0
  pushl $225
801075a0:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801075a5:	e9 66 f0 ff ff       	jmp    80106610 <alltraps>

801075aa <vector226>:
.globl vector226
vector226:
  pushl $0
801075aa:	6a 00                	push   $0x0
  pushl $226
801075ac:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801075b1:	e9 5a f0 ff ff       	jmp    80106610 <alltraps>

801075b6 <vector227>:
.globl vector227
vector227:
  pushl $0
801075b6:	6a 00                	push   $0x0
  pushl $227
801075b8:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801075bd:	e9 4e f0 ff ff       	jmp    80106610 <alltraps>

801075c2 <vector228>:
.globl vector228
vector228:
  pushl $0
801075c2:	6a 00                	push   $0x0
  pushl $228
801075c4:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801075c9:	e9 42 f0 ff ff       	jmp    80106610 <alltraps>

801075ce <vector229>:
.globl vector229
vector229:
  pushl $0
801075ce:	6a 00                	push   $0x0
  pushl $229
801075d0:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801075d5:	e9 36 f0 ff ff       	jmp    80106610 <alltraps>

801075da <vector230>:
.globl vector230
vector230:
  pushl $0
801075da:	6a 00                	push   $0x0
  pushl $230
801075dc:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801075e1:	e9 2a f0 ff ff       	jmp    80106610 <alltraps>

801075e6 <vector231>:
.globl vector231
vector231:
  pushl $0
801075e6:	6a 00                	push   $0x0
  pushl $231
801075e8:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801075ed:	e9 1e f0 ff ff       	jmp    80106610 <alltraps>

801075f2 <vector232>:
.globl vector232
vector232:
  pushl $0
801075f2:	6a 00                	push   $0x0
  pushl $232
801075f4:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801075f9:	e9 12 f0 ff ff       	jmp    80106610 <alltraps>

801075fe <vector233>:
.globl vector233
vector233:
  pushl $0
801075fe:	6a 00                	push   $0x0
  pushl $233
80107600:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107605:	e9 06 f0 ff ff       	jmp    80106610 <alltraps>

8010760a <vector234>:
.globl vector234
vector234:
  pushl $0
8010760a:	6a 00                	push   $0x0
  pushl $234
8010760c:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107611:	e9 fa ef ff ff       	jmp    80106610 <alltraps>

80107616 <vector235>:
.globl vector235
vector235:
  pushl $0
80107616:	6a 00                	push   $0x0
  pushl $235
80107618:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
8010761d:	e9 ee ef ff ff       	jmp    80106610 <alltraps>

80107622 <vector236>:
.globl vector236
vector236:
  pushl $0
80107622:	6a 00                	push   $0x0
  pushl $236
80107624:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107629:	e9 e2 ef ff ff       	jmp    80106610 <alltraps>

8010762e <vector237>:
.globl vector237
vector237:
  pushl $0
8010762e:	6a 00                	push   $0x0
  pushl $237
80107630:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107635:	e9 d6 ef ff ff       	jmp    80106610 <alltraps>

8010763a <vector238>:
.globl vector238
vector238:
  pushl $0
8010763a:	6a 00                	push   $0x0
  pushl $238
8010763c:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107641:	e9 ca ef ff ff       	jmp    80106610 <alltraps>

80107646 <vector239>:
.globl vector239
vector239:
  pushl $0
80107646:	6a 00                	push   $0x0
  pushl $239
80107648:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
8010764d:	e9 be ef ff ff       	jmp    80106610 <alltraps>

80107652 <vector240>:
.globl vector240
vector240:
  pushl $0
80107652:	6a 00                	push   $0x0
  pushl $240
80107654:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107659:	e9 b2 ef ff ff       	jmp    80106610 <alltraps>

8010765e <vector241>:
.globl vector241
vector241:
  pushl $0
8010765e:	6a 00                	push   $0x0
  pushl $241
80107660:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107665:	e9 a6 ef ff ff       	jmp    80106610 <alltraps>

8010766a <vector242>:
.globl vector242
vector242:
  pushl $0
8010766a:	6a 00                	push   $0x0
  pushl $242
8010766c:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107671:	e9 9a ef ff ff       	jmp    80106610 <alltraps>

80107676 <vector243>:
.globl vector243
vector243:
  pushl $0
80107676:	6a 00                	push   $0x0
  pushl $243
80107678:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
8010767d:	e9 8e ef ff ff       	jmp    80106610 <alltraps>

80107682 <vector244>:
.globl vector244
vector244:
  pushl $0
80107682:	6a 00                	push   $0x0
  pushl $244
80107684:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107689:	e9 82 ef ff ff       	jmp    80106610 <alltraps>

8010768e <vector245>:
.globl vector245
vector245:
  pushl $0
8010768e:	6a 00                	push   $0x0
  pushl $245
80107690:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107695:	e9 76 ef ff ff       	jmp    80106610 <alltraps>

8010769a <vector246>:
.globl vector246
vector246:
  pushl $0
8010769a:	6a 00                	push   $0x0
  pushl $246
8010769c:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801076a1:	e9 6a ef ff ff       	jmp    80106610 <alltraps>

801076a6 <vector247>:
.globl vector247
vector247:
  pushl $0
801076a6:	6a 00                	push   $0x0
  pushl $247
801076a8:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801076ad:	e9 5e ef ff ff       	jmp    80106610 <alltraps>

801076b2 <vector248>:
.globl vector248
vector248:
  pushl $0
801076b2:	6a 00                	push   $0x0
  pushl $248
801076b4:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801076b9:	e9 52 ef ff ff       	jmp    80106610 <alltraps>

801076be <vector249>:
.globl vector249
vector249:
  pushl $0
801076be:	6a 00                	push   $0x0
  pushl $249
801076c0:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801076c5:	e9 46 ef ff ff       	jmp    80106610 <alltraps>

801076ca <vector250>:
.globl vector250
vector250:
  pushl $0
801076ca:	6a 00                	push   $0x0
  pushl $250
801076cc:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801076d1:	e9 3a ef ff ff       	jmp    80106610 <alltraps>

801076d6 <vector251>:
.globl vector251
vector251:
  pushl $0
801076d6:	6a 00                	push   $0x0
  pushl $251
801076d8:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801076dd:	e9 2e ef ff ff       	jmp    80106610 <alltraps>

801076e2 <vector252>:
.globl vector252
vector252:
  pushl $0
801076e2:	6a 00                	push   $0x0
  pushl $252
801076e4:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801076e9:	e9 22 ef ff ff       	jmp    80106610 <alltraps>

801076ee <vector253>:
.globl vector253
vector253:
  pushl $0
801076ee:	6a 00                	push   $0x0
  pushl $253
801076f0:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801076f5:	e9 16 ef ff ff       	jmp    80106610 <alltraps>

801076fa <vector254>:
.globl vector254
vector254:
  pushl $0
801076fa:	6a 00                	push   $0x0
  pushl $254
801076fc:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107701:	e9 0a ef ff ff       	jmp    80106610 <alltraps>

80107706 <vector255>:
.globl vector255
vector255:
  pushl $0
80107706:	6a 00                	push   $0x0
  pushl $255
80107708:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
8010770d:	e9 fe ee ff ff       	jmp    80106610 <alltraps>
	...

80107714 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107714:	55                   	push   %ebp
80107715:	89 e5                	mov    %esp,%ebp
80107717:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
8010771a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010771d:	83 e8 01             	sub    $0x1,%eax
80107720:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107724:	8b 45 08             	mov    0x8(%ebp),%eax
80107727:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
8010772b:	8b 45 08             	mov    0x8(%ebp),%eax
8010772e:	c1 e8 10             	shr    $0x10,%eax
80107731:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107735:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107738:	0f 01 10             	lgdtl  (%eax)
}
8010773b:	c9                   	leave  
8010773c:	c3                   	ret    

8010773d <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
8010773d:	55                   	push   %ebp
8010773e:	89 e5                	mov    %esp,%ebp
80107740:	83 ec 04             	sub    $0x4,%esp
80107743:	8b 45 08             	mov    0x8(%ebp),%eax
80107746:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
8010774a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010774e:	0f 00 d8             	ltr    %ax
}
80107751:	c9                   	leave  
80107752:	c3                   	ret    

80107753 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107753:	55                   	push   %ebp
80107754:	89 e5                	mov    %esp,%ebp
80107756:	83 ec 04             	sub    $0x4,%esp
80107759:	8b 45 08             	mov    0x8(%ebp),%eax
8010775c:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107760:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107764:	8e e8                	mov    %eax,%gs
}
80107766:	c9                   	leave  
80107767:	c3                   	ret    

80107768 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107768:	55                   	push   %ebp
80107769:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010776b:	8b 45 08             	mov    0x8(%ebp),%eax
8010776e:	0f 22 d8             	mov    %eax,%cr3
}
80107771:	5d                   	pop    %ebp
80107772:	c3                   	ret    

80107773 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107773:	55                   	push   %ebp
80107774:	89 e5                	mov    %esp,%ebp
80107776:	8b 45 08             	mov    0x8(%ebp),%eax
80107779:	05 00 00 00 80       	add    $0x80000000,%eax
8010777e:	5d                   	pop    %ebp
8010777f:	c3                   	ret    

80107780 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107780:	55                   	push   %ebp
80107781:	89 e5                	mov    %esp,%ebp
80107783:	8b 45 08             	mov    0x8(%ebp),%eax
80107786:	05 00 00 00 80       	add    $0x80000000,%eax
8010778b:	5d                   	pop    %ebp
8010778c:	c3                   	ret    

8010778d <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
8010778d:	55                   	push   %ebp
8010778e:	89 e5                	mov    %esp,%ebp
80107790:	53                   	push   %ebx
80107791:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107794:	e8 f4 b6 ff ff       	call   80102e8d <cpunum>
80107799:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010779f:	05 20 f9 10 80       	add    $0x8010f920,%eax
801077a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801077a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077aa:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801077b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077b3:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801077b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077bc:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
801077c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077c3:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801077c7:	83 e2 f0             	and    $0xfffffff0,%edx
801077ca:	83 ca 0a             	or     $0xa,%edx
801077cd:	88 50 7d             	mov    %dl,0x7d(%eax)
801077d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077d3:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801077d7:	83 ca 10             	or     $0x10,%edx
801077da:	88 50 7d             	mov    %dl,0x7d(%eax)
801077dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077e0:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801077e4:	83 e2 9f             	and    $0xffffff9f,%edx
801077e7:	88 50 7d             	mov    %dl,0x7d(%eax)
801077ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077ed:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
801077f1:	83 ca 80             	or     $0xffffff80,%edx
801077f4:	88 50 7d             	mov    %dl,0x7d(%eax)
801077f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801077fa:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
801077fe:	83 ca 0f             	or     $0xf,%edx
80107801:	88 50 7e             	mov    %dl,0x7e(%eax)
80107804:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107807:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010780b:	83 e2 ef             	and    $0xffffffef,%edx
8010780e:	88 50 7e             	mov    %dl,0x7e(%eax)
80107811:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107814:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107818:	83 e2 df             	and    $0xffffffdf,%edx
8010781b:	88 50 7e             	mov    %dl,0x7e(%eax)
8010781e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107821:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107825:	83 ca 40             	or     $0x40,%edx
80107828:	88 50 7e             	mov    %dl,0x7e(%eax)
8010782b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010782e:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107832:	83 ca 80             	or     $0xffffff80,%edx
80107835:	88 50 7e             	mov    %dl,0x7e(%eax)
80107838:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010783b:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010783f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107842:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107849:	ff ff 
8010784b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010784e:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107855:	00 00 
80107857:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010785a:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107861:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107864:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010786b:	83 e2 f0             	and    $0xfffffff0,%edx
8010786e:	83 ca 02             	or     $0x2,%edx
80107871:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010787a:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107881:	83 ca 10             	or     $0x10,%edx
80107884:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010788a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010788d:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107894:	83 e2 9f             	and    $0xffffff9f,%edx
80107897:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010789d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078a0:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801078a7:	83 ca 80             	or     $0xffffff80,%edx
801078aa:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801078b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078b3:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078ba:	83 ca 0f             	or     $0xf,%edx
801078bd:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078c6:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078cd:	83 e2 ef             	and    $0xffffffef,%edx
801078d0:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078d9:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078e0:	83 e2 df             	and    $0xffffffdf,%edx
801078e3:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ec:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801078f3:	83 ca 40             	or     $0x40,%edx
801078f6:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801078fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801078ff:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107906:	83 ca 80             	or     $0xffffff80,%edx
80107909:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010790f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107912:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107919:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010791c:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107923:	ff ff 
80107925:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107928:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
8010792f:	00 00 
80107931:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107934:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010793b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010793e:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107945:	83 e2 f0             	and    $0xfffffff0,%edx
80107948:	83 ca 0a             	or     $0xa,%edx
8010794b:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107951:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107954:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010795b:	83 ca 10             	or     $0x10,%edx
8010795e:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107964:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107967:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010796e:	83 ca 60             	or     $0x60,%edx
80107971:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107977:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010797a:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107981:	83 ca 80             	or     $0xffffff80,%edx
80107984:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010798a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010798d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107994:	83 ca 0f             	or     $0xf,%edx
80107997:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010799d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079a0:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801079a7:	83 e2 ef             	and    $0xffffffef,%edx
801079aa:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079b3:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801079ba:	83 e2 df             	and    $0xffffffdf,%edx
801079bd:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079c6:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801079cd:	83 ca 40             	or     $0x40,%edx
801079d0:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079d9:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801079e0:	83 ca 80             	or     $0xffffff80,%edx
801079e3:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801079e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079ec:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801079f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801079f6:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801079fd:	ff ff 
801079ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a02:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107a09:	00 00 
80107a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a0e:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a18:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a1f:	83 e2 f0             	and    $0xfffffff0,%edx
80107a22:	83 ca 02             	or     $0x2,%edx
80107a25:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a2e:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a35:	83 ca 10             	or     $0x10,%edx
80107a38:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a41:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a48:	83 ca 60             	or     $0x60,%edx
80107a4b:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a54:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107a5b:	83 ca 80             	or     $0xffffff80,%edx
80107a5e:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a67:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107a6e:	83 ca 0f             	or     $0xf,%edx
80107a71:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a7a:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107a81:	83 e2 ef             	and    $0xffffffef,%edx
80107a84:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a8d:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107a94:	83 e2 df             	and    $0xffffffdf,%edx
80107a97:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa0:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107aa7:	83 ca 40             	or     $0x40,%edx
80107aaa:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab3:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107aba:	83 ca 80             	or     $0xffffff80,%edx
80107abd:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac6:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ad0:	05 b4 00 00 00       	add    $0xb4,%eax
80107ad5:	89 c3                	mov    %eax,%ebx
80107ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ada:	05 b4 00 00 00       	add    $0xb4,%eax
80107adf:	c1 e8 10             	shr    $0x10,%eax
80107ae2:	89 c1                	mov    %eax,%ecx
80107ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae7:	05 b4 00 00 00       	add    $0xb4,%eax
80107aec:	c1 e8 18             	shr    $0x18,%eax
80107aef:	89 c2                	mov    %eax,%edx
80107af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af4:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107afb:	00 00 
80107afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b00:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b0a:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
80107b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b13:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107b1a:	83 e1 f0             	and    $0xfffffff0,%ecx
80107b1d:	83 c9 02             	or     $0x2,%ecx
80107b20:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b29:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107b30:	83 c9 10             	or     $0x10,%ecx
80107b33:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b3c:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107b43:	83 e1 9f             	and    $0xffffff9f,%ecx
80107b46:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b4f:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
80107b56:	83 c9 80             	or     $0xffffff80,%ecx
80107b59:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80107b5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b62:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107b69:	83 e1 f0             	and    $0xfffffff0,%ecx
80107b6c:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b75:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107b7c:	83 e1 ef             	and    $0xffffffef,%ecx
80107b7f:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b88:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107b8f:	83 e1 df             	and    $0xffffffdf,%ecx
80107b92:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b9b:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107ba2:	83 c9 40             	or     $0x40,%ecx
80107ba5:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bae:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80107bb5:	83 c9 80             	or     $0xffffff80,%ecx
80107bb8:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80107bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bc1:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107bc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bca:	83 c0 70             	add    $0x70,%eax
80107bcd:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80107bd4:	00 
80107bd5:	89 04 24             	mov    %eax,(%esp)
80107bd8:	e8 37 fb ff ff       	call   80107714 <lgdt>
  loadgs(SEG_KCPU << 3);
80107bdd:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80107be4:	e8 6a fb ff ff       	call   80107753 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
80107be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bec:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107bf2:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107bf9:	00 00 00 00 
}
80107bfd:	83 c4 24             	add    $0x24,%esp
80107c00:	5b                   	pop    %ebx
80107c01:	5d                   	pop    %ebp
80107c02:	c3                   	ret    

80107c03 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107c03:	55                   	push   %ebp
80107c04:	89 e5                	mov    %esp,%ebp
80107c06:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107c09:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c0c:	c1 e8 16             	shr    $0x16,%eax
80107c0f:	c1 e0 02             	shl    $0x2,%eax
80107c12:	03 45 08             	add    0x8(%ebp),%eax
80107c15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c1b:	8b 00                	mov    (%eax),%eax
80107c1d:	83 e0 01             	and    $0x1,%eax
80107c20:	84 c0                	test   %al,%al
80107c22:	74 17                	je     80107c3b <walkpgdir+0x38>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107c24:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c27:	8b 00                	mov    (%eax),%eax
80107c29:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107c2e:	89 04 24             	mov    %eax,(%esp)
80107c31:	e8 4a fb ff ff       	call   80107780 <p2v>
80107c36:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c39:	eb 4b                	jmp    80107c86 <walkpgdir+0x83>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107c3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107c3f:	74 0e                	je     80107c4f <walkpgdir+0x4c>
80107c41:	e8 b9 ae ff ff       	call   80102aff <kalloc>
80107c46:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107c49:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107c4d:	75 07                	jne    80107c56 <walkpgdir+0x53>
      return 0;
80107c4f:	b8 00 00 00 00       	mov    $0x0,%eax
80107c54:	eb 41                	jmp    80107c97 <walkpgdir+0x94>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107c56:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107c5d:	00 
80107c5e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107c65:	00 
80107c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c69:	89 04 24             	mov    %eax,(%esp)
80107c6c:	e8 65 d5 ff ff       	call   801051d6 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c74:	89 04 24             	mov    %eax,(%esp)
80107c77:	e8 f7 fa ff ff       	call   80107773 <v2p>
80107c7c:	89 c2                	mov    %eax,%edx
80107c7e:	83 ca 07             	or     $0x7,%edx
80107c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107c84:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107c86:	8b 45 0c             	mov    0xc(%ebp),%eax
80107c89:	c1 e8 0c             	shr    $0xc,%eax
80107c8c:	25 ff 03 00 00       	and    $0x3ff,%eax
80107c91:	c1 e0 02             	shl    $0x2,%eax
80107c94:	03 45 f4             	add    -0xc(%ebp),%eax
}
80107c97:	c9                   	leave  
80107c98:	c3                   	ret    

80107c99 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107c99:	55                   	push   %ebp
80107c9a:	89 e5                	mov    %esp,%ebp
80107c9c:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ca2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107ca7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107caa:	8b 45 0c             	mov    0xc(%ebp),%eax
80107cad:	03 45 10             	add    0x10(%ebp),%eax
80107cb0:	83 e8 01             	sub    $0x1,%eax
80107cb3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107cbb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80107cc2:	00 
80107cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc6:	89 44 24 04          	mov    %eax,0x4(%esp)
80107cca:	8b 45 08             	mov    0x8(%ebp),%eax
80107ccd:	89 04 24             	mov    %eax,(%esp)
80107cd0:	e8 2e ff ff ff       	call   80107c03 <walkpgdir>
80107cd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107cd8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107cdc:	75 07                	jne    80107ce5 <mappages+0x4c>
      return -1;
80107cde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ce3:	eb 46                	jmp    80107d2b <mappages+0x92>
    if(*pte & PTE_P)
80107ce5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107ce8:	8b 00                	mov    (%eax),%eax
80107cea:	83 e0 01             	and    $0x1,%eax
80107ced:	84 c0                	test   %al,%al
80107cef:	74 0c                	je     80107cfd <mappages+0x64>
      panic("remap");
80107cf1:	c7 04 24 10 8b 10 80 	movl   $0x80108b10,(%esp)
80107cf8:	e8 40 88 ff ff       	call   8010053d <panic>
    *pte = pa | perm | PTE_P;
80107cfd:	8b 45 18             	mov    0x18(%ebp),%eax
80107d00:	0b 45 14             	or     0x14(%ebp),%eax
80107d03:	89 c2                	mov    %eax,%edx
80107d05:	83 ca 01             	or     $0x1,%edx
80107d08:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d0b:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107d0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d10:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107d13:	74 10                	je     80107d25 <mappages+0x8c>
      break;
    a += PGSIZE;
80107d15:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107d1c:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80107d23:	eb 96                	jmp    80107cbb <mappages+0x22>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
80107d25:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
80107d26:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d2b:	c9                   	leave  
80107d2c:	c3                   	ret    

80107d2d <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm()
{
80107d2d:	55                   	push   %ebp
80107d2e:	89 e5                	mov    %esp,%ebp
80107d30:	53                   	push   %ebx
80107d31:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107d34:	e8 c6 ad ff ff       	call   80102aff <kalloc>
80107d39:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107d3c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107d40:	75 0a                	jne    80107d4c <setupkvm+0x1f>
    return 0;
80107d42:	b8 00 00 00 00       	mov    $0x0,%eax
80107d47:	e9 98 00 00 00       	jmp    80107de4 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80107d4c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107d53:	00 
80107d54:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107d5b:	00 
80107d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d5f:	89 04 24             	mov    %eax,(%esp)
80107d62:	e8 6f d4 ff ff       	call   801051d6 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
80107d67:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80107d6e:	e8 0d fa ff ff       	call   80107780 <p2v>
80107d73:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80107d78:	76 0c                	jbe    80107d86 <setupkvm+0x59>
    panic("PHYSTOP too high");
80107d7a:	c7 04 24 16 8b 10 80 	movl   $0x80108b16,(%esp)
80107d81:	e8 b7 87 ff ff       	call   8010053d <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107d86:	c7 45 f4 a0 b4 10 80 	movl   $0x8010b4a0,-0xc(%ebp)
80107d8d:	eb 49                	jmp    80107dd8 <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
80107d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107d92:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80107d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80107d98:	8b 50 04             	mov    0x4(%eax),%edx
80107d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d9e:	8b 58 08             	mov    0x8(%eax),%ebx
80107da1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da4:	8b 40 04             	mov    0x4(%eax),%eax
80107da7:	29 c3                	sub    %eax,%ebx
80107da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dac:	8b 00                	mov    (%eax),%eax
80107dae:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80107db2:	89 54 24 0c          	mov    %edx,0xc(%esp)
80107db6:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80107dba:	89 44 24 04          	mov    %eax,0x4(%esp)
80107dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107dc1:	89 04 24             	mov    %eax,(%esp)
80107dc4:	e8 d0 fe ff ff       	call   80107c99 <mappages>
80107dc9:	85 c0                	test   %eax,%eax
80107dcb:	79 07                	jns    80107dd4 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80107dcd:	b8 00 00 00 00       	mov    $0x0,%eax
80107dd2:	eb 10                	jmp    80107de4 <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107dd4:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80107dd8:	81 7d f4 e0 b4 10 80 	cmpl   $0x8010b4e0,-0xc(%ebp)
80107ddf:	72 ae                	jb     80107d8f <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
80107de1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80107de4:	83 c4 34             	add    $0x34,%esp
80107de7:	5b                   	pop    %ebx
80107de8:	5d                   	pop    %ebp
80107de9:	c3                   	ret    

80107dea <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80107dea:	55                   	push   %ebp
80107deb:	89 e5                	mov    %esp,%ebp
80107ded:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107df0:	e8 38 ff ff ff       	call   80107d2d <setupkvm>
80107df5:	a3 f8 2a 11 80       	mov    %eax,0x80112af8
  switchkvm();
80107dfa:	e8 02 00 00 00       	call   80107e01 <switchkvm>
}
80107dff:	c9                   	leave  
80107e00:	c3                   	ret    

80107e01 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80107e01:	55                   	push   %ebp
80107e02:	89 e5                	mov    %esp,%ebp
80107e04:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80107e07:	a1 f8 2a 11 80       	mov    0x80112af8,%eax
80107e0c:	89 04 24             	mov    %eax,(%esp)
80107e0f:	e8 5f f9 ff ff       	call   80107773 <v2p>
80107e14:	89 04 24             	mov    %eax,(%esp)
80107e17:	e8 4c f9 ff ff       	call   80107768 <lcr3>
}
80107e1c:	c9                   	leave  
80107e1d:	c3                   	ret    

80107e1e <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80107e1e:	55                   	push   %ebp
80107e1f:	89 e5                	mov    %esp,%ebp
80107e21:	53                   	push   %ebx
80107e22:	83 ec 14             	sub    $0x14,%esp
  pushcli();
80107e25:	e8 a5 d2 ff ff       	call   801050cf <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80107e2a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107e30:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107e37:	83 c2 08             	add    $0x8,%edx
80107e3a:	89 d3                	mov    %edx,%ebx
80107e3c:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107e43:	83 c2 08             	add    $0x8,%edx
80107e46:	c1 ea 10             	shr    $0x10,%edx
80107e49:	89 d1                	mov    %edx,%ecx
80107e4b:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107e52:	83 c2 08             	add    $0x8,%edx
80107e55:	c1 ea 18             	shr    $0x18,%edx
80107e58:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80107e5f:	67 00 
80107e61:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
80107e68:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80107e6e:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107e75:	83 e1 f0             	and    $0xfffffff0,%ecx
80107e78:	83 c9 09             	or     $0x9,%ecx
80107e7b:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107e81:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107e88:	83 c9 10             	or     $0x10,%ecx
80107e8b:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107e91:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107e98:	83 e1 9f             	and    $0xffffff9f,%ecx
80107e9b:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107ea1:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80107ea8:	83 c9 80             	or     $0xffffff80,%ecx
80107eab:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80107eb1:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107eb8:	83 e1 f0             	and    $0xfffffff0,%ecx
80107ebb:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107ec1:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107ec8:	83 e1 ef             	and    $0xffffffef,%ecx
80107ecb:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107ed1:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107ed8:	83 e1 df             	and    $0xffffffdf,%ecx
80107edb:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107ee1:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107ee8:	83 c9 40             	or     $0x40,%ecx
80107eeb:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107ef1:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
80107ef8:	83 e1 7f             	and    $0x7f,%ecx
80107efb:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80107f01:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80107f07:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f0d:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80107f14:	83 e2 ef             	and    $0xffffffef,%edx
80107f17:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80107f1d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f23:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80107f29:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107f2f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80107f36:	8b 52 08             	mov    0x8(%edx),%edx
80107f39:	81 c2 00 10 00 00    	add    $0x1000,%edx
80107f3f:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80107f42:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
80107f49:	e8 ef f7 ff ff       	call   8010773d <ltr>
  if(p->pgdir == 0)
80107f4e:	8b 45 08             	mov    0x8(%ebp),%eax
80107f51:	8b 40 04             	mov    0x4(%eax),%eax
80107f54:	85 c0                	test   %eax,%eax
80107f56:	75 0c                	jne    80107f64 <switchuvm+0x146>
    panic("switchuvm: no pgdir");
80107f58:	c7 04 24 27 8b 10 80 	movl   $0x80108b27,(%esp)
80107f5f:	e8 d9 85 ff ff       	call   8010053d <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80107f64:	8b 45 08             	mov    0x8(%ebp),%eax
80107f67:	8b 40 04             	mov    0x4(%eax),%eax
80107f6a:	89 04 24             	mov    %eax,(%esp)
80107f6d:	e8 01 f8 ff ff       	call   80107773 <v2p>
80107f72:	89 04 24             	mov    %eax,(%esp)
80107f75:	e8 ee f7 ff ff       	call   80107768 <lcr3>
  popcli();
80107f7a:	e8 98 d1 ff ff       	call   80105117 <popcli>
}
80107f7f:	83 c4 14             	add    $0x14,%esp
80107f82:	5b                   	pop    %ebx
80107f83:	5d                   	pop    %ebp
80107f84:	c3                   	ret    

80107f85 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80107f85:	55                   	push   %ebp
80107f86:	89 e5                	mov    %esp,%ebp
80107f88:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80107f8b:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80107f92:	76 0c                	jbe    80107fa0 <inituvm+0x1b>
    panic("inituvm: more than a page");
80107f94:	c7 04 24 3b 8b 10 80 	movl   $0x80108b3b,(%esp)
80107f9b:	e8 9d 85 ff ff       	call   8010053d <panic>
  mem = kalloc();
80107fa0:	e8 5a ab ff ff       	call   80102aff <kalloc>
80107fa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80107fa8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107faf:	00 
80107fb0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107fb7:	00 
80107fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fbb:	89 04 24             	mov    %eax,(%esp)
80107fbe:	e8 13 d2 ff ff       	call   801051d6 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80107fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc6:	89 04 24             	mov    %eax,(%esp)
80107fc9:	e8 a5 f7 ff ff       	call   80107773 <v2p>
80107fce:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80107fd5:	00 
80107fd6:	89 44 24 0c          	mov    %eax,0xc(%esp)
80107fda:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80107fe1:	00 
80107fe2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107fe9:	00 
80107fea:	8b 45 08             	mov    0x8(%ebp),%eax
80107fed:	89 04 24             	mov    %eax,(%esp)
80107ff0:	e8 a4 fc ff ff       	call   80107c99 <mappages>
  memmove(mem, init, sz);
80107ff5:	8b 45 10             	mov    0x10(%ebp),%eax
80107ff8:	89 44 24 08          	mov    %eax,0x8(%esp)
80107ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
80107fff:	89 44 24 04          	mov    %eax,0x4(%esp)
80108003:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108006:	89 04 24             	mov    %eax,(%esp)
80108009:	e8 9b d2 ff ff       	call   801052a9 <memmove>
}
8010800e:	c9                   	leave  
8010800f:	c3                   	ret    

80108010 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80108010:	55                   	push   %ebp
80108011:	89 e5                	mov    %esp,%ebp
80108013:	53                   	push   %ebx
80108014:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80108017:	8b 45 0c             	mov    0xc(%ebp),%eax
8010801a:	25 ff 0f 00 00       	and    $0xfff,%eax
8010801f:	85 c0                	test   %eax,%eax
80108021:	74 0c                	je     8010802f <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
80108023:	c7 04 24 58 8b 10 80 	movl   $0x80108b58,(%esp)
8010802a:	e8 0e 85 ff ff       	call   8010053d <panic>
  for(i = 0; i < sz; i += PGSIZE){
8010802f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108036:	e9 ad 00 00 00       	jmp    801080e8 <loaduvm+0xd8>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010803b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010803e:	8b 55 0c             	mov    0xc(%ebp),%edx
80108041:	01 d0                	add    %edx,%eax
80108043:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010804a:	00 
8010804b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010804f:	8b 45 08             	mov    0x8(%ebp),%eax
80108052:	89 04 24             	mov    %eax,(%esp)
80108055:	e8 a9 fb ff ff       	call   80107c03 <walkpgdir>
8010805a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010805d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108061:	75 0c                	jne    8010806f <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80108063:	c7 04 24 7b 8b 10 80 	movl   $0x80108b7b,(%esp)
8010806a:	e8 ce 84 ff ff       	call   8010053d <panic>
    pa = PTE_ADDR(*pte);
8010806f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108072:	8b 00                	mov    (%eax),%eax
80108074:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108079:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
8010807c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010807f:	8b 55 18             	mov    0x18(%ebp),%edx
80108082:	89 d1                	mov    %edx,%ecx
80108084:	29 c1                	sub    %eax,%ecx
80108086:	89 c8                	mov    %ecx,%eax
80108088:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010808d:	77 11                	ja     801080a0 <loaduvm+0x90>
      n = sz - i;
8010808f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108092:	8b 55 18             	mov    0x18(%ebp),%edx
80108095:	89 d1                	mov    %edx,%ecx
80108097:	29 c1                	sub    %eax,%ecx
80108099:	89 c8                	mov    %ecx,%eax
8010809b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010809e:	eb 07                	jmp    801080a7 <loaduvm+0x97>
    else
      n = PGSIZE;
801080a0:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
801080a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080aa:	8b 55 14             	mov    0x14(%ebp),%edx
801080ad:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801080b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801080b3:	89 04 24             	mov    %eax,(%esp)
801080b6:	e8 c5 f6 ff ff       	call   80107780 <p2v>
801080bb:	8b 55 f0             	mov    -0x10(%ebp),%edx
801080be:	89 54 24 0c          	mov    %edx,0xc(%esp)
801080c2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801080c6:	89 44 24 04          	mov    %eax,0x4(%esp)
801080ca:	8b 45 10             	mov    0x10(%ebp),%eax
801080cd:	89 04 24             	mov    %eax,(%esp)
801080d0:	e8 89 9c ff ff       	call   80101d5e <readi>
801080d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801080d8:	74 07                	je     801080e1 <loaduvm+0xd1>
      return -1;
801080da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080df:	eb 18                	jmp    801080f9 <loaduvm+0xe9>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801080e1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801080e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080eb:	3b 45 18             	cmp    0x18(%ebp),%eax
801080ee:	0f 82 47 ff ff ff    	jb     8010803b <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801080f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801080f9:	83 c4 24             	add    $0x24,%esp
801080fc:	5b                   	pop    %ebx
801080fd:	5d                   	pop    %ebp
801080fe:	c3                   	ret    

801080ff <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801080ff:	55                   	push   %ebp
80108100:	89 e5                	mov    %esp,%ebp
80108102:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108105:	8b 45 10             	mov    0x10(%ebp),%eax
80108108:	85 c0                	test   %eax,%eax
8010810a:	79 0a                	jns    80108116 <allocuvm+0x17>
    return 0;
8010810c:	b8 00 00 00 00       	mov    $0x0,%eax
80108111:	e9 c1 00 00 00       	jmp    801081d7 <allocuvm+0xd8>
  if(newsz < oldsz)
80108116:	8b 45 10             	mov    0x10(%ebp),%eax
80108119:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010811c:	73 08                	jae    80108126 <allocuvm+0x27>
    return oldsz;
8010811e:	8b 45 0c             	mov    0xc(%ebp),%eax
80108121:	e9 b1 00 00 00       	jmp    801081d7 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
80108126:	8b 45 0c             	mov    0xc(%ebp),%eax
80108129:	05 ff 0f 00 00       	add    $0xfff,%eax
8010812e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108133:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80108136:	e9 8d 00 00 00       	jmp    801081c8 <allocuvm+0xc9>
    mem = kalloc();
8010813b:	e8 bf a9 ff ff       	call   80102aff <kalloc>
80108140:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108143:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108147:	75 2c                	jne    80108175 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80108149:	c7 04 24 99 8b 10 80 	movl   $0x80108b99,(%esp)
80108150:	e8 4c 82 ff ff       	call   801003a1 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108155:	8b 45 0c             	mov    0xc(%ebp),%eax
80108158:	89 44 24 08          	mov    %eax,0x8(%esp)
8010815c:	8b 45 10             	mov    0x10(%ebp),%eax
8010815f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108163:	8b 45 08             	mov    0x8(%ebp),%eax
80108166:	89 04 24             	mov    %eax,(%esp)
80108169:	e8 6b 00 00 00       	call   801081d9 <deallocuvm>
      return 0;
8010816e:	b8 00 00 00 00       	mov    $0x0,%eax
80108173:	eb 62                	jmp    801081d7 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80108175:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010817c:	00 
8010817d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108184:	00 
80108185:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108188:	89 04 24             	mov    %eax,(%esp)
8010818b:	e8 46 d0 ff ff       	call   801051d6 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108190:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108193:	89 04 24             	mov    %eax,(%esp)
80108196:	e8 d8 f5 ff ff       	call   80107773 <v2p>
8010819b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010819e:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
801081a5:	00 
801081a6:	89 44 24 0c          	mov    %eax,0xc(%esp)
801081aa:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801081b1:	00 
801081b2:	89 54 24 04          	mov    %edx,0x4(%esp)
801081b6:	8b 45 08             	mov    0x8(%ebp),%eax
801081b9:	89 04 24             	mov    %eax,(%esp)
801081bc:	e8 d8 fa ff ff       	call   80107c99 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
801081c1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801081c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081cb:	3b 45 10             	cmp    0x10(%ebp),%eax
801081ce:	0f 82 67 ff ff ff    	jb     8010813b <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
801081d4:	8b 45 10             	mov    0x10(%ebp),%eax
}
801081d7:	c9                   	leave  
801081d8:	c3                   	ret    

801081d9 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801081d9:	55                   	push   %ebp
801081da:	89 e5                	mov    %esp,%ebp
801081dc:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801081df:	8b 45 10             	mov    0x10(%ebp),%eax
801081e2:	3b 45 0c             	cmp    0xc(%ebp),%eax
801081e5:	72 08                	jb     801081ef <deallocuvm+0x16>
    return oldsz;
801081e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801081ea:	e9 a4 00 00 00       	jmp    80108293 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
801081ef:	8b 45 10             	mov    0x10(%ebp),%eax
801081f2:	05 ff 0f 00 00       	add    $0xfff,%eax
801081f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801081fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801081ff:	e9 80 00 00 00       	jmp    80108284 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108204:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108207:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010820e:	00 
8010820f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108213:	8b 45 08             	mov    0x8(%ebp),%eax
80108216:	89 04 24             	mov    %eax,(%esp)
80108219:	e8 e5 f9 ff ff       	call   80107c03 <walkpgdir>
8010821e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80108221:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108225:	75 09                	jne    80108230 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
80108227:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
8010822e:	eb 4d                	jmp    8010827d <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
80108230:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108233:	8b 00                	mov    (%eax),%eax
80108235:	83 e0 01             	and    $0x1,%eax
80108238:	84 c0                	test   %al,%al
8010823a:	74 41                	je     8010827d <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
8010823c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010823f:	8b 00                	mov    (%eax),%eax
80108241:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108246:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108249:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010824d:	75 0c                	jne    8010825b <deallocuvm+0x82>
        panic("kfree");
8010824f:	c7 04 24 b1 8b 10 80 	movl   $0x80108bb1,(%esp)
80108256:	e8 e2 82 ff ff       	call   8010053d <panic>
      char *v = p2v(pa);
8010825b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010825e:	89 04 24             	mov    %eax,(%esp)
80108261:	e8 1a f5 ff ff       	call   80107780 <p2v>
80108266:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108269:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010826c:	89 04 24             	mov    %eax,(%esp)
8010826f:	e8 f2 a7 ff ff       	call   80102a66 <kfree>
      *pte = 0;
80108274:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108277:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010827d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108284:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108287:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010828a:	0f 82 74 ff ff ff    	jb     80108204 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108290:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108293:	c9                   	leave  
80108294:	c3                   	ret    

80108295 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108295:	55                   	push   %ebp
80108296:	89 e5                	mov    %esp,%ebp
80108298:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
8010829b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010829f:	75 0c                	jne    801082ad <freevm+0x18>
    panic("freevm: no pgdir");
801082a1:	c7 04 24 b7 8b 10 80 	movl   $0x80108bb7,(%esp)
801082a8:	e8 90 82 ff ff       	call   8010053d <panic>
  deallocuvm(pgdir, KERNBASE, 0);
801082ad:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801082b4:	00 
801082b5:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
801082bc:	80 
801082bd:	8b 45 08             	mov    0x8(%ebp),%eax
801082c0:	89 04 24             	mov    %eax,(%esp)
801082c3:	e8 11 ff ff ff       	call   801081d9 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
801082c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801082cf:	eb 3c                	jmp    8010830d <freevm+0x78>
    if(pgdir[i] & PTE_P){
801082d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082d4:	c1 e0 02             	shl    $0x2,%eax
801082d7:	03 45 08             	add    0x8(%ebp),%eax
801082da:	8b 00                	mov    (%eax),%eax
801082dc:	83 e0 01             	and    $0x1,%eax
801082df:	84 c0                	test   %al,%al
801082e1:	74 26                	je     80108309 <freevm+0x74>
      char * v = p2v(PTE_ADDR(pgdir[i]));
801082e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082e6:	c1 e0 02             	shl    $0x2,%eax
801082e9:	03 45 08             	add    0x8(%ebp),%eax
801082ec:	8b 00                	mov    (%eax),%eax
801082ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801082f3:	89 04 24             	mov    %eax,(%esp)
801082f6:	e8 85 f4 ff ff       	call   80107780 <p2v>
801082fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
801082fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108301:	89 04 24             	mov    %eax,(%esp)
80108304:	e8 5d a7 ff ff       	call   80102a66 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108309:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010830d:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108314:	76 bb                	jbe    801082d1 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108316:	8b 45 08             	mov    0x8(%ebp),%eax
80108319:	89 04 24             	mov    %eax,(%esp)
8010831c:	e8 45 a7 ff ff       	call   80102a66 <kfree>
}
80108321:	c9                   	leave  
80108322:	c3                   	ret    

80108323 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108323:	55                   	push   %ebp
80108324:	89 e5                	mov    %esp,%ebp
80108326:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108329:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108330:	00 
80108331:	8b 45 0c             	mov    0xc(%ebp),%eax
80108334:	89 44 24 04          	mov    %eax,0x4(%esp)
80108338:	8b 45 08             	mov    0x8(%ebp),%eax
8010833b:	89 04 24             	mov    %eax,(%esp)
8010833e:	e8 c0 f8 ff ff       	call   80107c03 <walkpgdir>
80108343:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108346:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010834a:	75 0c                	jne    80108358 <clearpteu+0x35>
    panic("clearpteu");
8010834c:	c7 04 24 c8 8b 10 80 	movl   $0x80108bc8,(%esp)
80108353:	e8 e5 81 ff ff       	call   8010053d <panic>
  *pte &= ~PTE_U;
80108358:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010835b:	8b 00                	mov    (%eax),%eax
8010835d:	89 c2                	mov    %eax,%edx
8010835f:	83 e2 fb             	and    $0xfffffffb,%edx
80108362:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108365:	89 10                	mov    %edx,(%eax)
}
80108367:	c9                   	leave  
80108368:	c3                   	ret    

80108369 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108369:	55                   	push   %ebp
8010836a:	89 e5                	mov    %esp,%ebp
8010836c:	83 ec 48             	sub    $0x48,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
8010836f:	e8 b9 f9 ff ff       	call   80107d2d <setupkvm>
80108374:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108377:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010837b:	75 0a                	jne    80108387 <copyuvm+0x1e>
    return 0;
8010837d:	b8 00 00 00 00       	mov    $0x0,%eax
80108382:	e9 f1 00 00 00       	jmp    80108478 <copyuvm+0x10f>
  for(i = 0; i < sz; i += PGSIZE){
80108387:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010838e:	e9 c0 00 00 00       	jmp    80108453 <copyuvm+0xea>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108393:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108396:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010839d:	00 
8010839e:	89 44 24 04          	mov    %eax,0x4(%esp)
801083a2:	8b 45 08             	mov    0x8(%ebp),%eax
801083a5:	89 04 24             	mov    %eax,(%esp)
801083a8:	e8 56 f8 ff ff       	call   80107c03 <walkpgdir>
801083ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
801083b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801083b4:	75 0c                	jne    801083c2 <copyuvm+0x59>
      panic("copyuvm: pte should exist");
801083b6:	c7 04 24 d2 8b 10 80 	movl   $0x80108bd2,(%esp)
801083bd:	e8 7b 81 ff ff       	call   8010053d <panic>
    if(!(*pte & PTE_P))
801083c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083c5:	8b 00                	mov    (%eax),%eax
801083c7:	83 e0 01             	and    $0x1,%eax
801083ca:	85 c0                	test   %eax,%eax
801083cc:	75 0c                	jne    801083da <copyuvm+0x71>
      panic("copyuvm: page not present");
801083ce:	c7 04 24 ec 8b 10 80 	movl   $0x80108bec,(%esp)
801083d5:	e8 63 81 ff ff       	call   8010053d <panic>
    pa = PTE_ADDR(*pte);
801083da:	8b 45 ec             	mov    -0x14(%ebp),%eax
801083dd:	8b 00                	mov    (%eax),%eax
801083df:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if((mem = kalloc()) == 0)
801083e7:	e8 13 a7 ff ff       	call   80102aff <kalloc>
801083ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801083ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
801083f3:	74 6f                	je     80108464 <copyuvm+0xfb>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
801083f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801083f8:	89 04 24             	mov    %eax,(%esp)
801083fb:	e8 80 f3 ff ff       	call   80107780 <p2v>
80108400:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108407:	00 
80108408:	89 44 24 04          	mov    %eax,0x4(%esp)
8010840c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010840f:	89 04 24             	mov    %eax,(%esp)
80108412:	e8 92 ce ff ff       	call   801052a9 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
80108417:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010841a:	89 04 24             	mov    %eax,(%esp)
8010841d:	e8 51 f3 ff ff       	call   80107773 <v2p>
80108422:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108425:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
8010842c:	00 
8010842d:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108431:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108438:	00 
80108439:	89 54 24 04          	mov    %edx,0x4(%esp)
8010843d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108440:	89 04 24             	mov    %eax,(%esp)
80108443:	e8 51 f8 ff ff       	call   80107c99 <mappages>
80108448:	85 c0                	test   %eax,%eax
8010844a:	78 1b                	js     80108467 <copyuvm+0xfe>
  uint pa, i;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010844c:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108453:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108456:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108459:	0f 82 34 ff ff ff    	jb     80108393 <copyuvm+0x2a>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
      goto bad;
  }
  return d;
8010845f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108462:	eb 14                	jmp    80108478 <copyuvm+0x10f>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80108464:	90                   	nop
80108465:	eb 01                	jmp    80108468 <copyuvm+0xff>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), PTE_W|PTE_U) < 0)
      goto bad;
80108467:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80108468:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010846b:	89 04 24             	mov    %eax,(%esp)
8010846e:	e8 22 fe ff ff       	call   80108295 <freevm>
  return 0;
80108473:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108478:	c9                   	leave  
80108479:	c3                   	ret    

8010847a <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010847a:	55                   	push   %ebp
8010847b:	89 e5                	mov    %esp,%ebp
8010847d:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108480:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108487:	00 
80108488:	8b 45 0c             	mov    0xc(%ebp),%eax
8010848b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010848f:	8b 45 08             	mov    0x8(%ebp),%eax
80108492:	89 04 24             	mov    %eax,(%esp)
80108495:	e8 69 f7 ff ff       	call   80107c03 <walkpgdir>
8010849a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010849d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084a0:	8b 00                	mov    (%eax),%eax
801084a2:	83 e0 01             	and    $0x1,%eax
801084a5:	85 c0                	test   %eax,%eax
801084a7:	75 07                	jne    801084b0 <uva2ka+0x36>
    return 0;
801084a9:	b8 00 00 00 00       	mov    $0x0,%eax
801084ae:	eb 25                	jmp    801084d5 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
801084b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084b3:	8b 00                	mov    (%eax),%eax
801084b5:	83 e0 04             	and    $0x4,%eax
801084b8:	85 c0                	test   %eax,%eax
801084ba:	75 07                	jne    801084c3 <uva2ka+0x49>
    return 0;
801084bc:	b8 00 00 00 00       	mov    $0x0,%eax
801084c1:	eb 12                	jmp    801084d5 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
801084c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084c6:	8b 00                	mov    (%eax),%eax
801084c8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084cd:	89 04 24             	mov    %eax,(%esp)
801084d0:	e8 ab f2 ff ff       	call   80107780 <p2v>
}
801084d5:	c9                   	leave  
801084d6:	c3                   	ret    

801084d7 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801084d7:	55                   	push   %ebp
801084d8:	89 e5                	mov    %esp,%ebp
801084da:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
801084dd:	8b 45 10             	mov    0x10(%ebp),%eax
801084e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
801084e3:	e9 8b 00 00 00       	jmp    80108573 <copyout+0x9c>
    va0 = (uint)PGROUNDDOWN(va);
801084e8:	8b 45 0c             	mov    0xc(%ebp),%eax
801084eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
801084f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084f6:	89 44 24 04          	mov    %eax,0x4(%esp)
801084fa:	8b 45 08             	mov    0x8(%ebp),%eax
801084fd:	89 04 24             	mov    %eax,(%esp)
80108500:	e8 75 ff ff ff       	call   8010847a <uva2ka>
80108505:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108508:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010850c:	75 07                	jne    80108515 <copyout+0x3e>
      return -1;
8010850e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108513:	eb 6d                	jmp    80108582 <copyout+0xab>
    n = PGSIZE - (va - va0);
80108515:	8b 45 0c             	mov    0xc(%ebp),%eax
80108518:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010851b:	89 d1                	mov    %edx,%ecx
8010851d:	29 c1                	sub    %eax,%ecx
8010851f:	89 c8                	mov    %ecx,%eax
80108521:	05 00 10 00 00       	add    $0x1000,%eax
80108526:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108529:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010852c:	3b 45 14             	cmp    0x14(%ebp),%eax
8010852f:	76 06                	jbe    80108537 <copyout+0x60>
      n = len;
80108531:	8b 45 14             	mov    0x14(%ebp),%eax
80108534:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108537:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010853a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010853d:	89 d1                	mov    %edx,%ecx
8010853f:	29 c1                	sub    %eax,%ecx
80108541:	89 c8                	mov    %ecx,%eax
80108543:	03 45 e8             	add    -0x18(%ebp),%eax
80108546:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108549:	89 54 24 08          	mov    %edx,0x8(%esp)
8010854d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108550:	89 54 24 04          	mov    %edx,0x4(%esp)
80108554:	89 04 24             	mov    %eax,(%esp)
80108557:	e8 4d cd ff ff       	call   801052a9 <memmove>
    len -= n;
8010855c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010855f:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108562:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108565:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108568:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010856b:	05 00 10 00 00       	add    $0x1000,%eax
80108570:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108573:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108577:	0f 85 6b ff ff ff    	jne    801084e8 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010857d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108582:	c9                   	leave  
80108583:	c3                   	ret    
