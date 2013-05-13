
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 20             	sub    $0x20,%esp
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   9:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10:	00 
  11:	c7 04 24 2e 0c 00 00 	movl   $0xc2e,(%esp)
  18:	e8 9b 03 00 00       	call   3b8 <open>
  1d:	85 c0                	test   %eax,%eax
  1f:	79 30                	jns    51 <main+0x51>
    mknod("console", 1, 1);
  21:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  28:	00 
  29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  30:	00 
  31:	c7 04 24 2e 0c 00 00 	movl   $0xc2e,(%esp)
  38:	e8 83 03 00 00       	call   3c0 <mknod>
    open("console", O_RDWR);
  3d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  44:	00 
  45:	c7 04 24 2e 0c 00 00 	movl   $0xc2e,(%esp)
  4c:	e8 67 03 00 00       	call   3b8 <open>
  }
  dup(0);  // stdout
  51:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  58:	e8 93 03 00 00       	call   3f0 <dup>
  dup(0);  // stderr
  5d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  64:	e8 87 03 00 00       	call   3f0 <dup>
  69:	eb 01                	jmp    6c <main+0x6c>
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
  6b:	90                   	nop
  }
  dup(0);  // stdout
  dup(0);  // stderr

  for(;;){
    printf(1, "init: starting sh\n");
  6c:	c7 44 24 04 36 0c 00 	movl   $0xc36,0x4(%esp)
  73:	00 
  74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  7b:	e8 af 04 00 00       	call   52f <printf>
    pid = fork();
  80:	e8 eb 02 00 00       	call   370 <fork>
  85:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    if(pid < 0){
  89:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  8e:	79 19                	jns    a9 <main+0xa9>
      printf(1, "init: fork failed\n");
  90:	c7 44 24 04 49 0c 00 	movl   $0xc49,0x4(%esp)
  97:	00 
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 8b 04 00 00       	call   52f <printf>
      exit();
  a4:	e8 cf 02 00 00       	call   378 <exit>
    }
    if(pid == 0){
  a9:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
  ae:	75 41                	jne    f1 <main+0xf1>
      exec("sh", argv);
  b0:	c7 44 24 04 80 0f 00 	movl   $0xf80,0x4(%esp)
  b7:	00 
  b8:	c7 04 24 2b 0c 00 00 	movl   $0xc2b,(%esp)
  bf:	e8 ec 02 00 00       	call   3b0 <exec>
      printf(1, "init: exec sh failed\n");
  c4:	c7 44 24 04 5c 0c 00 	movl   $0xc5c,0x4(%esp)
  cb:	00 
  cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  d3:	e8 57 04 00 00       	call   52f <printf>
      exit();
  d8:	e8 9b 02 00 00       	call   378 <exit>
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  dd:	c7 44 24 04 72 0c 00 	movl   $0xc72,0x4(%esp)
  e4:	00 
  e5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  ec:	e8 3e 04 00 00       	call   52f <printf>
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
  f1:	e8 8a 02 00 00       	call   380 <wait>
  f6:	89 44 24 18          	mov    %eax,0x18(%esp)
  fa:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
  ff:	0f 88 66 ff ff ff    	js     6b <main+0x6b>
 105:	8b 44 24 18          	mov    0x18(%esp),%eax
 109:	3b 44 24 1c          	cmp    0x1c(%esp),%eax
 10d:	75 ce                	jne    dd <main+0xdd>
      printf(1, "zombie!\n");
  }
 10f:	e9 57 ff ff ff       	jmp    6b <main+0x6b>

00000114 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 114:	55                   	push   %ebp
 115:	89 e5                	mov    %esp,%ebp
 117:	57                   	push   %edi
 118:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 119:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11c:	8b 55 10             	mov    0x10(%ebp),%edx
 11f:	8b 45 0c             	mov    0xc(%ebp),%eax
 122:	89 cb                	mov    %ecx,%ebx
 124:	89 df                	mov    %ebx,%edi
 126:	89 d1                	mov    %edx,%ecx
 128:	fc                   	cld    
 129:	f3 aa                	rep stos %al,%es:(%edi)
 12b:	89 ca                	mov    %ecx,%edx
 12d:	89 fb                	mov    %edi,%ebx
 12f:	89 5d 08             	mov    %ebx,0x8(%ebp)
 132:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 135:	5b                   	pop    %ebx
 136:	5f                   	pop    %edi
 137:	5d                   	pop    %ebp
 138:	c3                   	ret    

00000139 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 139:	55                   	push   %ebp
 13a:	89 e5                	mov    %esp,%ebp
 13c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13f:	8b 45 08             	mov    0x8(%ebp),%eax
 142:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 145:	90                   	nop
 146:	8b 45 0c             	mov    0xc(%ebp),%eax
 149:	0f b6 10             	movzbl (%eax),%edx
 14c:	8b 45 08             	mov    0x8(%ebp),%eax
 14f:	88 10                	mov    %dl,(%eax)
 151:	8b 45 08             	mov    0x8(%ebp),%eax
 154:	0f b6 00             	movzbl (%eax),%eax
 157:	84 c0                	test   %al,%al
 159:	0f 95 c0             	setne  %al
 15c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 160:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 164:	84 c0                	test   %al,%al
 166:	75 de                	jne    146 <strcpy+0xd>
    ;
  return os;
 168:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 16b:	c9                   	leave  
 16c:	c3                   	ret    

0000016d <strcmp>:

int
strcmp(const char *p, const char *q)
{
 16d:	55                   	push   %ebp
 16e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 170:	eb 08                	jmp    17a <strcmp+0xd>
    p++, q++;
 172:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 176:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 17a:	8b 45 08             	mov    0x8(%ebp),%eax
 17d:	0f b6 00             	movzbl (%eax),%eax
 180:	84 c0                	test   %al,%al
 182:	74 10                	je     194 <strcmp+0x27>
 184:	8b 45 08             	mov    0x8(%ebp),%eax
 187:	0f b6 10             	movzbl (%eax),%edx
 18a:	8b 45 0c             	mov    0xc(%ebp),%eax
 18d:	0f b6 00             	movzbl (%eax),%eax
 190:	38 c2                	cmp    %al,%dl
 192:	74 de                	je     172 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
 194:	8b 45 08             	mov    0x8(%ebp),%eax
 197:	0f b6 00             	movzbl (%eax),%eax
 19a:	0f b6 d0             	movzbl %al,%edx
 19d:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a0:	0f b6 00             	movzbl (%eax),%eax
 1a3:	0f b6 c0             	movzbl %al,%eax
 1a6:	89 d1                	mov    %edx,%ecx
 1a8:	29 c1                	sub    %eax,%ecx
 1aa:	89 c8                	mov    %ecx,%eax
}
 1ac:	5d                   	pop    %ebp
 1ad:	c3                   	ret    

000001ae <strlen>:

uint
strlen(char *s)
{
 1ae:	55                   	push   %ebp
 1af:	89 e5                	mov    %esp,%ebp
 1b1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1b4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1bb:	eb 04                	jmp    1c1 <strlen+0x13>
 1bd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 1c4:	03 45 08             	add    0x8(%ebp),%eax
 1c7:	0f b6 00             	movzbl (%eax),%eax
 1ca:	84 c0                	test   %al,%al
 1cc:	75 ef                	jne    1bd <strlen+0xf>
    ;
  return n;
 1ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1d1:	c9                   	leave  
 1d2:	c3                   	ret    

000001d3 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1d3:	55                   	push   %ebp
 1d4:	89 e5                	mov    %esp,%ebp
 1d6:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
 1d9:	8b 45 10             	mov    0x10(%ebp),%eax
 1dc:	89 44 24 08          	mov    %eax,0x8(%esp)
 1e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e3:	89 44 24 04          	mov    %eax,0x4(%esp)
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
 1ea:	89 04 24             	mov    %eax,(%esp)
 1ed:	e8 22 ff ff ff       	call   114 <stosb>
  return dst;
 1f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1f5:	c9                   	leave  
 1f6:	c3                   	ret    

000001f7 <strchr>:

char*
strchr(const char *s, char c)
{
 1f7:	55                   	push   %ebp
 1f8:	89 e5                	mov    %esp,%ebp
 1fa:	83 ec 04             	sub    $0x4,%esp
 1fd:	8b 45 0c             	mov    0xc(%ebp),%eax
 200:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 203:	eb 14                	jmp    219 <strchr+0x22>
    if(*s == c)
 205:	8b 45 08             	mov    0x8(%ebp),%eax
 208:	0f b6 00             	movzbl (%eax),%eax
 20b:	3a 45 fc             	cmp    -0x4(%ebp),%al
 20e:	75 05                	jne    215 <strchr+0x1e>
      return (char*)s;
 210:	8b 45 08             	mov    0x8(%ebp),%eax
 213:	eb 13                	jmp    228 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 215:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 219:	8b 45 08             	mov    0x8(%ebp),%eax
 21c:	0f b6 00             	movzbl (%eax),%eax
 21f:	84 c0                	test   %al,%al
 221:	75 e2                	jne    205 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
 223:	b8 00 00 00 00       	mov    $0x0,%eax
}
 228:	c9                   	leave  
 229:	c3                   	ret    

0000022a <gets>:

char*
gets(char *buf, int max)
{
 22a:	55                   	push   %ebp
 22b:	89 e5                	mov    %esp,%ebp
 22d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 230:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 237:	eb 44                	jmp    27d <gets+0x53>
    cc = read(0, &c, 1);
 239:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 240:	00 
 241:	8d 45 ef             	lea    -0x11(%ebp),%eax
 244:	89 44 24 04          	mov    %eax,0x4(%esp)
 248:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 24f:	e8 3c 01 00 00       	call   390 <read>
 254:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 257:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 25b:	7e 2d                	jle    28a <gets+0x60>
      break;
    buf[i++] = c;
 25d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 260:	03 45 08             	add    0x8(%ebp),%eax
 263:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
 267:	88 10                	mov    %dl,(%eax)
 269:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
 26d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 271:	3c 0a                	cmp    $0xa,%al
 273:	74 16                	je     28b <gets+0x61>
 275:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 279:	3c 0d                	cmp    $0xd,%al
 27b:	74 0e                	je     28b <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 280:	83 c0 01             	add    $0x1,%eax
 283:	3b 45 0c             	cmp    0xc(%ebp),%eax
 286:	7c b1                	jl     239 <gets+0xf>
 288:	eb 01                	jmp    28b <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
 28a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 28b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 28e:	03 45 08             	add    0x8(%ebp),%eax
 291:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 294:	8b 45 08             	mov    0x8(%ebp),%eax
}
 297:	c9                   	leave  
 298:	c3                   	ret    

00000299 <stat>:

int
stat(char *n, struct stat *st)
{
 299:	55                   	push   %ebp
 29a:	89 e5                	mov    %esp,%ebp
 29c:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 29f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 2a6:	00 
 2a7:	8b 45 08             	mov    0x8(%ebp),%eax
 2aa:	89 04 24             	mov    %eax,(%esp)
 2ad:	e8 06 01 00 00       	call   3b8 <open>
 2b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2b5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2b9:	79 07                	jns    2c2 <stat+0x29>
    return -1;
 2bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2c0:	eb 23                	jmp    2e5 <stat+0x4c>
  r = fstat(fd, st);
 2c2:	8b 45 0c             	mov    0xc(%ebp),%eax
 2c5:	89 44 24 04          	mov    %eax,0x4(%esp)
 2c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2cc:	89 04 24             	mov    %eax,(%esp)
 2cf:	e8 fc 00 00 00       	call   3d0 <fstat>
 2d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2da:	89 04 24             	mov    %eax,(%esp)
 2dd:	e8 be 00 00 00       	call   3a0 <close>
  return r;
 2e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2e5:	c9                   	leave  
 2e6:	c3                   	ret    

000002e7 <atoi>:

int
atoi(const char *s)
{
 2e7:	55                   	push   %ebp
 2e8:	89 e5                	mov    %esp,%ebp
 2ea:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2ed:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2f4:	eb 23                	jmp    319 <atoi+0x32>
    n = n*10 + *s++ - '0';
 2f6:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2f9:	89 d0                	mov    %edx,%eax
 2fb:	c1 e0 02             	shl    $0x2,%eax
 2fe:	01 d0                	add    %edx,%eax
 300:	01 c0                	add    %eax,%eax
 302:	89 c2                	mov    %eax,%edx
 304:	8b 45 08             	mov    0x8(%ebp),%eax
 307:	0f b6 00             	movzbl (%eax),%eax
 30a:	0f be c0             	movsbl %al,%eax
 30d:	01 d0                	add    %edx,%eax
 30f:	83 e8 30             	sub    $0x30,%eax
 312:	89 45 fc             	mov    %eax,-0x4(%ebp)
 315:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 319:	8b 45 08             	mov    0x8(%ebp),%eax
 31c:	0f b6 00             	movzbl (%eax),%eax
 31f:	3c 2f                	cmp    $0x2f,%al
 321:	7e 0a                	jle    32d <atoi+0x46>
 323:	8b 45 08             	mov    0x8(%ebp),%eax
 326:	0f b6 00             	movzbl (%eax),%eax
 329:	3c 39                	cmp    $0x39,%al
 32b:	7e c9                	jle    2f6 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
 32d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 330:	c9                   	leave  
 331:	c3                   	ret    

00000332 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 332:	55                   	push   %ebp
 333:	89 e5                	mov    %esp,%ebp
 335:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 338:	8b 45 08             	mov    0x8(%ebp),%eax
 33b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 33e:	8b 45 0c             	mov    0xc(%ebp),%eax
 341:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 344:	eb 13                	jmp    359 <memmove+0x27>
    *dst++ = *src++;
 346:	8b 45 f8             	mov    -0x8(%ebp),%eax
 349:	0f b6 10             	movzbl (%eax),%edx
 34c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 34f:	88 10                	mov    %dl,(%eax)
 351:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 355:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 359:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
 35d:	0f 9f c0             	setg   %al
 360:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 364:	84 c0                	test   %al,%al
 366:	75 de                	jne    346 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
 368:	8b 45 08             	mov    0x8(%ebp),%eax
}
 36b:	c9                   	leave  
 36c:	c3                   	ret    
 36d:	90                   	nop
 36e:	90                   	nop
 36f:	90                   	nop

00000370 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 370:	b8 01 00 00 00       	mov    $0x1,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <exit>:
SYSCALL(exit)
 378:	b8 02 00 00 00       	mov    $0x2,%eax
 37d:	cd 40                	int    $0x40
 37f:	c3                   	ret    

00000380 <wait>:
SYSCALL(wait)
 380:	b8 03 00 00 00       	mov    $0x3,%eax
 385:	cd 40                	int    $0x40
 387:	c3                   	ret    

00000388 <pipe>:
SYSCALL(pipe)
 388:	b8 04 00 00 00       	mov    $0x4,%eax
 38d:	cd 40                	int    $0x40
 38f:	c3                   	ret    

00000390 <read>:
SYSCALL(read)
 390:	b8 05 00 00 00       	mov    $0x5,%eax
 395:	cd 40                	int    $0x40
 397:	c3                   	ret    

00000398 <write>:
SYSCALL(write)
 398:	b8 10 00 00 00       	mov    $0x10,%eax
 39d:	cd 40                	int    $0x40
 39f:	c3                   	ret    

000003a0 <close>:
SYSCALL(close)
 3a0:	b8 15 00 00 00       	mov    $0x15,%eax
 3a5:	cd 40                	int    $0x40
 3a7:	c3                   	ret    

000003a8 <kill>:
SYSCALL(kill)
 3a8:	b8 06 00 00 00       	mov    $0x6,%eax
 3ad:	cd 40                	int    $0x40
 3af:	c3                   	ret    

000003b0 <exec>:
SYSCALL(exec)
 3b0:	b8 07 00 00 00       	mov    $0x7,%eax
 3b5:	cd 40                	int    $0x40
 3b7:	c3                   	ret    

000003b8 <open>:
SYSCALL(open)
 3b8:	b8 0f 00 00 00       	mov    $0xf,%eax
 3bd:	cd 40                	int    $0x40
 3bf:	c3                   	ret    

000003c0 <mknod>:
SYSCALL(mknod)
 3c0:	b8 11 00 00 00       	mov    $0x11,%eax
 3c5:	cd 40                	int    $0x40
 3c7:	c3                   	ret    

000003c8 <unlink>:
SYSCALL(unlink)
 3c8:	b8 12 00 00 00       	mov    $0x12,%eax
 3cd:	cd 40                	int    $0x40
 3cf:	c3                   	ret    

000003d0 <fstat>:
SYSCALL(fstat)
 3d0:	b8 08 00 00 00       	mov    $0x8,%eax
 3d5:	cd 40                	int    $0x40
 3d7:	c3                   	ret    

000003d8 <link>:
SYSCALL(link)
 3d8:	b8 13 00 00 00       	mov    $0x13,%eax
 3dd:	cd 40                	int    $0x40
 3df:	c3                   	ret    

000003e0 <mkdir>:
SYSCALL(mkdir)
 3e0:	b8 14 00 00 00       	mov    $0x14,%eax
 3e5:	cd 40                	int    $0x40
 3e7:	c3                   	ret    

000003e8 <chdir>:
SYSCALL(chdir)
 3e8:	b8 09 00 00 00       	mov    $0x9,%eax
 3ed:	cd 40                	int    $0x40
 3ef:	c3                   	ret    

000003f0 <dup>:
SYSCALL(dup)
 3f0:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f5:	cd 40                	int    $0x40
 3f7:	c3                   	ret    

000003f8 <getpid>:
SYSCALL(getpid)
 3f8:	b8 0b 00 00 00       	mov    $0xb,%eax
 3fd:	cd 40                	int    $0x40
 3ff:	c3                   	ret    

00000400 <sbrk>:
SYSCALL(sbrk)
 400:	b8 0c 00 00 00       	mov    $0xc,%eax
 405:	cd 40                	int    $0x40
 407:	c3                   	ret    

00000408 <sleep>:
SYSCALL(sleep)
 408:	b8 0d 00 00 00       	mov    $0xd,%eax
 40d:	cd 40                	int    $0x40
 40f:	c3                   	ret    

00000410 <uptime>:
SYSCALL(uptime)
 410:	b8 0e 00 00 00       	mov    $0xe,%eax
 415:	cd 40                	int    $0x40
 417:	c3                   	ret    

00000418 <thread_create>:
SYSCALL(thread_create)
 418:	b8 16 00 00 00       	mov    $0x16,%eax
 41d:	cd 40                	int    $0x40
 41f:	c3                   	ret    

00000420 <thread_getId>:
SYSCALL(thread_getId)
 420:	b8 17 00 00 00       	mov    $0x17,%eax
 425:	cd 40                	int    $0x40
 427:	c3                   	ret    

00000428 <thread_getProcId>:
SYSCALL(thread_getProcId)
 428:	b8 18 00 00 00       	mov    $0x18,%eax
 42d:	cd 40                	int    $0x40
 42f:	c3                   	ret    

00000430 <thread_join>:
SYSCALL(thread_join)
 430:	b8 19 00 00 00       	mov    $0x19,%eax
 435:	cd 40                	int    $0x40
 437:	c3                   	ret    

00000438 <thread_exit>:
SYSCALL(thread_exit)
 438:	b8 1a 00 00 00       	mov    $0x1a,%eax
 43d:	cd 40                	int    $0x40
 43f:	c3                   	ret    

00000440 <binary_semaphore_create>:
SYSCALL(binary_semaphore_create)
 440:	b8 1b 00 00 00       	mov    $0x1b,%eax
 445:	cd 40                	int    $0x40
 447:	c3                   	ret    

00000448 <binary_semaphore_down>:
SYSCALL(binary_semaphore_down)
 448:	b8 1c 00 00 00       	mov    $0x1c,%eax
 44d:	cd 40                	int    $0x40
 44f:	c3                   	ret    

00000450 <binary_semaphore_up>:
SYSCALL(binary_semaphore_up)
 450:	b8 1d 00 00 00       	mov    $0x1d,%eax
 455:	cd 40                	int    $0x40
 457:	c3                   	ret    

00000458 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 458:	55                   	push   %ebp
 459:	89 e5                	mov    %esp,%ebp
 45b:	83 ec 28             	sub    $0x28,%esp
 45e:	8b 45 0c             	mov    0xc(%ebp),%eax
 461:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 464:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 46b:	00 
 46c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 46f:	89 44 24 04          	mov    %eax,0x4(%esp)
 473:	8b 45 08             	mov    0x8(%ebp),%eax
 476:	89 04 24             	mov    %eax,(%esp)
 479:	e8 1a ff ff ff       	call   398 <write>
}
 47e:	c9                   	leave  
 47f:	c3                   	ret    

00000480 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 480:	55                   	push   %ebp
 481:	89 e5                	mov    %esp,%ebp
 483:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 486:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 48d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 491:	74 17                	je     4aa <printint+0x2a>
 493:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 497:	79 11                	jns    4aa <printint+0x2a>
    neg = 1;
 499:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 4a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a3:	f7 d8                	neg    %eax
 4a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4a8:	eb 06                	jmp    4b0 <printint+0x30>
  } else {
    x = xx;
 4aa:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 4b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 4b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4bd:	ba 00 00 00 00       	mov    $0x0,%edx
 4c2:	f7 f1                	div    %ecx
 4c4:	89 d0                	mov    %edx,%eax
 4c6:	0f b6 90 88 0f 00 00 	movzbl 0xf88(%eax),%edx
 4cd:	8d 45 dc             	lea    -0x24(%ebp),%eax
 4d0:	03 45 f4             	add    -0xc(%ebp),%eax
 4d3:	88 10                	mov    %dl,(%eax)
 4d5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
 4d9:	8b 55 10             	mov    0x10(%ebp),%edx
 4dc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 4df:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4e2:	ba 00 00 00 00       	mov    $0x0,%edx
 4e7:	f7 75 d4             	divl   -0x2c(%ebp)
 4ea:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4ed:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4f1:	75 c4                	jne    4b7 <printint+0x37>
  if(neg)
 4f3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4f7:	74 2a                	je     523 <printint+0xa3>
    buf[i++] = '-';
 4f9:	8d 45 dc             	lea    -0x24(%ebp),%eax
 4fc:	03 45 f4             	add    -0xc(%ebp),%eax
 4ff:	c6 00 2d             	movb   $0x2d,(%eax)
 502:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
 506:	eb 1b                	jmp    523 <printint+0xa3>
    putc(fd, buf[i]);
 508:	8d 45 dc             	lea    -0x24(%ebp),%eax
 50b:	03 45 f4             	add    -0xc(%ebp),%eax
 50e:	0f b6 00             	movzbl (%eax),%eax
 511:	0f be c0             	movsbl %al,%eax
 514:	89 44 24 04          	mov    %eax,0x4(%esp)
 518:	8b 45 08             	mov    0x8(%ebp),%eax
 51b:	89 04 24             	mov    %eax,(%esp)
 51e:	e8 35 ff ff ff       	call   458 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 523:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 527:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 52b:	79 db                	jns    508 <printint+0x88>
    putc(fd, buf[i]);
}
 52d:	c9                   	leave  
 52e:	c3                   	ret    

0000052f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 52f:	55                   	push   %ebp
 530:	89 e5                	mov    %esp,%ebp
 532:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 535:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 53c:	8d 45 0c             	lea    0xc(%ebp),%eax
 53f:	83 c0 04             	add    $0x4,%eax
 542:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 545:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 54c:	e9 7d 01 00 00       	jmp    6ce <printf+0x19f>
    c = fmt[i] & 0xff;
 551:	8b 55 0c             	mov    0xc(%ebp),%edx
 554:	8b 45 f0             	mov    -0x10(%ebp),%eax
 557:	01 d0                	add    %edx,%eax
 559:	0f b6 00             	movzbl (%eax),%eax
 55c:	0f be c0             	movsbl %al,%eax
 55f:	25 ff 00 00 00       	and    $0xff,%eax
 564:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 567:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 56b:	75 2c                	jne    599 <printf+0x6a>
      if(c == '%'){
 56d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 571:	75 0c                	jne    57f <printf+0x50>
        state = '%';
 573:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 57a:	e9 4b 01 00 00       	jmp    6ca <printf+0x19b>
      } else {
        putc(fd, c);
 57f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 582:	0f be c0             	movsbl %al,%eax
 585:	89 44 24 04          	mov    %eax,0x4(%esp)
 589:	8b 45 08             	mov    0x8(%ebp),%eax
 58c:	89 04 24             	mov    %eax,(%esp)
 58f:	e8 c4 fe ff ff       	call   458 <putc>
 594:	e9 31 01 00 00       	jmp    6ca <printf+0x19b>
      }
    } else if(state == '%'){
 599:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 59d:	0f 85 27 01 00 00    	jne    6ca <printf+0x19b>
      if(c == 'd'){
 5a3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 5a7:	75 2d                	jne    5d6 <printf+0xa7>
        printint(fd, *ap, 10, 1);
 5a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5ac:	8b 00                	mov    (%eax),%eax
 5ae:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
 5b5:	00 
 5b6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
 5bd:	00 
 5be:	89 44 24 04          	mov    %eax,0x4(%esp)
 5c2:	8b 45 08             	mov    0x8(%ebp),%eax
 5c5:	89 04 24             	mov    %eax,(%esp)
 5c8:	e8 b3 fe ff ff       	call   480 <printint>
        ap++;
 5cd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5d1:	e9 ed 00 00 00       	jmp    6c3 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
 5d6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 5da:	74 06                	je     5e2 <printf+0xb3>
 5dc:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 5e0:	75 2d                	jne    60f <printf+0xe0>
        printint(fd, *ap, 16, 0);
 5e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5e5:	8b 00                	mov    (%eax),%eax
 5e7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
 5ee:	00 
 5ef:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
 5f6:	00 
 5f7:	89 44 24 04          	mov    %eax,0x4(%esp)
 5fb:	8b 45 08             	mov    0x8(%ebp),%eax
 5fe:	89 04 24             	mov    %eax,(%esp)
 601:	e8 7a fe ff ff       	call   480 <printint>
        ap++;
 606:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 60a:	e9 b4 00 00 00       	jmp    6c3 <printf+0x194>
      } else if(c == 's'){
 60f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 613:	75 46                	jne    65b <printf+0x12c>
        s = (char*)*ap;
 615:	8b 45 e8             	mov    -0x18(%ebp),%eax
 618:	8b 00                	mov    (%eax),%eax
 61a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 61d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 621:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 625:	75 27                	jne    64e <printf+0x11f>
          s = "(null)";
 627:	c7 45 f4 7b 0c 00 00 	movl   $0xc7b,-0xc(%ebp)
        while(*s != 0){
 62e:	eb 1e                	jmp    64e <printf+0x11f>
          putc(fd, *s);
 630:	8b 45 f4             	mov    -0xc(%ebp),%eax
 633:	0f b6 00             	movzbl (%eax),%eax
 636:	0f be c0             	movsbl %al,%eax
 639:	89 44 24 04          	mov    %eax,0x4(%esp)
 63d:	8b 45 08             	mov    0x8(%ebp),%eax
 640:	89 04 24             	mov    %eax,(%esp)
 643:	e8 10 fe ff ff       	call   458 <putc>
          s++;
 648:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 64c:	eb 01                	jmp    64f <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 64e:	90                   	nop
 64f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 652:	0f b6 00             	movzbl (%eax),%eax
 655:	84 c0                	test   %al,%al
 657:	75 d7                	jne    630 <printf+0x101>
 659:	eb 68                	jmp    6c3 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 65b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 65f:	75 1d                	jne    67e <printf+0x14f>
        putc(fd, *ap);
 661:	8b 45 e8             	mov    -0x18(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	0f be c0             	movsbl %al,%eax
 669:	89 44 24 04          	mov    %eax,0x4(%esp)
 66d:	8b 45 08             	mov    0x8(%ebp),%eax
 670:	89 04 24             	mov    %eax,(%esp)
 673:	e8 e0 fd ff ff       	call   458 <putc>
        ap++;
 678:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 67c:	eb 45                	jmp    6c3 <printf+0x194>
      } else if(c == '%'){
 67e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 682:	75 17                	jne    69b <printf+0x16c>
        putc(fd, c);
 684:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 687:	0f be c0             	movsbl %al,%eax
 68a:	89 44 24 04          	mov    %eax,0x4(%esp)
 68e:	8b 45 08             	mov    0x8(%ebp),%eax
 691:	89 04 24             	mov    %eax,(%esp)
 694:	e8 bf fd ff ff       	call   458 <putc>
 699:	eb 28                	jmp    6c3 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 69b:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
 6a2:	00 
 6a3:	8b 45 08             	mov    0x8(%ebp),%eax
 6a6:	89 04 24             	mov    %eax,(%esp)
 6a9:	e8 aa fd ff ff       	call   458 <putc>
        putc(fd, c);
 6ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 6b1:	0f be c0             	movsbl %al,%eax
 6b4:	89 44 24 04          	mov    %eax,0x4(%esp)
 6b8:	8b 45 08             	mov    0x8(%ebp),%eax
 6bb:	89 04 24             	mov    %eax,(%esp)
 6be:	e8 95 fd ff ff       	call   458 <putc>
      }
      state = 0;
 6c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 6ca:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 6ce:	8b 55 0c             	mov    0xc(%ebp),%edx
 6d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
 6d4:	01 d0                	add    %edx,%eax
 6d6:	0f b6 00             	movzbl (%eax),%eax
 6d9:	84 c0                	test   %al,%al
 6db:	0f 85 70 fe ff ff    	jne    551 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 6e1:	c9                   	leave  
 6e2:	c3                   	ret    
 6e3:	90                   	nop

000006e4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6e4:	55                   	push   %ebp
 6e5:	89 e5                	mov    %esp,%ebp
 6e7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ea:	8b 45 08             	mov    0x8(%ebp),%eax
 6ed:	83 e8 08             	sub    $0x8,%eax
 6f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f3:	a1 a4 0f 00 00       	mov    0xfa4,%eax
 6f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6fb:	eb 24                	jmp    721 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6fd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 700:	8b 00                	mov    (%eax),%eax
 702:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 705:	77 12                	ja     719 <free+0x35>
 707:	8b 45 f8             	mov    -0x8(%ebp),%eax
 70a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 70d:	77 24                	ja     733 <free+0x4f>
 70f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 712:	8b 00                	mov    (%eax),%eax
 714:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 717:	77 1a                	ja     733 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 719:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71c:	8b 00                	mov    (%eax),%eax
 71e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 721:	8b 45 f8             	mov    -0x8(%ebp),%eax
 724:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 727:	76 d4                	jbe    6fd <free+0x19>
 729:	8b 45 fc             	mov    -0x4(%ebp),%eax
 72c:	8b 00                	mov    (%eax),%eax
 72e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 731:	76 ca                	jbe    6fd <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
 733:	8b 45 f8             	mov    -0x8(%ebp),%eax
 736:	8b 40 04             	mov    0x4(%eax),%eax
 739:	c1 e0 03             	shl    $0x3,%eax
 73c:	89 c2                	mov    %eax,%edx
 73e:	03 55 f8             	add    -0x8(%ebp),%edx
 741:	8b 45 fc             	mov    -0x4(%ebp),%eax
 744:	8b 00                	mov    (%eax),%eax
 746:	39 c2                	cmp    %eax,%edx
 748:	75 24                	jne    76e <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
 74a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 74d:	8b 50 04             	mov    0x4(%eax),%edx
 750:	8b 45 fc             	mov    -0x4(%ebp),%eax
 753:	8b 00                	mov    (%eax),%eax
 755:	8b 40 04             	mov    0x4(%eax),%eax
 758:	01 c2                	add    %eax,%edx
 75a:	8b 45 f8             	mov    -0x8(%ebp),%eax
 75d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 760:	8b 45 fc             	mov    -0x4(%ebp),%eax
 763:	8b 00                	mov    (%eax),%eax
 765:	8b 10                	mov    (%eax),%edx
 767:	8b 45 f8             	mov    -0x8(%ebp),%eax
 76a:	89 10                	mov    %edx,(%eax)
 76c:	eb 0a                	jmp    778 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
 76e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 771:	8b 10                	mov    (%eax),%edx
 773:	8b 45 f8             	mov    -0x8(%ebp),%eax
 776:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 778:	8b 45 fc             	mov    -0x4(%ebp),%eax
 77b:	8b 40 04             	mov    0x4(%eax),%eax
 77e:	c1 e0 03             	shl    $0x3,%eax
 781:	03 45 fc             	add    -0x4(%ebp),%eax
 784:	3b 45 f8             	cmp    -0x8(%ebp),%eax
 787:	75 20                	jne    7a9 <free+0xc5>
    p->s.size += bp->s.size;
 789:	8b 45 fc             	mov    -0x4(%ebp),%eax
 78c:	8b 50 04             	mov    0x4(%eax),%edx
 78f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 792:	8b 40 04             	mov    0x4(%eax),%eax
 795:	01 c2                	add    %eax,%edx
 797:	8b 45 fc             	mov    -0x4(%ebp),%eax
 79a:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 79d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 7a0:	8b 10                	mov    (%eax),%edx
 7a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7a5:	89 10                	mov    %edx,(%eax)
 7a7:	eb 08                	jmp    7b1 <free+0xcd>
  } else
    p->s.ptr = bp;
 7a9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7ac:	8b 55 f8             	mov    -0x8(%ebp),%edx
 7af:	89 10                	mov    %edx,(%eax)
  freep = p;
 7b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 7b4:	a3 a4 0f 00 00       	mov    %eax,0xfa4
}
 7b9:	c9                   	leave  
 7ba:	c3                   	ret    

000007bb <morecore>:

static Header*
morecore(uint nu)
{
 7bb:	55                   	push   %ebp
 7bc:	89 e5                	mov    %esp,%ebp
 7be:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 7c1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 7c8:	77 07                	ja     7d1 <morecore+0x16>
    nu = 4096;
 7ca:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 7d1:	8b 45 08             	mov    0x8(%ebp),%eax
 7d4:	c1 e0 03             	shl    $0x3,%eax
 7d7:	89 04 24             	mov    %eax,(%esp)
 7da:	e8 21 fc ff ff       	call   400 <sbrk>
 7df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 7e2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 7e6:	75 07                	jne    7ef <morecore+0x34>
    return 0;
 7e8:	b8 00 00 00 00       	mov    $0x0,%eax
 7ed:	eb 22                	jmp    811 <morecore+0x56>
  hp = (Header*)p;
 7ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7f8:	8b 55 08             	mov    0x8(%ebp),%edx
 7fb:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
 801:	83 c0 08             	add    $0x8,%eax
 804:	89 04 24             	mov    %eax,(%esp)
 807:	e8 d8 fe ff ff       	call   6e4 <free>
  return freep;
 80c:	a1 a4 0f 00 00       	mov    0xfa4,%eax
}
 811:	c9                   	leave  
 812:	c3                   	ret    

00000813 <malloc>:

void*
malloc(uint nbytes)
{
 813:	55                   	push   %ebp
 814:	89 e5                	mov    %esp,%ebp
 816:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 819:	8b 45 08             	mov    0x8(%ebp),%eax
 81c:	83 c0 07             	add    $0x7,%eax
 81f:	c1 e8 03             	shr    $0x3,%eax
 822:	83 c0 01             	add    $0x1,%eax
 825:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 828:	a1 a4 0f 00 00       	mov    0xfa4,%eax
 82d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 830:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 834:	75 23                	jne    859 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 836:	c7 45 f0 9c 0f 00 00 	movl   $0xf9c,-0x10(%ebp)
 83d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 840:	a3 a4 0f 00 00       	mov    %eax,0xfa4
 845:	a1 a4 0f 00 00       	mov    0xfa4,%eax
 84a:	a3 9c 0f 00 00       	mov    %eax,0xf9c
    base.s.size = 0;
 84f:	c7 05 a0 0f 00 00 00 	movl   $0x0,0xfa0
 856:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 859:	8b 45 f0             	mov    -0x10(%ebp),%eax
 85c:	8b 00                	mov    (%eax),%eax
 85e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 861:	8b 45 f4             	mov    -0xc(%ebp),%eax
 864:	8b 40 04             	mov    0x4(%eax),%eax
 867:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 86a:	72 4d                	jb     8b9 <malloc+0xa6>
      if(p->s.size == nunits)
 86c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86f:	8b 40 04             	mov    0x4(%eax),%eax
 872:	3b 45 ec             	cmp    -0x14(%ebp),%eax
 875:	75 0c                	jne    883 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 877:	8b 45 f4             	mov    -0xc(%ebp),%eax
 87a:	8b 10                	mov    (%eax),%edx
 87c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 87f:	89 10                	mov    %edx,(%eax)
 881:	eb 26                	jmp    8a9 <malloc+0x96>
      else {
        p->s.size -= nunits;
 883:	8b 45 f4             	mov    -0xc(%ebp),%eax
 886:	8b 40 04             	mov    0x4(%eax),%eax
 889:	89 c2                	mov    %eax,%edx
 88b:	2b 55 ec             	sub    -0x14(%ebp),%edx
 88e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 891:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 894:	8b 45 f4             	mov    -0xc(%ebp),%eax
 897:	8b 40 04             	mov    0x4(%eax),%eax
 89a:	c1 e0 03             	shl    $0x3,%eax
 89d:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 8a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 8a6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 8a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ac:	a3 a4 0f 00 00       	mov    %eax,0xfa4
      return (void*)(p + 1);
 8b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8b4:	83 c0 08             	add    $0x8,%eax
 8b7:	eb 38                	jmp    8f1 <malloc+0xde>
    }
    if(p == freep)
 8b9:	a1 a4 0f 00 00       	mov    0xfa4,%eax
 8be:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 8c1:	75 1b                	jne    8de <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
 8c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
 8c6:	89 04 24             	mov    %eax,(%esp)
 8c9:	e8 ed fe ff ff       	call   7bb <morecore>
 8ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
 8d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 8d5:	75 07                	jne    8de <malloc+0xcb>
        return 0;
 8d7:	b8 00 00 00 00       	mov    $0x0,%eax
 8dc:	eb 13                	jmp    8f1 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8de:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e7:	8b 00                	mov    (%eax),%eax
 8e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
 8ec:	e9 70 ff ff ff       	jmp    861 <malloc+0x4e>
}
 8f1:	c9                   	leave  
 8f2:	c3                   	ret    
 8f3:	90                   	nop

000008f4 <semaphore_create>:
#include "semaphore.h"

struct semaphore* 
semaphore_create(int initial_semaphore_value, char* name)
{
 8f4:	55                   	push   %ebp
 8f5:	89 e5                	mov    %esp,%ebp
 8f7:	83 ec 28             	sub    $0x28,%esp
  int min = 1;
 8fa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  struct semaphore* s = malloc(sizeof(struct semaphore));
 901:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
 908:	e8 06 ff ff ff       	call   813 <malloc>
 90d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((s->s1 = binary_semaphore_create(1)) != -1)
 910:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 917:	e8 24 fb ff ff       	call   440 <binary_semaphore_create>
 91c:	8b 55 f0             	mov    -0x10(%ebp),%edx
 91f:	89 42 04             	mov    %eax,0x4(%edx)
 922:	83 f8 ff             	cmp    $0xffffffff,%eax
 925:	74 38                	je     95f <semaphore_create+0x6b>
  {
    if(initial_semaphore_value < 1)
 927:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 92b:	7f 06                	jg     933 <semaphore_create+0x3f>
      min = initial_semaphore_value;
 92d:	8b 45 08             	mov    0x8(%ebp),%eax
 930:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if((s->s2 = binary_semaphore_create(min)) != -1)
 933:	8b 45 f4             	mov    -0xc(%ebp),%eax
 936:	89 04 24             	mov    %eax,(%esp)
 939:	e8 02 fb ff ff       	call   440 <binary_semaphore_create>
 93e:	8b 55 f0             	mov    -0x10(%ebp),%edx
 941:	89 42 08             	mov    %eax,0x8(%edx)
 944:	83 f8 ff             	cmp    $0xffffffff,%eax
 947:	74 16                	je     95f <semaphore_create+0x6b>
    {
      s->value = initial_semaphore_value;
 949:	8b 45 f0             	mov    -0x10(%ebp),%eax
 94c:	8b 55 08             	mov    0x8(%ebp),%edx
 94f:	89 10                	mov    %edx,(%eax)
      s->name = name;
 951:	8b 45 f0             	mov    -0x10(%ebp),%eax
 954:	8b 55 0c             	mov    0xc(%ebp),%edx
 957:	89 50 0c             	mov    %edx,0xc(%eax)
      return s;
 95a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 95d:	eb 15                	jmp    974 <semaphore_create+0x80>
    }
  }
  free(s);
 95f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 962:	89 04 24             	mov    %eax,(%esp)
 965:	e8 7a fd ff ff       	call   6e4 <free>
  s = 0;
 96a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  return s;
 971:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 974:	c9                   	leave  
 975:	c3                   	ret    

00000976 <semaphore_down>:

void 
semaphore_down(struct semaphore* sem )
{
 976:	55                   	push   %ebp
 977:	89 e5                	mov    %esp,%ebp
 979:	83 ec 18             	sub    $0x18,%esp
 //printf(1,"semaphore_down for tid = %d\n",thread_getId());
 binary_semaphore_down(sem->s2);
 97c:	8b 45 08             	mov    0x8(%ebp),%eax
 97f:	8b 40 08             	mov    0x8(%eax),%eax
 982:	89 04 24             	mov    %eax,(%esp)
 985:	e8 be fa ff ff       	call   448 <binary_semaphore_down>
 binary_semaphore_down(sem->s1);
 98a:	8b 45 08             	mov    0x8(%ebp),%eax
 98d:	8b 40 04             	mov    0x4(%eax),%eax
 990:	89 04 24             	mov    %eax,(%esp)
 993:	e8 b0 fa ff ff       	call   448 <binary_semaphore_down>
 sem->value--;
 998:	8b 45 08             	mov    0x8(%ebp),%eax
 99b:	8b 00                	mov    (%eax),%eax
 99d:	8d 50 ff             	lea    -0x1(%eax),%edx
 9a0:	8b 45 08             	mov    0x8(%ebp),%eax
 9a3:	89 10                	mov    %edx,(%eax)
 //printf(1,"DOWN - sem %s semaphore_value = %d for tid = %d\n",sem->name,sem->value,thread_getId());
 if(sem->value>0)
 9a5:	8b 45 08             	mov    0x8(%ebp),%eax
 9a8:	8b 00                	mov    (%eax),%eax
 9aa:	85 c0                	test   %eax,%eax
 9ac:	7e 0e                	jle    9bc <semaphore_down+0x46>
  binary_semaphore_up(sem->s2);
 9ae:	8b 45 08             	mov    0x8(%ebp),%eax
 9b1:	8b 40 08             	mov    0x8(%eax),%eax
 9b4:	89 04 24             	mov    %eax,(%esp)
 9b7:	e8 94 fa ff ff       	call   450 <binary_semaphore_up>
 binary_semaphore_up(sem->s1);
 9bc:	8b 45 08             	mov    0x8(%ebp),%eax
 9bf:	8b 40 04             	mov    0x4(%eax),%eax
 9c2:	89 04 24             	mov    %eax,(%esp)
 9c5:	e8 86 fa ff ff       	call   450 <binary_semaphore_up>
}
 9ca:	c9                   	leave  
 9cb:	c3                   	ret    

000009cc <semaphore_up>:

void 
semaphore_up(struct semaphore* sem )
{
 9cc:	55                   	push   %ebp
 9cd:	89 e5                	mov    %esp,%ebp
 9cf:	83 ec 18             	sub    $0x18,%esp
  //printf(1,"semaphore_up for tid = %d\n",thread_getId());
  binary_semaphore_down(sem->s1);
 9d2:	8b 45 08             	mov    0x8(%ebp),%eax
 9d5:	8b 40 04             	mov    0x4(%eax),%eax
 9d8:	89 04 24             	mov    %eax,(%esp)
 9db:	e8 68 fa ff ff       	call   448 <binary_semaphore_down>
  sem->value++;
 9e0:	8b 45 08             	mov    0x8(%ebp),%eax
 9e3:	8b 00                	mov    (%eax),%eax
 9e5:	8d 50 01             	lea    0x1(%eax),%edx
 9e8:	8b 45 08             	mov    0x8(%ebp),%eax
 9eb:	89 10                	mov    %edx,(%eax)
  //printf(1,"UP - sem %s semaphore_value = %d for tid = %d\n",sem->name,sem->value,thread_getId());
  if(sem->value == 1)
 9ed:	8b 45 08             	mov    0x8(%ebp),%eax
 9f0:	8b 00                	mov    (%eax),%eax
 9f2:	83 f8 01             	cmp    $0x1,%eax
 9f5:	75 0e                	jne    a05 <semaphore_up+0x39>
    binary_semaphore_up(sem->s2);
 9f7:	8b 45 08             	mov    0x8(%ebp),%eax
 9fa:	8b 40 08             	mov    0x8(%eax),%eax
 9fd:	89 04 24             	mov    %eax,(%esp)
 a00:	e8 4b fa ff ff       	call   450 <binary_semaphore_up>
  binary_semaphore_up(sem->s1);
 a05:	8b 45 08             	mov    0x8(%ebp),%eax
 a08:	8b 40 04             	mov    0x4(%eax),%eax
 a0b:	89 04 24             	mov    %eax,(%esp)
 a0e:	e8 3d fa ff ff       	call   450 <binary_semaphore_up>
}
 a13:	c9                   	leave  
 a14:	c3                   	ret    
 a15:	90                   	nop
 a16:	90                   	nop
 a17:	90                   	nop

00000a18 <BB_create>:
#include "boundedbuffer.h"

struct BB* 
BB_create(int max_capacity,char* name)
{
 a18:	55                   	push   %ebp
 a19:	89 e5                	mov    %esp,%ebp
 a1b:	83 ec 28             	sub    $0x28,%esp
  struct BB* buf = malloc(sizeof(struct BB));
 a1e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
 a25:	e8 e9 fd ff ff       	call   813 <malloc>
 a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(buf,0,sizeof(struct BB));
 a2d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
 a34:	00 
 a35:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 a3c:	00 
 a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a40:	89 04 24             	mov    %eax,(%esp)
 a43:	e8 8b f7 ff ff       	call   1d3 <memset>
  buf->elements = malloc(sizeof(void*)*max_capacity);
 a48:	8b 45 08             	mov    0x8(%ebp),%eax
 a4b:	c1 e0 02             	shl    $0x2,%eax
 a4e:	89 04 24             	mov    %eax,(%esp)
 a51:	e8 bd fd ff ff       	call   813 <malloc>
 a56:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a59:	89 42 1c             	mov    %eax,0x1c(%edx)
  memset(buf->elements,0,sizeof(void*)*max_capacity);
 a5c:	8b 45 08             	mov    0x8(%ebp),%eax
 a5f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a69:	8b 40 1c             	mov    0x1c(%eax),%eax
 a6c:	89 54 24 08          	mov    %edx,0x8(%esp)
 a70:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 a77:	00 
 a78:	89 04 24             	mov    %eax,(%esp)
 a7b:	e8 53 f7 ff ff       	call   1d3 <memset>
  buf->name = name;
 a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a83:	8b 55 0c             	mov    0xc(%ebp),%edx
 a86:	89 50 18             	mov    %edx,0x18(%eax)
  if((buf->mutex = binary_semaphore_create(1)) != -1)
 a89:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 a90:	e8 ab f9 ff ff       	call   440 <binary_semaphore_create>
 a95:	8b 55 f4             	mov    -0xc(%ebp),%edx
 a98:	89 42 04             	mov    %eax,0x4(%edx)
 a9b:	83 f8 ff             	cmp    $0xffffffff,%eax
 a9e:	74 52                	je     af2 <BB_create+0xda>
  {
    buf->BUFFER_SIZE = max_capacity;
 aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa3:	8b 55 08             	mov    0x8(%ebp),%edx
 aa6:	89 10                	mov    %edx,(%eax)
    if((buf->empty = semaphore_create(max_capacity, name))!= 0 && (buf->full = semaphore_create(0, name))!= 0)
 aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
 aab:	89 44 24 04          	mov    %eax,0x4(%esp)
 aaf:	8b 45 08             	mov    0x8(%ebp),%eax
 ab2:	89 04 24             	mov    %eax,(%esp)
 ab5:	e8 3a fe ff ff       	call   8f4 <semaphore_create>
 aba:	8b 55 f4             	mov    -0xc(%ebp),%edx
 abd:	89 42 08             	mov    %eax,0x8(%edx)
 ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac3:	8b 40 08             	mov    0x8(%eax),%eax
 ac6:	85 c0                	test   %eax,%eax
 ac8:	74 28                	je     af2 <BB_create+0xda>
 aca:	8b 45 0c             	mov    0xc(%ebp),%eax
 acd:	89 44 24 04          	mov    %eax,0x4(%esp)
 ad1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 ad8:	e8 17 fe ff ff       	call   8f4 <semaphore_create>
 add:	8b 55 f4             	mov    -0xc(%ebp),%edx
 ae0:	89 42 0c             	mov    %eax,0xc(%edx)
 ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ae6:	8b 40 0c             	mov    0xc(%eax),%eax
 ae9:	85 c0                	test   %eax,%eax
 aeb:	74 05                	je     af2 <BB_create+0xda>
      return buf;
 aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af0:	eb 23                	jmp    b15 <BB_create+0xfd>
  }
  free(buf->elements);
 af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 af5:	8b 40 1c             	mov    0x1c(%eax),%eax
 af8:	89 04 24             	mov    %eax,(%esp)
 afb:	e8 e4 fb ff ff       	call   6e4 <free>
  free(buf);
 b00:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b03:	89 04 24             	mov    %eax,(%esp)
 b06:	e8 d9 fb ff ff       	call   6e4 <free>
  buf = 0;
 b0b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  return buf;
 b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 b15:	c9                   	leave  
 b16:	c3                   	ret    

00000b17 <BB_put>:

void 
BB_put(struct BB* bb, void* element)
{
 b17:	55                   	push   %ebp
 b18:	89 e5                	mov    %esp,%ebp
 b1a:	83 ec 18             	sub    $0x18,%esp
 // printf(1,"put in %s, tid = %d\n",bb->name,thread_getId());
  semaphore_down(bb->empty);
 b1d:	8b 45 08             	mov    0x8(%ebp),%eax
 b20:	8b 40 08             	mov    0x8(%eax),%eax
 b23:	89 04 24             	mov    %eax,(%esp)
 b26:	e8 4b fe ff ff       	call   976 <semaphore_down>
  binary_semaphore_down(bb->mutex);
 b2b:	8b 45 08             	mov    0x8(%ebp),%eax
 b2e:	8b 40 04             	mov    0x4(%eax),%eax
 b31:	89 04 24             	mov    %eax,(%esp)
 b34:	e8 0f f9 ff ff       	call   448 <binary_semaphore_down>
  bb->elements[bb->end] = element;
 b39:	8b 45 08             	mov    0x8(%ebp),%eax
 b3c:	8b 50 1c             	mov    0x1c(%eax),%edx
 b3f:	8b 45 08             	mov    0x8(%ebp),%eax
 b42:	8b 40 14             	mov    0x14(%eax),%eax
 b45:	c1 e0 02             	shl    $0x2,%eax
 b48:	01 c2                	add    %eax,%edx
 b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
 b4d:	89 02                	mov    %eax,(%edx)
  ++bb->end;
 b4f:	8b 45 08             	mov    0x8(%ebp),%eax
 b52:	8b 40 14             	mov    0x14(%eax),%eax
 b55:	8d 50 01             	lea    0x1(%eax),%edx
 b58:	8b 45 08             	mov    0x8(%ebp),%eax
 b5b:	89 50 14             	mov    %edx,0x14(%eax)
  bb->end = bb->end%bb->BUFFER_SIZE;
 b5e:	8b 45 08             	mov    0x8(%ebp),%eax
 b61:	8b 40 14             	mov    0x14(%eax),%eax
 b64:	8b 55 08             	mov    0x8(%ebp),%edx
 b67:	8b 0a                	mov    (%edx),%ecx
 b69:	89 c2                	mov    %eax,%edx
 b6b:	c1 fa 1f             	sar    $0x1f,%edx
 b6e:	f7 f9                	idiv   %ecx
 b70:	8b 45 08             	mov    0x8(%ebp),%eax
 b73:	89 50 14             	mov    %edx,0x14(%eax)
  binary_semaphore_up(bb->mutex);
 b76:	8b 45 08             	mov    0x8(%ebp),%eax
 b79:	8b 40 04             	mov    0x4(%eax),%eax
 b7c:	89 04 24             	mov    %eax,(%esp)
 b7f:	e8 cc f8 ff ff       	call   450 <binary_semaphore_up>
  semaphore_up(bb->full);
 b84:	8b 45 08             	mov    0x8(%ebp),%eax
 b87:	8b 40 0c             	mov    0xc(%eax),%eax
 b8a:	89 04 24             	mov    %eax,(%esp)
 b8d:	e8 3a fe ff ff       	call   9cc <semaphore_up>
}
 b92:	c9                   	leave  
 b93:	c3                   	ret    

00000b94 <BB_pop>:

void* 
BB_pop(struct BB* bb)
{
 b94:	55                   	push   %ebp
 b95:	89 e5                	mov    %esp,%ebp
 b97:	83 ec 28             	sub    $0x28,%esp
  void* item;
  //printf(1,"pop from  %s, tid = %d\n",bb->name,thread_getId());
  semaphore_down(bb->full);
 b9a:	8b 45 08             	mov    0x8(%ebp),%eax
 b9d:	8b 40 0c             	mov    0xc(%eax),%eax
 ba0:	89 04 24             	mov    %eax,(%esp)
 ba3:	e8 ce fd ff ff       	call   976 <semaphore_down>
  binary_semaphore_down(bb->mutex);
 ba8:	8b 45 08             	mov    0x8(%ebp),%eax
 bab:	8b 40 04             	mov    0x4(%eax),%eax
 bae:	89 04 24             	mov    %eax,(%esp)
 bb1:	e8 92 f8 ff ff       	call   448 <binary_semaphore_down>
  item = bb->elements[bb->start];
 bb6:	8b 45 08             	mov    0x8(%ebp),%eax
 bb9:	8b 50 1c             	mov    0x1c(%eax),%edx
 bbc:	8b 45 08             	mov    0x8(%ebp),%eax
 bbf:	8b 40 10             	mov    0x10(%eax),%eax
 bc2:	c1 e0 02             	shl    $0x2,%eax
 bc5:	01 d0                	add    %edx,%eax
 bc7:	8b 00                	mov    (%eax),%eax
 bc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bb->elements[bb->start] = 0;
 bcc:	8b 45 08             	mov    0x8(%ebp),%eax
 bcf:	8b 50 1c             	mov    0x1c(%eax),%edx
 bd2:	8b 45 08             	mov    0x8(%ebp),%eax
 bd5:	8b 40 10             	mov    0x10(%eax),%eax
 bd8:	c1 e0 02             	shl    $0x2,%eax
 bdb:	01 d0                	add    %edx,%eax
 bdd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  ++bb->start;
 be3:	8b 45 08             	mov    0x8(%ebp),%eax
 be6:	8b 40 10             	mov    0x10(%eax),%eax
 be9:	8d 50 01             	lea    0x1(%eax),%edx
 bec:	8b 45 08             	mov    0x8(%ebp),%eax
 bef:	89 50 10             	mov    %edx,0x10(%eax)
  bb->start = bb->start%bb->BUFFER_SIZE;
 bf2:	8b 45 08             	mov    0x8(%ebp),%eax
 bf5:	8b 40 10             	mov    0x10(%eax),%eax
 bf8:	8b 55 08             	mov    0x8(%ebp),%edx
 bfb:	8b 0a                	mov    (%edx),%ecx
 bfd:	89 c2                	mov    %eax,%edx
 bff:	c1 fa 1f             	sar    $0x1f,%edx
 c02:	f7 f9                	idiv   %ecx
 c04:	8b 45 08             	mov    0x8(%ebp),%eax
 c07:	89 50 10             	mov    %edx,0x10(%eax)
  binary_semaphore_up(bb->mutex);
 c0a:	8b 45 08             	mov    0x8(%ebp),%eax
 c0d:	8b 40 04             	mov    0x4(%eax),%eax
 c10:	89 04 24             	mov    %eax,(%esp)
 c13:	e8 38 f8 ff ff       	call   450 <binary_semaphore_up>
  semaphore_up(bb->empty);
 c18:	8b 45 08             	mov    0x8(%ebp),%eax
 c1b:	8b 40 08             	mov    0x8(%eax),%eax
 c1e:	89 04 24             	mov    %eax,(%esp)
 c21:	e8 a6 fd ff ff       	call   9cc <semaphore_up>
  return item;
 c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
 c29:	c9                   	leave  
 c2a:	c3                   	ret    
