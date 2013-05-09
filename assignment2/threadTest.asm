
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
  int b=0;
   7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(;;)
  {
    int i=0;
   e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    b = binary_semaphore_down(lock);
  15:	a1 dc 0d 00 00       	mov    0xddc,%eax
  1a:	89 04 24             	mov    %eax,(%esp)
  1d:	e8 86 04 00 00       	call   4a8 <binary_semaphore_down>
  22:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(b == -1)
  25:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  29:	75 45                	jne    70 <print+0x70>
    {
      printf(1,"the requested semaphore does not exist\n");
  2b:	c7 44 24 04 68 0a 00 	movl   $0xa68,0x4(%esp)
  32:	00 
  33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3a:	e8 50 05 00 00       	call   58f <printf>
      exit();
  3f:	e8 94 03 00 00       	call   3d8 <exit>
    }
    for(;i<3;i++)
      printf(1,"Process %d Thread %d is running.\n",thread_getProcId(),thread_getId());
  44:	e8 37 04 00 00       	call   480 <thread_getId>
  49:	89 c3                	mov    %eax,%ebx
  4b:	e8 38 04 00 00       	call   488 <thread_getProcId>
  50:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  54:	89 44 24 08          	mov    %eax,0x8(%esp)
  58:	c7 44 24 04 90 0a 00 	movl   $0xa90,0x4(%esp)
  5f:	00 
  60:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  67:	e8 23 05 00 00       	call   58f <printf>
    if(b == -1)
    {
      printf(1,"the requested semaphore does not exist\n");
      exit();
    }
    for(;i<3;i++)
  6c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  70:	83 7d f4 02          	cmpl   $0x2,-0xc(%ebp)
  74:	7e ce                	jle    44 <print+0x44>
      printf(1,"Process %d Thread %d is running.\n",thread_getProcId(),thread_getId());
    binary_semaphore_up(lock);
  76:	a1 dc 0d 00 00       	mov    0xddc,%eax
  7b:	89 04 24             	mov    %eax,(%esp)
  7e:	e8 2d 04 00 00       	call   4b0 <binary_semaphore_up>
    sleep(1);
  83:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8a:	e8 d9 03 00 00       	call   468 <sleep>
  }
  8f:	e9 7a ff ff ff       	jmp    e <print+0xe>

00000094 <threadTest>:
}


void
threadTest(char* n)
{
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	83 ec 28             	sub    $0x28,%esp
  int value = 0;
  9a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  lock = binary_semaphore_create(1);
  a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  a8:	e8 f3 03 00 00       	call   4a0 <binary_semaphore_create>
  ad:	a3 dc 0d 00 00       	mov    %eax,0xddc
  if(n)
  b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  b6:	0f 84 87 00 00 00    	je     143 <threadTest+0xaf>
  {
    int num = atoi(n);
  bc:	8b 45 08             	mov    0x8(%ebp),%eax
  bf:	89 04 24             	mov    %eax,(%esp)
  c2:	e8 80 02 00 00       	call   347 <atoi>
  c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for(;num>0;num--)
  ca:	eb 71                	jmp    13d <threadTest+0xa9>
    {
      int stack_size = 4096;
  cc:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
      void* stack = malloc(stack_size);
  d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  d6:	89 04 24             	mov    %eax,(%esp)
  d9:	e8 95 07 00 00       	call   873 <malloc>
  de:	89 45 e8             	mov    %eax,-0x18(%ebp)
      memset(stack,0,stack_size);
  e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  ef:	00 
  f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  f3:	89 04 24             	mov    %eax,(%esp)
  f6:	e8 38 01 00 00       	call   233 <memset>
      value = thread_create((void*)print,stack,stack_size);
  fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  fe:	89 44 24 08          	mov    %eax,0x8(%esp)
 102:	8b 45 e8             	mov    -0x18(%ebp),%eax
 105:	89 44 24 04          	mov    %eax,0x4(%esp)
 109:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 110:	e8 63 03 00 00       	call   478 <thread_create>
 115:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(value == -1)
 118:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
 11c:	75 1b                	jne    139 <threadTest+0xa5>
	printf(1,"Failed to create thread number %d\n",num);
 11e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 121:	89 44 24 08          	mov    %eax,0x8(%esp)
 125:	c7 44 24 04 b4 0a 00 	movl   $0xab4,0x4(%esp)
 12c:	00 
 12d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 134:	e8 56 04 00 00       	call   58f <printf>
  int value = 0;
  lock = binary_semaphore_create(1);
  if(n)
  {
    int num = atoi(n);
    for(;num>0;num--)
 139:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 13d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 141:	7f 89                	jg     cc <threadTest+0x38>
      value = thread_create((void*)print,stack,stack_size);
      if(value == -1)
	printf(1,"Failed to create thread number %d\n",num);
    }
  }
}
 143:	c9                   	leave  
 144:	c3                   	ret    

00000145 <main>:



int
main(int argc, char** argv)
{
 145:	55                   	push   %ebp
 146:	89 e5                	mov    %esp,%ebp
 148:	83 e4 f0             	and    $0xfffffff0,%esp
 14b:	83 ec 10             	sub    $0x10,%esp
  threadTest(argv[1]);
 14e:	8b 45 0c             	mov    0xc(%ebp),%eax
 151:	83 c0 04             	add    $0x4,%eax
 154:	8b 00                	mov    (%eax),%eax
 156:	89 04 24             	mov    %eax,(%esp)
 159:	e8 36 ff ff ff       	call   94 <threadTest>
  thread_exit(0);
 15e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 165:	e8 2e 03 00 00       	call   498 <thread_exit>
  return 0;
 16a:	b8 00 00 00 00       	mov    $0x0,%eax
 16f:	c9                   	leave  
 170:	c3                   	ret    
 171:	90                   	nop
 172:	90                   	nop
 173:	90                   	nop

00000174 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	57                   	push   %edi
 178:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 179:	8b 4d 08             	mov    0x8(%ebp),%ecx
 17c:	8b 55 10             	mov    0x10(%ebp),%edx
 17f:	8b 45 0c             	mov    0xc(%ebp),%eax
 182:	89 cb                	mov    %ecx,%ebx
 184:	89 df                	mov    %ebx,%edi
 186:	89 d1                	mov    %edx,%ecx
 188:	fc                   	cld    
 189:	f3 aa                	rep stos %al,%es:(%edi)
 18b:	89 ca                	mov    %ecx,%edx
 18d:	89 fb                	mov    %edi,%ebx
 18f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 192:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 195:	5b                   	pop    %ebx
 196:	5f                   	pop    %edi
 197:	5d                   	pop    %ebp
 198:	c3                   	ret    

00000199 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 199:	55                   	push   %ebp
 19a:	89 e5                	mov    %esp,%ebp
 19c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 1a5:	90                   	nop
 1a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a9:	0f b6 10             	movzbl (%eax),%edx
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	88 10                	mov    %dl,(%eax)
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	0f b6 00             	movzbl (%eax),%eax
 1b7:	84 c0                	test   %al,%al
 1b9:	0f 95 c0             	setne  %al
 1bc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1c0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 1c4:	84 c0                	test   %al,%al
 1c6:	75 de                	jne    1a6 <strcpy+0xd>
    ;
  return os;
 1c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1cb:	c9                   	leave  
 1cc:	c3                   	ret    

000001cd <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1cd:	55                   	push   %ebp
 1ce:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 1d0:	eb 08                	jmp    1da <strcmp+0xd>
    p++, q++;
 1d2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 1d6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 1da:	8b 45 08             	mov    0x8(%ebp),%eax
 1dd:	0f b6 00             	movzbl (%eax),%eax
 1e0:	84 c0                	test   %al,%al
 1e2:	74 10                	je     1f4 <strcmp+0x27>
 1e4:	8b 45 08             	mov    0x8(%ebp),%eax
 1e7:	0f b6 10             	movzbl (%eax),%edx
 1ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ed:	0f b6 00             	movzbl (%eax),%eax
 1f0:	38 c2                	cmp    %al,%dl
 1f2:	74 de                	je     1d2 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 1f4:	8b 45 08             	mov    0x8(%ebp),%eax
 1f7:	0f b6 00             	movzbl (%eax),%eax
 1fa:	0f b6 d0             	movzbl %al,%edx
 1fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 200:	0f b6 00             	movzbl (%eax),%eax
 203:	0f b6 c0             	movzbl %al,%eax
 206:	89 d1                	mov    %edx,%ecx
 208:	29 c1                	sub    %eax,%ecx
 20a:	89 c8                	mov    %ecx,%eax
}
 20c:	5d                   	pop    %ebp
 20d:	c3                   	ret    

0000020e <strlen>:

uint
strlen(char *s)
{
 20e:	55                   	push   %ebp
 20f:	89 e5                	mov    %esp,%ebp
 211:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 214:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 21b:	eb 04                	jmp    221 <strlen+0x13>
 21d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 221:	8b 45 fc             	mov    -0x4(%ebp),%eax
 224:	03 45 08             	add    0x8(%ebp),%eax
 227:	0f b6 00             	movzbl (%eax),%eax
 22a:	84 c0                	test   %al,%al
 22c:	75 ef                	jne    21d <strlen+0xf>
    ;
  return n;
 22e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 231:	c9                   	leave  
 232:	c3                   	ret    

00000233 <memset>:

void*
memset(void *dst, int c, uint n)
{
 233:	55                   	push   %ebp
 234:	89 e5                	mov    %esp,%ebp
 236:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 239:	8b 45 10             	mov    0x10(%ebp),%eax
 23c:	89 44 24 08          	mov    %eax,0x8(%esp)
 240:	8b 45 0c             	mov    0xc(%ebp),%eax
 243:	89 44 24 04          	mov    %eax,0x4(%esp)
 247:	8b 45 08             	mov    0x8(%ebp),%eax
 24a:	89 04 24             	mov    %eax,(%esp)
 24d:	e8 22 ff ff ff       	call   174 <stosb>
  return dst;
 252:	8b 45 08             	mov    0x8(%ebp),%eax
}
 255:	c9                   	leave  
 256:	c3                   	ret    

00000257 <strchr>:

char*
strchr(const char *s, char c)
{
 257:	55                   	push   %ebp
 258:	89 e5                	mov    %esp,%ebp
 25a:	83 ec 04             	sub    $0x4,%esp
 25d:	8b 45 0c             	mov    0xc(%ebp),%eax
 260:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 263:	eb 14                	jmp    279 <strchr+0x22>
    if(*s == c)
 265:	8b 45 08             	mov    0x8(%ebp),%eax
 268:	0f b6 00             	movzbl (%eax),%eax
 26b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 26e:	75 05                	jne    275 <strchr+0x1e>
      return (char*)s;
 270:	8b 45 08             	mov    0x8(%ebp),%eax
 273:	eb 13                	jmp    288 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 275:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 279:	8b 45 08             	mov    0x8(%ebp),%eax
 27c:	0f b6 00             	movzbl (%eax),%eax
 27f:	84 c0                	test   %al,%al
 281:	75 e2                	jne    265 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 283:	b8 00 00 00 00       	mov    $0x0,%eax
}
 288:	c9                   	leave  
 289:	c3                   	ret    

0000028a <gets>:

char*
gets(char *buf, int max)
{
 28a:	55                   	push   %ebp
 28b:	89 e5                	mov    %esp,%ebp
 28d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 290:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 297:	eb 44                	jmp    2dd <gets+0x53>
    cc = read(0, &c, 1);
 299:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 2a0:	00 
 2a1:	8d 45 ef             	lea    -0x11(%ebp),%eax
 2a4:	89 44 24 04          	mov    %eax,0x4(%esp)
 2a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 2af:	e8 3c 01 00 00       	call   3f0 <read>
 2b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 2b7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 2bb:	7e 2d                	jle    2ea <gets+0x60>
      break;
    buf[i++] = c;
 2bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2c0:	03 45 08             	add    0x8(%ebp),%eax
 2c3:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 2c7:	88 10                	mov    %dl,(%eax)
 2c9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 2cd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2d1:	3c 0a                	cmp    $0xa,%al
 2d3:	74 16                	je     2eb <gets+0x61>
 2d5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 2d9:	3c 0d                	cmp    $0xd,%al
 2db:	74 0e                	je     2eb <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2e0:	83 c0 01             	add    $0x1,%eax
 2e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
 2e6:	7c b1                	jl     299 <gets+0xf>
 2e8:	eb 01                	jmp    2eb <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 2ea:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 2eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2ee:	03 45 08             	add    0x8(%ebp),%eax
 2f1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 2f4:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2f7:	c9                   	leave  
 2f8:	c3                   	ret    

000002f9 <stat>:

int
stat(char *n, struct stat *st)
{
 2f9:	55                   	push   %ebp
 2fa:	89 e5                	mov    %esp,%ebp
 2fc:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 306:	00 
 307:	8b 45 08             	mov    0x8(%ebp),%eax
 30a:	89 04 24             	mov    %eax,(%esp)
 30d:	e8 06 01 00 00       	call   418 <open>
 312:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 315:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 319:	79 07                	jns    322 <stat+0x29>
    return -1;
 31b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 320:	eb 23                	jmp    345 <stat+0x4c>
  r = fstat(fd, st);
 322:	8b 45 0c             	mov    0xc(%ebp),%eax
 325:	89 44 24 04          	mov    %eax,0x4(%esp)
 329:	8b 45 f4             	mov    -0xc(%ebp),%eax
 32c:	89 04 24             	mov    %eax,(%esp)
 32f:	e8 fc 00 00 00       	call   430 <fstat>
 334:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 337:	8b 45 f4             	mov    -0xc(%ebp),%eax
 33a:	89 04 24             	mov    %eax,(%esp)
 33d:	e8 be 00 00 00       	call   400 <close>
  return r;
 342:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 345:	c9                   	leave  
 346:	c3                   	ret    

00000347 <atoi>:

int
atoi(const char *s)
{
 347:	55                   	push   %ebp
 348:	89 e5                	mov    %esp,%ebp
 34a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 34d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 354:	eb 23                	jmp    379 <atoi+0x32>
    n = n*10 + *s++ - '0';
 356:	8b 55 fc             	mov    -0x4(%ebp),%edx
 359:	89 d0                	mov    %edx,%eax
 35b:	c1 e0 02             	shl    $0x2,%eax
 35e:	01 d0                	add    %edx,%eax
 360:	01 c0                	add    %eax,%eax
 362:	89 c2                	mov    %eax,%edx
 364:	8b 45 08             	mov    0x8(%ebp),%eax
 367:	0f b6 00             	movzbl (%eax),%eax
 36a:	0f be c0             	movsbl %al,%eax
 36d:	01 d0                	add    %edx,%eax
 36f:	83 e8 30             	sub    $0x30,%eax
 372:	89 45 fc             	mov    %eax,-0x4(%ebp)
 375:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 379:	8b 45 08             	mov    0x8(%ebp),%eax
 37c:	0f b6 00             	movzbl (%eax),%eax
 37f:	3c 2f                	cmp    $0x2f,%al
 381:	7e 0a                	jle    38d <atoi+0x46>
 383:	8b 45 08             	mov    0x8(%ebp),%eax
 386:	0f b6 00             	movzbl (%eax),%eax
 389:	3c 39                	cmp    $0x39,%al
 38b:	7e c9                	jle    356 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 38d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 390:	c9                   	leave  
 391:	c3                   	ret    

00000392 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 392:	55                   	push   %ebp
 393:	89 e5                	mov    %esp,%ebp
 395:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 398:	8b 45 08             	mov    0x8(%ebp),%eax
 39b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 39e:	8b 45 0c             	mov    0xc(%ebp),%eax
 3a1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 3a4:	eb 13                	jmp    3b9 <memmove+0x27>
    *dst++ = *src++;
 3a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 3a9:	0f b6 10             	movzbl (%eax),%edx
 3ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
 3af:	88 10                	mov    %dl,(%eax)
 3b1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3b5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 3b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 3bd:	0f 9f c0             	setg   %al
 3c0:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 3c4:	84 c0                	test   %al,%al
 3c6:	75 de                	jne    3a6 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 3c8:	8b 45 08             	mov    0x8(%ebp),%eax
}
 3cb:	c9                   	leave  
 3cc:	c3                   	ret    
 3cd:	90                   	nop
 3ce:	90                   	nop
 3cf:	90                   	nop

000003d0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 3d0:	b8 01 00 00 00       	mov    $0x1,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <exit>:
SYSCALL(exit)
 3d8:	b8 02 00 00 00       	mov    $0x2,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <wait>:
SYSCALL(wait)
 3e0:	b8 03 00 00 00       	mov    $0x3,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <pipe>:
SYSCALL(pipe)
 3e8:	b8 04 00 00 00       	mov    $0x4,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <read>:
SYSCALL(read)
 3f0:	b8 05 00 00 00       	mov    $0x5,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <write>:
SYSCALL(write)
 3f8:	b8 10 00 00 00       	mov    $0x10,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <close>:
SYSCALL(close)
 400:	b8 15 00 00 00       	mov    $0x15,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <kill>:
SYSCALL(kill)
 408:	b8 06 00 00 00       	mov    $0x6,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <exec>:
SYSCALL(exec)
 410:	b8 07 00 00 00       	mov    $0x7,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <open>:
SYSCALL(open)
 418:	b8 0f 00 00 00       	mov    $0xf,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <mknod>:
SYSCALL(mknod)
 420:	b8 11 00 00 00       	mov    $0x11,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <unlink>:
SYSCALL(unlink)
 428:	b8 12 00 00 00       	mov    $0x12,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <fstat>:
SYSCALL(fstat)
 430:	b8 08 00 00 00       	mov    $0x8,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <link>:
SYSCALL(link)
 438:	b8 13 00 00 00       	mov    $0x13,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <mkdir>:
SYSCALL(mkdir)
 440:	b8 14 00 00 00       	mov    $0x14,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <chdir>:
SYSCALL(chdir)
 448:	b8 09 00 00 00       	mov    $0x9,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <dup>:
SYSCALL(dup)
 450:	b8 0a 00 00 00       	mov    $0xa,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <getpid>:
SYSCALL(getpid)
 458:	b8 0b 00 00 00       	mov    $0xb,%eax
 45d:	cd 40                	int    $0x40
 45f:	c3                   	ret    

00000460 <sbrk>:
SYSCALL(sbrk)
 460:	b8 0c 00 00 00       	mov    $0xc,%eax
 465:	cd 40                	int    $0x40
 467:	c3                   	ret    

00000468 <sleep>:
SYSCALL(sleep)
 468:	b8 0d 00 00 00       	mov    $0xd,%eax
 46d:	cd 40                	int    $0x40
 46f:	c3                   	ret    

00000470 <uptime>:
SYSCALL(uptime)
 470:	b8 0e 00 00 00       	mov    $0xe,%eax
 475:	cd 40                	int    $0x40
 477:	c3                   	ret    

00000478 <thread_create>:
SYSCALL(thread_create)
 478:	b8 16 00 00 00       	mov    $0x16,%eax
 47d:	cd 40                	int    $0x40
 47f:	c3                   	ret    

00000480 <thread_getId>:
SYSCALL(thread_getId)
 480:	b8 17 00 00 00       	mov    $0x17,%eax
 485:	cd 40                	int    $0x40
 487:	c3                   	ret    

00000488 <thread_getProcId>:
SYSCALL(thread_getProcId)
 488:	b8 18 00 00 00       	mov    $0x18,%eax
 48d:	cd 40                	int    $0x40
 48f:	c3                   	ret    

00000490 <thread_join>:
SYSCALL(thread_join)
 490:	b8 19 00 00 00       	mov    $0x19,%eax
 495:	cd 40                	int    $0x40
 497:	c3                   	ret    

00000498 <thread_exit>:
SYSCALL(thread_exit)
 498:	b8 1a 00 00 00       	mov    $0x1a,%eax
 49d:	cd 40                	int    $0x40
 49f:	c3                   	ret    

000004a0 <binary_semaphore_create>:
SYSCALL(binary_semaphore_create)
 4a0:	b8 1b 00 00 00       	mov    $0x1b,%eax
 4a5:	cd 40                	int    $0x40
 4a7:	c3                   	ret    

000004a8 <binary_semaphore_down>:
SYSCALL(binary_semaphore_down)
 4a8:	b8 1c 00 00 00       	mov    $0x1c,%eax
 4ad:	cd 40                	int    $0x40
 4af:	c3                   	ret    

000004b0 <binary_semaphore_up>:
SYSCALL(binary_semaphore_up)
 4b0:	b8 1d 00 00 00       	mov    $0x1d,%eax
 4b5:	cd 40                	int    $0x40
 4b7:	c3                   	ret    

000004b8 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4b8:	55                   	push   %ebp
 4b9:	89 e5                	mov    %esp,%ebp
 4bb:	83 ec 28             	sub    $0x28,%esp
 4be:	8b 45 0c             	mov    0xc(%ebp),%eax
 4c1:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 4c4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4cb:	00 
 4cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
 4cf:	89 44 24 04          	mov    %eax,0x4(%esp)
 4d3:	8b 45 08             	mov    0x8(%ebp),%eax
 4d6:	89 04 24             	mov    %eax,(%esp)
 4d9:	e8 1a ff ff ff       	call   3f8 <write>
}
 4de:	c9                   	leave  
 4df:	c3                   	ret    

000004e0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4e0:	55                   	push   %ebp
 4e1:	89 e5                	mov    %esp,%ebp
 4e3:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 4e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 4ed:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 4f1:	74 17                	je     50a <printint+0x2a>
 4f3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 4f7:	79 11                	jns    50a <printint+0x2a>
    neg = 1;
 4f9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 500:	8b 45 0c             	mov    0xc(%ebp),%eax
 503:	f7 d8                	neg    %eax
 505:	89 45 ec             	mov    %eax,-0x14(%ebp)
 508:	eb 06                	jmp    510 <printint+0x30>
  } else {
    x = xx;
 50a:	8b 45 0c             	mov    0xc(%ebp),%eax
 50d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 510:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 517:	8b 4d 10             	mov    0x10(%ebp),%ecx
 51a:	8b 45 ec             	mov    -0x14(%ebp),%eax
 51d:	ba 00 00 00 00       	mov    $0x0,%edx
 522:	f7 f1                	div    %ecx
 524:	89 d0                	mov    %edx,%eax
 526:	0f b6 90 bc 0d 00 00 	movzbl 0xdbc(%eax),%edx
 52d:	8d 45 dc             	lea    -0x24(%ebp),%eax
 530:	03 45 f4             	add    -0xc(%ebp),%eax
 533:	88 10                	mov    %dl,(%eax)
 535:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 539:	8b 55 10             	mov    0x10(%ebp),%edx
 53c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 53f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 542:	ba 00 00 00 00       	mov    $0x0,%edx
 547:	f7 75 d4             	divl   -0x2c(%ebp)
 54a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 54d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 551:	75 c4                	jne    517 <printint+0x37>
  if(neg)
 553:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 557:	74 2a                	je     583 <printint+0xa3>
    buf[i++] = '-';
 559:	8d 45 dc             	lea    -0x24(%ebp),%eax
 55c:	03 45 f4             	add    -0xc(%ebp),%eax
 55f:	c6 00 2d             	movb   $0x2d,(%eax)
 562:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 566:	eb 1b                	jmp    583 <printint+0xa3>
    putc(fd, buf[i]);
 568:	8d 45 dc             	lea    -0x24(%ebp),%eax
 56b:	03 45 f4             	add    -0xc(%ebp),%eax
 56e:	0f b6 00             	movzbl (%eax),%eax
 571:	0f be c0             	movsbl %al,%eax
 574:	89 44 24 04          	mov    %eax,0x4(%esp)
 578:	8b 45 08             	mov    0x8(%ebp),%eax
 57b:	89 04 24             	mov    %eax,(%esp)
 57e:	e8 35 ff ff ff       	call   4b8 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 583:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 587:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 58b:	79 db                	jns    568 <printint+0x88>
    putc(fd, buf[i]);
}
 58d:	c9                   	leave  
 58e:	c3                   	ret    

0000058f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 58f:	55                   	push   %ebp
 590:	89 e5                	mov    %esp,%ebp
 592:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 595:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 59c:	8d 45 0c             	lea    0xc(%ebp),%eax
 59f:	83 c0 04             	add    $0x4,%eax
 5a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 5a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 5ac:	e9 7d 01 00 00       	jmp    72e <printf+0x19f>
    c = fmt[i] & 0xff;
 5b1:	8b 55 0c             	mov    0xc(%ebp),%edx
 5b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5b7:	01 d0                	add    %edx,%eax
 5b9:	0f b6 00             	movzbl (%eax),%eax
 5bc:	0f be c0             	movsbl %al,%eax
 5bf:	25 ff 00 00 00       	and    $0xff,%eax
 5c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 5c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 5cb:	75 2c                	jne    5f9 <printf+0x6a>
      if(c == '%'){
 5cd:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5d1:	75 0c                	jne    5df <printf+0x50>
        state = '%';
 5d3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 5da:	e9 4b 01 00 00       	jmp    72a <printf+0x19b>
      } else {
        putc(fd, c);
 5df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5e2:	0f be c0             	movsbl %al,%eax
 5e5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5e9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ec:	89 04 24             	mov    %eax,(%esp)
 5ef:	e8 c4 fe ff ff       	call   4b8 <putc>
 5f4:	e9 31 01 00 00       	jmp    72a <printf+0x19b>
      }
    } else if(state == '%'){
 5f9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 5fd:	0f 85 27 01 00 00    	jne    72a <printf+0x19b>
      if(c == 'd'){
 603:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 607:	75 2d                	jne    636 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 609:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60c:	8b 00                	mov    (%eax),%eax
 60e:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 615:	00 
 616:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 61d:	00 
 61e:	89 44 24 04          	mov    %eax,0x4(%esp)
 622:	8b 45 08             	mov    0x8(%ebp),%eax
 625:	89 04 24             	mov    %eax,(%esp)
 628:	e8 b3 fe ff ff       	call   4e0 <printint>
        ap++;
 62d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 631:	e9 ed 00 00 00       	jmp    723 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 636:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 63a:	74 06                	je     642 <printf+0xb3>
 63c:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 640:	75 2d                	jne    66f <printf+0xe0>
        printint(fd, *ap, 16, 0);
 642:	8b 45 e8             	mov    -0x18(%ebp),%eax
 645:	8b 00                	mov    (%eax),%eax
 647:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 64e:	00 
 64f:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 656:	00 
 657:	89 44 24 04          	mov    %eax,0x4(%esp)
 65b:	8b 45 08             	mov    0x8(%ebp),%eax
 65e:	89 04 24             	mov    %eax,(%esp)
 661:	e8 7a fe ff ff       	call   4e0 <printint>
        ap++;
 666:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 66a:	e9 b4 00 00 00       	jmp    723 <printf+0x194>
      } else if(c == 's'){
 66f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 673:	75 46                	jne    6bb <printf+0x12c>
        s = (char*)*ap;
 675:	8b 45 e8             	mov    -0x18(%ebp),%eax
 678:	8b 00                	mov    (%eax),%eax
 67a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 67d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 681:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 685:	75 27                	jne    6ae <printf+0x11f>
          s = "(null)";
 687:	c7 45 f4 d7 0a 00 00 	movl   $0xad7,-0xc(%ebp)
        while(*s != 0){
 68e:	eb 1e                	jmp    6ae <printf+0x11f>
          putc(fd, *s);
 690:	8b 45 f4             	mov    -0xc(%ebp),%eax
 693:	0f b6 00             	movzbl (%eax),%eax
 696:	0f be c0             	movsbl %al,%eax
 699:	89 44 24 04          	mov    %eax,0x4(%esp)
 69d:	8b 45 08             	mov    0x8(%ebp),%eax
 6a0:	89 04 24             	mov    %eax,(%esp)
 6a3:	e8 10 fe ff ff       	call   4b8 <putc>
          s++;
 6a8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 6ac:	eb 01                	jmp    6af <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 6ae:	90                   	nop
 6af:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6b2:	0f b6 00             	movzbl (%eax),%eax
 6b5:	84 c0                	test   %al,%al
 6b7:	75 d7                	jne    690 <printf+0x101>
 6b9:	eb 68                	jmp    723 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6bb:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 6bf:	75 1d                	jne    6de <printf+0x14f>
        putc(fd, *ap);
 6c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 6c4:	8b 00                	mov    (%eax),%eax
 6c6:	0f be c0             	movsbl %al,%eax
 6c9:	89 44 24 04          	mov    %eax,0x4(%esp)
 6cd:	8b 45 08             	mov    0x8(%ebp),%eax
 6d0:	89 04 24             	mov    %eax,(%esp)
 6d3:	e8 e0 fd ff ff       	call   4b8 <putc>
        ap++;
 6d8:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 6dc:	eb 45                	jmp    723 <printf+0x194>
      } else if(c == '%'){
 6de:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 6e2:	75 17                	jne    6fb <printf+0x16c>
        putc(fd, c);
 6e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6e7:	0f be c0             	movsbl %al,%eax
 6ea:	89 44 24 04          	mov    %eax,0x4(%esp)
 6ee:	8b 45 08             	mov    0x8(%ebp),%eax
 6f1:	89 04 24             	mov    %eax,(%esp)
 6f4:	e8 bf fd ff ff       	call   4b8 <putc>
 6f9:	eb 28                	jmp    723 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 6fb:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 702:	00 
 703:	8b 45 08             	mov    0x8(%ebp),%eax
 706:	89 04 24             	mov    %eax,(%esp)
 709:	e8 aa fd ff ff       	call   4b8 <putc>
        putc(fd, c);
 70e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 711:	0f be c0             	movsbl %al,%eax
 714:	89 44 24 04          	mov    %eax,0x4(%esp)
 718:	8b 45 08             	mov    0x8(%ebp),%eax
 71b:	89 04 24             	mov    %eax,(%esp)
 71e:	e8 95 fd ff ff       	call   4b8 <putc>
      }
      state = 0;
 723:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 72a:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 72e:	8b 55 0c             	mov    0xc(%ebp),%edx
 731:	8b 45 f0             	mov    -0x10(%ebp),%eax
 734:	01 d0                	add    %edx,%eax
 736:	0f b6 00             	movzbl (%eax),%eax
 739:	84 c0                	test   %al,%al
 73b:	0f 85 70 fe ff ff    	jne    5b1 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 741:	c9                   	leave  
 742:	c3                   	ret    
 743:	90                   	nop

00000744 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 744:	55                   	push   %ebp
 745:	89 e5                	mov    %esp,%ebp
 747:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 74a:	8b 45 08             	mov    0x8(%ebp),%eax
 74d:	83 e8 08             	sub    $0x8,%eax
 750:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 753:	a1 d8 0d 00 00       	mov    0xdd8,%eax
 758:	89 45 fc             	mov    %eax,-0x4(%ebp)
 75b:	eb 24                	jmp    781 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 75d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 760:	8b 00                	mov    (%eax),%eax
 762:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 765:	77 12                	ja     779 <free+0x35>
 767:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 76d:	77 24                	ja     793 <free+0x4f>
 76f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 772:	8b 00                	mov    (%eax),%eax
 774:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 777:	77 1a                	ja     793 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 779:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77c:	8b 00                	mov    (%eax),%eax
 77e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 781:	8b 45 f8             	mov    -0x8(%ebp),%eax
 784:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 787:	76 d4                	jbe    75d <free+0x19>
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	8b 00                	mov    (%eax),%eax
 78e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 791:	76 ca                	jbe    75d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 793:	8b 45 f8             	mov    -0x8(%ebp),%eax
 796:	8b 40 04             	mov    0x4(%eax),%eax
 799:	c1 e0 03             	shl    $0x3,%eax
 79c:	89 c2                	mov    %eax,%edx
 79e:	03 55 f8             	add    -0x8(%ebp),%edx
 7a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a4:	8b 00                	mov    (%eax),%eax
 7a6:	39 c2                	cmp    %eax,%edx
 7a8:	75 24                	jne    7ce <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 7aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ad:	8b 50 04             	mov    0x4(%eax),%edx
 7b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b3:	8b 00                	mov    (%eax),%eax
 7b5:	8b 40 04             	mov    0x4(%eax),%eax
 7b8:	01 c2                	add    %eax,%edx
 7ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7bd:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 7c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7c3:	8b 00                	mov    (%eax),%eax
 7c5:	8b 10                	mov    (%eax),%edx
 7c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7ca:	89 10                	mov    %edx,(%eax)
 7cc:	eb 0a                	jmp    7d8 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 7ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7d1:	8b 10                	mov    (%eax),%edx
 7d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7d6:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 7d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7db:	8b 40 04             	mov    0x4(%eax),%eax
 7de:	c1 e0 03             	shl    $0x3,%eax
 7e1:	03 45 fc             	add    -0x4(%ebp),%eax
 7e4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 7e7:	75 20                	jne    809 <free+0xc5>
    p->s.size += bp->s.size;
 7e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ec:	8b 50 04             	mov    0x4(%eax),%edx
 7ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7f2:	8b 40 04             	mov    0x4(%eax),%eax
 7f5:	01 c2                	add    %eax,%edx
 7f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7fa:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 7fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
 800:	8b 10                	mov    (%eax),%edx
 802:	8b 45 fc             	mov    -0x4(%ebp),%eax
 805:	89 10                	mov    %edx,(%eax)
 807:	eb 08                	jmp    811 <free+0xcd>
  } else
    p->s.ptr = bp;
 809:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80c:	8b 55 f8             	mov    -0x8(%ebp),%edx
 80f:	89 10                	mov    %edx,(%eax)
  freep = p;
 811:	8b 45 fc             	mov    -0x4(%ebp),%eax
 814:	a3 d8 0d 00 00       	mov    %eax,0xdd8
}
 819:	c9                   	leave  
 81a:	c3                   	ret    

0000081b <morecore>:

static Header*
morecore(uint nu)
{
 81b:	55                   	push   %ebp
 81c:	89 e5                	mov    %esp,%ebp
 81e:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 821:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 828:	77 07                	ja     831 <morecore+0x16>
    nu = 4096;
 82a:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 831:	8b 45 08             	mov    0x8(%ebp),%eax
 834:	c1 e0 03             	shl    $0x3,%eax
 837:	89 04 24             	mov    %eax,(%esp)
 83a:	e8 21 fc ff ff       	call   460 <sbrk>
 83f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 842:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 846:	75 07                	jne    84f <morecore+0x34>
    return 0;
 848:	b8 00 00 00 00       	mov    $0x0,%eax
 84d:	eb 22                	jmp    871 <morecore+0x56>
  hp = (Header*)p;
 84f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 852:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 855:	8b 45 f0             	mov    -0x10(%ebp),%eax
 858:	8b 55 08             	mov    0x8(%ebp),%edx
 85b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 85e:	8b 45 f0             	mov    -0x10(%ebp),%eax
 861:	83 c0 08             	add    $0x8,%eax
 864:	89 04 24             	mov    %eax,(%esp)
 867:	e8 d8 fe ff ff       	call   744 <free>
  return freep;
 86c:	a1 d8 0d 00 00       	mov    0xdd8,%eax
}
 871:	c9                   	leave  
 872:	c3                   	ret    

00000873 <malloc>:

void*
malloc(uint nbytes)
{
 873:	55                   	push   %ebp
 874:	89 e5                	mov    %esp,%ebp
 876:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 879:	8b 45 08             	mov    0x8(%ebp),%eax
 87c:	83 c0 07             	add    $0x7,%eax
 87f:	c1 e8 03             	shr    $0x3,%eax
 882:	83 c0 01             	add    $0x1,%eax
 885:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 888:	a1 d8 0d 00 00       	mov    0xdd8,%eax
 88d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 890:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 894:	75 23                	jne    8b9 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 896:	c7 45 f0 d0 0d 00 00 	movl   $0xdd0,-0x10(%ebp)
 89d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8a0:	a3 d8 0d 00 00       	mov    %eax,0xdd8
 8a5:	a1 d8 0d 00 00       	mov    0xdd8,%eax
 8aa:	a3 d0 0d 00 00       	mov    %eax,0xdd0
    base.s.size = 0;
 8af:	c7 05 d4 0d 00 00 00 	movl   $0x0,0xdd4
 8b6:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bc:	8b 00                	mov    (%eax),%eax
 8be:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8c4:	8b 40 04             	mov    0x4(%eax),%eax
 8c7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8ca:	72 4d                	jb     919 <malloc+0xa6>
      if(p->s.size == nunits)
 8cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8cf:	8b 40 04             	mov    0x4(%eax),%eax
 8d2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 8d5:	75 0c                	jne    8e3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 8d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8da:	8b 10                	mov    (%eax),%edx
 8dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8df:	89 10                	mov    %edx,(%eax)
 8e1:	eb 26                	jmp    909 <malloc+0x96>
      else {
        p->s.size -= nunits;
 8e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e6:	8b 40 04             	mov    0x4(%eax),%eax
 8e9:	89 c2                	mov    %eax,%edx
 8eb:	2b 55 ec             	sub    -0x14(%ebp),%edx
 8ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 8f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8f7:	8b 40 04             	mov    0x4(%eax),%eax
 8fa:	c1 e0 03             	shl    $0x3,%eax
 8fd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 900:	8b 45 f4             	mov    -0xc(%ebp),%eax
 903:	8b 55 ec             	mov    -0x14(%ebp),%edx
 906:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 909:	8b 45 f0             	mov    -0x10(%ebp),%eax
 90c:	a3 d8 0d 00 00       	mov    %eax,0xdd8
      return (void*)(p + 1);
 911:	8b 45 f4             	mov    -0xc(%ebp),%eax
 914:	83 c0 08             	add    $0x8,%eax
 917:	eb 38                	jmp    951 <malloc+0xde>
    }
    if(p == freep)
 919:	a1 d8 0d 00 00       	mov    0xdd8,%eax
 91e:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 921:	75 1b                	jne    93e <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 923:	8b 45 ec             	mov    -0x14(%ebp),%eax
 926:	89 04 24             	mov    %eax,(%esp)
 929:	e8 ed fe ff ff       	call   81b <morecore>
 92e:	89 45 f4             	mov    %eax,-0xc(%ebp)
 931:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 935:	75 07                	jne    93e <malloc+0xcb>
        return 0;
 937:	b8 00 00 00 00       	mov    $0x0,%eax
 93c:	eb 13                	jmp    951 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 941:	89 45 f0             	mov    %eax,-0x10(%ebp)
 944:	8b 45 f4             	mov    -0xc(%ebp),%eax
 947:	8b 00                	mov    (%eax),%eax
 949:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 94c:	e9 70 ff ff ff       	jmp    8c1 <malloc+0x4e>
}
 951:	c9                   	leave  
 952:	c3                   	ret    
 953:	90                   	nop

00000954 <semaphore_create>:
#include "semaphore.h"

struct semaphore* 
semaphore_create(int initial_semaphore_value)
{
 954:	55                   	push   %ebp
 955:	89 e5                	mov    %esp,%ebp
 957:	83 ec 28             	sub    $0x28,%esp
  struct semaphore* s = malloc(sizeof(struct semaphore));
 95a:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
 961:	e8 0d ff ff ff       	call   873 <malloc>
 966:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((s->s1 = binary_semaphore_create(1)) != -1)
 969:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 970:	e8 2b fb ff ff       	call   4a0 <binary_semaphore_create>
 975:	8b 55 f4             	mov    -0xc(%ebp),%edx
 978:	89 42 04             	mov    %eax,0x4(%edx)
 97b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 97e:	8b 40 04             	mov    0x4(%eax),%eax
 981:	83 f8 ff             	cmp    $0xffffffff,%eax
 984:	74 2a                	je     9b0 <semaphore_create+0x5c>
  {
    if((s->s2 = binary_semaphore_create(1)) != -1)
 986:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 98d:	e8 0e fb ff ff       	call   4a0 <binary_semaphore_create>
 992:	8b 55 f4             	mov    -0xc(%ebp),%edx
 995:	89 42 08             	mov    %eax,0x8(%edx)
 998:	8b 45 f4             	mov    -0xc(%ebp),%eax
 99b:	8b 40 08             	mov    0x8(%eax),%eax
 99e:	83 f8 ff             	cmp    $0xffffffff,%eax
 9a1:	74 0d                	je     9b0 <semaphore_create+0x5c>
    {
      s->value = initial_semaphore_value;
 9a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a6:	8b 55 08             	mov    0x8(%ebp),%edx
 9a9:	89 10                	mov    %edx,(%eax)
      return s;
 9ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9ae:	eb 15                	jmp    9c5 <semaphore_create+0x71>
    }
  }
  free(s);
 9b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9b3:	89 04 24             	mov    %eax,(%esp)
 9b6:	e8 89 fd ff ff       	call   744 <free>
  s = 0;
 9bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  return s;
 9c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 9c5:	c9                   	leave  
 9c6:	c3                   	ret    

000009c7 <semaphore_down>:

void 
semaphore_down(struct semaphore* sem )
{
 9c7:	55                   	push   %ebp
 9c8:	89 e5                	mov    %esp,%ebp
 9ca:	83 ec 18             	sub    $0x18,%esp
 binary_semaphore_down(sem->s2);
 9cd:	8b 45 08             	mov    0x8(%ebp),%eax
 9d0:	8b 40 08             	mov    0x8(%eax),%eax
 9d3:	89 04 24             	mov    %eax,(%esp)
 9d6:	e8 cd fa ff ff       	call   4a8 <binary_semaphore_down>
 binary_semaphore_down(sem->s1);
 9db:	8b 45 08             	mov    0x8(%ebp),%eax
 9de:	8b 40 04             	mov    0x4(%eax),%eax
 9e1:	89 04 24             	mov    %eax,(%esp)
 9e4:	e8 bf fa ff ff       	call   4a8 <binary_semaphore_down>
 sem->value--;
 9e9:	8b 45 08             	mov    0x8(%ebp),%eax
 9ec:	8b 00                	mov    (%eax),%eax
 9ee:	8d 50 ff             	lea    -0x1(%eax),%edx
 9f1:	8b 45 08             	mov    0x8(%ebp),%eax
 9f4:	89 10                	mov    %edx,(%eax)
 if(sem->value>0)
 9f6:	8b 45 08             	mov    0x8(%ebp),%eax
 9f9:	8b 00                	mov    (%eax),%eax
 9fb:	85 c0                	test   %eax,%eax
 9fd:	7e 0e                	jle    a0d <semaphore_down+0x46>
  binary_semaphore_up(sem->s2);
 9ff:	8b 45 08             	mov    0x8(%ebp),%eax
 a02:	8b 40 08             	mov    0x8(%eax),%eax
 a05:	89 04 24             	mov    %eax,(%esp)
 a08:	e8 a3 fa ff ff       	call   4b0 <binary_semaphore_up>
 binary_semaphore_up(sem->s1);
 a0d:	8b 45 08             	mov    0x8(%ebp),%eax
 a10:	8b 40 04             	mov    0x4(%eax),%eax
 a13:	89 04 24             	mov    %eax,(%esp)
 a16:	e8 95 fa ff ff       	call   4b0 <binary_semaphore_up>
}
 a1b:	c9                   	leave  
 a1c:	c3                   	ret    

00000a1d <semaphore_up>:

void 
semaphore_up(struct semaphore* sem )
{
 a1d:	55                   	push   %ebp
 a1e:	89 e5                	mov    %esp,%ebp
 a20:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s1);
 a23:	8b 45 08             	mov    0x8(%ebp),%eax
 a26:	8b 40 04             	mov    0x4(%eax),%eax
 a29:	89 04 24             	mov    %eax,(%esp)
 a2c:	e8 77 fa ff ff       	call   4a8 <binary_semaphore_down>
  sem->value++;
 a31:	8b 45 08             	mov    0x8(%ebp),%eax
 a34:	8b 00                	mov    (%eax),%eax
 a36:	8d 50 01             	lea    0x1(%eax),%edx
 a39:	8b 45 08             	mov    0x8(%ebp),%eax
 a3c:	89 10                	mov    %edx,(%eax)
  if(sem->value == 1)
 a3e:	8b 45 08             	mov    0x8(%ebp),%eax
 a41:	8b 00                	mov    (%eax),%eax
 a43:	83 f8 01             	cmp    $0x1,%eax
 a46:	75 0e                	jne    a56 <semaphore_up+0x39>
    binary_semaphore_up(sem->s2);
 a48:	8b 45 08             	mov    0x8(%ebp),%eax
 a4b:	8b 40 08             	mov    0x8(%eax),%eax
 a4e:	89 04 24             	mov    %eax,(%esp)
 a51:	e8 5a fa ff ff       	call   4b0 <binary_semaphore_up>
  binary_semaphore_up(sem->s1);
 a56:	8b 45 08             	mov    0x8(%ebp),%eax
 a59:	8b 40 04             	mov    0x4(%eax),%eax
 a5c:	89 04 24             	mov    %eax,(%esp)
 a5f:	e8 4c fa ff ff       	call   4b0 <binary_semaphore_up>
}
 a64:	c9                   	leave  
 a65:	c3                   	ret    
