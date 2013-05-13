
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(argc != 3){
   9:	83 7d 08 03          	cmpl   $0x3,0x8(%ebp)
   d:	74 19                	je     28 <main+0x28>
    printf(2, "Usage: ln old new\n");
   f:	c7 44 24 04 93 0b 00 	movl   $0xb93,0x4(%esp)
  16:	00 
  17:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1e:	e8 74 04 00 00       	call   497 <printf>
    exit();
  23:	e8 b8 02 00 00       	call   2e0 <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  28:	8b 45 0c             	mov    0xc(%ebp),%eax
  2b:	83 c0 08             	add    $0x8,%eax
  2e:	8b 10                	mov    (%eax),%edx
  30:	8b 45 0c             	mov    0xc(%ebp),%eax
  33:	83 c0 04             	add    $0x4,%eax
  36:	8b 00                	mov    (%eax),%eax
  38:	89 54 24 04          	mov    %edx,0x4(%esp)
  3c:	89 04 24             	mov    %eax,(%esp)
  3f:	e8 fc 02 00 00       	call   340 <link>
  44:	85 c0                	test   %eax,%eax
  46:	79 2c                	jns    74 <main+0x74>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  48:	8b 45 0c             	mov    0xc(%ebp),%eax
  4b:	83 c0 08             	add    $0x8,%eax
  4e:	8b 10                	mov    (%eax),%edx
  50:	8b 45 0c             	mov    0xc(%ebp),%eax
  53:	83 c0 04             	add    $0x4,%eax
  56:	8b 00                	mov    (%eax),%eax
  58:	89 54 24 0c          	mov    %edx,0xc(%esp)
  5c:	89 44 24 08          	mov    %eax,0x8(%esp)
  60:	c7 44 24 04 a6 0b 00 	movl   $0xba6,0x4(%esp)
  67:	00 
  68:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  6f:	e8 23 04 00 00       	call   497 <printf>
  exit();
  74:	e8 67 02 00 00       	call   2e0 <exit>
  79:	90                   	nop
  7a:	90                   	nop
  7b:	90                   	nop

0000007c <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  7c:	55                   	push   %ebp
  7d:	89 e5                	mov    %esp,%ebp
  7f:	57                   	push   %edi
  80:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  84:	8b 55 10             	mov    0x10(%ebp),%edx
  87:	8b 45 0c             	mov    0xc(%ebp),%eax
  8a:	89 cb                	mov    %ecx,%ebx
  8c:	89 df                	mov    %ebx,%edi
  8e:	89 d1                	mov    %edx,%ecx
  90:	fc                   	cld    
  91:	f3 aa                	rep stos %al,%es:(%edi)
  93:	89 ca                	mov    %ecx,%edx
  95:	89 fb                	mov    %edi,%ebx
  97:	89 5d 08             	mov    %ebx,0x8(%ebp)
  9a:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  9d:	5b                   	pop    %ebx
  9e:	5f                   	pop    %edi
  9f:	5d                   	pop    %ebp
  a0:	c3                   	ret    

000000a1 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  a1:	55                   	push   %ebp
  a2:	89 e5                	mov    %esp,%ebp
  a4:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a7:	8b 45 08             	mov    0x8(%ebp),%eax
  aa:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  ad:	90                   	nop
  ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  b1:	0f b6 10             	movzbl (%eax),%edx
  b4:	8b 45 08             	mov    0x8(%ebp),%eax
  b7:	88 10                	mov    %dl,(%eax)
  b9:	8b 45 08             	mov    0x8(%ebp),%eax
  bc:	0f b6 00             	movzbl (%eax),%eax
  bf:	84 c0                	test   %al,%al
  c1:	0f 95 c0             	setne  %al
  c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  c8:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  cc:	84 c0                	test   %al,%al
  ce:	75 de                	jne    ae <strcpy+0xd>
    ;
  return os;
  d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  d3:	c9                   	leave  
  d4:	c3                   	ret    

000000d5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  d5:	55                   	push   %ebp
  d6:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  d8:	eb 08                	jmp    e2 <strcmp+0xd>
    p++, q++;
  da:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  de:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	0f b6 00             	movzbl (%eax),%eax
  e8:	84 c0                	test   %al,%al
  ea:	74 10                	je     fc <strcmp+0x27>
  ec:	8b 45 08             	mov    0x8(%ebp),%eax
  ef:	0f b6 10             	movzbl (%eax),%edx
  f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  f5:	0f b6 00             	movzbl (%eax),%eax
  f8:	38 c2                	cmp    %al,%dl
  fa:	74 de                	je     da <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
  fc:	8b 45 08             	mov    0x8(%ebp),%eax
  ff:	0f b6 00             	movzbl (%eax),%eax
 102:	0f b6 d0             	movzbl %al,%edx
 105:	8b 45 0c             	mov    0xc(%ebp),%eax
 108:	0f b6 00             	movzbl (%eax),%eax
 10b:	0f b6 c0             	movzbl %al,%eax
 10e:	89 d1                	mov    %edx,%ecx
 110:	29 c1                	sub    %eax,%ecx
 112:	89 c8                	mov    %ecx,%eax
}
 114:	5d                   	pop    %ebp
 115:	c3                   	ret    

00000116 <strlen>:

uint
strlen(char *s)
{
 116:	55                   	push   %ebp
 117:	89 e5                	mov    %esp,%ebp
 119:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 11c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 123:	eb 04                	jmp    129 <strlen+0x13>
 125:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 129:	8b 45 fc             	mov    -0x4(%ebp),%eax
 12c:	03 45 08             	add    0x8(%ebp),%eax
 12f:	0f b6 00             	movzbl (%eax),%eax
 132:	84 c0                	test   %al,%al
 134:	75 ef                	jne    125 <strlen+0xf>
    ;
  return n;
 136:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 139:	c9                   	leave  
 13a:	c3                   	ret    

0000013b <memset>:

void*
memset(void *dst, int c, uint n)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 141:	8b 45 10             	mov    0x10(%ebp),%eax
 144:	89 44 24 08          	mov    %eax,0x8(%esp)
 148:	8b 45 0c             	mov    0xc(%ebp),%eax
 14b:	89 44 24 04          	mov    %eax,0x4(%esp)
 14f:	8b 45 08             	mov    0x8(%ebp),%eax
 152:	89 04 24             	mov    %eax,(%esp)
 155:	e8 22 ff ff ff       	call   7c <stosb>
  return dst;
 15a:	8b 45 08             	mov    0x8(%ebp),%eax
}
 15d:	c9                   	leave  
 15e:	c3                   	ret    

0000015f <strchr>:

char*
strchr(const char *s, char c)
{
 15f:	55                   	push   %ebp
 160:	89 e5                	mov    %esp,%ebp
 162:	83 ec 04             	sub    $0x4,%esp
 165:	8b 45 0c             	mov    0xc(%ebp),%eax
 168:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 16b:	eb 14                	jmp    181 <strchr+0x22>
    if(*s == c)
 16d:	8b 45 08             	mov    0x8(%ebp),%eax
 170:	0f b6 00             	movzbl (%eax),%eax
 173:	3a 45 fc             	cmp    -0x4(%ebp),%al
 176:	75 05                	jne    17d <strchr+0x1e>
      return (char*)s;
 178:	8b 45 08             	mov    0x8(%ebp),%eax
 17b:	eb 13                	jmp    190 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 17d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 181:	8b 45 08             	mov    0x8(%ebp),%eax
 184:	0f b6 00             	movzbl (%eax),%eax
 187:	84 c0                	test   %al,%al
 189:	75 e2                	jne    16d <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 18b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 190:	c9                   	leave  
 191:	c3                   	ret    

00000192 <gets>:

char*
gets(char *buf, int max)
{
 192:	55                   	push   %ebp
 193:	89 e5                	mov    %esp,%ebp
 195:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 198:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 19f:	eb 44                	jmp    1e5 <gets+0x53>
    cc = read(0, &c, 1);
 1a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1a8:	00 
 1a9:	8d 45 ef             	lea    -0x11(%ebp),%eax
 1ac:	89 44 24 04          	mov    %eax,0x4(%esp)
 1b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 1b7:	e8 3c 01 00 00       	call   2f8 <read>
 1bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1c3:	7e 2d                	jle    1f2 <gets+0x60>
      break;
    buf[i++] = c;
 1c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1c8:	03 45 08             	add    0x8(%ebp),%eax
 1cb:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 1cf:	88 10                	mov    %dl,(%eax)
 1d1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 1d5:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1d9:	3c 0a                	cmp    $0xa,%al
 1db:	74 16                	je     1f3 <gets+0x61>
 1dd:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1e1:	3c 0d                	cmp    $0xd,%al
 1e3:	74 0e                	je     1f3 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1e8:	83 c0 01             	add    $0x1,%eax
 1eb:	3b 45 0c             	cmp    0xc(%ebp),%eax
 1ee:	7c b1                	jl     1a1 <gets+0xf>
 1f0:	eb 01                	jmp    1f3 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 1f2:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 1f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1f6:	03 45 08             	add    0x8(%ebp),%eax
 1f9:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ff:	c9                   	leave  
 200:	c3                   	ret    

00000201 <stat>:

int
stat(char *n, struct stat *st)
{
 201:	55                   	push   %ebp
 202:	89 e5                	mov    %esp,%ebp
 204:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 207:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 20e:	00 
 20f:	8b 45 08             	mov    0x8(%ebp),%eax
 212:	89 04 24             	mov    %eax,(%esp)
 215:	e8 06 01 00 00       	call   320 <open>
 21a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 21d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 221:	79 07                	jns    22a <stat+0x29>
    return -1;
 223:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 228:	eb 23                	jmp    24d <stat+0x4c>
  r = fstat(fd, st);
 22a:	8b 45 0c             	mov    0xc(%ebp),%eax
 22d:	89 44 24 04          	mov    %eax,0x4(%esp)
 231:	8b 45 f4             	mov    -0xc(%ebp),%eax
 234:	89 04 24             	mov    %eax,(%esp)
 237:	e8 fc 00 00 00       	call   338 <fstat>
 23c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 23f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 242:	89 04 24             	mov    %eax,(%esp)
 245:	e8 be 00 00 00       	call   308 <close>
  return r;
 24a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 24d:	c9                   	leave  
 24e:	c3                   	ret    

0000024f <atoi>:

int
atoi(const char *s)
{
 24f:	55                   	push   %ebp
 250:	89 e5                	mov    %esp,%ebp
 252:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 255:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 25c:	eb 23                	jmp    281 <atoi+0x32>
    n = n*10 + *s++ - '0';
 25e:	8b 55 fc             	mov    -0x4(%ebp),%edx
 261:	89 d0                	mov    %edx,%eax
 263:	c1 e0 02             	shl    $0x2,%eax
 266:	01 d0                	add    %edx,%eax
 268:	01 c0                	add    %eax,%eax
 26a:	89 c2                	mov    %eax,%edx
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	0f b6 00             	movzbl (%eax),%eax
 272:	0f be c0             	movsbl %al,%eax
 275:	01 d0                	add    %edx,%eax
 277:	83 e8 30             	sub    $0x30,%eax
 27a:	89 45 fc             	mov    %eax,-0x4(%ebp)
 27d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 281:	8b 45 08             	mov    0x8(%ebp),%eax
 284:	0f b6 00             	movzbl (%eax),%eax
 287:	3c 2f                	cmp    $0x2f,%al
 289:	7e 0a                	jle    295 <atoi+0x46>
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	0f b6 00             	movzbl (%eax),%eax
 291:	3c 39                	cmp    $0x39,%al
 293:	7e c9                	jle    25e <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 295:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 298:	c9                   	leave  
 299:	c3                   	ret    

0000029a <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 2a0:	8b 45 08             	mov    0x8(%ebp),%eax
 2a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 2a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 2a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 2ac:	eb 13                	jmp    2c1 <memmove+0x27>
    *dst++ = *src++;
 2ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
 2b1:	0f b6 10             	movzbl (%eax),%edx
 2b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2b7:	88 10                	mov    %dl,(%eax)
 2b9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 2bd:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 2c5:	0f 9f c0             	setg   %al
 2c8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 2cc:	84 c0                	test   %al,%al
 2ce:	75 de                	jne    2ae <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 2d0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2d3:	c9                   	leave  
 2d4:	c3                   	ret    
 2d5:	90                   	nop
 2d6:	90                   	nop
 2d7:	90                   	nop

000002d8 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2d8:	b8 01 00 00 00       	mov    $0x1,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <exit>:
SYSCALL(exit)
 2e0:	b8 02 00 00 00       	mov    $0x2,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <wait>:
SYSCALL(wait)
 2e8:	b8 03 00 00 00       	mov    $0x3,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <pipe>:
SYSCALL(pipe)
 2f0:	b8 04 00 00 00       	mov    $0x4,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <read>:
SYSCALL(read)
 2f8:	b8 05 00 00 00       	mov    $0x5,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <write>:
SYSCALL(write)
 300:	b8 10 00 00 00       	mov    $0x10,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <close>:
SYSCALL(close)
 308:	b8 15 00 00 00       	mov    $0x15,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <kill>:
SYSCALL(kill)
 310:	b8 06 00 00 00       	mov    $0x6,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <exec>:
SYSCALL(exec)
 318:	b8 07 00 00 00       	mov    $0x7,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <open>:
SYSCALL(open)
 320:	b8 0f 00 00 00       	mov    $0xf,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <mknod>:
SYSCALL(mknod)
 328:	b8 11 00 00 00       	mov    $0x11,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <unlink>:
SYSCALL(unlink)
 330:	b8 12 00 00 00       	mov    $0x12,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <fstat>:
SYSCALL(fstat)
 338:	b8 08 00 00 00       	mov    $0x8,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <link>:
SYSCALL(link)
 340:	b8 13 00 00 00       	mov    $0x13,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <mkdir>:
SYSCALL(mkdir)
 348:	b8 14 00 00 00       	mov    $0x14,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <chdir>:
SYSCALL(chdir)
 350:	b8 09 00 00 00       	mov    $0x9,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <dup>:
SYSCALL(dup)
 358:	b8 0a 00 00 00       	mov    $0xa,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <getpid>:
SYSCALL(getpid)
 360:	b8 0b 00 00 00       	mov    $0xb,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <sbrk>:
SYSCALL(sbrk)
 368:	b8 0c 00 00 00       	mov    $0xc,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <sleep>:
SYSCALL(sleep)
 370:	b8 0d 00 00 00       	mov    $0xd,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <uptime>:
SYSCALL(uptime)
 378:	b8 0e 00 00 00       	mov    $0xe,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <thread_create>:
SYSCALL(thread_create)
 380:	b8 16 00 00 00       	mov    $0x16,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <thread_getId>:
SYSCALL(thread_getId)
 388:	b8 17 00 00 00       	mov    $0x17,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <thread_getProcId>:
SYSCALL(thread_getProcId)
 390:	b8 18 00 00 00       	mov    $0x18,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <thread_join>:
SYSCALL(thread_join)
 398:	b8 19 00 00 00       	mov    $0x19,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <thread_exit>:
SYSCALL(thread_exit)
 3a0:	b8 1a 00 00 00       	mov    $0x1a,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <binary_semaphore_create>:
SYSCALL(binary_semaphore_create)
 3a8:	b8 1b 00 00 00       	mov    $0x1b,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <binary_semaphore_down>:
SYSCALL(binary_semaphore_down)
 3b0:	b8 1c 00 00 00       	mov    $0x1c,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <binary_semaphore_up>:
SYSCALL(binary_semaphore_up)
 3b8:	b8 1d 00 00 00       	mov    $0x1d,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	83 ec 28             	sub    $0x28,%esp
 3c6:	8b 45 0c             	mov    0xc(%ebp),%eax
 3c9:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 3cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3d3:	00 
 3d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
 3d7:	89 44 24 04          	mov    %eax,0x4(%esp)
 3db:	8b 45 08             	mov    0x8(%ebp),%eax
 3de:	89 04 24             	mov    %eax,(%esp)
 3e1:	e8 1a ff ff ff       	call   300 <write>
}
 3e6:	c9                   	leave  
 3e7:	c3                   	ret    

000003e8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e8:	55                   	push   %ebp
 3e9:	89 e5                	mov    %esp,%ebp
 3eb:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3ee:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3f5:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3f9:	74 17                	je     412 <printint+0x2a>
 3fb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3ff:	79 11                	jns    412 <printint+0x2a>
    neg = 1;
 401:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 408:	8b 45 0c             	mov    0xc(%ebp),%eax
 40b:	f7 d8                	neg    %eax
 40d:	89 45 ec             	mov    %eax,-0x14(%ebp)
 410:	eb 06                	jmp    418 <printint+0x30>
  } else {
    x = xx;
 412:	8b 45 0c             	mov    0xc(%ebp),%eax
 415:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 418:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 41f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 422:	8b 45 ec             	mov    -0x14(%ebp),%eax
 425:	ba 00 00 00 00       	mov    $0x0,%edx
 42a:	f7 f1                	div    %ecx
 42c:	89 d0                	mov    %edx,%eax
 42e:	0f b6 90 c0 0e 00 00 	movzbl 0xec0(%eax),%edx
 435:	8d 45 dc             	lea    -0x24(%ebp),%eax
 438:	03 45 f4             	add    -0xc(%ebp),%eax
 43b:	88 10                	mov    %dl,(%eax)
 43d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 441:	8b 55 10             	mov    0x10(%ebp),%edx
 444:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 447:	8b 45 ec             	mov    -0x14(%ebp),%eax
 44a:	ba 00 00 00 00       	mov    $0x0,%edx
 44f:	f7 75 d4             	divl   -0x2c(%ebp)
 452:	89 45 ec             	mov    %eax,-0x14(%ebp)
 455:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 459:	75 c4                	jne    41f <printint+0x37>
  if(neg)
 45b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 45f:	74 2a                	je     48b <printint+0xa3>
    buf[i++] = '-';
 461:	8d 45 dc             	lea    -0x24(%ebp),%eax
 464:	03 45 f4             	add    -0xc(%ebp),%eax
 467:	c6 00 2d             	movb   $0x2d,(%eax)
 46a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 46e:	eb 1b                	jmp    48b <printint+0xa3>
    putc(fd, buf[i]);
 470:	8d 45 dc             	lea    -0x24(%ebp),%eax
 473:	03 45 f4             	add    -0xc(%ebp),%eax
 476:	0f b6 00             	movzbl (%eax),%eax
 479:	0f be c0             	movsbl %al,%eax
 47c:	89 44 24 04          	mov    %eax,0x4(%esp)
 480:	8b 45 08             	mov    0x8(%ebp),%eax
 483:	89 04 24             	mov    %eax,(%esp)
 486:	e8 35 ff ff ff       	call   3c0 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 48b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 48f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 493:	79 db                	jns    470 <printint+0x88>
    putc(fd, buf[i]);
}
 495:	c9                   	leave  
 496:	c3                   	ret    

00000497 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 497:	55                   	push   %ebp
 498:	89 e5                	mov    %esp,%ebp
 49a:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 49d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 4a4:	8d 45 0c             	lea    0xc(%ebp),%eax
 4a7:	83 c0 04             	add    $0x4,%eax
 4aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 4ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4b4:	e9 7d 01 00 00       	jmp    636 <printf+0x19f>
    c = fmt[i] & 0xff;
 4b9:	8b 55 0c             	mov    0xc(%ebp),%edx
 4bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 4bf:	01 d0                	add    %edx,%eax
 4c1:	0f b6 00             	movzbl (%eax),%eax
 4c4:	0f be c0             	movsbl %al,%eax
 4c7:	25 ff 00 00 00       	and    $0xff,%eax
 4cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 4cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4d3:	75 2c                	jne    501 <printf+0x6a>
      if(c == '%'){
 4d5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4d9:	75 0c                	jne    4e7 <printf+0x50>
        state = '%';
 4db:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4e2:	e9 4b 01 00 00       	jmp    632 <printf+0x19b>
      } else {
        putc(fd, c);
 4e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4ea:	0f be c0             	movsbl %al,%eax
 4ed:	89 44 24 04          	mov    %eax,0x4(%esp)
 4f1:	8b 45 08             	mov    0x8(%ebp),%eax
 4f4:	89 04 24             	mov    %eax,(%esp)
 4f7:	e8 c4 fe ff ff       	call   3c0 <putc>
 4fc:	e9 31 01 00 00       	jmp    632 <printf+0x19b>
      }
    } else if(state == '%'){
 501:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 505:	0f 85 27 01 00 00    	jne    632 <printf+0x19b>
      if(c == 'd'){
 50b:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 50f:	75 2d                	jne    53e <printf+0xa7>
        printint(fd, *ap, 10, 1);
 511:	8b 45 e8             	mov    -0x18(%ebp),%eax
 514:	8b 00                	mov    (%eax),%eax
 516:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 51d:	00 
 51e:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 525:	00 
 526:	89 44 24 04          	mov    %eax,0x4(%esp)
 52a:	8b 45 08             	mov    0x8(%ebp),%eax
 52d:	89 04 24             	mov    %eax,(%esp)
 530:	e8 b3 fe ff ff       	call   3e8 <printint>
        ap++;
 535:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 539:	e9 ed 00 00 00       	jmp    62b <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 53e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 542:	74 06                	je     54a <printf+0xb3>
 544:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 548:	75 2d                	jne    577 <printf+0xe0>
        printint(fd, *ap, 16, 0);
 54a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54d:	8b 00                	mov    (%eax),%eax
 54f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 556:	00 
 557:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 55e:	00 
 55f:	89 44 24 04          	mov    %eax,0x4(%esp)
 563:	8b 45 08             	mov    0x8(%ebp),%eax
 566:	89 04 24             	mov    %eax,(%esp)
 569:	e8 7a fe ff ff       	call   3e8 <printint>
        ap++;
 56e:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 572:	e9 b4 00 00 00       	jmp    62b <printf+0x194>
      } else if(c == 's'){
 577:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 57b:	75 46                	jne    5c3 <printf+0x12c>
        s = (char*)*ap;
 57d:	8b 45 e8             	mov    -0x18(%ebp),%eax
 580:	8b 00                	mov    (%eax),%eax
 582:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 585:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 589:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 58d:	75 27                	jne    5b6 <printf+0x11f>
          s = "(null)";
 58f:	c7 45 f4 ba 0b 00 00 	movl   $0xbba,-0xc(%ebp)
        while(*s != 0){
 596:	eb 1e                	jmp    5b6 <printf+0x11f>
          putc(fd, *s);
 598:	8b 45 f4             	mov    -0xc(%ebp),%eax
 59b:	0f b6 00             	movzbl (%eax),%eax
 59e:	0f be c0             	movsbl %al,%eax
 5a1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a5:	8b 45 08             	mov    0x8(%ebp),%eax
 5a8:	89 04 24             	mov    %eax,(%esp)
 5ab:	e8 10 fe ff ff       	call   3c0 <putc>
          s++;
 5b0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 5b4:	eb 01                	jmp    5b7 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5b6:	90                   	nop
 5b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5ba:	0f b6 00             	movzbl (%eax),%eax
 5bd:	84 c0                	test   %al,%al
 5bf:	75 d7                	jne    598 <printf+0x101>
 5c1:	eb 68                	jmp    62b <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 5c3:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 5c7:	75 1d                	jne    5e6 <printf+0x14f>
        putc(fd, *ap);
 5c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5cc:	8b 00                	mov    (%eax),%eax
 5ce:	0f be c0             	movsbl %al,%eax
 5d1:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d5:	8b 45 08             	mov    0x8(%ebp),%eax
 5d8:	89 04 24             	mov    %eax,(%esp)
 5db:	e8 e0 fd ff ff       	call   3c0 <putc>
        ap++;
 5e0:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5e4:	eb 45                	jmp    62b <printf+0x194>
      } else if(c == '%'){
 5e6:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 5ea:	75 17                	jne    603 <printf+0x16c>
        putc(fd, c);
 5ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5ef:	0f be c0             	movsbl %al,%eax
 5f2:	89 44 24 04          	mov    %eax,0x4(%esp)
 5f6:	8b 45 08             	mov    0x8(%ebp),%eax
 5f9:	89 04 24             	mov    %eax,(%esp)
 5fc:	e8 bf fd ff ff       	call   3c0 <putc>
 601:	eb 28                	jmp    62b <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 603:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 60a:	00 
 60b:	8b 45 08             	mov    0x8(%ebp),%eax
 60e:	89 04 24             	mov    %eax,(%esp)
 611:	e8 aa fd ff ff       	call   3c0 <putc>
        putc(fd, c);
 616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 619:	0f be c0             	movsbl %al,%eax
 61c:	89 44 24 04          	mov    %eax,0x4(%esp)
 620:	8b 45 08             	mov    0x8(%ebp),%eax
 623:	89 04 24             	mov    %eax,(%esp)
 626:	e8 95 fd ff ff       	call   3c0 <putc>
      }
      state = 0;
 62b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 632:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 636:	8b 55 0c             	mov    0xc(%ebp),%edx
 639:	8b 45 f0             	mov    -0x10(%ebp),%eax
 63c:	01 d0                	add    %edx,%eax
 63e:	0f b6 00             	movzbl (%eax),%eax
 641:	84 c0                	test   %al,%al
 643:	0f 85 70 fe ff ff    	jne    4b9 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 649:	c9                   	leave  
 64a:	c3                   	ret    
 64b:	90                   	nop

0000064c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 64c:	55                   	push   %ebp
 64d:	89 e5                	mov    %esp,%ebp
 64f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 652:	8b 45 08             	mov    0x8(%ebp),%eax
 655:	83 e8 08             	sub    $0x8,%eax
 658:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 65b:	a1 dc 0e 00 00       	mov    0xedc,%eax
 660:	89 45 fc             	mov    %eax,-0x4(%ebp)
 663:	eb 24                	jmp    689 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 665:	8b 45 fc             	mov    -0x4(%ebp),%eax
 668:	8b 00                	mov    (%eax),%eax
 66a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 66d:	77 12                	ja     681 <free+0x35>
 66f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 672:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 675:	77 24                	ja     69b <free+0x4f>
 677:	8b 45 fc             	mov    -0x4(%ebp),%eax
 67a:	8b 00                	mov    (%eax),%eax
 67c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 67f:	77 1a                	ja     69b <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 681:	8b 45 fc             	mov    -0x4(%ebp),%eax
 684:	8b 00                	mov    (%eax),%eax
 686:	89 45 fc             	mov    %eax,-0x4(%ebp)
 689:	8b 45 f8             	mov    -0x8(%ebp),%eax
 68c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 68f:	76 d4                	jbe    665 <free+0x19>
 691:	8b 45 fc             	mov    -0x4(%ebp),%eax
 694:	8b 00                	mov    (%eax),%eax
 696:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 699:	76 ca                	jbe    665 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 69b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 69e:	8b 40 04             	mov    0x4(%eax),%eax
 6a1:	c1 e0 03             	shl    $0x3,%eax
 6a4:	89 c2                	mov    %eax,%edx
 6a6:	03 55 f8             	add    -0x8(%ebp),%edx
 6a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ac:	8b 00                	mov    (%eax),%eax
 6ae:	39 c2                	cmp    %eax,%edx
 6b0:	75 24                	jne    6d6 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 6b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b5:	8b 50 04             	mov    0x4(%eax),%edx
 6b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bb:	8b 00                	mov    (%eax),%eax
 6bd:	8b 40 04             	mov    0x4(%eax),%eax
 6c0:	01 c2                	add    %eax,%edx
 6c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6c5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 6c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cb:	8b 00                	mov    (%eax),%eax
 6cd:	8b 10                	mov    (%eax),%edx
 6cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6d2:	89 10                	mov    %edx,(%eax)
 6d4:	eb 0a                	jmp    6e0 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 6d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d9:	8b 10                	mov    (%eax),%edx
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 6e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6e3:	8b 40 04             	mov    0x4(%eax),%eax
 6e6:	c1 e0 03             	shl    $0x3,%eax
 6e9:	03 45 fc             	add    -0x4(%ebp),%eax
 6ec:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 6ef:	75 20                	jne    711 <free+0xc5>
    p->s.size += bp->s.size;
 6f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f4:	8b 50 04             	mov    0x4(%eax),%edx
 6f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6fa:	8b 40 04             	mov    0x4(%eax),%eax
 6fd:	01 c2                	add    %eax,%edx
 6ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
 702:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 705:	8b 45 f8             	mov    -0x8(%ebp),%eax
 708:	8b 10                	mov    (%eax),%edx
 70a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70d:	89 10                	mov    %edx,(%eax)
 70f:	eb 08                	jmp    719 <free+0xcd>
  } else
    p->s.ptr = bp;
 711:	8b 45 fc             	mov    -0x4(%ebp),%eax
 714:	8b 55 f8             	mov    -0x8(%ebp),%edx
 717:	89 10                	mov    %edx,(%eax)
  freep = p;
 719:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71c:	a3 dc 0e 00 00       	mov    %eax,0xedc
}
 721:	c9                   	leave  
 722:	c3                   	ret    

00000723 <morecore>:

static Header*
morecore(uint nu)
{
 723:	55                   	push   %ebp
 724:	89 e5                	mov    %esp,%ebp
 726:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 729:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 730:	77 07                	ja     739 <morecore+0x16>
    nu = 4096;
 732:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 739:	8b 45 08             	mov    0x8(%ebp),%eax
 73c:	c1 e0 03             	shl    $0x3,%eax
 73f:	89 04 24             	mov    %eax,(%esp)
 742:	e8 21 fc ff ff       	call   368 <sbrk>
 747:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 74a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 74e:	75 07                	jne    757 <morecore+0x34>
    return 0;
 750:	b8 00 00 00 00       	mov    $0x0,%eax
 755:	eb 22                	jmp    779 <morecore+0x56>
  hp = (Header*)p;
 757:	8b 45 f4             	mov    -0xc(%ebp),%eax
 75a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 75d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 760:	8b 55 08             	mov    0x8(%ebp),%edx
 763:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 766:	8b 45 f0             	mov    -0x10(%ebp),%eax
 769:	83 c0 08             	add    $0x8,%eax
 76c:	89 04 24             	mov    %eax,(%esp)
 76f:	e8 d8 fe ff ff       	call   64c <free>
  return freep;
 774:	a1 dc 0e 00 00       	mov    0xedc,%eax
}
 779:	c9                   	leave  
 77a:	c3                   	ret    

0000077b <malloc>:

void*
malloc(uint nbytes)
{
 77b:	55                   	push   %ebp
 77c:	89 e5                	mov    %esp,%ebp
 77e:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 781:	8b 45 08             	mov    0x8(%ebp),%eax
 784:	83 c0 07             	add    $0x7,%eax
 787:	c1 e8 03             	shr    $0x3,%eax
 78a:	83 c0 01             	add    $0x1,%eax
 78d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 790:	a1 dc 0e 00 00       	mov    0xedc,%eax
 795:	89 45 f0             	mov    %eax,-0x10(%ebp)
 798:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 79c:	75 23                	jne    7c1 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 79e:	c7 45 f0 d4 0e 00 00 	movl   $0xed4,-0x10(%ebp)
 7a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7a8:	a3 dc 0e 00 00       	mov    %eax,0xedc
 7ad:	a1 dc 0e 00 00       	mov    0xedc,%eax
 7b2:	a3 d4 0e 00 00       	mov    %eax,0xed4
    base.s.size = 0;
 7b7:	c7 05 d8 0e 00 00 00 	movl   $0x0,0xed8
 7be:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7c4:	8b 00                	mov    (%eax),%eax
 7c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 7c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7cc:	8b 40 04             	mov    0x4(%eax),%eax
 7cf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7d2:	72 4d                	jb     821 <malloc+0xa6>
      if(p->s.size == nunits)
 7d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d7:	8b 40 04             	mov    0x4(%eax),%eax
 7da:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 7dd:	75 0c                	jne    7eb <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 7df:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7e2:	8b 10                	mov    (%eax),%edx
 7e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7e7:	89 10                	mov    %edx,(%eax)
 7e9:	eb 26                	jmp    811 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ee:	8b 40 04             	mov    0x4(%eax),%eax
 7f1:	89 c2                	mov    %eax,%edx
 7f3:	2b 55 ec             	sub    -0x14(%ebp),%edx
 7f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f9:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7ff:	8b 40 04             	mov    0x4(%eax),%eax
 802:	c1 e0 03             	shl    $0x3,%eax
 805:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 808:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80b:	8b 55 ec             	mov    -0x14(%ebp),%edx
 80e:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 811:	8b 45 f0             	mov    -0x10(%ebp),%eax
 814:	a3 dc 0e 00 00       	mov    %eax,0xedc
      return (void*)(p + 1);
 819:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81c:	83 c0 08             	add    $0x8,%eax
 81f:	eb 38                	jmp    859 <malloc+0xde>
    }
    if(p == freep)
 821:	a1 dc 0e 00 00       	mov    0xedc,%eax
 826:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 829:	75 1b                	jne    846 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 82b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 82e:	89 04 24             	mov    %eax,(%esp)
 831:	e8 ed fe ff ff       	call   723 <morecore>
 836:	89 45 f4             	mov    %eax,-0xc(%ebp)
 839:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 83d:	75 07                	jne    846 <malloc+0xcb>
        return 0;
 83f:	b8 00 00 00 00       	mov    $0x0,%eax
 844:	eb 13                	jmp    859 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 846:	8b 45 f4             	mov    -0xc(%ebp),%eax
 849:	89 45 f0             	mov    %eax,-0x10(%ebp)
 84c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84f:	8b 00                	mov    (%eax),%eax
 851:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 854:	e9 70 ff ff ff       	jmp    7c9 <malloc+0x4e>
}
 859:	c9                   	leave  
 85a:	c3                   	ret    
 85b:	90                   	nop

0000085c <semaphore_create>:
#include "semaphore.h"

struct semaphore* 
semaphore_create(int initial_semaphore_value, char* name)
{
 85c:	55                   	push   %ebp
 85d:	89 e5                	mov    %esp,%ebp
 85f:	83 ec 28             	sub    $0x28,%esp
  int min = 1;
 862:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  struct semaphore* s = malloc(sizeof(struct semaphore));
 869:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
 870:	e8 06 ff ff ff       	call   77b <malloc>
 875:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((s->s1 = binary_semaphore_create(1)) != -1)
 878:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 87f:	e8 24 fb ff ff       	call   3a8 <binary_semaphore_create>
 884:	8b 55 f0             	mov    -0x10(%ebp),%edx
 887:	89 42 04             	mov    %eax,0x4(%edx)
 88a:	83 f8 ff             	cmp    $0xffffffff,%eax
 88d:	74 38                	je     8c7 <semaphore_create+0x6b>
  {
    if(initial_semaphore_value < 1)
 88f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 893:	7f 06                	jg     89b <semaphore_create+0x3f>
      min = initial_semaphore_value;
 895:	8b 45 08             	mov    0x8(%ebp),%eax
 898:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if((s->s2 = binary_semaphore_create(min)) != -1)
 89b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89e:	89 04 24             	mov    %eax,(%esp)
 8a1:	e8 02 fb ff ff       	call   3a8 <binary_semaphore_create>
 8a6:	8b 55 f0             	mov    -0x10(%ebp),%edx
 8a9:	89 42 08             	mov    %eax,0x8(%edx)
 8ac:	83 f8 ff             	cmp    $0xffffffff,%eax
 8af:	74 16                	je     8c7 <semaphore_create+0x6b>
    {
      s->value = initial_semaphore_value;
 8b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8b4:	8b 55 08             	mov    0x8(%ebp),%edx
 8b7:	89 10                	mov    %edx,(%eax)
      s->name = name;
 8b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8bc:	8b 55 0c             	mov    0xc(%ebp),%edx
 8bf:	89 50 0c             	mov    %edx,0xc(%eax)
      return s;
 8c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8c5:	eb 15                	jmp    8dc <semaphore_create+0x80>
    }
  }
  free(s);
 8c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ca:	89 04 24             	mov    %eax,(%esp)
 8cd:	e8 7a fd ff ff       	call   64c <free>
  s = 0;
 8d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  return s;
 8d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 8dc:	c9                   	leave  
 8dd:	c3                   	ret    

000008de <semaphore_down>:

void 
semaphore_down(struct semaphore* sem )
{
 8de:	55                   	push   %ebp
 8df:	89 e5                	mov    %esp,%ebp
 8e1:	83 ec 18             	sub    $0x18,%esp
 //printf(1,"semaphore_down for tid = %d\n",thread_getId());
 binary_semaphore_down(sem->s2);
 8e4:	8b 45 08             	mov    0x8(%ebp),%eax
 8e7:	8b 40 08             	mov    0x8(%eax),%eax
 8ea:	89 04 24             	mov    %eax,(%esp)
 8ed:	e8 be fa ff ff       	call   3b0 <binary_semaphore_down>
 binary_semaphore_down(sem->s1);
 8f2:	8b 45 08             	mov    0x8(%ebp),%eax
 8f5:	8b 40 04             	mov    0x4(%eax),%eax
 8f8:	89 04 24             	mov    %eax,(%esp)
 8fb:	e8 b0 fa ff ff       	call   3b0 <binary_semaphore_down>
 sem->value--;
 900:	8b 45 08             	mov    0x8(%ebp),%eax
 903:	8b 00                	mov    (%eax),%eax
 905:	8d 50 ff             	lea    -0x1(%eax),%edx
 908:	8b 45 08             	mov    0x8(%ebp),%eax
 90b:	89 10                	mov    %edx,(%eax)
 //printf(1,"DOWN - sem %s semaphore_value = %d for tid = %d\n",sem->name,sem->value,thread_getId());
 if(sem->value>0)
 90d:	8b 45 08             	mov    0x8(%ebp),%eax
 910:	8b 00                	mov    (%eax),%eax
 912:	85 c0                	test   %eax,%eax
 914:	7e 0e                	jle    924 <semaphore_down+0x46>
  binary_semaphore_up(sem->s2);
 916:	8b 45 08             	mov    0x8(%ebp),%eax
 919:	8b 40 08             	mov    0x8(%eax),%eax
 91c:	89 04 24             	mov    %eax,(%esp)
 91f:	e8 94 fa ff ff       	call   3b8 <binary_semaphore_up>
 binary_semaphore_up(sem->s1);
 924:	8b 45 08             	mov    0x8(%ebp),%eax
 927:	8b 40 04             	mov    0x4(%eax),%eax
 92a:	89 04 24             	mov    %eax,(%esp)
 92d:	e8 86 fa ff ff       	call   3b8 <binary_semaphore_up>
}
 932:	c9                   	leave  
 933:	c3                   	ret    

00000934 <semaphore_up>:

void 
semaphore_up(struct semaphore* sem )
{
 934:	55                   	push   %ebp
 935:	89 e5                	mov    %esp,%ebp
 937:	83 ec 18             	sub    $0x18,%esp
  //printf(1,"semaphore_up for tid = %d\n",thread_getId());
  binary_semaphore_down(sem->s1);
 93a:	8b 45 08             	mov    0x8(%ebp),%eax
 93d:	8b 40 04             	mov    0x4(%eax),%eax
 940:	89 04 24             	mov    %eax,(%esp)
 943:	e8 68 fa ff ff       	call   3b0 <binary_semaphore_down>
  sem->value++;
 948:	8b 45 08             	mov    0x8(%ebp),%eax
 94b:	8b 00                	mov    (%eax),%eax
 94d:	8d 50 01             	lea    0x1(%eax),%edx
 950:	8b 45 08             	mov    0x8(%ebp),%eax
 953:	89 10                	mov    %edx,(%eax)
  //printf(1,"UP - sem %s semaphore_value = %d for tid = %d\n",sem->name,sem->value,thread_getId());
  if(sem->value == 1)
 955:	8b 45 08             	mov    0x8(%ebp),%eax
 958:	8b 00                	mov    (%eax),%eax
 95a:	83 f8 01             	cmp    $0x1,%eax
 95d:	75 0e                	jne    96d <semaphore_up+0x39>
    binary_semaphore_up(sem->s2);
 95f:	8b 45 08             	mov    0x8(%ebp),%eax
 962:	8b 40 08             	mov    0x8(%eax),%eax
 965:	89 04 24             	mov    %eax,(%esp)
 968:	e8 4b fa ff ff       	call   3b8 <binary_semaphore_up>
  binary_semaphore_up(sem->s1);
 96d:	8b 45 08             	mov    0x8(%ebp),%eax
 970:	8b 40 04             	mov    0x4(%eax),%eax
 973:	89 04 24             	mov    %eax,(%esp)
 976:	e8 3d fa ff ff       	call   3b8 <binary_semaphore_up>
}
 97b:	c9                   	leave  
 97c:	c3                   	ret    
 97d:	90                   	nop
 97e:	90                   	nop
 97f:	90                   	nop

00000980 <BB_create>:
#include "boundedbuffer.h"

struct BB* 
BB_create(int max_capacity,char* name)
{
 980:	55                   	push   %ebp
 981:	89 e5                	mov    %esp,%ebp
 983:	83 ec 28             	sub    $0x28,%esp
  struct BB* buf = malloc(sizeof(struct BB));
 986:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
 98d:	e8 e9 fd ff ff       	call   77b <malloc>
 992:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(buf,0,sizeof(struct BB));
 995:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 99c:	00 
 99d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 9a4:	00 
 9a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a8:	89 04 24             	mov    %eax,(%esp)
 9ab:	e8 8b f7 ff ff       	call   13b <memset>
  buf->elements = malloc(sizeof(void*)*max_capacity);
 9b0:	8b 45 08             	mov    0x8(%ebp),%eax
 9b3:	c1 e0 02             	shl    $0x2,%eax
 9b6:	89 04 24             	mov    %eax,(%esp)
 9b9:	e8 bd fd ff ff       	call   77b <malloc>
 9be:	8b 55 f4             	mov    -0xc(%ebp),%edx
 9c1:	89 42 1c             	mov    %eax,0x1c(%edx)
  memset(buf->elements,0,sizeof(void*)*max_capacity);
 9c4:	8b 45 08             	mov    0x8(%ebp),%eax
 9c7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 9ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9d1:	8b 40 1c             	mov    0x1c(%eax),%eax
 9d4:	89 54 24 08          	mov    %edx,0x8(%esp)
 9d8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 9df:	00 
 9e0:	89 04 24             	mov    %eax,(%esp)
 9e3:	e8 53 f7 ff ff       	call   13b <memset>
  buf->name = name;
 9e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9eb:	8b 55 0c             	mov    0xc(%ebp),%edx
 9ee:	89 50 18             	mov    %edx,0x18(%eax)
  if((buf->mutex = binary_semaphore_create(1)) != -1)
 9f1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 9f8:	e8 ab f9 ff ff       	call   3a8 <binary_semaphore_create>
 9fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a00:	89 42 04             	mov    %eax,0x4(%edx)
 a03:	83 f8 ff             	cmp    $0xffffffff,%eax
 a06:	74 52                	je     a5a <BB_create+0xda>
  {
    buf->BUFFER_SIZE = max_capacity;
 a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a0b:	8b 55 08             	mov    0x8(%ebp),%edx
 a0e:	89 10                	mov    %edx,(%eax)
    if((buf->empty = semaphore_create(max_capacity, name))!= 0 && (buf->full = semaphore_create(0, name))!= 0)
 a10:	8b 45 0c             	mov    0xc(%ebp),%eax
 a13:	89 44 24 04          	mov    %eax,0x4(%esp)
 a17:	8b 45 08             	mov    0x8(%ebp),%eax
 a1a:	89 04 24             	mov    %eax,(%esp)
 a1d:	e8 3a fe ff ff       	call   85c <semaphore_create>
 a22:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a25:	89 42 08             	mov    %eax,0x8(%edx)
 a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a2b:	8b 40 08             	mov    0x8(%eax),%eax
 a2e:	85 c0                	test   %eax,%eax
 a30:	74 28                	je     a5a <BB_create+0xda>
 a32:	8b 45 0c             	mov    0xc(%ebp),%eax
 a35:	89 44 24 04          	mov    %eax,0x4(%esp)
 a39:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 a40:	e8 17 fe ff ff       	call   85c <semaphore_create>
 a45:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a48:	89 42 0c             	mov    %eax,0xc(%edx)
 a4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a4e:	8b 40 0c             	mov    0xc(%eax),%eax
 a51:	85 c0                	test   %eax,%eax
 a53:	74 05                	je     a5a <BB_create+0xda>
      return buf;
 a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a58:	eb 23                	jmp    a7d <BB_create+0xfd>
  }
  free(buf->elements);
 a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5d:	8b 40 1c             	mov    0x1c(%eax),%eax
 a60:	89 04 24             	mov    %eax,(%esp)
 a63:	e8 e4 fb ff ff       	call   64c <free>
  free(buf);
 a68:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a6b:	89 04 24             	mov    %eax,(%esp)
 a6e:	e8 d9 fb ff ff       	call   64c <free>
  buf = 0;
 a73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  return buf;
 a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 a7d:	c9                   	leave  
 a7e:	c3                   	ret    

00000a7f <BB_put>:

void 
BB_put(struct BB* bb, void* element)
{
 a7f:	55                   	push   %ebp
 a80:	89 e5                	mov    %esp,%ebp
 a82:	83 ec 18             	sub    $0x18,%esp
 // printf(1,"put in %s, tid = %d\n",bb->name,thread_getId());
  semaphore_down(bb->empty);
 a85:	8b 45 08             	mov    0x8(%ebp),%eax
 a88:	8b 40 08             	mov    0x8(%eax),%eax
 a8b:	89 04 24             	mov    %eax,(%esp)
 a8e:	e8 4b fe ff ff       	call   8de <semaphore_down>
  binary_semaphore_down(bb->mutex);
 a93:	8b 45 08             	mov    0x8(%ebp),%eax
 a96:	8b 40 04             	mov    0x4(%eax),%eax
 a99:	89 04 24             	mov    %eax,(%esp)
 a9c:	e8 0f f9 ff ff       	call   3b0 <binary_semaphore_down>
  bb->elements[bb->end] = element;
 aa1:	8b 45 08             	mov    0x8(%ebp),%eax
 aa4:	8b 50 1c             	mov    0x1c(%eax),%edx
 aa7:	8b 45 08             	mov    0x8(%ebp),%eax
 aaa:	8b 40 14             	mov    0x14(%eax),%eax
 aad:	c1 e0 02             	shl    $0x2,%eax
 ab0:	01 c2                	add    %eax,%edx
 ab2:	8b 45 0c             	mov    0xc(%ebp),%eax
 ab5:	89 02                	mov    %eax,(%edx)
  ++bb->end;
 ab7:	8b 45 08             	mov    0x8(%ebp),%eax
 aba:	8b 40 14             	mov    0x14(%eax),%eax
 abd:	8d 50 01             	lea    0x1(%eax),%edx
 ac0:	8b 45 08             	mov    0x8(%ebp),%eax
 ac3:	89 50 14             	mov    %edx,0x14(%eax)
  bb->end = bb->end%bb->BUFFER_SIZE;
 ac6:	8b 45 08             	mov    0x8(%ebp),%eax
 ac9:	8b 40 14             	mov    0x14(%eax),%eax
 acc:	8b 55 08             	mov    0x8(%ebp),%edx
 acf:	8b 0a                	mov    (%edx),%ecx
 ad1:	89 c2                	mov    %eax,%edx
 ad3:	c1 fa 1f             	sar    $0x1f,%edx
 ad6:	f7 f9                	idiv   %ecx
 ad8:	8b 45 08             	mov    0x8(%ebp),%eax
 adb:	89 50 14             	mov    %edx,0x14(%eax)
  binary_semaphore_up(bb->mutex);
 ade:	8b 45 08             	mov    0x8(%ebp),%eax
 ae1:	8b 40 04             	mov    0x4(%eax),%eax
 ae4:	89 04 24             	mov    %eax,(%esp)
 ae7:	e8 cc f8 ff ff       	call   3b8 <binary_semaphore_up>
  semaphore_up(bb->full);
 aec:	8b 45 08             	mov    0x8(%ebp),%eax
 aef:	8b 40 0c             	mov    0xc(%eax),%eax
 af2:	89 04 24             	mov    %eax,(%esp)
 af5:	e8 3a fe ff ff       	call   934 <semaphore_up>
}
 afa:	c9                   	leave  
 afb:	c3                   	ret    

00000afc <BB_pop>:

void* 
BB_pop(struct BB* bb)
{
 afc:	55                   	push   %ebp
 afd:	89 e5                	mov    %esp,%ebp
 aff:	83 ec 28             	sub    $0x28,%esp
  void* item;
  //printf(1,"pop from  %s, tid = %d\n",bb->name,thread_getId());
  semaphore_down(bb->full);
 b02:	8b 45 08             	mov    0x8(%ebp),%eax
 b05:	8b 40 0c             	mov    0xc(%eax),%eax
 b08:	89 04 24             	mov    %eax,(%esp)
 b0b:	e8 ce fd ff ff       	call   8de <semaphore_down>
  binary_semaphore_down(bb->mutex);
 b10:	8b 45 08             	mov    0x8(%ebp),%eax
 b13:	8b 40 04             	mov    0x4(%eax),%eax
 b16:	89 04 24             	mov    %eax,(%esp)
 b19:	e8 92 f8 ff ff       	call   3b0 <binary_semaphore_down>
  item = bb->elements[bb->start];
 b1e:	8b 45 08             	mov    0x8(%ebp),%eax
 b21:	8b 50 1c             	mov    0x1c(%eax),%edx
 b24:	8b 45 08             	mov    0x8(%ebp),%eax
 b27:	8b 40 10             	mov    0x10(%eax),%eax
 b2a:	c1 e0 02             	shl    $0x2,%eax
 b2d:	01 d0                	add    %edx,%eax
 b2f:	8b 00                	mov    (%eax),%eax
 b31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bb->elements[bb->start] = 0;
 b34:	8b 45 08             	mov    0x8(%ebp),%eax
 b37:	8b 50 1c             	mov    0x1c(%eax),%edx
 b3a:	8b 45 08             	mov    0x8(%ebp),%eax
 b3d:	8b 40 10             	mov    0x10(%eax),%eax
 b40:	c1 e0 02             	shl    $0x2,%eax
 b43:	01 d0                	add    %edx,%eax
 b45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  ++bb->start;
 b4b:	8b 45 08             	mov    0x8(%ebp),%eax
 b4e:	8b 40 10             	mov    0x10(%eax),%eax
 b51:	8d 50 01             	lea    0x1(%eax),%edx
 b54:	8b 45 08             	mov    0x8(%ebp),%eax
 b57:	89 50 10             	mov    %edx,0x10(%eax)
  bb->start = bb->start%bb->BUFFER_SIZE;
 b5a:	8b 45 08             	mov    0x8(%ebp),%eax
 b5d:	8b 40 10             	mov    0x10(%eax),%eax
 b60:	8b 55 08             	mov    0x8(%ebp),%edx
 b63:	8b 0a                	mov    (%edx),%ecx
 b65:	89 c2                	mov    %eax,%edx
 b67:	c1 fa 1f             	sar    $0x1f,%edx
 b6a:	f7 f9                	idiv   %ecx
 b6c:	8b 45 08             	mov    0x8(%ebp),%eax
 b6f:	89 50 10             	mov    %edx,0x10(%eax)
  binary_semaphore_up(bb->mutex);
 b72:	8b 45 08             	mov    0x8(%ebp),%eax
 b75:	8b 40 04             	mov    0x4(%eax),%eax
 b78:	89 04 24             	mov    %eax,(%esp)
 b7b:	e8 38 f8 ff ff       	call   3b8 <binary_semaphore_up>
  semaphore_up(bb->empty);
 b80:	8b 45 08             	mov    0x8(%ebp),%eax
 b83:	8b 40 08             	mov    0x8(%eax),%eax
 b86:	89 04 24             	mov    %eax,(%esp)
 b89:	e8 a6 fd ff ff       	call   934 <semaphore_up>
  return item;
 b8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 b91:	c9                   	leave  
 b92:	c3                   	ret    
