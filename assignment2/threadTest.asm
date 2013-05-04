
_threadTest:     file format elf32-i386


Disassembly of section .text:

00000000 <print>:
#include "user.h"

int lock;

void *print(void)
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
   e:	a1 58 0d 00 00       	mov    0xd58,%eax
  13:	89 04 24             	mov    %eax,(%esp)
  16:	e8 31 04 00 00       	call   44c <binary_semaphore_down>
    for(;i<3;i++)
  1b:	eb 2c                	jmp    49 <print+0x49>
      printf(1,"Process %d Thread %d is running.\n",thread_getProcId(),thread_getId());
  1d:	e8 02 04 00 00       	call   424 <thread_getId>
  22:	89 c3                	mov    %eax,%ebx
  24:	e8 03 04 00 00       	call   42c <thread_getProcId>
  29:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  2d:	89 44 24 08          	mov    %eax,0x8(%esp)
  31:	c7 44 24 04 0c 0a 00 	movl   $0xa0c,0x4(%esp)
  38:	00 
  39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  40:	e8 ee 04 00 00       	call   533 <printf>
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
  4f:	a1 58 0d 00 00       	mov    0xd58,%eax
  54:	89 04 24             	mov    %eax,(%esp)
  57:	e8 f8 03 00 00       	call   454 <binary_semaphore_up>
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
  72:	e8 cd 03 00 00       	call   444 <binary_semaphore_create>
  77:	a3 58 0d 00 00       	mov    %eax,0xd58
  int num = atoi(n);
  7c:	8b 45 08             	mov    0x8(%ebp),%eax
  7f:	89 04 24             	mov    %eax,(%esp)
  82:	e8 64 02 00 00       	call   2eb <atoi>
  87:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(;num>0;num--)
  8a:	eb 57                	jmp    e3 <threadTest+0x85>
  {
    uint stack_size = 1024;
  8c:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
    void* stack = malloc(stack_size);
  93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  96:	89 04 24             	mov    %eax,(%esp)
  99:	e8 79 07 00 00       	call   817 <malloc>
  9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    value = thread_create((void*)print,stack,stack_size);
  a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  b6:	e8 61 03 00 00       	call   41c <thread_create>
  bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(value == -1)
  be:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  c2:	75 1b                	jne    df <threadTest+0x81>
      printf(1,"Failed to create thread number %d\n",num);
  c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  cb:	c7 44 24 04 30 0a 00 	movl   $0xa30,0x4(%esp)
  d2:	00 
  d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  da:	e8 54 04 00 00       	call   533 <printf>
threadTest(char* n)
{
  int value = 0;
  lock = binary_semaphore_create(1);
  int num = atoi(n);
  for(;num>0;num--)
  df:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  e3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  e7:	7f a3                	jg     8c <threadTest+0x2e>
    void* stack = malloc(stack_size);
    value = thread_create((void*)print,stack,stack_size);
    if(value == -1)
      printf(1,"Failed to create thread number %d\n",num);
  }
}
  e9:	c9                   	leave  
  ea:	c3                   	ret    

000000eb <main>:



int
main(int argc, char** argv)
{
  eb:	55                   	push   %ebp
  ec:	89 e5                	mov    %esp,%ebp
  ee:	83 e4 f0             	and    $0xfffffff0,%esp
  f1:	83 ec 10             	sub    $0x10,%esp
  threadTest(argv[1]);
  f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  f7:	83 c0 04             	add    $0x4,%eax
  fa:	8b 00                	mov    (%eax),%eax
  fc:	89 04 24             	mov    %eax,(%esp)
  ff:	e8 5a ff ff ff       	call   5e <threadTest>
  thread_exit(0);
 104:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 10b:	e8 2c 03 00 00       	call   43c <thread_exit>
  return 0;
 110:	b8 00 00 00 00       	mov    $0x0,%eax
 115:	c9                   	leave  
 116:	c3                   	ret    
 117:	90                   	nop

00000118 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 118:	55                   	push   %ebp
 119:	89 e5                	mov    %esp,%ebp
 11b:	57                   	push   %edi
 11c:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 11d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 120:	8b 55 10             	mov    0x10(%ebp),%edx
 123:	8b 45 0c             	mov    0xc(%ebp),%eax
 126:	89 cb                	mov    %ecx,%ebx
 128:	89 df                	mov    %ebx,%edi
 12a:	89 d1                	mov    %edx,%ecx
 12c:	fc                   	cld    
 12d:	f3 aa                	rep stos %al,%es:(%edi)
 12f:	89 ca                	mov    %ecx,%edx
 131:	89 fb                	mov    %edi,%ebx
 133:	89 5d 08             	mov    %ebx,0x8(%ebp)
 136:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 139:	5b                   	pop    %ebx
 13a:	5f                   	pop    %edi
 13b:	5d                   	pop    %ebp
 13c:	c3                   	ret    

0000013d <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 13d:	55                   	push   %ebp
 13e:	89 e5                	mov    %esp,%ebp
 140:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 143:	8b 45 08             	mov    0x8(%ebp),%eax
 146:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 149:	90                   	nop
 14a:	8b 45 0c             	mov    0xc(%ebp),%eax
 14d:	0f b6 10             	movzbl (%eax),%edx
 150:	8b 45 08             	mov    0x8(%ebp),%eax
 153:	88 10                	mov    %dl,(%eax)
 155:	8b 45 08             	mov    0x8(%ebp),%eax
 158:	0f b6 00             	movzbl (%eax),%eax
 15b:	84 c0                	test   %al,%al
 15d:	0f 95 c0             	setne  %al
 160:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 164:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 168:	84 c0                	test   %al,%al
 16a:	75 de                	jne    14a <strcpy+0xd>
    ;
  return os;
 16c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16f:	c9                   	leave  
 170:	c3                   	ret    

00000171 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 171:	55                   	push   %ebp
 172:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 174:	eb 08                	jmp    17e <strcmp+0xd>
    p++, q++;
 176:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 17a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17e:	8b 45 08             	mov    0x8(%ebp),%eax
 181:	0f b6 00             	movzbl (%eax),%eax
 184:	84 c0                	test   %al,%al
 186:	74 10                	je     198 <strcmp+0x27>
 188:	8b 45 08             	mov    0x8(%ebp),%eax
 18b:	0f b6 10             	movzbl (%eax),%edx
 18e:	8b 45 0c             	mov    0xc(%ebp),%eax
 191:	0f b6 00             	movzbl (%eax),%eax
 194:	38 c2                	cmp    %al,%dl
 196:	74 de                	je     176 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 198:	8b 45 08             	mov    0x8(%ebp),%eax
 19b:	0f b6 00             	movzbl (%eax),%eax
 19e:	0f b6 d0             	movzbl %al,%edx
 1a1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a4:	0f b6 00             	movzbl (%eax),%eax
 1a7:	0f b6 c0             	movzbl %al,%eax
 1aa:	89 d1                	mov    %edx,%ecx
 1ac:	29 c1                	sub    %eax,%ecx
 1ae:	89 c8                	mov    %ecx,%eax
}
 1b0:	5d                   	pop    %ebp
 1b1:	c3                   	ret    

000001b2 <strlen>:

uint
strlen(char *s)
{
 1b2:	55                   	push   %ebp
 1b3:	89 e5                	mov    %esp,%ebp
 1b5:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1bf:	eb 04                	jmp    1c5 <strlen+0x13>
 1c1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1c8:	03 45 08             	add    0x8(%ebp),%eax
 1cb:	0f b6 00             	movzbl (%eax),%eax
 1ce:	84 c0                	test   %al,%al
 1d0:	75 ef                	jne    1c1 <strlen+0xf>
    ;
  return n;
 1d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d5:	c9                   	leave  
 1d6:	c3                   	ret    

000001d7 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1dd:	8b 45 10             	mov    0x10(%ebp),%eax
 1e0:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e4:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1eb:	8b 45 08             	mov    0x8(%ebp),%eax
 1ee:	89 04 24             	mov    %eax,(%esp)
 1f1:	e8 22 ff ff ff       	call   118 <stosb>
  return dst;
 1f6:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f9:	c9                   	leave  
 1fa:	c3                   	ret    

000001fb <strchr>:

char*
strchr(const char *s, char c)
{
 1fb:	55                   	push   %ebp
 1fc:	89 e5                	mov    %esp,%ebp
 1fe:	83 ec 04             	sub    $0x4,%esp
 201:	8b 45 0c             	mov    0xc(%ebp),%eax
 204:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 207:	eb 14                	jmp    21d <strchr+0x22>
    if(*s == c)
 209:	8b 45 08             	mov    0x8(%ebp),%eax
 20c:	0f b6 00             	movzbl (%eax),%eax
 20f:	3a 45 fc             	cmp    -0x4(%ebp),%al
 212:	75 05                	jne    219 <strchr+0x1e>
      return (char*)s;
 214:	8b 45 08             	mov    0x8(%ebp),%eax
 217:	eb 13                	jmp    22c <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 219:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 21d:	8b 45 08             	mov    0x8(%ebp),%eax
 220:	0f b6 00             	movzbl (%eax),%eax
 223:	84 c0                	test   %al,%al
 225:	75 e2                	jne    209 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 227:	b8 00 00 00 00       	mov    $0x0,%eax
}
 22c:	c9                   	leave  
 22d:	c3                   	ret    

0000022e <gets>:

char*
gets(char *buf, int max)
{
 22e:	55                   	push   %ebp
 22f:	89 e5                	mov    %esp,%ebp
 231:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 234:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 23b:	eb 44                	jmp    281 <gets+0x53>
    cc = read(0, &c, 1);
 23d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 244:	00 
 245:	8d 45 ef             	lea    -0x11(%ebp),%eax
 248:	89 44 24 04          	mov    %eax,0x4(%esp)
 24c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 253:	e8 3c 01 00 00       	call   394 <read>
 258:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 25b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 25f:	7e 2d                	jle    28e <gets+0x60>
      break;
    buf[i++] = c;
 261:	8b 45 f4             	mov    -0xc(%ebp),%eax
 264:	03 45 08             	add    0x8(%ebp),%eax
 267:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 26b:	88 10                	mov    %dl,(%eax)
 26d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 271:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 275:	3c 0a                	cmp    $0xa,%al
 277:	74 16                	je     28f <gets+0x61>
 279:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 27d:	3c 0d                	cmp    $0xd,%al
 27f:	74 0e                	je     28f <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 281:	8b 45 f4             	mov    -0xc(%ebp),%eax
 284:	83 c0 01             	add    $0x1,%eax
 287:	3b 45 0c             	cmp    0xc(%ebp),%eax
 28a:	7c b1                	jl     23d <gets+0xf>
 28c:	eb 01                	jmp    28f <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 28e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 28f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 292:	03 45 08             	add    0x8(%ebp),%eax
 295:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 298:	8b 45 08             	mov    0x8(%ebp),%eax
}
 29b:	c9                   	leave  
 29c:	c3                   	ret    

0000029d <stat>:

int
stat(char *n, struct stat *st)
{
 29d:	55                   	push   %ebp
 29e:	89 e5                	mov    %esp,%ebp
 2a0:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2aa:	00 
 2ab:	8b 45 08             	mov    0x8(%ebp),%eax
 2ae:	89 04 24             	mov    %eax,(%esp)
 2b1:	e8 06 01 00 00       	call   3bc <open>
 2b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2bd:	79 07                	jns    2c6 <stat+0x29>
    return -1;
 2bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c4:	eb 23                	jmp    2e9 <stat+0x4c>
  r = fstat(fd, st);
 2c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 2cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2d0:	89 04 24             	mov    %eax,(%esp)
 2d3:	e8 fc 00 00 00       	call   3d4 <fstat>
 2d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2db:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2de:	89 04 24             	mov    %eax,(%esp)
 2e1:	e8 be 00 00 00       	call   3a4 <close>
  return r;
 2e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e9:	c9                   	leave  
 2ea:	c3                   	ret    

000002eb <atoi>:

int
atoi(const char *s)
{
 2eb:	55                   	push   %ebp
 2ec:	89 e5                	mov    %esp,%ebp
 2ee:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2f1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2f8:	eb 23                	jmp    31d <atoi+0x32>
    n = n*10 + *s++ - '0';
 2fa:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2fd:	89 d0                	mov    %edx,%eax
 2ff:	c1 e0 02             	shl    $0x2,%eax
 302:	01 d0                	add    %edx,%eax
 304:	01 c0                	add    %eax,%eax
 306:	89 c2                	mov    %eax,%edx
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	0f be c0             	movsbl %al,%eax
 311:	01 d0                	add    %edx,%eax
 313:	83 e8 30             	sub    $0x30,%eax
 316:	89 45 fc             	mov    %eax,-0x4(%ebp)
 319:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 31d:	8b 45 08             	mov    0x8(%ebp),%eax
 320:	0f b6 00             	movzbl (%eax),%eax
 323:	3c 2f                	cmp    $0x2f,%al
 325:	7e 0a                	jle    331 <atoi+0x46>
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	0f b6 00             	movzbl (%eax),%eax
 32d:	3c 39                	cmp    $0x39,%al
 32f:	7e c9                	jle    2fa <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 331:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 334:	c9                   	leave  
 335:	c3                   	ret    

00000336 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 336:	55                   	push   %ebp
 337:	89 e5                	mov    %esp,%ebp
 339:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 33c:	8b 45 08             	mov    0x8(%ebp),%eax
 33f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 342:	8b 45 0c             	mov    0xc(%ebp),%eax
 345:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 348:	eb 13                	jmp    35d <memmove+0x27>
    *dst++ = *src++;
 34a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 34d:	0f b6 10             	movzbl (%eax),%edx
 350:	8b 45 fc             	mov    -0x4(%ebp),%eax
 353:	88 10                	mov    %dl,(%eax)
 355:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 359:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 35d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 361:	0f 9f c0             	setg   %al
 364:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 368:	84 c0                	test   %al,%al
 36a:	75 de                	jne    34a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 36c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36f:	c9                   	leave  
 370:	c3                   	ret    
 371:	90                   	nop
 372:	90                   	nop
 373:	90                   	nop

00000374 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 374:	b8 01 00 00 00       	mov    $0x1,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <exit>:
SYSCALL(exit)
 37c:	b8 02 00 00 00       	mov    $0x2,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <wait>:
SYSCALL(wait)
 384:	b8 03 00 00 00       	mov    $0x3,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <pipe>:
SYSCALL(pipe)
 38c:	b8 04 00 00 00       	mov    $0x4,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <read>:
SYSCALL(read)
 394:	b8 05 00 00 00       	mov    $0x5,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <write>:
SYSCALL(write)
 39c:	b8 10 00 00 00       	mov    $0x10,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <close>:
SYSCALL(close)
 3a4:	b8 15 00 00 00       	mov    $0x15,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <kill>:
SYSCALL(kill)
 3ac:	b8 06 00 00 00       	mov    $0x6,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <exec>:
SYSCALL(exec)
 3b4:	b8 07 00 00 00       	mov    $0x7,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <open>:
SYSCALL(open)
 3bc:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <mknod>:
SYSCALL(mknod)
 3c4:	b8 11 00 00 00       	mov    $0x11,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <unlink>:
SYSCALL(unlink)
 3cc:	b8 12 00 00 00       	mov    $0x12,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <fstat>:
SYSCALL(fstat)
 3d4:	b8 08 00 00 00       	mov    $0x8,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <link>:
SYSCALL(link)
 3dc:	b8 13 00 00 00       	mov    $0x13,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <mkdir>:
SYSCALL(mkdir)
 3e4:	b8 14 00 00 00       	mov    $0x14,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <chdir>:
SYSCALL(chdir)
 3ec:	b8 09 00 00 00       	mov    $0x9,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <dup>:
SYSCALL(dup)
 3f4:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <getpid>:
SYSCALL(getpid)
 3fc:	b8 0b 00 00 00       	mov    $0xb,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <sbrk>:
SYSCALL(sbrk)
 404:	b8 0c 00 00 00       	mov    $0xc,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <sleep>:
SYSCALL(sleep)
 40c:	b8 0d 00 00 00       	mov    $0xd,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <uptime>:
SYSCALL(uptime)
 414:	b8 0e 00 00 00       	mov    $0xe,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <thread_create>:
SYSCALL(thread_create)
 41c:	b8 16 00 00 00       	mov    $0x16,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <thread_getId>:
SYSCALL(thread_getId)
 424:	b8 17 00 00 00       	mov    $0x17,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <thread_getProcId>:
SYSCALL(thread_getProcId)
 42c:	b8 18 00 00 00       	mov    $0x18,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <thread_join>:
SYSCALL(thread_join)
 434:	b8 19 00 00 00       	mov    $0x19,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <thread_exit>:
SYSCALL(thread_exit)
 43c:	b8 1a 00 00 00       	mov    $0x1a,%eax
 441:	cd 40                	int    $0x40
 443:	c3                   	ret    

00000444 <binary_semaphore_create>:
SYSCALL(binary_semaphore_create)
 444:	b8 1b 00 00 00       	mov    $0x1b,%eax
 449:	cd 40                	int    $0x40
 44b:	c3                   	ret    

0000044c <binary_semaphore_down>:
SYSCALL(binary_semaphore_down)
 44c:	b8 1c 00 00 00       	mov    $0x1c,%eax
 451:	cd 40                	int    $0x40
 453:	c3                   	ret    

00000454 <binary_semaphore_up>:
SYSCALL(binary_semaphore_up)
 454:	b8 1d 00 00 00       	mov    $0x1d,%eax
 459:	cd 40                	int    $0x40
 45b:	c3                   	ret    

0000045c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 45c:	55                   	push   %ebp
 45d:	89 e5                	mov    %esp,%ebp
 45f:	83 ec 28             	sub    $0x28,%esp
 462:	8b 45 0c             	mov    0xc(%ebp),%eax
 465:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 468:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 46f:	00 
 470:	8d 45 f4             	lea    -0xc(%ebp),%eax
 473:	89 44 24 04          	mov    %eax,0x4(%esp)
 477:	8b 45 08             	mov    0x8(%ebp),%eax
 47a:	89 04 24             	mov    %eax,(%esp)
 47d:	e8 1a ff ff ff       	call   39c <write>
}
 482:	c9                   	leave  
 483:	c3                   	ret    

00000484 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 484:	55                   	push   %ebp
 485:	89 e5                	mov    %esp,%ebp
 487:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 48a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 491:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 495:	74 17                	je     4ae <printint+0x2a>
 497:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 49b:	79 11                	jns    4ae <printint+0x2a>
    neg = 1;
 49d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4a4:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a7:	f7 d8                	neg    %eax
 4a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ac:	eb 06                	jmp    4b4 <printint+0x30>
  } else {
    x = xx;
 4ae:	8b 45 0c             	mov    0xc(%ebp),%eax
 4b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4be:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4c1:	ba 00 00 00 00       	mov    $0x0,%edx
 4c6:	f7 f1                	div    %ecx
 4c8:	89 d0                	mov    %edx,%eax
 4ca:	0f b6 90 38 0d 00 00 	movzbl 0xd38(%eax),%edx
 4d1:	8d 45 dc             	lea    -0x24(%ebp),%eax
 4d4:	03 45 f4             	add    -0xc(%ebp),%eax
 4d7:	88 10                	mov    %dl,(%eax)
 4d9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 4dd:	8b 55 10             	mov    0x10(%ebp),%edx
 4e0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e6:	ba 00 00 00 00       	mov    $0x0,%edx
 4eb:	f7 75 d4             	divl   -0x2c(%ebp)
 4ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f5:	75 c4                	jne    4bb <printint+0x37>
  if(neg)
 4f7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4fb:	74 2a                	je     527 <printint+0xa3>
    buf[i++] = '-';
 4fd:	8d 45 dc             	lea    -0x24(%ebp),%eax
 500:	03 45 f4             	add    -0xc(%ebp),%eax
 503:	c6 00 2d             	movb   $0x2d,(%eax)
 506:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 50a:	eb 1b                	jmp    527 <printint+0xa3>
    putc(fd, buf[i]);
 50c:	8d 45 dc             	lea    -0x24(%ebp),%eax
 50f:	03 45 f4             	add    -0xc(%ebp),%eax
 512:	0f b6 00             	movzbl (%eax),%eax
 515:	0f be c0             	movsbl %al,%eax
 518:	89 44 24 04          	mov    %eax,0x4(%esp)
 51c:	8b 45 08             	mov    0x8(%ebp),%eax
 51f:	89 04 24             	mov    %eax,(%esp)
 522:	e8 35 ff ff ff       	call   45c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 527:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 52b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 52f:	79 db                	jns    50c <printint+0x88>
    putc(fd, buf[i]);
}
 531:	c9                   	leave  
 532:	c3                   	ret    

00000533 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 533:	55                   	push   %ebp
 534:	89 e5                	mov    %esp,%ebp
 536:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 539:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 540:	8d 45 0c             	lea    0xc(%ebp),%eax
 543:	83 c0 04             	add    $0x4,%eax
 546:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 549:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 550:	e9 7d 01 00 00       	jmp    6d2 <printf+0x19f>
    c = fmt[i] & 0xff;
 555:	8b 55 0c             	mov    0xc(%ebp),%edx
 558:	8b 45 f0             	mov    -0x10(%ebp),%eax
 55b:	01 d0                	add    %edx,%eax
 55d:	0f b6 00             	movzbl (%eax),%eax
 560:	0f be c0             	movsbl %al,%eax
 563:	25 ff 00 00 00       	and    $0xff,%eax
 568:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 56b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 56f:	75 2c                	jne    59d <printf+0x6a>
      if(c == '%'){
 571:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 575:	75 0c                	jne    583 <printf+0x50>
        state = '%';
 577:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 57e:	e9 4b 01 00 00       	jmp    6ce <printf+0x19b>
      } else {
        putc(fd, c);
 583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 586:	0f be c0             	movsbl %al,%eax
 589:	89 44 24 04          	mov    %eax,0x4(%esp)
 58d:	8b 45 08             	mov    0x8(%ebp),%eax
 590:	89 04 24             	mov    %eax,(%esp)
 593:	e8 c4 fe ff ff       	call   45c <putc>
 598:	e9 31 01 00 00       	jmp    6ce <printf+0x19b>
      }
    } else if(state == '%'){
 59d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5a1:	0f 85 27 01 00 00    	jne    6ce <printf+0x19b>
      if(c == 'd'){
 5a7:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5ab:	75 2d                	jne    5da <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5b0:	8b 00                	mov    (%eax),%eax
 5b2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5b9:	00 
 5ba:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5c1:	00 
 5c2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c6:	8b 45 08             	mov    0x8(%ebp),%eax
 5c9:	89 04 24             	mov    %eax,(%esp)
 5cc:	e8 b3 fe ff ff       	call   484 <printint>
        ap++;
 5d1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d5:	e9 ed 00 00 00       	jmp    6c7 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 5da:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5de:	74 06                	je     5e6 <printf+0xb3>
 5e0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5e4:	75 2d                	jne    613 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e9:	8b 00                	mov    (%eax),%eax
 5eb:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5f2:	00 
 5f3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5fa:	00 
 5fb:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ff:	8b 45 08             	mov    0x8(%ebp),%eax
 602:	89 04 24             	mov    %eax,(%esp)
 605:	e8 7a fe ff ff       	call   484 <printint>
        ap++;
 60a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60e:	e9 b4 00 00 00       	jmp    6c7 <printf+0x194>
      } else if(c == 's'){
 613:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 617:	75 46                	jne    65f <printf+0x12c>
        s = (char*)*ap;
 619:	8b 45 e8             	mov    -0x18(%ebp),%eax
 61c:	8b 00                	mov    (%eax),%eax
 61e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 621:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 625:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 629:	75 27                	jne    652 <printf+0x11f>
          s = "(null)";
 62b:	c7 45 f4 53 0a 00 00 	movl   $0xa53,-0xc(%ebp)
        while(*s != 0){
 632:	eb 1e                	jmp    652 <printf+0x11f>
          putc(fd, *s);
 634:	8b 45 f4             	mov    -0xc(%ebp),%eax
 637:	0f b6 00             	movzbl (%eax),%eax
 63a:	0f be c0             	movsbl %al,%eax
 63d:	89 44 24 04          	mov    %eax,0x4(%esp)
 641:	8b 45 08             	mov    0x8(%ebp),%eax
 644:	89 04 24             	mov    %eax,(%esp)
 647:	e8 10 fe ff ff       	call   45c <putc>
          s++;
 64c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 650:	eb 01                	jmp    653 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 652:	90                   	nop
 653:	8b 45 f4             	mov    -0xc(%ebp),%eax
 656:	0f b6 00             	movzbl (%eax),%eax
 659:	84 c0                	test   %al,%al
 65b:	75 d7                	jne    634 <printf+0x101>
 65d:	eb 68                	jmp    6c7 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 65f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 663:	75 1d                	jne    682 <printf+0x14f>
        putc(fd, *ap);
 665:	8b 45 e8             	mov    -0x18(%ebp),%eax
 668:	8b 00                	mov    (%eax),%eax
 66a:	0f be c0             	movsbl %al,%eax
 66d:	89 44 24 04          	mov    %eax,0x4(%esp)
 671:	8b 45 08             	mov    0x8(%ebp),%eax
 674:	89 04 24             	mov    %eax,(%esp)
 677:	e8 e0 fd ff ff       	call   45c <putc>
        ap++;
 67c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 680:	eb 45                	jmp    6c7 <printf+0x194>
      } else if(c == '%'){
 682:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 686:	75 17                	jne    69f <printf+0x16c>
        putc(fd, c);
 688:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 68b:	0f be c0             	movsbl %al,%eax
 68e:	89 44 24 04          	mov    %eax,0x4(%esp)
 692:	8b 45 08             	mov    0x8(%ebp),%eax
 695:	89 04 24             	mov    %eax,(%esp)
 698:	e8 bf fd ff ff       	call   45c <putc>
 69d:	eb 28                	jmp    6c7 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 69f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6a6:	00 
 6a7:	8b 45 08             	mov    0x8(%ebp),%eax
 6aa:	89 04 24             	mov    %eax,(%esp)
 6ad:	e8 aa fd ff ff       	call   45c <putc>
        putc(fd, c);
 6b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b5:	0f be c0             	movsbl %al,%eax
 6b8:	89 44 24 04          	mov    %eax,0x4(%esp)
 6bc:	8b 45 08             	mov    0x8(%ebp),%eax
 6bf:	89 04 24             	mov    %eax,(%esp)
 6c2:	e8 95 fd ff ff       	call   45c <putc>
      }
      state = 0;
 6c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ce:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6d2:	8b 55 0c             	mov    0xc(%ebp),%edx
 6d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d8:	01 d0                	add    %edx,%eax
 6da:	0f b6 00             	movzbl (%eax),%eax
 6dd:	84 c0                	test   %al,%al
 6df:	0f 85 70 fe ff ff    	jne    555 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6e5:	c9                   	leave  
 6e6:	c3                   	ret    
 6e7:	90                   	nop

000006e8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e8:	55                   	push   %ebp
 6e9:	89 e5                	mov    %esp,%ebp
 6eb:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ee:	8b 45 08             	mov    0x8(%ebp),%eax
 6f1:	83 e8 08             	sub    $0x8,%eax
 6f4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f7:	a1 54 0d 00 00       	mov    0xd54,%eax
 6fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6ff:	eb 24                	jmp    725 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 701:	8b 45 fc             	mov    -0x4(%ebp),%eax
 704:	8b 00                	mov    (%eax),%eax
 706:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 709:	77 12                	ja     71d <free+0x35>
 70b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 711:	77 24                	ja     737 <free+0x4f>
 713:	8b 45 fc             	mov    -0x4(%ebp),%eax
 716:	8b 00                	mov    (%eax),%eax
 718:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 71b:	77 1a                	ja     737 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 720:	8b 00                	mov    (%eax),%eax
 722:	89 45 fc             	mov    %eax,-0x4(%ebp)
 725:	8b 45 f8             	mov    -0x8(%ebp),%eax
 728:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 72b:	76 d4                	jbe    701 <free+0x19>
 72d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 730:	8b 00                	mov    (%eax),%eax
 732:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 735:	76 ca                	jbe    701 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 737:	8b 45 f8             	mov    -0x8(%ebp),%eax
 73a:	8b 40 04             	mov    0x4(%eax),%eax
 73d:	c1 e0 03             	shl    $0x3,%eax
 740:	89 c2                	mov    %eax,%edx
 742:	03 55 f8             	add    -0x8(%ebp),%edx
 745:	8b 45 fc             	mov    -0x4(%ebp),%eax
 748:	8b 00                	mov    (%eax),%eax
 74a:	39 c2                	cmp    %eax,%edx
 74c:	75 24                	jne    772 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 74e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 751:	8b 50 04             	mov    0x4(%eax),%edx
 754:	8b 45 fc             	mov    -0x4(%ebp),%eax
 757:	8b 00                	mov    (%eax),%eax
 759:	8b 40 04             	mov    0x4(%eax),%eax
 75c:	01 c2                	add    %eax,%edx
 75e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 761:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 764:	8b 45 fc             	mov    -0x4(%ebp),%eax
 767:	8b 00                	mov    (%eax),%eax
 769:	8b 10                	mov    (%eax),%edx
 76b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76e:	89 10                	mov    %edx,(%eax)
 770:	eb 0a                	jmp    77c <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 772:	8b 45 fc             	mov    -0x4(%ebp),%eax
 775:	8b 10                	mov    (%eax),%edx
 777:	8b 45 f8             	mov    -0x8(%ebp),%eax
 77a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 77c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77f:	8b 40 04             	mov    0x4(%eax),%eax
 782:	c1 e0 03             	shl    $0x3,%eax
 785:	03 45 fc             	add    -0x4(%ebp),%eax
 788:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 78b:	75 20                	jne    7ad <free+0xc5>
    p->s.size += bp->s.size;
 78d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 790:	8b 50 04             	mov    0x4(%eax),%edx
 793:	8b 45 f8             	mov    -0x8(%ebp),%eax
 796:	8b 40 04             	mov    0x4(%eax),%eax
 799:	01 c2                	add    %eax,%edx
 79b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a4:	8b 10                	mov    (%eax),%edx
 7a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a9:	89 10                	mov    %edx,(%eax)
 7ab:	eb 08                	jmp    7b5 <free+0xcd>
  } else
    p->s.ptr = bp;
 7ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b0:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7b3:	89 10                	mov    %edx,(%eax)
  freep = p;
 7b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b8:	a3 54 0d 00 00       	mov    %eax,0xd54
}
 7bd:	c9                   	leave  
 7be:	c3                   	ret    

000007bf <morecore>:

static Header*
morecore(uint nu)
{
 7bf:	55                   	push   %ebp
 7c0:	89 e5                	mov    %esp,%ebp
 7c2:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7c5:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7cc:	77 07                	ja     7d5 <morecore+0x16>
    nu = 4096;
 7ce:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7d5:	8b 45 08             	mov    0x8(%ebp),%eax
 7d8:	c1 e0 03             	shl    $0x3,%eax
 7db:	89 04 24             	mov    %eax,(%esp)
 7de:	e8 21 fc ff ff       	call   404 <sbrk>
 7e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7e6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7ea:	75 07                	jne    7f3 <morecore+0x34>
    return 0;
 7ec:	b8 00 00 00 00       	mov    $0x0,%eax
 7f1:	eb 22                	jmp    815 <morecore+0x56>
  hp = (Header*)p;
 7f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fc:	8b 55 08             	mov    0x8(%ebp),%edx
 7ff:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 802:	8b 45 f0             	mov    -0x10(%ebp),%eax
 805:	83 c0 08             	add    $0x8,%eax
 808:	89 04 24             	mov    %eax,(%esp)
 80b:	e8 d8 fe ff ff       	call   6e8 <free>
  return freep;
 810:	a1 54 0d 00 00       	mov    0xd54,%eax
}
 815:	c9                   	leave  
 816:	c3                   	ret    

00000817 <malloc>:

void*
malloc(uint nbytes)
{
 817:	55                   	push   %ebp
 818:	89 e5                	mov    %esp,%ebp
 81a:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 81d:	8b 45 08             	mov    0x8(%ebp),%eax
 820:	83 c0 07             	add    $0x7,%eax
 823:	c1 e8 03             	shr    $0x3,%eax
 826:	83 c0 01             	add    $0x1,%eax
 829:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 82c:	a1 54 0d 00 00       	mov    0xd54,%eax
 831:	89 45 f0             	mov    %eax,-0x10(%ebp)
 834:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 838:	75 23                	jne    85d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 83a:	c7 45 f0 4c 0d 00 00 	movl   $0xd4c,-0x10(%ebp)
 841:	8b 45 f0             	mov    -0x10(%ebp),%eax
 844:	a3 54 0d 00 00       	mov    %eax,0xd54
 849:	a1 54 0d 00 00       	mov    0xd54,%eax
 84e:	a3 4c 0d 00 00       	mov    %eax,0xd4c
    base.s.size = 0;
 853:	c7 05 50 0d 00 00 00 	movl   $0x0,0xd50
 85a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 860:	8b 00                	mov    (%eax),%eax
 862:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 865:	8b 45 f4             	mov    -0xc(%ebp),%eax
 868:	8b 40 04             	mov    0x4(%eax),%eax
 86b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 86e:	72 4d                	jb     8bd <malloc+0xa6>
      if(p->s.size == nunits)
 870:	8b 45 f4             	mov    -0xc(%ebp),%eax
 873:	8b 40 04             	mov    0x4(%eax),%eax
 876:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 879:	75 0c                	jne    887 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 87b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87e:	8b 10                	mov    (%eax),%edx
 880:	8b 45 f0             	mov    -0x10(%ebp),%eax
 883:	89 10                	mov    %edx,(%eax)
 885:	eb 26                	jmp    8ad <malloc+0x96>
      else {
        p->s.size -= nunits;
 887:	8b 45 f4             	mov    -0xc(%ebp),%eax
 88a:	8b 40 04             	mov    0x4(%eax),%eax
 88d:	89 c2                	mov    %eax,%edx
 88f:	2b 55 ec             	sub    -0x14(%ebp),%edx
 892:	8b 45 f4             	mov    -0xc(%ebp),%eax
 895:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 898:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89b:	8b 40 04             	mov    0x4(%eax),%eax
 89e:	c1 e0 03             	shl    $0x3,%eax
 8a1:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8aa:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b0:	a3 54 0d 00 00       	mov    %eax,0xd54
      return (void*)(p + 1);
 8b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b8:	83 c0 08             	add    $0x8,%eax
 8bb:	eb 38                	jmp    8f5 <malloc+0xde>
    }
    if(p == freep)
 8bd:	a1 54 0d 00 00       	mov    0xd54,%eax
 8c2:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8c5:	75 1b                	jne    8e2 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8ca:	89 04 24             	mov    %eax,(%esp)
 8cd:	e8 ed fe ff ff       	call   7bf <morecore>
 8d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8d9:	75 07                	jne    8e2 <malloc+0xcb>
        return 0;
 8db:	b8 00 00 00 00       	mov    $0x0,%eax
 8e0:	eb 13                	jmp    8f5 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8eb:	8b 00                	mov    (%eax),%eax
 8ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8f0:	e9 70 ff ff ff       	jmp    865 <malloc+0x4e>
}
 8f5:	c9                   	leave  
 8f6:	c3                   	ret    
 8f7:	90                   	nop

000008f8 <semaphore_create>:
#include "semaphore.h"

struct semaphore* 
semaphore_create(int initial_semaphore_value)
{
 8f8:	55                   	push   %ebp
 8f9:	89 e5                	mov    %esp,%ebp
 8fb:	83 ec 28             	sub    $0x28,%esp
  struct semaphore* s = malloc(sizeof(struct semaphore));
 8fe:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
 905:	e8 0d ff ff ff       	call   817 <malloc>
 90a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((s->s1 = binary_semaphore_create(1)) != -1)
 90d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 914:	e8 2b fb ff ff       	call   444 <binary_semaphore_create>
 919:	8b 55 f4             	mov    -0xc(%ebp),%edx
 91c:	89 42 04             	mov    %eax,0x4(%edx)
 91f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 922:	8b 40 04             	mov    0x4(%eax),%eax
 925:	83 f8 ff             	cmp    $0xffffffff,%eax
 928:	74 2a                	je     954 <semaphore_create+0x5c>
  {
    if((s->s2 = binary_semaphore_create(1)) != -1)
 92a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 931:	e8 0e fb ff ff       	call   444 <binary_semaphore_create>
 936:	8b 55 f4             	mov    -0xc(%ebp),%edx
 939:	89 42 08             	mov    %eax,0x8(%edx)
 93c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 93f:	8b 40 08             	mov    0x8(%eax),%eax
 942:	83 f8 ff             	cmp    $0xffffffff,%eax
 945:	74 0d                	je     954 <semaphore_create+0x5c>
    {
      s->value = initial_semaphore_value;
 947:	8b 45 f4             	mov    -0xc(%ebp),%eax
 94a:	8b 55 08             	mov    0x8(%ebp),%edx
 94d:	89 10                	mov    %edx,(%eax)
      return s;
 94f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 952:	eb 15                	jmp    969 <semaphore_create+0x71>
    }
  }
  free(s);
 954:	8b 45 f4             	mov    -0xc(%ebp),%eax
 957:	89 04 24             	mov    %eax,(%esp)
 95a:	e8 89 fd ff ff       	call   6e8 <free>
  s = 0;
 95f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  return s;
 966:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 969:	c9                   	leave  
 96a:	c3                   	ret    

0000096b <semaphore_down>:

void 
semaphore_down(struct semaphore* sem )
{
 96b:	55                   	push   %ebp
 96c:	89 e5                	mov    %esp,%ebp
 96e:	83 ec 18             	sub    $0x18,%esp
 binary_semaphore_down(sem->s2);
 971:	8b 45 08             	mov    0x8(%ebp),%eax
 974:	8b 40 08             	mov    0x8(%eax),%eax
 977:	89 04 24             	mov    %eax,(%esp)
 97a:	e8 cd fa ff ff       	call   44c <binary_semaphore_down>
 binary_semaphore_down(sem->s1);
 97f:	8b 45 08             	mov    0x8(%ebp),%eax
 982:	8b 40 04             	mov    0x4(%eax),%eax
 985:	89 04 24             	mov    %eax,(%esp)
 988:	e8 bf fa ff ff       	call   44c <binary_semaphore_down>
 sem->value--;
 98d:	8b 45 08             	mov    0x8(%ebp),%eax
 990:	8b 00                	mov    (%eax),%eax
 992:	8d 50 ff             	lea    -0x1(%eax),%edx
 995:	8b 45 08             	mov    0x8(%ebp),%eax
 998:	89 10                	mov    %edx,(%eax)
 if(sem->value>0)
 99a:	8b 45 08             	mov    0x8(%ebp),%eax
 99d:	8b 00                	mov    (%eax),%eax
 99f:	85 c0                	test   %eax,%eax
 9a1:	7e 0e                	jle    9b1 <semaphore_down+0x46>
  binary_semaphore_up(sem->s2);
 9a3:	8b 45 08             	mov    0x8(%ebp),%eax
 9a6:	8b 40 08             	mov    0x8(%eax),%eax
 9a9:	89 04 24             	mov    %eax,(%esp)
 9ac:	e8 a3 fa ff ff       	call   454 <binary_semaphore_up>
 binary_semaphore_up(sem->s1);
 9b1:	8b 45 08             	mov    0x8(%ebp),%eax
 9b4:	8b 40 04             	mov    0x4(%eax),%eax
 9b7:	89 04 24             	mov    %eax,(%esp)
 9ba:	e8 95 fa ff ff       	call   454 <binary_semaphore_up>
}
 9bf:	c9                   	leave  
 9c0:	c3                   	ret    

000009c1 <semaphore_up>:

void 
semaphore_up(struct semaphore* sem )
{
 9c1:	55                   	push   %ebp
 9c2:	89 e5                	mov    %esp,%ebp
 9c4:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s1);
 9c7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ca:	8b 40 04             	mov    0x4(%eax),%eax
 9cd:	89 04 24             	mov    %eax,(%esp)
 9d0:	e8 77 fa ff ff       	call   44c <binary_semaphore_down>
  sem->value++;
 9d5:	8b 45 08             	mov    0x8(%ebp),%eax
 9d8:	8b 00                	mov    (%eax),%eax
 9da:	8d 50 01             	lea    0x1(%eax),%edx
 9dd:	8b 45 08             	mov    0x8(%ebp),%eax
 9e0:	89 10                	mov    %edx,(%eax)
  if(sem->value == 1)
 9e2:	8b 45 08             	mov    0x8(%ebp),%eax
 9e5:	8b 00                	mov    (%eax),%eax
 9e7:	83 f8 01             	cmp    $0x1,%eax
 9ea:	75 0e                	jne    9fa <semaphore_up+0x39>
    binary_semaphore_up(sem->s2);
 9ec:	8b 45 08             	mov    0x8(%ebp),%eax
 9ef:	8b 40 08             	mov    0x8(%eax),%eax
 9f2:	89 04 24             	mov    %eax,(%esp)
 9f5:	e8 5a fa ff ff       	call   454 <binary_semaphore_up>
  binary_semaphore_up(sem->s1);
 9fa:	8b 45 08             	mov    0x8(%ebp),%eax
 9fd:	8b 40 04             	mov    0x4(%eax),%eax
 a00:	89 04 24             	mov    %eax,(%esp)
 a03:	e8 4c fa ff ff       	call   454 <binary_semaphore_up>
}
 a08:	c9                   	leave  
 a09:	c3                   	ret    
