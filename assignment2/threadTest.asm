
_threadTest:     file format elf32-i386


Disassembly of section .text:

00000000 <print>:
#include "user.h"

int lock;

void *print()
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 24             	sub    $0x24,%esp
  for(;;)
  {
    int i=0;
   7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    binary_semaphore_down(lock);
   e:	a1 80 0d 00 00       	mov    0xd80,%eax
  13:	89 04 24             	mov    %eax,(%esp)
  16:	e8 55 04 00 00       	call   470 <binary_semaphore_down>
    for(;i<3;i++)
  1b:	eb 2c                	jmp    49 <print+0x49>
      printf(1,"Process %d Thread %d is running.\n",thread_getProcId(),thread_getId());
  1d:	e8 26 04 00 00       	call   448 <thread_getId>
  22:	89 c3                	mov    %eax,%ebx
  24:	e8 27 04 00 00       	call   450 <thread_getProcId>
  29:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  2d:	89 44 24 08          	mov    %eax,0x8(%esp)
  31:	c7 44 24 04 30 0a 00 	movl   $0xa30,0x4(%esp)
  38:	00 
  39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  40:	e8 12 05 00 00       	call   557 <printf>
{
  for(;;)
  {
    int i=0;
    binary_semaphore_down(lock);
    for(;i<3;i++)
  45:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  49:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
  4d:	7e ce                	jle    1d <print+0x1d>
      printf(1,"Process %d Thread %d is running.\n",thread_getProcId(),thread_getId());
    binary_semaphore_up(lock);
  4f:	a1 80 0d 00 00       	mov    0xd80,%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 1c 04 00 00       	call   478 <binary_semaphore_up>
  }
  5c:	eb a9                	jmp    7 <print+0x7>

0000005e <threadTest>:
}


void
threadTest(char* n)
{
  5e:	55                   	push   %ebp
  5f:	89 e5                	mov    %esp,%ebp
  61:	83 ec 28             	sub    $0x28,%esp
  int value = 0;
  64:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  lock = binary_semaphore_create(1);
  6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  72:	e8 f1 03 00 00       	call   468 <binary_semaphore_create>
  77:	a3 80 0d 00 00       	mov    %eax,0xd80
  int num = atoi(n);
  7c:	8b 45 08             	mov    0x8(%ebp),%eax
  7f:	89 04 24             	mov    %eax,(%esp)
  82:	e8 88 02 00 00       	call   30f <atoi>
  87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(;num>0;num--)
  8a:	eb 72                	jmp    fe <threadTest+0xa0>
  {
    uint stack_size = 1024;
  8c:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
    void* stack = malloc(stack_size);
  93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  96:	89 04 24             	mov    %eax,(%esp)
  99:	e8 9d 07 00 00       	call   83b <malloc>
  9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    value = thread_create(print,stack,stack_size);
  a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  b6:	e8 85 03 00 00       	call   440 <thread_create>
  bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    printf(1,"%d\n",value);
  be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  c5:	c7 44 24 04 52 0a 00 	movl   $0xa52,0x4(%esp)
  cc:	00 
  cd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d4:	e8 7e 04 00 00       	call   557 <printf>
    if(value == -1)
  d9:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  dd:	75 1b                	jne    fa <threadTest+0x9c>
      printf(1,"Failed to create thread number %d\n",num);
  df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  e6:	c7 44 24 04 58 0a 00 	movl   $0xa58,0x4(%esp)
  ed:	00 
  ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  f5:	e8 5d 04 00 00       	call   557 <printf>
threadTest(char* n)
{
  int value = 0;
  lock = binary_semaphore_create(1);
  int num = atoi(n);
  for(;num>0;num--)
  fa:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  fe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 102:	7f 88                	jg     8c <threadTest+0x2e>
    value = thread_create(print,stack,stack_size);
    printf(1,"%d\n",value);
    if(value == -1)
      printf(1,"Failed to create thread number %d\n",num);
  }
}
 104:	c9                   	leave  
 105:	c3                   	ret    

00000106 <main>:



int
main(int argc, char** argv)
{
 106:	55                   	push   %ebp
 107:	89 e5                	mov    %esp,%ebp
 109:	83 e4 f0             	and    $0xfffffff0,%esp
 10c:	83 ec 20             	sub    $0x20,%esp
  void * ret_val = 0;
 10f:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
 116:	00 
  threadTest(argv[1]);
 117:	8b 45 0c             	mov    0xc(%ebp),%eax
 11a:	83 c0 04             	add    $0x4,%eax
 11d:	8b 00                	mov    (%eax),%eax
 11f:	89 04 24             	mov    %eax,(%esp)
 122:	e8 37 ff ff ff       	call   5e <threadTest>
  thread_exit(ret_val);
 127:	8b 44 24 1c          	mov    0x1c(%esp),%eax
 12b:	89 04 24             	mov    %eax,(%esp)
 12e:	e8 2d 03 00 00       	call   460 <thread_exit>
  return 0;
 133:	b8 00 00 00 00       	mov    $0x0,%eax
 138:	c9                   	leave  
 139:	c3                   	ret    
 13a:	90                   	nop
 13b:	90                   	nop

0000013c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 13c:	55                   	push   %ebp
 13d:	89 e5                	mov    %esp,%ebp
 13f:	57                   	push   %edi
 140:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 141:	8b 4d 08             	mov    0x8(%ebp),%ecx
 144:	8b 55 10             	mov    0x10(%ebp),%edx
 147:	8b 45 0c             	mov    0xc(%ebp),%eax
 14a:	89 cb                	mov    %ecx,%ebx
 14c:	89 df                	mov    %ebx,%edi
 14e:	89 d1                	mov    %edx,%ecx
 150:	fc                   	cld    
 151:	f3 aa                	rep stos %al,%es:(%edi)
 153:	89 ca                	mov    %ecx,%edx
 155:	89 fb                	mov    %edi,%ebx
 157:	89 5d 08             	mov    %ebx,0x8(%ebp)
 15a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 15d:	5b                   	pop    %ebx
 15e:	5f                   	pop    %edi
 15f:	5d                   	pop    %ebp
 160:	c3                   	ret    

00000161 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 161:	55                   	push   %ebp
 162:	89 e5                	mov    %esp,%ebp
 164:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 167:	8b 45 08             	mov    0x8(%ebp),%eax
 16a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 16d:	90                   	nop
 16e:	8b 45 0c             	mov    0xc(%ebp),%eax
 171:	0f b6 10             	movzbl (%eax),%edx
 174:	8b 45 08             	mov    0x8(%ebp),%eax
 177:	88 10                	mov    %dl,(%eax)
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	0f b6 00             	movzbl (%eax),%eax
 17f:	84 c0                	test   %al,%al
 181:	0f 95 c0             	setne  %al
 184:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 188:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 18c:	84 c0                	test   %al,%al
 18e:	75 de                	jne    16e <strcpy+0xd>
    ;
  return os;
 190:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 193:	c9                   	leave  
 194:	c3                   	ret    

00000195 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 195:	55                   	push   %ebp
 196:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 198:	eb 08                	jmp    1a2 <strcmp+0xd>
    p++, q++;
 19a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 19e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1a2:	8b 45 08             	mov    0x8(%ebp),%eax
 1a5:	0f b6 00             	movzbl (%eax),%eax
 1a8:	84 c0                	test   %al,%al
 1aa:	74 10                	je     1bc <strcmp+0x27>
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	0f b6 10             	movzbl (%eax),%edx
 1b2:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b5:	0f b6 00             	movzbl (%eax),%eax
 1b8:	38 c2                	cmp    %al,%dl
 1ba:	74 de                	je     19a <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1bc:	8b 45 08             	mov    0x8(%ebp),%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	0f b6 d0             	movzbl %al,%edx
 1c5:	8b 45 0c             	mov    0xc(%ebp),%eax
 1c8:	0f b6 00             	movzbl (%eax),%eax
 1cb:	0f b6 c0             	movzbl %al,%eax
 1ce:	89 d1                	mov    %edx,%ecx
 1d0:	29 c1                	sub    %eax,%ecx
 1d2:	89 c8                	mov    %ecx,%eax
}
 1d4:	5d                   	pop    %ebp
 1d5:	c3                   	ret    

000001d6 <strlen>:

uint
strlen(char *s)
{
 1d6:	55                   	push   %ebp
 1d7:	89 e5                	mov    %esp,%ebp
 1d9:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1dc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1e3:	eb 04                	jmp    1e9 <strlen+0x13>
 1e5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1ec:	03 45 08             	add    0x8(%ebp),%eax
 1ef:	0f b6 00             	movzbl (%eax),%eax
 1f2:	84 c0                	test   %al,%al
 1f4:	75 ef                	jne    1e5 <strlen+0xf>
    ;
  return n;
 1f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1f9:	c9                   	leave  
 1fa:	c3                   	ret    

000001fb <memset>:

void*
memset(void *dst, int c, uint n)
{
 1fb:	55                   	push   %ebp
 1fc:	89 e5                	mov    %esp,%ebp
 1fe:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 201:	8b 45 10             	mov    0x10(%ebp),%eax
 204:	89 44 24 08          	mov    %eax,0x8(%esp)
 208:	8b 45 0c             	mov    0xc(%ebp),%eax
 20b:	89 44 24 04          	mov    %eax,0x4(%esp)
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	89 04 24             	mov    %eax,(%esp)
 215:	e8 22 ff ff ff       	call   13c <stosb>
  return dst;
 21a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 21d:	c9                   	leave  
 21e:	c3                   	ret    

0000021f <strchr>:

char*
strchr(const char *s, char c)
{
 21f:	55                   	push   %ebp
 220:	89 e5                	mov    %esp,%ebp
 222:	83 ec 04             	sub    $0x4,%esp
 225:	8b 45 0c             	mov    0xc(%ebp),%eax
 228:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 22b:	eb 14                	jmp    241 <strchr+0x22>
    if(*s == c)
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	0f b6 00             	movzbl (%eax),%eax
 233:	3a 45 fc             	cmp    -0x4(%ebp),%al
 236:	75 05                	jne    23d <strchr+0x1e>
      return (char*)s;
 238:	8b 45 08             	mov    0x8(%ebp),%eax
 23b:	eb 13                	jmp    250 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 23d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 241:	8b 45 08             	mov    0x8(%ebp),%eax
 244:	0f b6 00             	movzbl (%eax),%eax
 247:	84 c0                	test   %al,%al
 249:	75 e2                	jne    22d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 24b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 250:	c9                   	leave  
 251:	c3                   	ret    

00000252 <gets>:

char*
gets(char *buf, int max)
{
 252:	55                   	push   %ebp
 253:	89 e5                	mov    %esp,%ebp
 255:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 258:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 25f:	eb 44                	jmp    2a5 <gets+0x53>
    cc = read(0, &c, 1);
 261:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 268:	00 
 269:	8d 45 ef             	lea    -0x11(%ebp),%eax
 26c:	89 44 24 04          	mov    %eax,0x4(%esp)
 270:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 277:	e8 3c 01 00 00       	call   3b8 <read>
 27c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 27f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 283:	7e 2d                	jle    2b2 <gets+0x60>
      break;
    buf[i++] = c;
 285:	8b 45 f4             	mov    -0xc(%ebp),%eax
 288:	03 45 08             	add    0x8(%ebp),%eax
 28b:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 28f:	88 10                	mov    %dl,(%eax)
 291:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 295:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 299:	3c 0a                	cmp    $0xa,%al
 29b:	74 16                	je     2b3 <gets+0x61>
 29d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2a1:	3c 0d                	cmp    $0xd,%al
 2a3:	74 0e                	je     2b3 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2a8:	83 c0 01             	add    $0x1,%eax
 2ab:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2ae:	7c b1                	jl     261 <gets+0xf>
 2b0:	eb 01                	jmp    2b3 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2b2:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b6:	03 45 08             	add    0x8(%ebp),%eax
 2b9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2bc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2bf:	c9                   	leave  
 2c0:	c3                   	ret    

000002c1 <stat>:

int
stat(char *n, struct stat *st)
{
 2c1:	55                   	push   %ebp
 2c2:	89 e5                	mov    %esp,%ebp
 2c4:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2ce:	00 
 2cf:	8b 45 08             	mov    0x8(%ebp),%eax
 2d2:	89 04 24             	mov    %eax,(%esp)
 2d5:	e8 06 01 00 00       	call   3e0 <open>
 2da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2e1:	79 07                	jns    2ea <stat+0x29>
    return -1;
 2e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2e8:	eb 23                	jmp    30d <stat+0x4c>
  r = fstat(fd, st);
 2ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 2ed:	89 44 24 04          	mov    %eax,0x4(%esp)
 2f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2f4:	89 04 24             	mov    %eax,(%esp)
 2f7:	e8 fc 00 00 00       	call   3f8 <fstat>
 2fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
 302:	89 04 24             	mov    %eax,(%esp)
 305:	e8 be 00 00 00       	call   3c8 <close>
  return r;
 30a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 30d:	c9                   	leave  
 30e:	c3                   	ret    

0000030f <atoi>:

int
atoi(const char *s)
{
 30f:	55                   	push   %ebp
 310:	89 e5                	mov    %esp,%ebp
 312:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 315:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 31c:	eb 23                	jmp    341 <atoi+0x32>
    n = n*10 + *s++ - '0';
 31e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 321:	89 d0                	mov    %edx,%eax
 323:	c1 e0 02             	shl    $0x2,%eax
 326:	01 d0                	add    %edx,%eax
 328:	01 c0                	add    %eax,%eax
 32a:	89 c2                	mov    %eax,%edx
 32c:	8b 45 08             	mov    0x8(%ebp),%eax
 32f:	0f b6 00             	movzbl (%eax),%eax
 332:	0f be c0             	movsbl %al,%eax
 335:	01 d0                	add    %edx,%eax
 337:	83 e8 30             	sub    $0x30,%eax
 33a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 33d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 341:	8b 45 08             	mov    0x8(%ebp),%eax
 344:	0f b6 00             	movzbl (%eax),%eax
 347:	3c 2f                	cmp    $0x2f,%al
 349:	7e 0a                	jle    355 <atoi+0x46>
 34b:	8b 45 08             	mov    0x8(%ebp),%eax
 34e:	0f b6 00             	movzbl (%eax),%eax
 351:	3c 39                	cmp    $0x39,%al
 353:	7e c9                	jle    31e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 355:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 358:	c9                   	leave  
 359:	c3                   	ret    

0000035a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 35a:	55                   	push   %ebp
 35b:	89 e5                	mov    %esp,%ebp
 35d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 360:	8b 45 08             	mov    0x8(%ebp),%eax
 363:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 366:	8b 45 0c             	mov    0xc(%ebp),%eax
 369:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 36c:	eb 13                	jmp    381 <memmove+0x27>
    *dst++ = *src++;
 36e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 371:	0f b6 10             	movzbl (%eax),%edx
 374:	8b 45 fc             	mov    -0x4(%ebp),%eax
 377:	88 10                	mov    %dl,(%eax)
 379:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 37d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 381:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 385:	0f 9f c0             	setg   %al
 388:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 38c:	84 c0                	test   %al,%al
 38e:	75 de                	jne    36e <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 390:	8b 45 08             	mov    0x8(%ebp),%eax
}
 393:	c9                   	leave  
 394:	c3                   	ret    
 395:	90                   	nop
 396:	90                   	nop
 397:	90                   	nop

00000398 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 398:	b8 01 00 00 00       	mov    $0x1,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <exit>:
SYSCALL(exit)
 3a0:	b8 02 00 00 00       	mov    $0x2,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <wait>:
SYSCALL(wait)
 3a8:	b8 03 00 00 00       	mov    $0x3,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <pipe>:
SYSCALL(pipe)
 3b0:	b8 04 00 00 00       	mov    $0x4,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <read>:
SYSCALL(read)
 3b8:	b8 05 00 00 00       	mov    $0x5,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <write>:
SYSCALL(write)
 3c0:	b8 10 00 00 00       	mov    $0x10,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <close>:
SYSCALL(close)
 3c8:	b8 15 00 00 00       	mov    $0x15,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <kill>:
SYSCALL(kill)
 3d0:	b8 06 00 00 00       	mov    $0x6,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <exec>:
SYSCALL(exec)
 3d8:	b8 07 00 00 00       	mov    $0x7,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <open>:
SYSCALL(open)
 3e0:	b8 0f 00 00 00       	mov    $0xf,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <mknod>:
SYSCALL(mknod)
 3e8:	b8 11 00 00 00       	mov    $0x11,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <unlink>:
SYSCALL(unlink)
 3f0:	b8 12 00 00 00       	mov    $0x12,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <fstat>:
SYSCALL(fstat)
 3f8:	b8 08 00 00 00       	mov    $0x8,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <link>:
SYSCALL(link)
 400:	b8 13 00 00 00       	mov    $0x13,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <mkdir>:
SYSCALL(mkdir)
 408:	b8 14 00 00 00       	mov    $0x14,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <chdir>:
SYSCALL(chdir)
 410:	b8 09 00 00 00       	mov    $0x9,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <dup>:
SYSCALL(dup)
 418:	b8 0a 00 00 00       	mov    $0xa,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <getpid>:
SYSCALL(getpid)
 420:	b8 0b 00 00 00       	mov    $0xb,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <sbrk>:
SYSCALL(sbrk)
 428:	b8 0c 00 00 00       	mov    $0xc,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <sleep>:
SYSCALL(sleep)
 430:	b8 0d 00 00 00       	mov    $0xd,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <uptime>:
SYSCALL(uptime)
 438:	b8 0e 00 00 00       	mov    $0xe,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <thread_create>:
SYSCALL(thread_create)
 440:	b8 16 00 00 00       	mov    $0x16,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <thread_getId>:
SYSCALL(thread_getId)
 448:	b8 17 00 00 00       	mov    $0x17,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <thread_getProcId>:
SYSCALL(thread_getProcId)
 450:	b8 18 00 00 00       	mov    $0x18,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <thread_join>:
SYSCALL(thread_join)
 458:	b8 19 00 00 00       	mov    $0x19,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <thread_exit>:
SYSCALL(thread_exit)
 460:	b8 1a 00 00 00       	mov    $0x1a,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <binary_semaphore_create>:
SYSCALL(binary_semaphore_create)
 468:	b8 1b 00 00 00       	mov    $0x1b,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <binary_semaphore_down>:
SYSCALL(binary_semaphore_down)
 470:	b8 1c 00 00 00       	mov    $0x1c,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <binary_semaphore_up>:
SYSCALL(binary_semaphore_up)
 478:	b8 1d 00 00 00       	mov    $0x1d,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	83 ec 28             	sub    $0x28,%esp
 486:	8b 45 0c             	mov    0xc(%ebp),%eax
 489:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 48c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 493:	00 
 494:	8d 45 f4             	lea    -0xc(%ebp),%eax
 497:	89 44 24 04          	mov    %eax,0x4(%esp)
 49b:	8b 45 08             	mov    0x8(%ebp),%eax
 49e:	89 04 24             	mov    %eax,(%esp)
 4a1:	e8 1a ff ff ff       	call   3c0 <write>
}
 4a6:	c9                   	leave  
 4a7:	c3                   	ret    

000004a8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4a8:	55                   	push   %ebp
 4a9:	89 e5                	mov    %esp,%ebp
 4ab:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4ae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4b5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4b9:	74 17                	je     4d2 <printint+0x2a>
 4bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4bf:	79 11                	jns    4d2 <printint+0x2a>
    neg = 1;
 4c1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 4cb:	f7 d8                	neg    %eax
 4cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4d0:	eb 06                	jmp    4d8 <printint+0x30>
  } else {
    x = xx;
 4d2:	8b 45 0c             	mov    0xc(%ebp),%eax
 4d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4df:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e5:	ba 00 00 00 00       	mov    $0x0,%edx
 4ea:	f7 f1                	div    %ecx
 4ec:	89 d0                	mov    %edx,%eax
 4ee:	0f b6 90 60 0d 00 00 	movzbl 0xd60(%eax),%edx
 4f5:	8d 45 dc             	lea    -0x24(%ebp),%eax
 4f8:	03 45 f4             	add    -0xc(%ebp),%eax
 4fb:	88 10                	mov    %dl,(%eax)
 4fd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 501:	8b 55 10             	mov    0x10(%ebp),%edx
 504:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 507:	8b 45 ec             	mov    -0x14(%ebp),%eax
 50a:	ba 00 00 00 00       	mov    $0x0,%edx
 50f:	f7 75 d4             	divl   -0x2c(%ebp)
 512:	89 45 ec             	mov    %eax,-0x14(%ebp)
 515:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 519:	75 c4                	jne    4df <printint+0x37>
  if(neg)
 51b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 51f:	74 2a                	je     54b <printint+0xa3>
    buf[i++] = '-';
 521:	8d 45 dc             	lea    -0x24(%ebp),%eax
 524:	03 45 f4             	add    -0xc(%ebp),%eax
 527:	c6 00 2d             	movb   $0x2d,(%eax)
 52a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 52e:	eb 1b                	jmp    54b <printint+0xa3>
    putc(fd, buf[i]);
 530:	8d 45 dc             	lea    -0x24(%ebp),%eax
 533:	03 45 f4             	add    -0xc(%ebp),%eax
 536:	0f b6 00             	movzbl (%eax),%eax
 539:	0f be c0             	movsbl %al,%eax
 53c:	89 44 24 04          	mov    %eax,0x4(%esp)
 540:	8b 45 08             	mov    0x8(%ebp),%eax
 543:	89 04 24             	mov    %eax,(%esp)
 546:	e8 35 ff ff ff       	call   480 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 54b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 54f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 553:	79 db                	jns    530 <printint+0x88>
    putc(fd, buf[i]);
}
 555:	c9                   	leave  
 556:	c3                   	ret    

00000557 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 557:	55                   	push   %ebp
 558:	89 e5                	mov    %esp,%ebp
 55a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 55d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 564:	8d 45 0c             	lea    0xc(%ebp),%eax
 567:	83 c0 04             	add    $0x4,%eax
 56a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 56d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 574:	e9 7d 01 00 00       	jmp    6f6 <printf+0x19f>
    c = fmt[i] & 0xff;
 579:	8b 55 0c             	mov    0xc(%ebp),%edx
 57c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 57f:	01 d0                	add    %edx,%eax
 581:	0f b6 00             	movzbl (%eax),%eax
 584:	0f be c0             	movsbl %al,%eax
 587:	25 ff 00 00 00       	and    $0xff,%eax
 58c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 58f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 593:	75 2c                	jne    5c1 <printf+0x6a>
      if(c == '%'){
 595:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 599:	75 0c                	jne    5a7 <printf+0x50>
        state = '%';
 59b:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5a2:	e9 4b 01 00 00       	jmp    6f2 <printf+0x19b>
      } else {
        putc(fd, c);
 5a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5aa:	0f be c0             	movsbl %al,%eax
 5ad:	89 44 24 04          	mov    %eax,0x4(%esp)
 5b1:	8b 45 08             	mov    0x8(%ebp),%eax
 5b4:	89 04 24             	mov    %eax,(%esp)
 5b7:	e8 c4 fe ff ff       	call   480 <putc>
 5bc:	e9 31 01 00 00       	jmp    6f2 <printf+0x19b>
      }
    } else if(state == '%'){
 5c1:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5c5:	0f 85 27 01 00 00    	jne    6f2 <printf+0x19b>
      if(c == 'd'){
 5cb:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5cf:	75 2d                	jne    5fe <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5d4:	8b 00                	mov    (%eax),%eax
 5d6:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5dd:	00 
 5de:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5e5:	00 
 5e6:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ea:	8b 45 08             	mov    0x8(%ebp),%eax
 5ed:	89 04 24             	mov    %eax,(%esp)
 5f0:	e8 b3 fe ff ff       	call   4a8 <printint>
        ap++;
 5f5:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5f9:	e9 ed 00 00 00       	jmp    6eb <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 5fe:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 602:	74 06                	je     60a <printf+0xb3>
 604:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 608:	75 2d                	jne    637 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 60a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60d:	8b 00                	mov    (%eax),%eax
 60f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 616:	00 
 617:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 61e:	00 
 61f:	89 44 24 04          	mov    %eax,0x4(%esp)
 623:	8b 45 08             	mov    0x8(%ebp),%eax
 626:	89 04 24             	mov    %eax,(%esp)
 629:	e8 7a fe ff ff       	call   4a8 <printint>
        ap++;
 62e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 632:	e9 b4 00 00 00       	jmp    6eb <printf+0x194>
      } else if(c == 's'){
 637:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 63b:	75 46                	jne    683 <printf+0x12c>
        s = (char*)*ap;
 63d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 640:	8b 00                	mov    (%eax),%eax
 642:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 645:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 649:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 64d:	75 27                	jne    676 <printf+0x11f>
          s = "(null)";
 64f:	c7 45 f4 7b 0a 00 00 	movl   $0xa7b,-0xc(%ebp)
        while(*s != 0){
 656:	eb 1e                	jmp    676 <printf+0x11f>
          putc(fd, *s);
 658:	8b 45 f4             	mov    -0xc(%ebp),%eax
 65b:	0f b6 00             	movzbl (%eax),%eax
 65e:	0f be c0             	movsbl %al,%eax
 661:	89 44 24 04          	mov    %eax,0x4(%esp)
 665:	8b 45 08             	mov    0x8(%ebp),%eax
 668:	89 04 24             	mov    %eax,(%esp)
 66b:	e8 10 fe ff ff       	call   480 <putc>
          s++;
 670:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 674:	eb 01                	jmp    677 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 676:	90                   	nop
 677:	8b 45 f4             	mov    -0xc(%ebp),%eax
 67a:	0f b6 00             	movzbl (%eax),%eax
 67d:	84 c0                	test   %al,%al
 67f:	75 d7                	jne    658 <printf+0x101>
 681:	eb 68                	jmp    6eb <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 683:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 687:	75 1d                	jne    6a6 <printf+0x14f>
        putc(fd, *ap);
 689:	8b 45 e8             	mov    -0x18(%ebp),%eax
 68c:	8b 00                	mov    (%eax),%eax
 68e:	0f be c0             	movsbl %al,%eax
 691:	89 44 24 04          	mov    %eax,0x4(%esp)
 695:	8b 45 08             	mov    0x8(%ebp),%eax
 698:	89 04 24             	mov    %eax,(%esp)
 69b:	e8 e0 fd ff ff       	call   480 <putc>
        ap++;
 6a0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6a4:	eb 45                	jmp    6eb <printf+0x194>
      } else if(c == '%'){
 6a6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6aa:	75 17                	jne    6c3 <printf+0x16c>
        putc(fd, c);
 6ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6af:	0f be c0             	movsbl %al,%eax
 6b2:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b6:	8b 45 08             	mov    0x8(%ebp),%eax
 6b9:	89 04 24             	mov    %eax,(%esp)
 6bc:	e8 bf fd ff ff       	call   480 <putc>
 6c1:	eb 28                	jmp    6eb <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6c3:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6ca:	00 
 6cb:	8b 45 08             	mov    0x8(%ebp),%eax
 6ce:	89 04 24             	mov    %eax,(%esp)
 6d1:	e8 aa fd ff ff       	call   480 <putc>
        putc(fd, c);
 6d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6d9:	0f be c0             	movsbl %al,%eax
 6dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 6e0:	8b 45 08             	mov    0x8(%ebp),%eax
 6e3:	89 04 24             	mov    %eax,(%esp)
 6e6:	e8 95 fd ff ff       	call   480 <putc>
      }
      state = 0;
 6eb:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6f2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6f6:	8b 55 0c             	mov    0xc(%ebp),%edx
 6f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6fc:	01 d0                	add    %edx,%eax
 6fe:	0f b6 00             	movzbl (%eax),%eax
 701:	84 c0                	test   %al,%al
 703:	0f 85 70 fe ff ff    	jne    579 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 709:	c9                   	leave  
 70a:	c3                   	ret    
 70b:	90                   	nop

0000070c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 70c:	55                   	push   %ebp
 70d:	89 e5                	mov    %esp,%ebp
 70f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 712:	8b 45 08             	mov    0x8(%ebp),%eax
 715:	83 e8 08             	sub    $0x8,%eax
 718:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71b:	a1 7c 0d 00 00       	mov    0xd7c,%eax
 720:	89 45 fc             	mov    %eax,-0x4(%ebp)
 723:	eb 24                	jmp    749 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 725:	8b 45 fc             	mov    -0x4(%ebp),%eax
 728:	8b 00                	mov    (%eax),%eax
 72a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 72d:	77 12                	ja     741 <free+0x35>
 72f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 732:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 735:	77 24                	ja     75b <free+0x4f>
 737:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73a:	8b 00                	mov    (%eax),%eax
 73c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 73f:	77 1a                	ja     75b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 741:	8b 45 fc             	mov    -0x4(%ebp),%eax
 744:	8b 00                	mov    (%eax),%eax
 746:	89 45 fc             	mov    %eax,-0x4(%ebp)
 749:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 74f:	76 d4                	jbe    725 <free+0x19>
 751:	8b 45 fc             	mov    -0x4(%ebp),%eax
 754:	8b 00                	mov    (%eax),%eax
 756:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 759:	76 ca                	jbe    725 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 75b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75e:	8b 40 04             	mov    0x4(%eax),%eax
 761:	c1 e0 03             	shl    $0x3,%eax
 764:	89 c2                	mov    %eax,%edx
 766:	03 55 f8             	add    -0x8(%ebp),%edx
 769:	8b 45 fc             	mov    -0x4(%ebp),%eax
 76c:	8b 00                	mov    (%eax),%eax
 76e:	39 c2                	cmp    %eax,%edx
 770:	75 24                	jne    796 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 772:	8b 45 f8             	mov    -0x8(%ebp),%eax
 775:	8b 50 04             	mov    0x4(%eax),%edx
 778:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77b:	8b 00                	mov    (%eax),%eax
 77d:	8b 40 04             	mov    0x4(%eax),%eax
 780:	01 c2                	add    %eax,%edx
 782:	8b 45 f8             	mov    -0x8(%ebp),%eax
 785:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 788:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78b:	8b 00                	mov    (%eax),%eax
 78d:	8b 10                	mov    (%eax),%edx
 78f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 792:	89 10                	mov    %edx,(%eax)
 794:	eb 0a                	jmp    7a0 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 796:	8b 45 fc             	mov    -0x4(%ebp),%eax
 799:	8b 10                	mov    (%eax),%edx
 79b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 79e:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a3:	8b 40 04             	mov    0x4(%eax),%eax
 7a6:	c1 e0 03             	shl    $0x3,%eax
 7a9:	03 45 fc             	add    -0x4(%ebp),%eax
 7ac:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7af:	75 20                	jne    7d1 <free+0xc5>
    p->s.size += bp->s.size;
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	8b 50 04             	mov    0x4(%eax),%edx
 7b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ba:	8b 40 04             	mov    0x4(%eax),%eax
 7bd:	01 c2                	add    %eax,%edx
 7bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7c8:	8b 10                	mov    (%eax),%edx
 7ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7cd:	89 10                	mov    %edx,(%eax)
 7cf:	eb 08                	jmp    7d9 <free+0xcd>
  } else
    p->s.ptr = bp;
 7d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d4:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7d7:	89 10                	mov    %edx,(%eax)
  freep = p;
 7d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7dc:	a3 7c 0d 00 00       	mov    %eax,0xd7c
}
 7e1:	c9                   	leave  
 7e2:	c3                   	ret    

000007e3 <morecore>:

static Header*
morecore(uint nu)
{
 7e3:	55                   	push   %ebp
 7e4:	89 e5                	mov    %esp,%ebp
 7e6:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7e9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7f0:	77 07                	ja     7f9 <morecore+0x16>
    nu = 4096;
 7f2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7f9:	8b 45 08             	mov    0x8(%ebp),%eax
 7fc:	c1 e0 03             	shl    $0x3,%eax
 7ff:	89 04 24             	mov    %eax,(%esp)
 802:	e8 21 fc ff ff       	call   428 <sbrk>
 807:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 80a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 80e:	75 07                	jne    817 <morecore+0x34>
    return 0;
 810:	b8 00 00 00 00       	mov    $0x0,%eax
 815:	eb 22                	jmp    839 <morecore+0x56>
  hp = (Header*)p;
 817:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 81d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 820:	8b 55 08             	mov    0x8(%ebp),%edx
 823:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 826:	8b 45 f0             	mov    -0x10(%ebp),%eax
 829:	83 c0 08             	add    $0x8,%eax
 82c:	89 04 24             	mov    %eax,(%esp)
 82f:	e8 d8 fe ff ff       	call   70c <free>
  return freep;
 834:	a1 7c 0d 00 00       	mov    0xd7c,%eax
}
 839:	c9                   	leave  
 83a:	c3                   	ret    

0000083b <malloc>:

void*
malloc(uint nbytes)
{
 83b:	55                   	push   %ebp
 83c:	89 e5                	mov    %esp,%ebp
 83e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 841:	8b 45 08             	mov    0x8(%ebp),%eax
 844:	83 c0 07             	add    $0x7,%eax
 847:	c1 e8 03             	shr    $0x3,%eax
 84a:	83 c0 01             	add    $0x1,%eax
 84d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 850:	a1 7c 0d 00 00       	mov    0xd7c,%eax
 855:	89 45 f0             	mov    %eax,-0x10(%ebp)
 858:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 85c:	75 23                	jne    881 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 85e:	c7 45 f0 74 0d 00 00 	movl   $0xd74,-0x10(%ebp)
 865:	8b 45 f0             	mov    -0x10(%ebp),%eax
 868:	a3 7c 0d 00 00       	mov    %eax,0xd7c
 86d:	a1 7c 0d 00 00       	mov    0xd7c,%eax
 872:	a3 74 0d 00 00       	mov    %eax,0xd74
    base.s.size = 0;
 877:	c7 05 78 0d 00 00 00 	movl   $0x0,0xd78
 87e:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 881:	8b 45 f0             	mov    -0x10(%ebp),%eax
 884:	8b 00                	mov    (%eax),%eax
 886:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 889:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88c:	8b 40 04             	mov    0x4(%eax),%eax
 88f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 892:	72 4d                	jb     8e1 <malloc+0xa6>
      if(p->s.size == nunits)
 894:	8b 45 f4             	mov    -0xc(%ebp),%eax
 897:	8b 40 04             	mov    0x4(%eax),%eax
 89a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 89d:	75 0c                	jne    8ab <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 89f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a2:	8b 10                	mov    (%eax),%edx
 8a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a7:	89 10                	mov    %edx,(%eax)
 8a9:	eb 26                	jmp    8d1 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8ae:	8b 40 04             	mov    0x4(%eax),%eax
 8b1:	89 c2                	mov    %eax,%edx
 8b3:	2b 55 ec             	sub    -0x14(%ebp),%edx
 8b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8bf:	8b 40 04             	mov    0x4(%eax),%eax
 8c2:	c1 e0 03             	shl    $0x3,%eax
 8c5:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8ce:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8d4:	a3 7c 0d 00 00       	mov    %eax,0xd7c
      return (void*)(p + 1);
 8d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8dc:	83 c0 08             	add    $0x8,%eax
 8df:	eb 38                	jmp    919 <malloc+0xde>
    }
    if(p == freep)
 8e1:	a1 7c 0d 00 00       	mov    0xd7c,%eax
 8e6:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8e9:	75 1b                	jne    906 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ee:	89 04 24             	mov    %eax,(%esp)
 8f1:	e8 ed fe ff ff       	call   7e3 <morecore>
 8f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8fd:	75 07                	jne    906 <malloc+0xcb>
        return 0;
 8ff:	b8 00 00 00 00       	mov    $0x0,%eax
 904:	eb 13                	jmp    919 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 906:	8b 45 f4             	mov    -0xc(%ebp),%eax
 909:	89 45 f0             	mov    %eax,-0x10(%ebp)
 90c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 90f:	8b 00                	mov    (%eax),%eax
 911:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 914:	e9 70 ff ff ff       	jmp    889 <malloc+0x4e>
}
 919:	c9                   	leave  
 91a:	c3                   	ret    
 91b:	90                   	nop

0000091c <semaphore_create>:
#include "semaphore.h"

struct semaphore* 
semaphore_create(int initial_semaphore_value)
{
 91c:	55                   	push   %ebp
 91d:	89 e5                	mov    %esp,%ebp
 91f:	83 ec 28             	sub    $0x28,%esp
  struct semaphore* s = malloc(sizeof(struct semaphore));
 922:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
 929:	e8 0d ff ff ff       	call   83b <malloc>
 92e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((s->s1 = binary_semaphore_create(1)) != -1)
 931:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 938:	e8 2b fb ff ff       	call   468 <binary_semaphore_create>
 93d:	8b 55 f4             	mov    -0xc(%ebp),%edx
 940:	89 42 04             	mov    %eax,0x4(%edx)
 943:	8b 45 f4             	mov    -0xc(%ebp),%eax
 946:	8b 40 04             	mov    0x4(%eax),%eax
 949:	83 f8 ff             	cmp    $0xffffffff,%eax
 94c:	74 2a                	je     978 <semaphore_create+0x5c>
  {
    if((s->s2 = binary_semaphore_create(1)) != -1)
 94e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 955:	e8 0e fb ff ff       	call   468 <binary_semaphore_create>
 95a:	8b 55 f4             	mov    -0xc(%ebp),%edx
 95d:	89 42 08             	mov    %eax,0x8(%edx)
 960:	8b 45 f4             	mov    -0xc(%ebp),%eax
 963:	8b 40 08             	mov    0x8(%eax),%eax
 966:	83 f8 ff             	cmp    $0xffffffff,%eax
 969:	74 0d                	je     978 <semaphore_create+0x5c>
    {
      s->value = initial_semaphore_value;
 96b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 96e:	8b 55 08             	mov    0x8(%ebp),%edx
 971:	89 10                	mov    %edx,(%eax)
      return s;
 973:	8b 45 f4             	mov    -0xc(%ebp),%eax
 976:	eb 15                	jmp    98d <semaphore_create+0x71>
    }
  }
  free(s);
 978:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97b:	89 04 24             	mov    %eax,(%esp)
 97e:	e8 89 fd ff ff       	call   70c <free>
  s = 0;
 983:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  return s;
 98a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 98d:	c9                   	leave  
 98e:	c3                   	ret    

0000098f <semaphore_down>:

void 
semaphore_down(struct semaphore* sem )
{
 98f:	55                   	push   %ebp
 990:	89 e5                	mov    %esp,%ebp
 992:	83 ec 18             	sub    $0x18,%esp
 binary_semaphore_down(sem->s2);
 995:	8b 45 08             	mov    0x8(%ebp),%eax
 998:	8b 40 08             	mov    0x8(%eax),%eax
 99b:	89 04 24             	mov    %eax,(%esp)
 99e:	e8 cd fa ff ff       	call   470 <binary_semaphore_down>
 binary_semaphore_down(sem->s1);
 9a3:	8b 45 08             	mov    0x8(%ebp),%eax
 9a6:	8b 40 04             	mov    0x4(%eax),%eax
 9a9:	89 04 24             	mov    %eax,(%esp)
 9ac:	e8 bf fa ff ff       	call   470 <binary_semaphore_down>
 sem->value--;
 9b1:	8b 45 08             	mov    0x8(%ebp),%eax
 9b4:	8b 00                	mov    (%eax),%eax
 9b6:	8d 50 ff             	lea    -0x1(%eax),%edx
 9b9:	8b 45 08             	mov    0x8(%ebp),%eax
 9bc:	89 10                	mov    %edx,(%eax)
 if(sem->value>0)
 9be:	8b 45 08             	mov    0x8(%ebp),%eax
 9c1:	8b 00                	mov    (%eax),%eax
 9c3:	85 c0                	test   %eax,%eax
 9c5:	7e 0e                	jle    9d5 <semaphore_down+0x46>
  binary_semaphore_up(sem->s2);
 9c7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ca:	8b 40 08             	mov    0x8(%eax),%eax
 9cd:	89 04 24             	mov    %eax,(%esp)
 9d0:	e8 a3 fa ff ff       	call   478 <binary_semaphore_up>
 binary_semaphore_up(sem->s1);
 9d5:	8b 45 08             	mov    0x8(%ebp),%eax
 9d8:	8b 40 04             	mov    0x4(%eax),%eax
 9db:	89 04 24             	mov    %eax,(%esp)
 9de:	e8 95 fa ff ff       	call   478 <binary_semaphore_up>
}
 9e3:	c9                   	leave  
 9e4:	c3                   	ret    

000009e5 <semaphore_up>:

void 
semaphore_up(struct semaphore* sem )
{
 9e5:	55                   	push   %ebp
 9e6:	89 e5                	mov    %esp,%ebp
 9e8:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s1);
 9eb:	8b 45 08             	mov    0x8(%ebp),%eax
 9ee:	8b 40 04             	mov    0x4(%eax),%eax
 9f1:	89 04 24             	mov    %eax,(%esp)
 9f4:	e8 77 fa ff ff       	call   470 <binary_semaphore_down>
  sem->value++;
 9f9:	8b 45 08             	mov    0x8(%ebp),%eax
 9fc:	8b 00                	mov    (%eax),%eax
 9fe:	8d 50 01             	lea    0x1(%eax),%edx
 a01:	8b 45 08             	mov    0x8(%ebp),%eax
 a04:	89 10                	mov    %edx,(%eax)
  if(sem->value == 1)
 a06:	8b 45 08             	mov    0x8(%ebp),%eax
 a09:	8b 00                	mov    (%eax),%eax
 a0b:	83 f8 01             	cmp    $0x1,%eax
 a0e:	75 0e                	jne    a1e <semaphore_up+0x39>
    binary_semaphore_up(sem->s2);
 a10:	8b 45 08             	mov    0x8(%ebp),%eax
 a13:	8b 40 08             	mov    0x8(%eax),%eax
 a16:	89 04 24             	mov    %eax,(%esp)
 a19:	e8 5a fa ff ff       	call   478 <binary_semaphore_up>
  binary_semaphore_up(sem->s1);
 a1e:	8b 45 08             	mov    0x8(%ebp),%eax
 a21:	8b 40 04             	mov    0x4(%eax),%eax
 a24:	89 04 24             	mov    %eax,(%esp)
 a27:	e8 4c fa ff ff       	call   478 <binary_semaphore_up>
}
 a2c:	c9                   	leave  
 a2d:	c3                   	ret    
