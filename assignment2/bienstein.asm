
_bienstein:     file format elf32-i386


Disassembly of section .text:

00000000 <enter_bar>:

int M,A,C,S,B,fd;


void enter_bar() //bouncer
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 ec 18             	sub    $0x18,%esp
  semaphore_down(bouncer);
       6:	a1 b4 1d 00 00       	mov    0x1db4,%eax
       b:	89 04 24             	mov    %eax,(%esp)
       e:	e8 2f 13 00 00       	call   1342 <semaphore_down>
}
      13:	c9                   	leave  
      14:	c3                   	ret    

00000015 <leave_bar>:

void leave_bar() //bouncer
{
      15:	55                   	push   %ebp
      16:	89 e5                	mov    %esp,%ebp
      18:	83 ec 18             	sub    $0x18,%esp
  semaphore_up(bouncer);
      1b:	a1 b4 1d 00 00       	mov    0x1db4,%eax
      20:	89 04 24             	mov    %eax,(%esp)
      23:	e8 70 13 00 00       	call   1398 <semaphore_up>
}
      28:	c9                   	leave  
      29:	c3                   	ret    

0000002a <place_action>:

void place_action(struct Action* action) //ABB
{
      2a:	55                   	push   %ebp
      2b:	89 e5                	mov    %esp,%ebp
      2d:	83 ec 18             	sub    $0x18,%esp
  BB_put(ABB, action);
      30:	a1 c8 1d 00 00       	mov    0x1dc8,%eax
      35:	8b 55 08             	mov    0x8(%ebp),%edx
      38:	89 54 24 04          	mov    %edx,0x4(%esp)
      3c:	89 04 24             	mov    %eax,(%esp)
      3f:	e8 9f 14 00 00       	call   14e3 <BB_put>
}
      44:	c9                   	leave  
      45:	c3                   	ret    

00000046 <get_action>:

struct Action* get_action() //ABB
{
      46:	55                   	push   %ebp
      47:	89 e5                	mov    %esp,%ebp
      49:	83 ec 18             	sub    $0x18,%esp
  return BB_pop(ABB);
      4c:	a1 c8 1d 00 00       	mov    0x1dc8,%eax
      51:	89 04 24             	mov    %eax,(%esp)
      54:	e8 07 15 00 00       	call   1560 <BB_pop>
}
      59:	c9                   	leave  
      5a:	c3                   	ret    

0000005b <serve_drink>:

void serve_drink(struct Cup* cup) //DrinkBB
{
      5b:	55                   	push   %ebp
      5c:	89 e5                	mov    %esp,%ebp
      5e:	83 ec 18             	sub    $0x18,%esp
  BB_put(DrinkBB,cup);
      61:	a1 d4 1d 00 00       	mov    0x1dd4,%eax
      66:	8b 55 08             	mov    0x8(%ebp),%edx
      69:	89 54 24 04          	mov    %edx,0x4(%esp)
      6d:	89 04 24             	mov    %eax,(%esp)
      70:	e8 6e 14 00 00       	call   14e3 <BB_put>
}
      75:	c9                   	leave  
      76:	c3                   	ret    

00000077 <get_drink>:

struct Cup* get_drink() //DrinkBB
{
      77:	55                   	push   %ebp
      78:	89 e5                	mov    %esp,%ebp
      7a:	83 ec 18             	sub    $0x18,%esp
  return BB_pop(DrinkBB);
      7d:	a1 d4 1d 00 00       	mov    0x1dd4,%eax
      82:	89 04 24             	mov    %eax,(%esp)
      85:	e8 d6 14 00 00       	call   1560 <BB_pop>
}
      8a:	c9                   	leave  
      8b:	c3                   	ret    

0000008c <get_clean_cup>:

struct Cup* get_clean_cup() //CBB
{
      8c:	55                   	push   %ebp
      8d:	89 e5                	mov    %esp,%ebp
      8f:	83 ec 18             	sub    $0x18,%esp
  return BB_pop(CBB);
      92:	a1 e0 1d 00 00       	mov    0x1de0,%eax
      97:	89 04 24             	mov    %eax,(%esp)
      9a:	e8 c1 14 00 00       	call   1560 <BB_pop>
}
      9f:	c9                   	leave  
      a0:	c3                   	ret    

000000a1 <add_clean_cup>:

void add_clean_cup(struct Cup* cup) //CBB
{
      a1:	55                   	push   %ebp
      a2:	89 e5                	mov    %esp,%ebp
      a4:	83 ec 18             	sub    $0x18,%esp
  BB_put(CBB,cup);
      a7:	a1 e0 1d 00 00       	mov    0x1de0,%eax
      ac:	8b 55 08             	mov    0x8(%ebp),%edx
      af:	89 54 24 04          	mov    %edx,0x4(%esp)
      b3:	89 04 24             	mov    %eax,(%esp)
      b6:	e8 28 14 00 00       	call   14e3 <BB_put>
}
      bb:	c9                   	leave  
      bc:	c3                   	ret    

000000bd <return_cup>:

void return_cup(struct Cup* cup) //DBB
{
      bd:	55                   	push   %ebp
      be:	89 e5                	mov    %esp,%ebp
      c0:	83 ec 18             	sub    $0x18,%esp
  BB_put(DBB,cup);
      c3:	a1 d0 1d 00 00       	mov    0x1dd0,%eax
      c8:	8b 55 08             	mov    0x8(%ebp),%edx
      cb:	89 54 24 04          	mov    %edx,0x4(%esp)
      cf:	89 04 24             	mov    %eax,(%esp)
      d2:	e8 0c 14 00 00       	call   14e3 <BB_put>
}
      d7:	c9                   	leave  
      d8:	c3                   	ret    

000000d9 <wash_dirty>:

struct Cup* wash_dirty() //DBB
{
      d9:	55                   	push   %ebp
      da:	89 e5                	mov    %esp,%ebp
      dc:	83 ec 18             	sub    $0x18,%esp
  return BB_pop(DBB);
      df:	a1 d0 1d 00 00       	mov    0x1dd0,%eax
      e4:	89 04 24             	mov    %eax,(%esp)
      e7:	e8 74 14 00 00       	call   1560 <BB_pop>
}
      ec:	c9                   	leave  
      ed:	c3                   	ret    

000000ee <getconf>:

int getconf(void)
{
      ee:	55                   	push   %ebp
      ef:	89 e5                	mov    %esp,%ebp
      f1:	81 ec 28 02 00 00    	sub    $0x228,%esp
  int fdin,rd;
  char buf[512];
  memset(&buf,0,512);
      f7:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
      fe:	00 
      ff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     106:	00 
     107:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     10d:	89 04 24             	mov    %eax,(%esp)
     110:	e8 8a 0a 00 00       	call   b9f <memset>
  
  if((fdin = open("con.conf",O_RDONLY)) < 0)
     115:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     11c:	00 
     11d:	c7 04 24 f8 15 00 00 	movl   $0x15f8,(%esp)
     124:	e8 5b 0c 00 00       	call   d84 <open>
     129:	89 45 f0             	mov    %eax,-0x10(%ebp)
     12c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     130:	79 1e                	jns    150 <getconf+0x62>
  {
    printf(2,"Couldn't open the conf file\n");
     132:	c7 44 24 04 01 16 00 	movl   $0x1601,0x4(%esp)
     139:	00 
     13a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     141:	e8 b5 0d 00 00       	call   efb <printf>
    return -1;
     146:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     14b:	e9 60 01 00 00       	jmp    2b0 <getconf+0x1c2>
  }
  
  if((rd = read(fdin, &buf, 512)) <= 0)
     150:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
     157:	00 
     158:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     15e:	89 44 24 04          	mov    %eax,0x4(%esp)
     162:	8b 45 f0             	mov    -0x10(%ebp),%eax
     165:	89 04 24             	mov    %eax,(%esp)
     168:	e8 ef 0b 00 00       	call   d5c <read>
     16d:	89 45 ec             	mov    %eax,-0x14(%ebp)
     170:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     174:	7f 1e                	jg     194 <getconf+0xa6>
  {
    printf(2,"Couldn't read from conf file\n");
     176:	c7 44 24 04 1e 16 00 	movl   $0x161e,0x4(%esp)
     17d:	00 
     17e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     185:	e8 71 0d 00 00       	call   efb <printf>
    return -1;
     18a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     18f:	e9 1c 01 00 00       	jmp    2b0 <getconf+0x1c2>
  }
  
  int i = 0;
     194:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  for(;i<rd;i++)
     19b:	eb 20                	jmp    1bd <getconf+0xcf>
    if(buf[i] == '\n')
     19d:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     1a3:	03 45 f4             	add    -0xc(%ebp),%eax
     1a6:	0f b6 00             	movzbl (%eax),%eax
     1a9:	3c 0a                	cmp    $0xa,%al
     1ab:	75 0c                	jne    1b9 <getconf+0xcb>
      buf[i] = 0;
     1ad:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     1b3:	03 45 f4             	add    -0xc(%ebp),%eax
     1b6:	c6 00 00             	movb   $0x0,(%eax)
    printf(2,"Couldn't read from conf file\n");
    return -1;
  }
  
  int i = 0;
  for(;i<rd;i++)
     1b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     1bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1c0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     1c3:	7c d8                	jl     19d <getconf+0xaf>
    if(buf[i] == '\n')
      buf[i] = 0;

  for(i=0;i<rd;i++)
     1c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     1cc:	e9 ce 00 00 00       	jmp    29f <getconf+0x1b1>
  {
    if(buf[i] == '=')
     1d1:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     1d7:	03 45 f4             	add    -0xc(%ebp),%eax
     1da:	0f b6 00             	movzbl (%eax),%eax
     1dd:	3c 3d                	cmp    $0x3d,%al
     1df:	0f 85 b6 00 00 00    	jne    29b <getconf+0x1ad>
    {
      switch(buf[i-1])
     1e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
     1e8:	83 e8 01             	sub    $0x1,%eax
     1eb:	0f b6 84 05 ec fd ff 	movzbl -0x214(%ebp,%eax,1),%eax
     1f2:	ff 
     1f3:	0f be c0             	movsbl %al,%eax
     1f6:	83 e8 41             	sub    $0x41,%eax
     1f9:	83 f8 12             	cmp    $0x12,%eax
     1fc:	0f 87 99 00 00 00    	ja     29b <getconf+0x1ad>
     202:	8b 04 85 3c 16 00 00 	mov    0x163c(,%eax,4),%eax
     209:	ff e0                	jmp    *%eax
      {
	case 'M':
	  M = atoi(&buf[i+1]);
     20b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     20e:	8d 50 01             	lea    0x1(%eax),%edx
     211:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     217:	01 d0                	add    %edx,%eax
     219:	89 04 24             	mov    %eax,(%esp)
     21c:	e8 92 0a 00 00       	call   cb3 <atoi>
     221:	a3 d8 1d 00 00       	mov    %eax,0x1dd8
	  break;
     226:	eb 73                	jmp    29b <getconf+0x1ad>
	case 'A':
	   A = atoi(&buf[i+1]);
     228:	8b 45 f4             	mov    -0xc(%ebp),%eax
     22b:	8d 50 01             	lea    0x1(%eax),%edx
     22e:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     234:	01 d0                	add    %edx,%eax
     236:	89 04 24             	mov    %eax,(%esp)
     239:	e8 75 0a 00 00       	call   cb3 <atoi>
     23e:	a3 b0 1d 00 00       	mov    %eax,0x1db0
	  break;
     243:	eb 56                	jmp    29b <getconf+0x1ad>
	case 'C':
	   C = atoi(&buf[i+1]);
     245:	8b 45 f4             	mov    -0xc(%ebp),%eax
     248:	8d 50 01             	lea    0x1(%eax),%edx
     24b:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     251:	01 d0                	add    %edx,%eax
     253:	89 04 24             	mov    %eax,(%esp)
     256:	e8 58 0a 00 00       	call   cb3 <atoi>
     25b:	a3 cc 1d 00 00       	mov    %eax,0x1dcc
	  break;
     260:	eb 39                	jmp    29b <getconf+0x1ad>
	case 'S':
	   S = atoi(&buf[i+1]);
     262:	8b 45 f4             	mov    -0xc(%ebp),%eax
     265:	8d 50 01             	lea    0x1(%eax),%edx
     268:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     26e:	01 d0                	add    %edx,%eax
     270:	89 04 24             	mov    %eax,(%esp)
     273:	e8 3b 0a 00 00       	call   cb3 <atoi>
     278:	a3 c0 1d 00 00       	mov    %eax,0x1dc0
	  break;
     27d:	eb 1c                	jmp    29b <getconf+0x1ad>
	case 'B':
	   B = atoi(&buf[i+1]);
     27f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     282:	8d 50 01             	lea    0x1(%eax),%edx
     285:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     28b:	01 d0                	add    %edx,%eax
     28d:	89 04 24             	mov    %eax,(%esp)
     290:	e8 1e 0a 00 00       	call   cb3 <atoi>
     295:	a3 c4 1d 00 00       	mov    %eax,0x1dc4
	  break;
     29a:	90                   	nop
  int i = 0;
  for(;i<rd;i++)
    if(buf[i] == '\n')
      buf[i] = 0;

  for(i=0;i<rd;i++)
     29b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     29f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     2a2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
     2a5:	0f 8c 26 ff ff ff    	jl     1d1 <getconf+0xe3>
	   B = atoi(&buf[i+1]);
	  break;
      }
    }
  }
  return 0;
     2ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
     2b0:	c9                   	leave  
     2b1:	c3                   	ret    

000002b2 <student_func>:

void* student_func(void)
{
     2b2:	55                   	push   %ebp
     2b3:	89 e5                	mov    %esp,%ebp
     2b5:	83 ec 48             	sub    $0x48,%esp
  int tid = thread_getId();
     2b8:	e8 2f 0b 00 00       	call   dec <thread_getId>
     2bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i = 0;
     2c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
  enter_bar();
     2c7:	e8 34 fd ff ff       	call   0 <enter_bar>
  for(;i < tid%5;i++)
     2cc:	e9 b2 00 00 00       	jmp    383 <student_func+0xd1>
  {
    struct Action* get = malloc(sizeof(struct Action)); //create the get_drink action
     2d1:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     2d8:	e8 02 0f 00 00       	call   11df <malloc>
     2dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    get->type = GET_DRINK;
     2e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
     2e3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    get->cup = 0;
     2e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
     2ec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    get->tid = tid;
     2f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
     2f6:	8b 55 f0             	mov    -0x10(%ebp),%edx
     2f9:	89 50 08             	mov    %edx,0x8(%eax)
    place_action(get);
     2fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
     2ff:	89 04 24             	mov    %eax,(%esp)
     302:	e8 23 fd ff ff       	call   2a <place_action>
    struct Cup * cup = get_drink();			//get cup from DrinkBB buffer
     307:	e8 6b fd ff ff       	call   77 <get_drink>
     30c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    printf(fd,"Student %d is having his %d drink, with cup %d\n",tid,i+1,cup->id);
     30f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     312:	8b 10                	mov    (%eax),%edx
     314:	8b 45 f4             	mov    -0xc(%ebp),%eax
     317:	8d 48 01             	lea    0x1(%eax),%ecx
     31a:	a1 b8 1d 00 00       	mov    0x1db8,%eax
     31f:	89 54 24 10          	mov    %edx,0x10(%esp)
     323:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
     327:	8b 55 f0             	mov    -0x10(%ebp),%edx
     32a:	89 54 24 08          	mov    %edx,0x8(%esp)
     32e:	c7 44 24 04 88 16 00 	movl   $0x1688,0x4(%esp)
     335:	00 
     336:	89 04 24             	mov    %eax,(%esp)
     339:	e8 bd 0b 00 00       	call   efb <printf>
    sleep(1);
     33e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     345:	e8 8a 0a 00 00       	call   dd4 <sleep>
    struct Action* put = malloc(sizeof(struct Action));
     34a:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     351:	e8 89 0e 00 00       	call   11df <malloc>
     356:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    put->type = PUT_DRINK;
     359:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     35c:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    put->cup = cup;
     362:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     365:	8b 55 e8             	mov    -0x18(%ebp),%edx
     368:	89 50 04             	mov    %edx,0x4(%eax)
    put->tid = tid;
     36b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     36e:	8b 55 f0             	mov    -0x10(%ebp),%edx
     371:	89 50 08             	mov    %edx,0x8(%eax)
    place_action(put);
     374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     377:	89 04 24             	mov    %eax,(%esp)
     37a:	e8 ab fc ff ff       	call   2a <place_action>
{
  int tid = thread_getId();
  int i = 0;
  
  enter_bar();
  for(;i < tid%5;i++)
     37f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     383:	8b 4d f0             	mov    -0x10(%ebp),%ecx
     386:	ba 67 66 66 66       	mov    $0x66666667,%edx
     38b:	89 c8                	mov    %ecx,%eax
     38d:	f7 ea                	imul   %edx
     38f:	d1 fa                	sar    %edx
     391:	89 c8                	mov    %ecx,%eax
     393:	c1 f8 1f             	sar    $0x1f,%eax
     396:	29 c2                	sub    %eax,%edx
     398:	89 d0                	mov    %edx,%eax
     39a:	c1 e0 02             	shl    $0x2,%eax
     39d:	01 d0                	add    %edx,%eax
     39f:	89 ca                	mov    %ecx,%edx
     3a1:	29 c2                	sub    %eax,%edx
     3a3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
     3a6:	0f 8f 25 ff ff ff    	jg     2d1 <student_func+0x1f>
    put->type = PUT_DRINK;
    put->cup = cup;
    put->tid = tid;
    place_action(put);
  }
  printf(fd,"Student %d is drunk, and trying to go home\n",tid);
     3ac:	a1 b8 1d 00 00       	mov    0x1db8,%eax
     3b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
     3b4:	89 54 24 08          	mov    %edx,0x8(%esp)
     3b8:	c7 44 24 04 b8 16 00 	movl   $0x16b8,0x4(%esp)
     3bf:	00 
     3c0:	89 04 24             	mov    %eax,(%esp)
     3c3:	e8 33 0b 00 00       	call   efb <printf>
  leave_bar();
     3c8:	e8 48 fc ff ff       	call   15 <leave_bar>
  thread_exit(0);
     3cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     3d4:	e8 2b 0a 00 00       	call   e04 <thread_exit>
  return 0;
     3d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
     3de:	c9                   	leave  
     3df:	c3                   	ret    

000003e0 <bartender_func>:

void* bartender_func(void)
{
     3e0:	55                   	push   %ebp
     3e1:	89 e5                	mov    %esp,%ebp
     3e3:	83 ec 48             	sub    $0x48,%esp
  double n,bufSize;
  int tid = thread_getId();
     3e6:	e8 01 0a 00 00       	call   dec <thread_getId>
     3eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(;;)
  {
    struct Action * act = get_action();
     3ee:	e8 53 fc ff ff       	call   46 <get_action>
     3f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(act->type == GET_DRINK)
     3f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
     3f9:	8b 00                	mov    (%eax),%eax
     3fb:	83 f8 01             	cmp    $0x1,%eax
     3fe:	75 3d                	jne    43d <bartender_func+0x5d>
    {
      struct Cup * cup = get_clean_cup();
     400:	e8 87 fc ff ff       	call   8c <get_clean_cup>
     405:	89 45 ec             	mov    %eax,-0x14(%ebp)
      printf(fd,"Bartender %d is making drink with cup #%d\n",tid,cup->id);
     408:	8b 45 ec             	mov    -0x14(%ebp),%eax
     40b:	8b 10                	mov    (%eax),%edx
     40d:	a1 b8 1d 00 00       	mov    0x1db8,%eax
     412:	89 54 24 0c          	mov    %edx,0xc(%esp)
     416:	8b 55 f4             	mov    -0xc(%ebp),%edx
     419:	89 54 24 08          	mov    %edx,0x8(%esp)
     41d:	c7 44 24 04 e4 16 00 	movl   $0x16e4,0x4(%esp)
     424:	00 
     425:	89 04 24             	mov    %eax,(%esp)
     428:	e8 ce 0a 00 00       	call   efb <printf>
      serve_drink(cup);
     42d:	8b 45 ec             	mov    -0x14(%ebp),%eax
     430:	89 04 24             	mov    %eax,(%esp)
     433:	e8 23 fc ff ff       	call   5b <serve_drink>
     438:	e9 b1 00 00 00       	jmp    4ee <bartender_func+0x10e>
    }
    else if(act->type == PUT_DRINK)
     43d:	8b 45 f0             	mov    -0x10(%ebp),%eax
     440:	8b 00                	mov    (%eax),%eax
     442:	83 f8 02             	cmp    $0x2,%eax
     445:	0f 85 a3 00 00 00    	jne    4ee <bartender_func+0x10e>
    {
      struct Cup * cup = act->cup;
     44b:	8b 45 f0             	mov    -0x10(%ebp),%eax
     44e:	8b 40 04             	mov    0x4(%eax),%eax
     451:	89 45 e8             	mov    %eax,-0x18(%ebp)
      return_cup(cup);
     454:	8b 45 e8             	mov    -0x18(%ebp),%eax
     457:	89 04 24             	mov    %eax,(%esp)
     45a:	e8 5e fc ff ff       	call   bd <return_cup>
      printf(fd,"Bartender %d returned cup #%d\n",tid,cup->id);
     45f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     462:	8b 10                	mov    (%eax),%edx
     464:	a1 b8 1d 00 00       	mov    0x1db8,%eax
     469:	89 54 24 0c          	mov    %edx,0xc(%esp)
     46d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     470:	89 54 24 08          	mov    %edx,0x8(%esp)
     474:	c7 44 24 04 10 17 00 	movl   $0x1710,0x4(%esp)
     47b:	00 
     47c:	89 04 24             	mov    %eax,(%esp)
     47f:	e8 77 0a 00 00       	call   efb <printf>
      
      n = DBB->full->value;
     484:	a1 d0 1d 00 00       	mov    0x1dd0,%eax
     489:	8b 40 0c             	mov    0xc(%eax),%eax
     48c:	8b 00                	mov    (%eax),%eax
     48e:	89 45 d0             	mov    %eax,-0x30(%ebp)
     491:	db 45 d0             	fildl  -0x30(%ebp)
     494:	dd 5d e0             	fstpl  -0x20(%ebp)
      bufSize = DBB->BUFFER_SIZE;
     497:	a1 d0 1d 00 00       	mov    0x1dd0,%eax
     49c:	8b 00                	mov    (%eax),%eax
     49e:	89 45 d0             	mov    %eax,-0x30(%ebp)
     4a1:	db 45 d0             	fildl  -0x30(%ebp)
     4a4:	dd 5d d8             	fstpl  -0x28(%ebp)
      if(n/bufSize >= 0.6)
     4a7:	dd 45 e0             	fldl   -0x20(%ebp)
     4aa:	dc 75 d8             	fdivl  -0x28(%ebp)
     4ad:	dd 05 b0 18 00 00    	fldl   0x18b0
     4b3:	d9 c9                	fxch   %st(1)
     4b5:	df e9                	fucomip %st(1),%st
     4b7:	dd d8                	fstp   %st(0)
     4b9:	0f 93 c0             	setae  %al
     4bc:	84 c0                	test   %al,%al
     4be:	74 2e                	je     4ee <bartender_func+0x10e>
      {
	dirtycups = n;
     4c0:	dd 45 e0             	fldl   -0x20(%ebp)
     4c3:	d9 7d d6             	fnstcw -0x2a(%ebp)
     4c6:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
     4ca:	b4 0c                	mov    $0xc,%ah
     4cc:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
     4d0:	d9 6d d4             	fldcw  -0x2c(%ebp)
     4d3:	db 5d d0             	fistpl -0x30(%ebp)
     4d6:	d9 6d d6             	fldcw  -0x2a(%ebp)
     4d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
     4dc:	a3 bc 1d 00 00       	mov    %eax,0x1dbc
	binary_semaphore_up(cupsem);
     4e1:	a1 dc 1d 00 00       	mov    0x1ddc,%eax
     4e6:	89 04 24             	mov    %eax,(%esp)
     4e9:	e8 2e 09 00 00       	call   e1c <binary_semaphore_up>
      }
    }
    free(act);
     4ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4f1:	89 04 24             	mov    %eax,(%esp)
     4f4:	e8 b7 0b 00 00       	call   10b0 <free>
  }
     4f9:	e9 f0 fe ff ff       	jmp    3ee <bartender_func+0xe>

000004fe <cupboy_func>:
  return 0;
}

void* cupboy_func(void)
{
     4fe:	55                   	push   %ebp
     4ff:	89 e5                	mov    %esp,%ebp
     501:	83 ec 28             	sub    $0x28,%esp
  int i, n;
  
  for(;;)
  {
    //n = dirtycups;
    n = DBB->full->value;
     504:	a1 d0 1d 00 00       	mov    0x1dd0,%eax
     509:	8b 40 0c             	mov    0xc(%eax),%eax
     50c:	8b 00                	mov    (%eax),%eax
     50e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    for(i=0;i<n;i++)
     511:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     518:	eb 41                	jmp    55b <cupboy_func+0x5d>
    {
      struct Cup * cup = wash_dirty();
     51a:	e8 ba fb ff ff       	call   d9 <wash_dirty>
     51f:	89 45 ec             	mov    %eax,-0x14(%ebp)
      sleep(1);
     522:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     529:	e8 a6 08 00 00       	call   dd4 <sleep>
      add_clean_cup(cup);
     52e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     531:	89 04 24             	mov    %eax,(%esp)
     534:	e8 68 fb ff ff       	call   a1 <add_clean_cup>
      printf(fd,"Cup boy added clean cup #%d\n",cup->id);    
     539:	8b 45 ec             	mov    -0x14(%ebp),%eax
     53c:	8b 10                	mov    (%eax),%edx
     53e:	a1 b8 1d 00 00       	mov    0x1db8,%eax
     543:	89 54 24 08          	mov    %edx,0x8(%esp)
     547:	c7 44 24 04 2f 17 00 	movl   $0x172f,0x4(%esp)
     54e:	00 
     54f:	89 04 24             	mov    %eax,(%esp)
     552:	e8 a4 09 00 00       	call   efb <printf>
  
  for(;;)
  {
    //n = dirtycups;
    n = DBB->full->value;
    for(i=0;i<n;i++)
     557:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     55b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     55e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     561:	7c b7                	jl     51a <cupboy_func+0x1c>
      struct Cup * cup = wash_dirty();
      sleep(1);
      add_clean_cup(cup);
      printf(fd,"Cup boy added clean cup #%d\n",cup->id);    
    }
    binary_semaphore_down(cupsem);
     563:	a1 dc 1d 00 00       	mov    0x1ddc,%eax
     568:	89 04 24             	mov    %eax,(%esp)
     56b:	e8 a4 08 00 00       	call   e14 <binary_semaphore_down>
  }
     570:	eb 92                	jmp    504 <cupboy_func+0x6>

00000572 <main>:
}


int 
main(void)
{
     572:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     576:	83 e4 f0             	and    $0xfffffff0,%esp
     579:	ff 71 fc             	pushl  -0x4(%ecx)
     57c:	55                   	push   %ebp
     57d:	89 e5                	mov    %esp,%ebp
     57f:	53                   	push   %ebx
     580:	51                   	push   %ecx
     581:	83 ec 50             	sub    $0x50,%esp
     584:	89 e0                	mov    %esp,%eax
     586:	89 c3                	mov    %eax,%ebx
  printf(1,"Running simulation...\nPlease run 'cat Synch_problem_log.txt' to see results\n");
     588:	c7 44 24 04 4c 17 00 	movl   $0x174c,0x4(%esp)
     58f:	00 
     590:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     597:	e8 5f 09 00 00       	call   efb <printf>
  close(1);
     59c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5a3:	e8 c4 07 00 00       	call   d6c <close>
  if((fd = open("Synch_problem_log.txt",(O_WRONLY | O_CREATE))) < 0)
     5a8:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     5af:	00 
     5b0:	c7 04 24 99 17 00 00 	movl   $0x1799,(%esp)
     5b7:	e8 c8 07 00 00       	call   d84 <open>
     5bc:	a3 b8 1d 00 00       	mov    %eax,0x1db8
     5c1:	a1 b8 1d 00 00       	mov    0x1db8,%eax
     5c6:	85 c0                	test   %eax,%eax
     5c8:	79 1e                	jns    5e8 <main+0x76>
  {
    printf(2,"Couldn't open the log file\n");
     5ca:	c7 44 24 04 af 17 00 	movl   $0x17af,0x4(%esp)
     5d1:	00 
     5d2:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     5d9:	e8 1d 09 00 00       	call   efb <printf>
    return -1;
     5de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     5e3:	e9 ec 04 00 00       	jmp    ad4 <main+0x562>
  }
  if (getconf() == -1)
     5e8:	e8 01 fb ff ff       	call   ee <getconf>
     5ed:	83 f8 ff             	cmp    $0xffffffff,%eax
     5f0:	75 0a                	jne    5fc <main+0x8a>
  {
    return -1;
     5f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     5f7:	e9 d8 04 00 00       	jmp    ad4 <main+0x562>
  }
  //fd=1;
  void * barStack[B];
     5fc:	a1 c4 1d 00 00       	mov    0x1dc4,%eax
     601:	8d 50 ff             	lea    -0x1(%eax),%edx
     604:	89 55 f0             	mov    %edx,-0x10(%ebp)
     607:	c1 e0 02             	shl    $0x2,%eax
     60a:	8d 50 0f             	lea    0xf(%eax),%edx
     60d:	b8 10 00 00 00       	mov    $0x10,%eax
     612:	83 e8 01             	sub    $0x1,%eax
     615:	01 d0                	add    %edx,%eax
     617:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
     61e:	ba 00 00 00 00       	mov    $0x0,%edx
     623:	f7 75 c4             	divl   -0x3c(%ebp)
     626:	6b c0 10             	imul   $0x10,%eax,%eax
     629:	29 c4                	sub    %eax,%esp
     62b:	8d 44 24 0c          	lea    0xc(%esp),%eax
     62f:	83 c0 0f             	add    $0xf,%eax
     632:	c1 e8 04             	shr    $0x4,%eax
     635:	c1 e0 04             	shl    $0x4,%eax
     638:	89 45 ec             	mov    %eax,-0x14(%ebp)
  void * studStack[S];
     63b:	a1 c0 1d 00 00       	mov    0x1dc0,%eax
     640:	8d 50 ff             	lea    -0x1(%eax),%edx
     643:	89 55 e8             	mov    %edx,-0x18(%ebp)
     646:	c1 e0 02             	shl    $0x2,%eax
     649:	8d 50 0f             	lea    0xf(%eax),%edx
     64c:	b8 10 00 00 00       	mov    $0x10,%eax
     651:	83 e8 01             	sub    $0x1,%eax
     654:	01 d0                	add    %edx,%eax
     656:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
     65d:	ba 00 00 00 00       	mov    $0x0,%edx
     662:	f7 75 c4             	divl   -0x3c(%ebp)
     665:	6b c0 10             	imul   $0x10,%eax,%eax
     668:	29 c4                	sub    %eax,%esp
     66a:	8d 44 24 0c          	lea    0xc(%esp),%eax
     66e:	83 c0 0f             	add    $0xf,%eax
     671:	c1 e8 04             	shr    $0x4,%eax
     674:	c1 e0 04             	shl    $0x4,%eax
     677:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int studTid[S];
     67a:	a1 c0 1d 00 00       	mov    0x1dc0,%eax
     67f:	8d 50 ff             	lea    -0x1(%eax),%edx
     682:	89 55 e0             	mov    %edx,-0x20(%ebp)
     685:	c1 e0 02             	shl    $0x2,%eax
     688:	8d 50 0f             	lea    0xf(%eax),%edx
     68b:	b8 10 00 00 00       	mov    $0x10,%eax
     690:	83 e8 01             	sub    $0x1,%eax
     693:	01 d0                	add    %edx,%eax
     695:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
     69c:	ba 00 00 00 00       	mov    $0x0,%edx
     6a1:	f7 75 c4             	divl   -0x3c(%ebp)
     6a4:	6b c0 10             	imul   $0x10,%eax,%eax
     6a7:	29 c4                	sub    %eax,%esp
     6a9:	8d 44 24 0c          	lea    0xc(%esp),%eax
     6ad:	83 c0 0f             	add    $0xf,%eax
     6b0:	c1 e8 04             	shr    $0x4,%eax
     6b3:	c1 e0 04             	shl    $0x4,%eax
     6b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  int i = 0;  
     6b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  bouncer = semaphore_create(M,"bouncer");
     6c0:	a1 d8 1d 00 00       	mov    0x1dd8,%eax
     6c5:	c7 44 24 04 cb 17 00 	movl   $0x17cb,0x4(%esp)
     6cc:	00 
     6cd:	89 04 24             	mov    %eax,(%esp)
     6d0:	e8 eb 0b 00 00       	call   12c0 <semaphore_create>
     6d5:	a3 b4 1d 00 00       	mov    %eax,0x1db4
  cupsem = binary_semaphore_create(1/*,"cupboy"*/);
     6da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6e1:	e8 26 07 00 00       	call   e0c <binary_semaphore_create>
     6e6:	a3 dc 1d 00 00       	mov    %eax,0x1ddc
  ABB = BB_create(A,"ABB");
     6eb:	a1 b0 1d 00 00       	mov    0x1db0,%eax
     6f0:	c7 44 24 04 d3 17 00 	movl   $0x17d3,0x4(%esp)
     6f7:	00 
     6f8:	89 04 24             	mov    %eax,(%esp)
     6fb:	e8 e4 0c 00 00       	call   13e4 <BB_create>
     700:	a3 c8 1d 00 00       	mov    %eax,0x1dc8
  DrinkBB = BB_create(A,"DrinkBB");
     705:	a1 b0 1d 00 00       	mov    0x1db0,%eax
     70a:	c7 44 24 04 d7 17 00 	movl   $0x17d7,0x4(%esp)
     711:	00 
     712:	89 04 24             	mov    %eax,(%esp)
     715:	e8 ca 0c 00 00       	call   13e4 <BB_create>
     71a:	a3 d4 1d 00 00       	mov    %eax,0x1dd4
  CBB = BB_create(C,"CBB");
     71f:	a1 cc 1d 00 00       	mov    0x1dcc,%eax
     724:	c7 44 24 04 df 17 00 	movl   $0x17df,0x4(%esp)
     72b:	00 
     72c:	89 04 24             	mov    %eax,(%esp)
     72f:	e8 b0 0c 00 00       	call   13e4 <BB_create>
     734:	a3 e0 1d 00 00       	mov    %eax,0x1de0
  DBB = BB_create(C,"DBB");
     739:	a1 cc 1d 00 00       	mov    0x1dcc,%eax
     73e:	c7 44 24 04 e3 17 00 	movl   $0x17e3,0x4(%esp)
     745:	00 
     746:	89 04 24             	mov    %eax,(%esp)
     749:	e8 96 0c 00 00       	call   13e4 <BB_create>
     74e:	a3 d0 1d 00 00       	mov    %eax,0x1dd0
  struct Cup* cups[C];
     753:	a1 cc 1d 00 00       	mov    0x1dcc,%eax
     758:	8d 50 ff             	lea    -0x1(%eax),%edx
     75b:	89 55 d8             	mov    %edx,-0x28(%ebp)
     75e:	c1 e0 02             	shl    $0x2,%eax
     761:	8d 50 0f             	lea    0xf(%eax),%edx
     764:	b8 10 00 00 00       	mov    $0x10,%eax
     769:	83 e8 01             	sub    $0x1,%eax
     76c:	01 d0                	add    %edx,%eax
     76e:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
     775:	ba 00 00 00 00       	mov    $0x0,%edx
     77a:	f7 75 c4             	divl   -0x3c(%ebp)
     77d:	6b c0 10             	imul   $0x10,%eax,%eax
     780:	29 c4                	sub    %eax,%esp
     782:	8d 44 24 0c          	lea    0xc(%esp),%eax
     786:	83 c0 0f             	add    $0xf,%eax
     789:	c1 e8 04             	shr    $0x4,%eax
     78c:	c1 e0 04             	shl    $0x4,%eax
     78f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  for(;i<C;i++)
     792:	eb 41                	jmp    7d5 <main+0x263>
  {
    cups[i] = malloc(sizeof(struct Cup));
     794:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     79b:	e8 3f 0a 00 00       	call   11df <malloc>
     7a0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     7a3:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     7a6:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    cups[i]->id = i;
     7a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     7ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
     7af:	8b 04 90             	mov    (%eax,%edx,4),%eax
     7b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
     7b5:	89 10                	mov    %edx,(%eax)
    BB_put(CBB,cups[i]);
     7b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     7ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
     7bd:	8b 14 90             	mov    (%eax,%edx,4),%edx
     7c0:	a1 e0 1d 00 00       	mov    0x1de0,%eax
     7c5:	89 54 24 04          	mov    %edx,0x4(%esp)
     7c9:	89 04 24             	mov    %eax,(%esp)
     7cc:	e8 12 0d 00 00       	call   14e3 <BB_put>
  DrinkBB = BB_create(A,"DrinkBB");
  CBB = BB_create(C,"CBB");
  DBB = BB_create(C,"DBB");
  struct Cup* cups[C];
  
  for(;i<C;i++)
     7d1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     7d5:	a1 cc 1d 00 00       	mov    0x1dcc,%eax
     7da:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     7dd:	7c b5                	jl     794 <main+0x222>
    cups[i] = malloc(sizeof(struct Cup));
    cups[i]->id = i;
    BB_put(CBB,cups[i]);
  }
  
  void* cupStack = malloc(sizeof(void*)*1024);
     7df:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     7e6:	e8 f4 09 00 00       	call   11df <malloc>
     7eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  memset(cupStack,0,sizeof(void*)*1024);
     7ee:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     7f5:	00 
     7f6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     7fd:	00 
     7fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
     801:	89 04 24             	mov    %eax,(%esp)
     804:	e8 96 03 00 00       	call   b9f <memset>
  if(thread_create(cupboy_func,cupStack,sizeof(void*)*1024) < 0)
     809:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     810:	00 
     811:	8b 45 d0             	mov    -0x30(%ebp),%eax
     814:	89 44 24 04          	mov    %eax,0x4(%esp)
     818:	c7 04 24 fe 04 00 00 	movl   $0x4fe,(%esp)
     81f:	e8 c0 05 00 00       	call   de4 <thread_create>
     824:	85 c0                	test   %eax,%eax
     826:	79 19                	jns    841 <main+0x2cf>
  {
    printf(2,"Failed to create cupboy thread. Exiting...\n");
     828:	c7 44 24 04 e8 17 00 	movl   $0x17e8,0x4(%esp)
     82f:	00 
     830:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     837:	e8 bf 06 00 00       	call   efb <printf>
    exit();
     83c:	e8 03 05 00 00       	call   d44 <exit>
  }
  
  for(i=0;i<B;i++)
     841:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     848:	e9 82 00 00 00       	jmp    8cf <main+0x35d>
  {
    barStack[i] = malloc(sizeof(void*)*1024);
     84d:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     854:	e8 86 09 00 00       	call   11df <malloc>
     859:	8b 55 ec             	mov    -0x14(%ebp),%edx
     85c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     85f:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    memset(barStack[i],0,sizeof(void*)*1024);
     862:	8b 45 ec             	mov    -0x14(%ebp),%eax
     865:	8b 55 f4             	mov    -0xc(%ebp),%edx
     868:	8b 04 90             	mov    (%eax,%edx,4),%eax
     86b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     872:	00 
     873:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     87a:	00 
     87b:	89 04 24             	mov    %eax,(%esp)
     87e:	e8 1c 03 00 00       	call   b9f <memset>
    if(thread_create(bartender_func,barStack[i],sizeof(void*)*1024) < 0)
     883:	8b 45 ec             	mov    -0x14(%ebp),%eax
     886:	8b 55 f4             	mov    -0xc(%ebp),%edx
     889:	8b 04 90             	mov    (%eax,%edx,4),%eax
     88c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     893:	00 
     894:	89 44 24 04          	mov    %eax,0x4(%esp)
     898:	c7 04 24 e0 03 00 00 	movl   $0x3e0,(%esp)
     89f:	e8 40 05 00 00       	call   de4 <thread_create>
     8a4:	85 c0                	test   %eax,%eax
     8a6:	79 23                	jns    8cb <main+0x359>
    {
      printf(2,"Failed to create bartender thread #%d. Exiting...\n",i+1);
     8a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8ab:	83 c0 01             	add    $0x1,%eax
     8ae:	89 44 24 08          	mov    %eax,0x8(%esp)
     8b2:	c7 44 24 04 14 18 00 	movl   $0x1814,0x4(%esp)
     8b9:	00 
     8ba:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     8c1:	e8 35 06 00 00       	call   efb <printf>
      exit();
     8c6:	e8 79 04 00 00       	call   d44 <exit>
  {
    printf(2,"Failed to create cupboy thread. Exiting...\n");
    exit();
  }
  
  for(i=0;i<B;i++)
     8cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     8cf:	a1 c4 1d 00 00       	mov    0x1dc4,%eax
     8d4:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     8d7:	0f 8c 70 ff ff ff    	jl     84d <main+0x2db>
    {
      printf(2,"Failed to create bartender thread #%d. Exiting...\n",i+1);
      exit();
    } 
  }
  for(i=0;i<S;i++)
     8dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     8e4:	e9 94 00 00 00       	jmp    97d <main+0x40b>
  {
    studStack[i] = malloc(sizeof(void*)*1024);
     8e9:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     8f0:	e8 ea 08 00 00       	call   11df <malloc>
     8f5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     8f8:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     8fb:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    memset(studStack[i],0,sizeof(void*)*1024);
     8fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     901:	8b 55 f4             	mov    -0xc(%ebp),%edx
     904:	8b 04 90             	mov    (%eax,%edx,4),%eax
     907:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     90e:	00 
     90f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     916:	00 
     917:	89 04 24             	mov    %eax,(%esp)
     91a:	e8 80 02 00 00       	call   b9f <memset>
    if((studTid[i] = thread_create(student_func,studStack[i],sizeof(void*)*1024)) < 0)
     91f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     922:	8b 55 f4             	mov    -0xc(%ebp),%edx
     925:	8b 04 90             	mov    (%eax,%edx,4),%eax
     928:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     92f:	00 
     930:	89 44 24 04          	mov    %eax,0x4(%esp)
     934:	c7 04 24 b2 02 00 00 	movl   $0x2b2,(%esp)
     93b:	e8 a4 04 00 00       	call   de4 <thread_create>
     940:	8b 55 dc             	mov    -0x24(%ebp),%edx
     943:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     946:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
     949:	8b 45 dc             	mov    -0x24(%ebp),%eax
     94c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     94f:	8b 04 90             	mov    (%eax,%edx,4),%eax
     952:	85 c0                	test   %eax,%eax
     954:	79 23                	jns    979 <main+0x407>
    {
      printf(2,"Failed to create student thread #%d. Exiting...\n",i+1);
     956:	8b 45 f4             	mov    -0xc(%ebp),%eax
     959:	83 c0 01             	add    $0x1,%eax
     95c:	89 44 24 08          	mov    %eax,0x8(%esp)
     960:	c7 44 24 04 48 18 00 	movl   $0x1848,0x4(%esp)
     967:	00 
     968:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     96f:	e8 87 05 00 00       	call   efb <printf>
      exit();
     974:	e8 cb 03 00 00       	call   d44 <exit>
    {
      printf(2,"Failed to create bartender thread #%d. Exiting...\n",i+1);
      exit();
    } 
  }
  for(i=0;i<S;i++)
     979:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     97d:	a1 c0 1d 00 00       	mov    0x1dc0,%eax
     982:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     985:	0f 8c 5e ff ff ff    	jl     8e9 <main+0x377>
      printf(2,"Failed to create student thread #%d. Exiting...\n",i+1);
      exit();
    } 
  }

  for(i=0;i<S;i++)
     98b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     992:	eb 55                	jmp    9e9 <main+0x477>
  {
    if(thread_join(studTid[i],0) != 0)
     994:	8b 45 dc             	mov    -0x24(%ebp),%eax
     997:	8b 55 f4             	mov    -0xc(%ebp),%edx
     99a:	8b 04 90             	mov    (%eax,%edx,4),%eax
     99d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     9a4:	00 
     9a5:	89 04 24             	mov    %eax,(%esp)
     9a8:	e8 4f 04 00 00       	call   dfc <thread_join>
     9ad:	85 c0                	test   %eax,%eax
     9af:	74 23                	je     9d4 <main+0x462>
    {
      printf(2,"Failed to join on student thread #%d. Exiting...\n",i+1);
     9b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9b4:	83 c0 01             	add    $0x1,%eax
     9b7:	89 44 24 08          	mov    %eax,0x8(%esp)
     9bb:	c7 44 24 04 7c 18 00 	movl   $0x187c,0x4(%esp)
     9c2:	00 
     9c3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     9ca:	e8 2c 05 00 00       	call   efb <printf>
      exit();
     9cf:	e8 70 03 00 00       	call   d44 <exit>
    }
    
    free(studStack[i]);
     9d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     9d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9da:	8b 04 90             	mov    (%eax,%edx,4),%eax
     9dd:	89 04 24             	mov    %eax,(%esp)
     9e0:	e8 cb 06 00 00       	call   10b0 <free>
      printf(2,"Failed to create student thread #%d. Exiting...\n",i+1);
      exit();
    } 
  }

  for(i=0;i<S;i++)
     9e5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     9e9:	a1 c0 1d 00 00       	mov    0x1dc0,%eax
     9ee:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     9f1:	7c a1                	jl     994 <main+0x422>
    }
    
    free(studStack[i]);
  }
  
  for(i=0;i<B;i++)
     9f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     9fa:	eb 15                	jmp    a11 <main+0x49f>
    free(barStack[i]);
     9fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
     9ff:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a02:	8b 04 90             	mov    (%eax,%edx,4),%eax
     a05:	89 04 24             	mov    %eax,(%esp)
     a08:	e8 a3 06 00 00       	call   10b0 <free>
    }
    
    free(studStack[i]);
  }
  
  for(i=0;i<B;i++)
     a0d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a11:	a1 c4 1d 00 00       	mov    0x1dc4,%eax
     a16:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     a19:	7c e1                	jl     9fc <main+0x48a>
    free(barStack[i]);
  free(cupStack);
     a1b:	8b 45 d0             	mov    -0x30(%ebp),%eax
     a1e:	89 04 24             	mov    %eax,(%esp)
     a21:	e8 8a 06 00 00       	call   10b0 <free>
  
  for(i=0;i<C;i++)
     a26:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     a2d:	eb 15                	jmp    a44 <main+0x4d2>
    free(cups[i]);
     a2f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     a32:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a35:	8b 04 90             	mov    (%eax,%edx,4),%eax
     a38:	89 04 24             	mov    %eax,(%esp)
     a3b:	e8 70 06 00 00       	call   10b0 <free>
  
  for(i=0;i<B;i++)
    free(barStack[i]);
  free(cupStack);
  
  for(i=0;i<C;i++)
     a40:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a44:	a1 cc 1d 00 00       	mov    0x1dcc,%eax
     a49:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     a4c:	7c e1                	jl     a2f <main+0x4bd>
    free(cups[i]);
  

  free(CBB->elements);
     a4e:	a1 e0 1d 00 00       	mov    0x1de0,%eax
     a53:	8b 40 1c             	mov    0x1c(%eax),%eax
     a56:	89 04 24             	mov    %eax,(%esp)
     a59:	e8 52 06 00 00       	call   10b0 <free>
  free(DBB->elements);
     a5e:	a1 d0 1d 00 00       	mov    0x1dd0,%eax
     a63:	8b 40 1c             	mov    0x1c(%eax),%eax
     a66:	89 04 24             	mov    %eax,(%esp)
     a69:	e8 42 06 00 00       	call   10b0 <free>
  free(CBB);
     a6e:	a1 e0 1d 00 00       	mov    0x1de0,%eax
     a73:	89 04 24             	mov    %eax,(%esp)
     a76:	e8 35 06 00 00       	call   10b0 <free>
  free(DBB);
     a7b:	a1 d0 1d 00 00       	mov    0x1dd0,%eax
     a80:	89 04 24             	mov    %eax,(%esp)
     a83:	e8 28 06 00 00       	call   10b0 <free>
  
  free(ABB->elements);
     a88:	a1 c8 1d 00 00       	mov    0x1dc8,%eax
     a8d:	8b 40 1c             	mov    0x1c(%eax),%eax
     a90:	89 04 24             	mov    %eax,(%esp)
     a93:	e8 18 06 00 00       	call   10b0 <free>
  free(DrinkBB->elements);
     a98:	a1 d4 1d 00 00       	mov    0x1dd4,%eax
     a9d:	8b 40 1c             	mov    0x1c(%eax),%eax
     aa0:	89 04 24             	mov    %eax,(%esp)
     aa3:	e8 08 06 00 00       	call   10b0 <free>
  free(ABB);
     aa8:	a1 c8 1d 00 00       	mov    0x1dc8,%eax
     aad:	89 04 24             	mov    %eax,(%esp)
     ab0:	e8 fb 05 00 00       	call   10b0 <free>
  free(DrinkBB);
     ab5:	a1 d4 1d 00 00       	mov    0x1dd4,%eax
     aba:	89 04 24             	mov    %eax,(%esp)
     abd:	e8 ee 05 00 00       	call   10b0 <free>
  close(fd);
     ac2:	a1 b8 1d 00 00       	mov    0x1db8,%eax
     ac7:	89 04 24             	mov    %eax,(%esp)
     aca:	e8 9d 02 00 00       	call   d6c <close>
  exit();
     acf:	e8 70 02 00 00       	call   d44 <exit>
     ad4:	89 dc                	mov    %ebx,%esp
  return 0;
}
     ad6:	8d 65 f8             	lea    -0x8(%ebp),%esp
     ad9:	59                   	pop    %ecx
     ada:	5b                   	pop    %ebx
     adb:	5d                   	pop    %ebp
     adc:	8d 61 fc             	lea    -0x4(%ecx),%esp
     adf:	c3                   	ret    

00000ae0 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     ae0:	55                   	push   %ebp
     ae1:	89 e5                	mov    %esp,%ebp
     ae3:	57                   	push   %edi
     ae4:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     ae5:	8b 4d 08             	mov    0x8(%ebp),%ecx
     ae8:	8b 55 10             	mov    0x10(%ebp),%edx
     aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
     aee:	89 cb                	mov    %ecx,%ebx
     af0:	89 df                	mov    %ebx,%edi
     af2:	89 d1                	mov    %edx,%ecx
     af4:	fc                   	cld    
     af5:	f3 aa                	rep stos %al,%es:(%edi)
     af7:	89 ca                	mov    %ecx,%edx
     af9:	89 fb                	mov    %edi,%ebx
     afb:	89 5d 08             	mov    %ebx,0x8(%ebp)
     afe:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     b01:	5b                   	pop    %ebx
     b02:	5f                   	pop    %edi
     b03:	5d                   	pop    %ebp
     b04:	c3                   	ret    

00000b05 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     b05:	55                   	push   %ebp
     b06:	89 e5                	mov    %esp,%ebp
     b08:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     b0b:	8b 45 08             	mov    0x8(%ebp),%eax
     b0e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     b11:	90                   	nop
     b12:	8b 45 0c             	mov    0xc(%ebp),%eax
     b15:	0f b6 10             	movzbl (%eax),%edx
     b18:	8b 45 08             	mov    0x8(%ebp),%eax
     b1b:	88 10                	mov    %dl,(%eax)
     b1d:	8b 45 08             	mov    0x8(%ebp),%eax
     b20:	0f b6 00             	movzbl (%eax),%eax
     b23:	84 c0                	test   %al,%al
     b25:	0f 95 c0             	setne  %al
     b28:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     b2c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     b30:	84 c0                	test   %al,%al
     b32:	75 de                	jne    b12 <strcpy+0xd>
    ;
  return os;
     b34:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     b37:	c9                   	leave  
     b38:	c3                   	ret    

00000b39 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b39:	55                   	push   %ebp
     b3a:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     b3c:	eb 08                	jmp    b46 <strcmp+0xd>
    p++, q++;
     b3e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     b42:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     b46:	8b 45 08             	mov    0x8(%ebp),%eax
     b49:	0f b6 00             	movzbl (%eax),%eax
     b4c:	84 c0                	test   %al,%al
     b4e:	74 10                	je     b60 <strcmp+0x27>
     b50:	8b 45 08             	mov    0x8(%ebp),%eax
     b53:	0f b6 10             	movzbl (%eax),%edx
     b56:	8b 45 0c             	mov    0xc(%ebp),%eax
     b59:	0f b6 00             	movzbl (%eax),%eax
     b5c:	38 c2                	cmp    %al,%dl
     b5e:	74 de                	je     b3e <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     b60:	8b 45 08             	mov    0x8(%ebp),%eax
     b63:	0f b6 00             	movzbl (%eax),%eax
     b66:	0f b6 d0             	movzbl %al,%edx
     b69:	8b 45 0c             	mov    0xc(%ebp),%eax
     b6c:	0f b6 00             	movzbl (%eax),%eax
     b6f:	0f b6 c0             	movzbl %al,%eax
     b72:	89 d1                	mov    %edx,%ecx
     b74:	29 c1                	sub    %eax,%ecx
     b76:	89 c8                	mov    %ecx,%eax
}
     b78:	5d                   	pop    %ebp
     b79:	c3                   	ret    

00000b7a <strlen>:

uint
strlen(char *s)
{
     b7a:	55                   	push   %ebp
     b7b:	89 e5                	mov    %esp,%ebp
     b7d:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     b80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     b87:	eb 04                	jmp    b8d <strlen+0x13>
     b89:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     b8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
     b90:	03 45 08             	add    0x8(%ebp),%eax
     b93:	0f b6 00             	movzbl (%eax),%eax
     b96:	84 c0                	test   %al,%al
     b98:	75 ef                	jne    b89 <strlen+0xf>
    ;
  return n;
     b9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     b9d:	c9                   	leave  
     b9e:	c3                   	ret    

00000b9f <memset>:

void*
memset(void *dst, int c, uint n)
{
     b9f:	55                   	push   %ebp
     ba0:	89 e5                	mov    %esp,%ebp
     ba2:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     ba5:	8b 45 10             	mov    0x10(%ebp),%eax
     ba8:	89 44 24 08          	mov    %eax,0x8(%esp)
     bac:	8b 45 0c             	mov    0xc(%ebp),%eax
     baf:	89 44 24 04          	mov    %eax,0x4(%esp)
     bb3:	8b 45 08             	mov    0x8(%ebp),%eax
     bb6:	89 04 24             	mov    %eax,(%esp)
     bb9:	e8 22 ff ff ff       	call   ae0 <stosb>
  return dst;
     bbe:	8b 45 08             	mov    0x8(%ebp),%eax
}
     bc1:	c9                   	leave  
     bc2:	c3                   	ret    

00000bc3 <strchr>:

char*
strchr(const char *s, char c)
{
     bc3:	55                   	push   %ebp
     bc4:	89 e5                	mov    %esp,%ebp
     bc6:	83 ec 04             	sub    $0x4,%esp
     bc9:	8b 45 0c             	mov    0xc(%ebp),%eax
     bcc:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     bcf:	eb 14                	jmp    be5 <strchr+0x22>
    if(*s == c)
     bd1:	8b 45 08             	mov    0x8(%ebp),%eax
     bd4:	0f b6 00             	movzbl (%eax),%eax
     bd7:	3a 45 fc             	cmp    -0x4(%ebp),%al
     bda:	75 05                	jne    be1 <strchr+0x1e>
      return (char*)s;
     bdc:	8b 45 08             	mov    0x8(%ebp),%eax
     bdf:	eb 13                	jmp    bf4 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     be1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     be5:	8b 45 08             	mov    0x8(%ebp),%eax
     be8:	0f b6 00             	movzbl (%eax),%eax
     beb:	84 c0                	test   %al,%al
     bed:	75 e2                	jne    bd1 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     bef:	b8 00 00 00 00       	mov    $0x0,%eax
}
     bf4:	c9                   	leave  
     bf5:	c3                   	ret    

00000bf6 <gets>:

char*
gets(char *buf, int max)
{
     bf6:	55                   	push   %ebp
     bf7:	89 e5                	mov    %esp,%ebp
     bf9:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     bfc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c03:	eb 44                	jmp    c49 <gets+0x53>
    cc = read(0, &c, 1);
     c05:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     c0c:	00 
     c0d:	8d 45 ef             	lea    -0x11(%ebp),%eax
     c10:	89 44 24 04          	mov    %eax,0x4(%esp)
     c14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c1b:	e8 3c 01 00 00       	call   d5c <read>
     c20:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     c23:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c27:	7e 2d                	jle    c56 <gets+0x60>
      break;
    buf[i++] = c;
     c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c2c:	03 45 08             	add    0x8(%ebp),%eax
     c2f:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
     c33:	88 10                	mov    %dl,(%eax)
     c35:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
     c39:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     c3d:	3c 0a                	cmp    $0xa,%al
     c3f:	74 16                	je     c57 <gets+0x61>
     c41:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     c45:	3c 0d                	cmp    $0xd,%al
     c47:	74 0e                	je     c57 <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c49:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c4c:	83 c0 01             	add    $0x1,%eax
     c4f:	3b 45 0c             	cmp    0xc(%ebp),%eax
     c52:	7c b1                	jl     c05 <gets+0xf>
     c54:	eb 01                	jmp    c57 <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     c56:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c5a:	03 45 08             	add    0x8(%ebp),%eax
     c5d:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     c60:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c63:	c9                   	leave  
     c64:	c3                   	ret    

00000c65 <stat>:

int
stat(char *n, struct stat *st)
{
     c65:	55                   	push   %ebp
     c66:	89 e5                	mov    %esp,%ebp
     c68:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     c6b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     c72:	00 
     c73:	8b 45 08             	mov    0x8(%ebp),%eax
     c76:	89 04 24             	mov    %eax,(%esp)
     c79:	e8 06 01 00 00       	call   d84 <open>
     c7e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     c81:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     c85:	79 07                	jns    c8e <stat+0x29>
    return -1;
     c87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c8c:	eb 23                	jmp    cb1 <stat+0x4c>
  r = fstat(fd, st);
     c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
     c91:	89 44 24 04          	mov    %eax,0x4(%esp)
     c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c98:	89 04 24             	mov    %eax,(%esp)
     c9b:	e8 fc 00 00 00       	call   d9c <fstat>
     ca0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ca6:	89 04 24             	mov    %eax,(%esp)
     ca9:	e8 be 00 00 00       	call   d6c <close>
  return r;
     cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     cb1:	c9                   	leave  
     cb2:	c3                   	ret    

00000cb3 <atoi>:

int
atoi(const char *s)
{
     cb3:	55                   	push   %ebp
     cb4:	89 e5                	mov    %esp,%ebp
     cb6:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     cb9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     cc0:	eb 23                	jmp    ce5 <atoi+0x32>
    n = n*10 + *s++ - '0';
     cc2:	8b 55 fc             	mov    -0x4(%ebp),%edx
     cc5:	89 d0                	mov    %edx,%eax
     cc7:	c1 e0 02             	shl    $0x2,%eax
     cca:	01 d0                	add    %edx,%eax
     ccc:	01 c0                	add    %eax,%eax
     cce:	89 c2                	mov    %eax,%edx
     cd0:	8b 45 08             	mov    0x8(%ebp),%eax
     cd3:	0f b6 00             	movzbl (%eax),%eax
     cd6:	0f be c0             	movsbl %al,%eax
     cd9:	01 d0                	add    %edx,%eax
     cdb:	83 e8 30             	sub    $0x30,%eax
     cde:	89 45 fc             	mov    %eax,-0x4(%ebp)
     ce1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     ce5:	8b 45 08             	mov    0x8(%ebp),%eax
     ce8:	0f b6 00             	movzbl (%eax),%eax
     ceb:	3c 2f                	cmp    $0x2f,%al
     ced:	7e 0a                	jle    cf9 <atoi+0x46>
     cef:	8b 45 08             	mov    0x8(%ebp),%eax
     cf2:	0f b6 00             	movzbl (%eax),%eax
     cf5:	3c 39                	cmp    $0x39,%al
     cf7:	7e c9                	jle    cc2 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     cf9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     cfc:	c9                   	leave  
     cfd:	c3                   	ret    

00000cfe <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     cfe:	55                   	push   %ebp
     cff:	89 e5                	mov    %esp,%ebp
     d01:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     d04:	8b 45 08             	mov    0x8(%ebp),%eax
     d07:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     d0a:	8b 45 0c             	mov    0xc(%ebp),%eax
     d0d:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     d10:	eb 13                	jmp    d25 <memmove+0x27>
    *dst++ = *src++;
     d12:	8b 45 f8             	mov    -0x8(%ebp),%eax
     d15:	0f b6 10             	movzbl (%eax),%edx
     d18:	8b 45 fc             	mov    -0x4(%ebp),%eax
     d1b:	88 10                	mov    %dl,(%eax)
     d1d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     d21:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     d29:	0f 9f c0             	setg   %al
     d2c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     d30:	84 c0                	test   %al,%al
     d32:	75 de                	jne    d12 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     d34:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d37:	c9                   	leave  
     d38:	c3                   	ret    
     d39:	90                   	nop
     d3a:	90                   	nop
     d3b:	90                   	nop

00000d3c <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     d3c:	b8 01 00 00 00       	mov    $0x1,%eax
     d41:	cd 40                	int    $0x40
     d43:	c3                   	ret    

00000d44 <exit>:
SYSCALL(exit)
     d44:	b8 02 00 00 00       	mov    $0x2,%eax
     d49:	cd 40                	int    $0x40
     d4b:	c3                   	ret    

00000d4c <wait>:
SYSCALL(wait)
     d4c:	b8 03 00 00 00       	mov    $0x3,%eax
     d51:	cd 40                	int    $0x40
     d53:	c3                   	ret    

00000d54 <pipe>:
SYSCALL(pipe)
     d54:	b8 04 00 00 00       	mov    $0x4,%eax
     d59:	cd 40                	int    $0x40
     d5b:	c3                   	ret    

00000d5c <read>:
SYSCALL(read)
     d5c:	b8 05 00 00 00       	mov    $0x5,%eax
     d61:	cd 40                	int    $0x40
     d63:	c3                   	ret    

00000d64 <write>:
SYSCALL(write)
     d64:	b8 10 00 00 00       	mov    $0x10,%eax
     d69:	cd 40                	int    $0x40
     d6b:	c3                   	ret    

00000d6c <close>:
SYSCALL(close)
     d6c:	b8 15 00 00 00       	mov    $0x15,%eax
     d71:	cd 40                	int    $0x40
     d73:	c3                   	ret    

00000d74 <kill>:
SYSCALL(kill)
     d74:	b8 06 00 00 00       	mov    $0x6,%eax
     d79:	cd 40                	int    $0x40
     d7b:	c3                   	ret    

00000d7c <exec>:
SYSCALL(exec)
     d7c:	b8 07 00 00 00       	mov    $0x7,%eax
     d81:	cd 40                	int    $0x40
     d83:	c3                   	ret    

00000d84 <open>:
SYSCALL(open)
     d84:	b8 0f 00 00 00       	mov    $0xf,%eax
     d89:	cd 40                	int    $0x40
     d8b:	c3                   	ret    

00000d8c <mknod>:
SYSCALL(mknod)
     d8c:	b8 11 00 00 00       	mov    $0x11,%eax
     d91:	cd 40                	int    $0x40
     d93:	c3                   	ret    

00000d94 <unlink>:
SYSCALL(unlink)
     d94:	b8 12 00 00 00       	mov    $0x12,%eax
     d99:	cd 40                	int    $0x40
     d9b:	c3                   	ret    

00000d9c <fstat>:
SYSCALL(fstat)
     d9c:	b8 08 00 00 00       	mov    $0x8,%eax
     da1:	cd 40                	int    $0x40
     da3:	c3                   	ret    

00000da4 <link>:
SYSCALL(link)
     da4:	b8 13 00 00 00       	mov    $0x13,%eax
     da9:	cd 40                	int    $0x40
     dab:	c3                   	ret    

00000dac <mkdir>:
SYSCALL(mkdir)
     dac:	b8 14 00 00 00       	mov    $0x14,%eax
     db1:	cd 40                	int    $0x40
     db3:	c3                   	ret    

00000db4 <chdir>:
SYSCALL(chdir)
     db4:	b8 09 00 00 00       	mov    $0x9,%eax
     db9:	cd 40                	int    $0x40
     dbb:	c3                   	ret    

00000dbc <dup>:
SYSCALL(dup)
     dbc:	b8 0a 00 00 00       	mov    $0xa,%eax
     dc1:	cd 40                	int    $0x40
     dc3:	c3                   	ret    

00000dc4 <getpid>:
SYSCALL(getpid)
     dc4:	b8 0b 00 00 00       	mov    $0xb,%eax
     dc9:	cd 40                	int    $0x40
     dcb:	c3                   	ret    

00000dcc <sbrk>:
SYSCALL(sbrk)
     dcc:	b8 0c 00 00 00       	mov    $0xc,%eax
     dd1:	cd 40                	int    $0x40
     dd3:	c3                   	ret    

00000dd4 <sleep>:
SYSCALL(sleep)
     dd4:	b8 0d 00 00 00       	mov    $0xd,%eax
     dd9:	cd 40                	int    $0x40
     ddb:	c3                   	ret    

00000ddc <uptime>:
SYSCALL(uptime)
     ddc:	b8 0e 00 00 00       	mov    $0xe,%eax
     de1:	cd 40                	int    $0x40
     de3:	c3                   	ret    

00000de4 <thread_create>:
SYSCALL(thread_create)
     de4:	b8 16 00 00 00       	mov    $0x16,%eax
     de9:	cd 40                	int    $0x40
     deb:	c3                   	ret    

00000dec <thread_getId>:
SYSCALL(thread_getId)
     dec:	b8 17 00 00 00       	mov    $0x17,%eax
     df1:	cd 40                	int    $0x40
     df3:	c3                   	ret    

00000df4 <thread_getProcId>:
SYSCALL(thread_getProcId)
     df4:	b8 18 00 00 00       	mov    $0x18,%eax
     df9:	cd 40                	int    $0x40
     dfb:	c3                   	ret    

00000dfc <thread_join>:
SYSCALL(thread_join)
     dfc:	b8 19 00 00 00       	mov    $0x19,%eax
     e01:	cd 40                	int    $0x40
     e03:	c3                   	ret    

00000e04 <thread_exit>:
SYSCALL(thread_exit)
     e04:	b8 1a 00 00 00       	mov    $0x1a,%eax
     e09:	cd 40                	int    $0x40
     e0b:	c3                   	ret    

00000e0c <binary_semaphore_create>:
SYSCALL(binary_semaphore_create)
     e0c:	b8 1b 00 00 00       	mov    $0x1b,%eax
     e11:	cd 40                	int    $0x40
     e13:	c3                   	ret    

00000e14 <binary_semaphore_down>:
SYSCALL(binary_semaphore_down)
     e14:	b8 1c 00 00 00       	mov    $0x1c,%eax
     e19:	cd 40                	int    $0x40
     e1b:	c3                   	ret    

00000e1c <binary_semaphore_up>:
SYSCALL(binary_semaphore_up)
     e1c:	b8 1d 00 00 00       	mov    $0x1d,%eax
     e21:	cd 40                	int    $0x40
     e23:	c3                   	ret    

00000e24 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     e24:	55                   	push   %ebp
     e25:	89 e5                	mov    %esp,%ebp
     e27:	83 ec 28             	sub    $0x28,%esp
     e2a:	8b 45 0c             	mov    0xc(%ebp),%eax
     e2d:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     e30:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e37:	00 
     e38:	8d 45 f4             	lea    -0xc(%ebp),%eax
     e3b:	89 44 24 04          	mov    %eax,0x4(%esp)
     e3f:	8b 45 08             	mov    0x8(%ebp),%eax
     e42:	89 04 24             	mov    %eax,(%esp)
     e45:	e8 1a ff ff ff       	call   d64 <write>
}
     e4a:	c9                   	leave  
     e4b:	c3                   	ret    

00000e4c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e4c:	55                   	push   %ebp
     e4d:	89 e5                	mov    %esp,%ebp
     e4f:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     e52:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     e59:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     e5d:	74 17                	je     e76 <printint+0x2a>
     e5f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     e63:	79 11                	jns    e76 <printint+0x2a>
    neg = 1;
     e65:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     e6c:	8b 45 0c             	mov    0xc(%ebp),%eax
     e6f:	f7 d8                	neg    %eax
     e71:	89 45 ec             	mov    %eax,-0x14(%ebp)
     e74:	eb 06                	jmp    e7c <printint+0x30>
  } else {
    x = xx;
     e76:	8b 45 0c             	mov    0xc(%ebp),%eax
     e79:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     e7c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     e83:	8b 4d 10             	mov    0x10(%ebp),%ecx
     e86:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e89:	ba 00 00 00 00       	mov    $0x0,%edx
     e8e:	f7 f1                	div    %ecx
     e90:	89 d0                	mov    %edx,%eax
     e92:	0f b6 90 90 1d 00 00 	movzbl 0x1d90(%eax),%edx
     e99:	8d 45 dc             	lea    -0x24(%ebp),%eax
     e9c:	03 45 f4             	add    -0xc(%ebp),%eax
     e9f:	88 10                	mov    %dl,(%eax)
     ea1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
     ea5:	8b 55 10             	mov    0x10(%ebp),%edx
     ea8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     eab:	8b 45 ec             	mov    -0x14(%ebp),%eax
     eae:	ba 00 00 00 00       	mov    $0x0,%edx
     eb3:	f7 75 d4             	divl   -0x2c(%ebp)
     eb6:	89 45 ec             	mov    %eax,-0x14(%ebp)
     eb9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     ebd:	75 c4                	jne    e83 <printint+0x37>
  if(neg)
     ebf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     ec3:	74 2a                	je     eef <printint+0xa3>
    buf[i++] = '-';
     ec5:	8d 45 dc             	lea    -0x24(%ebp),%eax
     ec8:	03 45 f4             	add    -0xc(%ebp),%eax
     ecb:	c6 00 2d             	movb   $0x2d,(%eax)
     ece:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
     ed2:	eb 1b                	jmp    eef <printint+0xa3>
    putc(fd, buf[i]);
     ed4:	8d 45 dc             	lea    -0x24(%ebp),%eax
     ed7:	03 45 f4             	add    -0xc(%ebp),%eax
     eda:	0f b6 00             	movzbl (%eax),%eax
     edd:	0f be c0             	movsbl %al,%eax
     ee0:	89 44 24 04          	mov    %eax,0x4(%esp)
     ee4:	8b 45 08             	mov    0x8(%ebp),%eax
     ee7:	89 04 24             	mov    %eax,(%esp)
     eea:	e8 35 ff ff ff       	call   e24 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     eef:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     ef3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ef7:	79 db                	jns    ed4 <printint+0x88>
    putc(fd, buf[i]);
}
     ef9:	c9                   	leave  
     efa:	c3                   	ret    

00000efb <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     efb:	55                   	push   %ebp
     efc:	89 e5                	mov    %esp,%ebp
     efe:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     f01:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     f08:	8d 45 0c             	lea    0xc(%ebp),%eax
     f0b:	83 c0 04             	add    $0x4,%eax
     f0e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     f11:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     f18:	e9 7d 01 00 00       	jmp    109a <printf+0x19f>
    c = fmt[i] & 0xff;
     f1d:	8b 55 0c             	mov    0xc(%ebp),%edx
     f20:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f23:	01 d0                	add    %edx,%eax
     f25:	0f b6 00             	movzbl (%eax),%eax
     f28:	0f be c0             	movsbl %al,%eax
     f2b:	25 ff 00 00 00       	and    $0xff,%eax
     f30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     f33:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f37:	75 2c                	jne    f65 <printf+0x6a>
      if(c == '%'){
     f39:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     f3d:	75 0c                	jne    f4b <printf+0x50>
        state = '%';
     f3f:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     f46:	e9 4b 01 00 00       	jmp    1096 <printf+0x19b>
      } else {
        putc(fd, c);
     f4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     f4e:	0f be c0             	movsbl %al,%eax
     f51:	89 44 24 04          	mov    %eax,0x4(%esp)
     f55:	8b 45 08             	mov    0x8(%ebp),%eax
     f58:	89 04 24             	mov    %eax,(%esp)
     f5b:	e8 c4 fe ff ff       	call   e24 <putc>
     f60:	e9 31 01 00 00       	jmp    1096 <printf+0x19b>
      }
    } else if(state == '%'){
     f65:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     f69:	0f 85 27 01 00 00    	jne    1096 <printf+0x19b>
      if(c == 'd'){
     f6f:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     f73:	75 2d                	jne    fa2 <printf+0xa7>
        printint(fd, *ap, 10, 1);
     f75:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f78:	8b 00                	mov    (%eax),%eax
     f7a:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     f81:	00 
     f82:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     f89:	00 
     f8a:	89 44 24 04          	mov    %eax,0x4(%esp)
     f8e:	8b 45 08             	mov    0x8(%ebp),%eax
     f91:	89 04 24             	mov    %eax,(%esp)
     f94:	e8 b3 fe ff ff       	call   e4c <printint>
        ap++;
     f99:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     f9d:	e9 ed 00 00 00       	jmp    108f <printf+0x194>
      } else if(c == 'x' || c == 'p'){
     fa2:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     fa6:	74 06                	je     fae <printf+0xb3>
     fa8:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     fac:	75 2d                	jne    fdb <printf+0xe0>
        printint(fd, *ap, 16, 0);
     fae:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fb1:	8b 00                	mov    (%eax),%eax
     fb3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     fba:	00 
     fbb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     fc2:	00 
     fc3:	89 44 24 04          	mov    %eax,0x4(%esp)
     fc7:	8b 45 08             	mov    0x8(%ebp),%eax
     fca:	89 04 24             	mov    %eax,(%esp)
     fcd:	e8 7a fe ff ff       	call   e4c <printint>
        ap++;
     fd2:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     fd6:	e9 b4 00 00 00       	jmp    108f <printf+0x194>
      } else if(c == 's'){
     fdb:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     fdf:	75 46                	jne    1027 <printf+0x12c>
        s = (char*)*ap;
     fe1:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fe4:	8b 00                	mov    (%eax),%eax
     fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     fe9:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     fed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     ff1:	75 27                	jne    101a <printf+0x11f>
          s = "(null)";
     ff3:	c7 45 f4 b8 18 00 00 	movl   $0x18b8,-0xc(%ebp)
        while(*s != 0){
     ffa:	eb 1e                	jmp    101a <printf+0x11f>
          putc(fd, *s);
     ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
     fff:	0f b6 00             	movzbl (%eax),%eax
    1002:	0f be c0             	movsbl %al,%eax
    1005:	89 44 24 04          	mov    %eax,0x4(%esp)
    1009:	8b 45 08             	mov    0x8(%ebp),%eax
    100c:	89 04 24             	mov    %eax,(%esp)
    100f:	e8 10 fe ff ff       	call   e24 <putc>
          s++;
    1014:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1018:	eb 01                	jmp    101b <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    101a:	90                   	nop
    101b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    101e:	0f b6 00             	movzbl (%eax),%eax
    1021:	84 c0                	test   %al,%al
    1023:	75 d7                	jne    ffc <printf+0x101>
    1025:	eb 68                	jmp    108f <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    1027:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    102b:	75 1d                	jne    104a <printf+0x14f>
        putc(fd, *ap);
    102d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1030:	8b 00                	mov    (%eax),%eax
    1032:	0f be c0             	movsbl %al,%eax
    1035:	89 44 24 04          	mov    %eax,0x4(%esp)
    1039:	8b 45 08             	mov    0x8(%ebp),%eax
    103c:	89 04 24             	mov    %eax,(%esp)
    103f:	e8 e0 fd ff ff       	call   e24 <putc>
        ap++;
    1044:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1048:	eb 45                	jmp    108f <printf+0x194>
      } else if(c == '%'){
    104a:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    104e:	75 17                	jne    1067 <printf+0x16c>
        putc(fd, c);
    1050:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1053:	0f be c0             	movsbl %al,%eax
    1056:	89 44 24 04          	mov    %eax,0x4(%esp)
    105a:	8b 45 08             	mov    0x8(%ebp),%eax
    105d:	89 04 24             	mov    %eax,(%esp)
    1060:	e8 bf fd ff ff       	call   e24 <putc>
    1065:	eb 28                	jmp    108f <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    1067:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    106e:	00 
    106f:	8b 45 08             	mov    0x8(%ebp),%eax
    1072:	89 04 24             	mov    %eax,(%esp)
    1075:	e8 aa fd ff ff       	call   e24 <putc>
        putc(fd, c);
    107a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    107d:	0f be c0             	movsbl %al,%eax
    1080:	89 44 24 04          	mov    %eax,0x4(%esp)
    1084:	8b 45 08             	mov    0x8(%ebp),%eax
    1087:	89 04 24             	mov    %eax,(%esp)
    108a:	e8 95 fd ff ff       	call   e24 <putc>
      }
      state = 0;
    108f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1096:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    109a:	8b 55 0c             	mov    0xc(%ebp),%edx
    109d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10a0:	01 d0                	add    %edx,%eax
    10a2:	0f b6 00             	movzbl (%eax),%eax
    10a5:	84 c0                	test   %al,%al
    10a7:	0f 85 70 fe ff ff    	jne    f1d <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    10ad:	c9                   	leave  
    10ae:	c3                   	ret    
    10af:	90                   	nop

000010b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10b0:	55                   	push   %ebp
    10b1:	89 e5                	mov    %esp,%ebp
    10b3:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10b6:	8b 45 08             	mov    0x8(%ebp),%eax
    10b9:	83 e8 08             	sub    $0x8,%eax
    10bc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10bf:	a1 ac 1d 00 00       	mov    0x1dac,%eax
    10c4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    10c7:	eb 24                	jmp    10ed <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10cc:	8b 00                	mov    (%eax),%eax
    10ce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    10d1:	77 12                	ja     10e5 <free+0x35>
    10d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    10d9:	77 24                	ja     10ff <free+0x4f>
    10db:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10de:	8b 00                	mov    (%eax),%eax
    10e0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    10e3:	77 1a                	ja     10ff <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10e8:	8b 00                	mov    (%eax),%eax
    10ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
    10ed:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10f0:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    10f3:	76 d4                	jbe    10c9 <free+0x19>
    10f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10f8:	8b 00                	mov    (%eax),%eax
    10fa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    10fd:	76 ca                	jbe    10c9 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    10ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1102:	8b 40 04             	mov    0x4(%eax),%eax
    1105:	c1 e0 03             	shl    $0x3,%eax
    1108:	89 c2                	mov    %eax,%edx
    110a:	03 55 f8             	add    -0x8(%ebp),%edx
    110d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1110:	8b 00                	mov    (%eax),%eax
    1112:	39 c2                	cmp    %eax,%edx
    1114:	75 24                	jne    113a <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
    1116:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1119:	8b 50 04             	mov    0x4(%eax),%edx
    111c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    111f:	8b 00                	mov    (%eax),%eax
    1121:	8b 40 04             	mov    0x4(%eax),%eax
    1124:	01 c2                	add    %eax,%edx
    1126:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1129:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    112c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    112f:	8b 00                	mov    (%eax),%eax
    1131:	8b 10                	mov    (%eax),%edx
    1133:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1136:	89 10                	mov    %edx,(%eax)
    1138:	eb 0a                	jmp    1144 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
    113a:	8b 45 fc             	mov    -0x4(%ebp),%eax
    113d:	8b 10                	mov    (%eax),%edx
    113f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1142:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1144:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1147:	8b 40 04             	mov    0x4(%eax),%eax
    114a:	c1 e0 03             	shl    $0x3,%eax
    114d:	03 45 fc             	add    -0x4(%ebp),%eax
    1150:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1153:	75 20                	jne    1175 <free+0xc5>
    p->s.size += bp->s.size;
    1155:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1158:	8b 50 04             	mov    0x4(%eax),%edx
    115b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    115e:	8b 40 04             	mov    0x4(%eax),%eax
    1161:	01 c2                	add    %eax,%edx
    1163:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1166:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1169:	8b 45 f8             	mov    -0x8(%ebp),%eax
    116c:	8b 10                	mov    (%eax),%edx
    116e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1171:	89 10                	mov    %edx,(%eax)
    1173:	eb 08                	jmp    117d <free+0xcd>
  } else
    p->s.ptr = bp;
    1175:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1178:	8b 55 f8             	mov    -0x8(%ebp),%edx
    117b:	89 10                	mov    %edx,(%eax)
  freep = p;
    117d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1180:	a3 ac 1d 00 00       	mov    %eax,0x1dac
}
    1185:	c9                   	leave  
    1186:	c3                   	ret    

00001187 <morecore>:

static Header*
morecore(uint nu)
{
    1187:	55                   	push   %ebp
    1188:	89 e5                	mov    %esp,%ebp
    118a:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    118d:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    1194:	77 07                	ja     119d <morecore+0x16>
    nu = 4096;
    1196:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    119d:	8b 45 08             	mov    0x8(%ebp),%eax
    11a0:	c1 e0 03             	shl    $0x3,%eax
    11a3:	89 04 24             	mov    %eax,(%esp)
    11a6:	e8 21 fc ff ff       	call   dcc <sbrk>
    11ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    11ae:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    11b2:	75 07                	jne    11bb <morecore+0x34>
    return 0;
    11b4:	b8 00 00 00 00       	mov    $0x0,%eax
    11b9:	eb 22                	jmp    11dd <morecore+0x56>
  hp = (Header*)p;
    11bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    11c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11c4:	8b 55 08             	mov    0x8(%ebp),%edx
    11c7:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    11ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11cd:	83 c0 08             	add    $0x8,%eax
    11d0:	89 04 24             	mov    %eax,(%esp)
    11d3:	e8 d8 fe ff ff       	call   10b0 <free>
  return freep;
    11d8:	a1 ac 1d 00 00       	mov    0x1dac,%eax
}
    11dd:	c9                   	leave  
    11de:	c3                   	ret    

000011df <malloc>:

void*
malloc(uint nbytes)
{
    11df:	55                   	push   %ebp
    11e0:	89 e5                	mov    %esp,%ebp
    11e2:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11e5:	8b 45 08             	mov    0x8(%ebp),%eax
    11e8:	83 c0 07             	add    $0x7,%eax
    11eb:	c1 e8 03             	shr    $0x3,%eax
    11ee:	83 c0 01             	add    $0x1,%eax
    11f1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    11f4:	a1 ac 1d 00 00       	mov    0x1dac,%eax
    11f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    11fc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1200:	75 23                	jne    1225 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1202:	c7 45 f0 a4 1d 00 00 	movl   $0x1da4,-0x10(%ebp)
    1209:	8b 45 f0             	mov    -0x10(%ebp),%eax
    120c:	a3 ac 1d 00 00       	mov    %eax,0x1dac
    1211:	a1 ac 1d 00 00       	mov    0x1dac,%eax
    1216:	a3 a4 1d 00 00       	mov    %eax,0x1da4
    base.s.size = 0;
    121b:	c7 05 a8 1d 00 00 00 	movl   $0x0,0x1da8
    1222:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1225:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1228:	8b 00                	mov    (%eax),%eax
    122a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    122d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1230:	8b 40 04             	mov    0x4(%eax),%eax
    1233:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1236:	72 4d                	jb     1285 <malloc+0xa6>
      if(p->s.size == nunits)
    1238:	8b 45 f4             	mov    -0xc(%ebp),%eax
    123b:	8b 40 04             	mov    0x4(%eax),%eax
    123e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1241:	75 0c                	jne    124f <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1243:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1246:	8b 10                	mov    (%eax),%edx
    1248:	8b 45 f0             	mov    -0x10(%ebp),%eax
    124b:	89 10                	mov    %edx,(%eax)
    124d:	eb 26                	jmp    1275 <malloc+0x96>
      else {
        p->s.size -= nunits;
    124f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1252:	8b 40 04             	mov    0x4(%eax),%eax
    1255:	89 c2                	mov    %eax,%edx
    1257:	2b 55 ec             	sub    -0x14(%ebp),%edx
    125a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    125d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1260:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1263:	8b 40 04             	mov    0x4(%eax),%eax
    1266:	c1 e0 03             	shl    $0x3,%eax
    1269:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    126c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    126f:	8b 55 ec             	mov    -0x14(%ebp),%edx
    1272:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    1275:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1278:	a3 ac 1d 00 00       	mov    %eax,0x1dac
      return (void*)(p + 1);
    127d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1280:	83 c0 08             	add    $0x8,%eax
    1283:	eb 38                	jmp    12bd <malloc+0xde>
    }
    if(p == freep)
    1285:	a1 ac 1d 00 00       	mov    0x1dac,%eax
    128a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    128d:	75 1b                	jne    12aa <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    128f:	8b 45 ec             	mov    -0x14(%ebp),%eax
    1292:	89 04 24             	mov    %eax,(%esp)
    1295:	e8 ed fe ff ff       	call   1187 <morecore>
    129a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    129d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12a1:	75 07                	jne    12aa <malloc+0xcb>
        return 0;
    12a3:	b8 00 00 00 00       	mov    $0x0,%eax
    12a8:	eb 13                	jmp    12bd <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
    12b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12b3:	8b 00                	mov    (%eax),%eax
    12b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    12b8:	e9 70 ff ff ff       	jmp    122d <malloc+0x4e>
}
    12bd:	c9                   	leave  
    12be:	c3                   	ret    
    12bf:	90                   	nop

000012c0 <semaphore_create>:
#include "semaphore.h"

struct semaphore* 
semaphore_create(int initial_semaphore_value, char* name)
{
    12c0:	55                   	push   %ebp
    12c1:	89 e5                	mov    %esp,%ebp
    12c3:	83 ec 28             	sub    $0x28,%esp
  int min = 1;
    12c6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  struct semaphore* s = malloc(sizeof(struct semaphore));
    12cd:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
    12d4:	e8 06 ff ff ff       	call   11df <malloc>
    12d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((s->s1 = binary_semaphore_create(1)) != -1)
    12dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12e3:	e8 24 fb ff ff       	call   e0c <binary_semaphore_create>
    12e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
    12eb:	89 42 04             	mov    %eax,0x4(%edx)
    12ee:	83 f8 ff             	cmp    $0xffffffff,%eax
    12f1:	74 38                	je     132b <semaphore_create+0x6b>
  {
    if(initial_semaphore_value < 1)
    12f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    12f7:	7f 06                	jg     12ff <semaphore_create+0x3f>
      min = initial_semaphore_value;
    12f9:	8b 45 08             	mov    0x8(%ebp),%eax
    12fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if((s->s2 = binary_semaphore_create(min)) != -1)
    12ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1302:	89 04 24             	mov    %eax,(%esp)
    1305:	e8 02 fb ff ff       	call   e0c <binary_semaphore_create>
    130a:	8b 55 f0             	mov    -0x10(%ebp),%edx
    130d:	89 42 08             	mov    %eax,0x8(%edx)
    1310:	83 f8 ff             	cmp    $0xffffffff,%eax
    1313:	74 16                	je     132b <semaphore_create+0x6b>
    {
      s->value = initial_semaphore_value;
    1315:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1318:	8b 55 08             	mov    0x8(%ebp),%edx
    131b:	89 10                	mov    %edx,(%eax)
      s->name = name;
    131d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1320:	8b 55 0c             	mov    0xc(%ebp),%edx
    1323:	89 50 0c             	mov    %edx,0xc(%eax)
      return s;
    1326:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1329:	eb 15                	jmp    1340 <semaphore_create+0x80>
    }
  }
  free(s);
    132b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    132e:	89 04 24             	mov    %eax,(%esp)
    1331:	e8 7a fd ff ff       	call   10b0 <free>
  s = 0;
    1336:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  return s;
    133d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1340:	c9                   	leave  
    1341:	c3                   	ret    

00001342 <semaphore_down>:

void 
semaphore_down(struct semaphore* sem )
{
    1342:	55                   	push   %ebp
    1343:	89 e5                	mov    %esp,%ebp
    1345:	83 ec 18             	sub    $0x18,%esp
 binary_semaphore_down(sem->s2);
    1348:	8b 45 08             	mov    0x8(%ebp),%eax
    134b:	8b 40 08             	mov    0x8(%eax),%eax
    134e:	89 04 24             	mov    %eax,(%esp)
    1351:	e8 be fa ff ff       	call   e14 <binary_semaphore_down>
 binary_semaphore_down(sem->s1);
    1356:	8b 45 08             	mov    0x8(%ebp),%eax
    1359:	8b 40 04             	mov    0x4(%eax),%eax
    135c:	89 04 24             	mov    %eax,(%esp)
    135f:	e8 b0 fa ff ff       	call   e14 <binary_semaphore_down>
 sem->value--;
    1364:	8b 45 08             	mov    0x8(%ebp),%eax
    1367:	8b 00                	mov    (%eax),%eax
    1369:	8d 50 ff             	lea    -0x1(%eax),%edx
    136c:	8b 45 08             	mov    0x8(%ebp),%eax
    136f:	89 10                	mov    %edx,(%eax)
 if(sem->value>0)
    1371:	8b 45 08             	mov    0x8(%ebp),%eax
    1374:	8b 00                	mov    (%eax),%eax
    1376:	85 c0                	test   %eax,%eax
    1378:	7e 0e                	jle    1388 <semaphore_down+0x46>
  binary_semaphore_up(sem->s2);
    137a:	8b 45 08             	mov    0x8(%ebp),%eax
    137d:	8b 40 08             	mov    0x8(%eax),%eax
    1380:	89 04 24             	mov    %eax,(%esp)
    1383:	e8 94 fa ff ff       	call   e1c <binary_semaphore_up>
 binary_semaphore_up(sem->s1);
    1388:	8b 45 08             	mov    0x8(%ebp),%eax
    138b:	8b 40 04             	mov    0x4(%eax),%eax
    138e:	89 04 24             	mov    %eax,(%esp)
    1391:	e8 86 fa ff ff       	call   e1c <binary_semaphore_up>
}
    1396:	c9                   	leave  
    1397:	c3                   	ret    

00001398 <semaphore_up>:

void 
semaphore_up(struct semaphore* sem )
{
    1398:	55                   	push   %ebp
    1399:	89 e5                	mov    %esp,%ebp
    139b:	83 ec 18             	sub    $0x18,%esp
  binary_semaphore_down(sem->s1);
    139e:	8b 45 08             	mov    0x8(%ebp),%eax
    13a1:	8b 40 04             	mov    0x4(%eax),%eax
    13a4:	89 04 24             	mov    %eax,(%esp)
    13a7:	e8 68 fa ff ff       	call   e14 <binary_semaphore_down>
  sem->value++;
    13ac:	8b 45 08             	mov    0x8(%ebp),%eax
    13af:	8b 00                	mov    (%eax),%eax
    13b1:	8d 50 01             	lea    0x1(%eax),%edx
    13b4:	8b 45 08             	mov    0x8(%ebp),%eax
    13b7:	89 10                	mov    %edx,(%eax)
  if(sem->value == 1)
    13b9:	8b 45 08             	mov    0x8(%ebp),%eax
    13bc:	8b 00                	mov    (%eax),%eax
    13be:	83 f8 01             	cmp    $0x1,%eax
    13c1:	75 0e                	jne    13d1 <semaphore_up+0x39>
    binary_semaphore_up(sem->s2);
    13c3:	8b 45 08             	mov    0x8(%ebp),%eax
    13c6:	8b 40 08             	mov    0x8(%eax),%eax
    13c9:	89 04 24             	mov    %eax,(%esp)
    13cc:	e8 4b fa ff ff       	call   e1c <binary_semaphore_up>
  binary_semaphore_up(sem->s1);
    13d1:	8b 45 08             	mov    0x8(%ebp),%eax
    13d4:	8b 40 04             	mov    0x4(%eax),%eax
    13d7:	89 04 24             	mov    %eax,(%esp)
    13da:	e8 3d fa ff ff       	call   e1c <binary_semaphore_up>
}
    13df:	c9                   	leave  
    13e0:	c3                   	ret    
    13e1:	90                   	nop
    13e2:	90                   	nop
    13e3:	90                   	nop

000013e4 <BB_create>:
#include "boundedbuffer.h"

struct BB* 
BB_create(int max_capacity,char* name)
{
    13e4:	55                   	push   %ebp
    13e5:	89 e5                	mov    %esp,%ebp
    13e7:	83 ec 28             	sub    $0x28,%esp
  struct BB* buf = malloc(sizeof(struct BB));
    13ea:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
    13f1:	e8 e9 fd ff ff       	call   11df <malloc>
    13f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(buf,0,sizeof(struct BB));
    13f9:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
    1400:	00 
    1401:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1408:	00 
    1409:	8b 45 f4             	mov    -0xc(%ebp),%eax
    140c:	89 04 24             	mov    %eax,(%esp)
    140f:	e8 8b f7 ff ff       	call   b9f <memset>
  buf->elements = malloc(sizeof(void*)*max_capacity);
    1414:	8b 45 08             	mov    0x8(%ebp),%eax
    1417:	c1 e0 02             	shl    $0x2,%eax
    141a:	89 04 24             	mov    %eax,(%esp)
    141d:	e8 bd fd ff ff       	call   11df <malloc>
    1422:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1425:	89 42 1c             	mov    %eax,0x1c(%edx)
  memset(buf->elements,0,sizeof(void*)*max_capacity);
    1428:	8b 45 08             	mov    0x8(%ebp),%eax
    142b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1432:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1435:	8b 40 1c             	mov    0x1c(%eax),%eax
    1438:	89 54 24 08          	mov    %edx,0x8(%esp)
    143c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1443:	00 
    1444:	89 04 24             	mov    %eax,(%esp)
    1447:	e8 53 f7 ff ff       	call   b9f <memset>
  buf->name = name;
    144c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    144f:	8b 55 0c             	mov    0xc(%ebp),%edx
    1452:	89 50 18             	mov    %edx,0x18(%eax)
  if((buf->mutex = binary_semaphore_create(1)) != -1)
    1455:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    145c:	e8 ab f9 ff ff       	call   e0c <binary_semaphore_create>
    1461:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1464:	89 42 04             	mov    %eax,0x4(%edx)
    1467:	83 f8 ff             	cmp    $0xffffffff,%eax
    146a:	74 52                	je     14be <BB_create+0xda>
  {
    buf->BUFFER_SIZE = max_capacity;
    146c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    146f:	8b 55 08             	mov    0x8(%ebp),%edx
    1472:	89 10                	mov    %edx,(%eax)
    if((buf->empty = semaphore_create(max_capacity, name))!= 0 && (buf->full = semaphore_create(0, name))!= 0)
    1474:	8b 45 0c             	mov    0xc(%ebp),%eax
    1477:	89 44 24 04          	mov    %eax,0x4(%esp)
    147b:	8b 45 08             	mov    0x8(%ebp),%eax
    147e:	89 04 24             	mov    %eax,(%esp)
    1481:	e8 3a fe ff ff       	call   12c0 <semaphore_create>
    1486:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1489:	89 42 08             	mov    %eax,0x8(%edx)
    148c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    148f:	8b 40 08             	mov    0x8(%eax),%eax
    1492:	85 c0                	test   %eax,%eax
    1494:	74 28                	je     14be <BB_create+0xda>
    1496:	8b 45 0c             	mov    0xc(%ebp),%eax
    1499:	89 44 24 04          	mov    %eax,0x4(%esp)
    149d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    14a4:	e8 17 fe ff ff       	call   12c0 <semaphore_create>
    14a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14ac:	89 42 0c             	mov    %eax,0xc(%edx)
    14af:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14b2:	8b 40 0c             	mov    0xc(%eax),%eax
    14b5:	85 c0                	test   %eax,%eax
    14b7:	74 05                	je     14be <BB_create+0xda>
      return buf;
    14b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14bc:	eb 23                	jmp    14e1 <BB_create+0xfd>
  }
  free(buf->elements);
    14be:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14c1:	8b 40 1c             	mov    0x1c(%eax),%eax
    14c4:	89 04 24             	mov    %eax,(%esp)
    14c7:	e8 e4 fb ff ff       	call   10b0 <free>
  free(buf);
    14cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14cf:	89 04 24             	mov    %eax,(%esp)
    14d2:	e8 d9 fb ff ff       	call   10b0 <free>
  buf = 0;
    14d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  return buf;
    14de:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    14e1:	c9                   	leave  
    14e2:	c3                   	ret    

000014e3 <BB_put>:

void 
BB_put(struct BB* bb, void* element)
{
    14e3:	55                   	push   %ebp
    14e4:	89 e5                	mov    %esp,%ebp
    14e6:	83 ec 18             	sub    $0x18,%esp
  semaphore_down(bb->empty);
    14e9:	8b 45 08             	mov    0x8(%ebp),%eax
    14ec:	8b 40 08             	mov    0x8(%eax),%eax
    14ef:	89 04 24             	mov    %eax,(%esp)
    14f2:	e8 4b fe ff ff       	call   1342 <semaphore_down>
  binary_semaphore_down(bb->mutex);
    14f7:	8b 45 08             	mov    0x8(%ebp),%eax
    14fa:	8b 40 04             	mov    0x4(%eax),%eax
    14fd:	89 04 24             	mov    %eax,(%esp)
    1500:	e8 0f f9 ff ff       	call   e14 <binary_semaphore_down>
  bb->elements[bb->end] = element;
    1505:	8b 45 08             	mov    0x8(%ebp),%eax
    1508:	8b 50 1c             	mov    0x1c(%eax),%edx
    150b:	8b 45 08             	mov    0x8(%ebp),%eax
    150e:	8b 40 14             	mov    0x14(%eax),%eax
    1511:	c1 e0 02             	shl    $0x2,%eax
    1514:	01 c2                	add    %eax,%edx
    1516:	8b 45 0c             	mov    0xc(%ebp),%eax
    1519:	89 02                	mov    %eax,(%edx)
  ++bb->end;
    151b:	8b 45 08             	mov    0x8(%ebp),%eax
    151e:	8b 40 14             	mov    0x14(%eax),%eax
    1521:	8d 50 01             	lea    0x1(%eax),%edx
    1524:	8b 45 08             	mov    0x8(%ebp),%eax
    1527:	89 50 14             	mov    %edx,0x14(%eax)
  bb->end = bb->end%bb->BUFFER_SIZE;
    152a:	8b 45 08             	mov    0x8(%ebp),%eax
    152d:	8b 40 14             	mov    0x14(%eax),%eax
    1530:	8b 55 08             	mov    0x8(%ebp),%edx
    1533:	8b 0a                	mov    (%edx),%ecx
    1535:	89 c2                	mov    %eax,%edx
    1537:	c1 fa 1f             	sar    $0x1f,%edx
    153a:	f7 f9                	idiv   %ecx
    153c:	8b 45 08             	mov    0x8(%ebp),%eax
    153f:	89 50 14             	mov    %edx,0x14(%eax)
  binary_semaphore_up(bb->mutex);
    1542:	8b 45 08             	mov    0x8(%ebp),%eax
    1545:	8b 40 04             	mov    0x4(%eax),%eax
    1548:	89 04 24             	mov    %eax,(%esp)
    154b:	e8 cc f8 ff ff       	call   e1c <binary_semaphore_up>
  semaphore_up(bb->full);
    1550:	8b 45 08             	mov    0x8(%ebp),%eax
    1553:	8b 40 0c             	mov    0xc(%eax),%eax
    1556:	89 04 24             	mov    %eax,(%esp)
    1559:	e8 3a fe ff ff       	call   1398 <semaphore_up>
}
    155e:	c9                   	leave  
    155f:	c3                   	ret    

00001560 <BB_pop>:

void* 
BB_pop(struct BB* bb)
{
    1560:	55                   	push   %ebp
    1561:	89 e5                	mov    %esp,%ebp
    1563:	83 ec 28             	sub    $0x28,%esp
  void* item;
  semaphore_down(bb->full);
    1566:	8b 45 08             	mov    0x8(%ebp),%eax
    1569:	8b 40 0c             	mov    0xc(%eax),%eax
    156c:	89 04 24             	mov    %eax,(%esp)
    156f:	e8 ce fd ff ff       	call   1342 <semaphore_down>
  binary_semaphore_down(bb->mutex);
    1574:	8b 45 08             	mov    0x8(%ebp),%eax
    1577:	8b 40 04             	mov    0x4(%eax),%eax
    157a:	89 04 24             	mov    %eax,(%esp)
    157d:	e8 92 f8 ff ff       	call   e14 <binary_semaphore_down>
  item = bb->elements[bb->start];
    1582:	8b 45 08             	mov    0x8(%ebp),%eax
    1585:	8b 50 1c             	mov    0x1c(%eax),%edx
    1588:	8b 45 08             	mov    0x8(%ebp),%eax
    158b:	8b 40 10             	mov    0x10(%eax),%eax
    158e:	c1 e0 02             	shl    $0x2,%eax
    1591:	01 d0                	add    %edx,%eax
    1593:	8b 00                	mov    (%eax),%eax
    1595:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bb->elements[bb->start] = 0;
    1598:	8b 45 08             	mov    0x8(%ebp),%eax
    159b:	8b 50 1c             	mov    0x1c(%eax),%edx
    159e:	8b 45 08             	mov    0x8(%ebp),%eax
    15a1:	8b 40 10             	mov    0x10(%eax),%eax
    15a4:	c1 e0 02             	shl    $0x2,%eax
    15a7:	01 d0                	add    %edx,%eax
    15a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  ++bb->start;
    15af:	8b 45 08             	mov    0x8(%ebp),%eax
    15b2:	8b 40 10             	mov    0x10(%eax),%eax
    15b5:	8d 50 01             	lea    0x1(%eax),%edx
    15b8:	8b 45 08             	mov    0x8(%ebp),%eax
    15bb:	89 50 10             	mov    %edx,0x10(%eax)
  bb->start = bb->start%bb->BUFFER_SIZE;
    15be:	8b 45 08             	mov    0x8(%ebp),%eax
    15c1:	8b 40 10             	mov    0x10(%eax),%eax
    15c4:	8b 55 08             	mov    0x8(%ebp),%edx
    15c7:	8b 0a                	mov    (%edx),%ecx
    15c9:	89 c2                	mov    %eax,%edx
    15cb:	c1 fa 1f             	sar    $0x1f,%edx
    15ce:	f7 f9                	idiv   %ecx
    15d0:	8b 45 08             	mov    0x8(%ebp),%eax
    15d3:	89 50 10             	mov    %edx,0x10(%eax)
  binary_semaphore_up(bb->mutex);
    15d6:	8b 45 08             	mov    0x8(%ebp),%eax
    15d9:	8b 40 04             	mov    0x4(%eax),%eax
    15dc:	89 04 24             	mov    %eax,(%esp)
    15df:	e8 38 f8 ff ff       	call   e1c <binary_semaphore_up>
  semaphore_up(bb->empty);
    15e4:	8b 45 08             	mov    0x8(%ebp),%eax
    15e7:	8b 40 08             	mov    0x8(%eax),%eax
    15ea:	89 04 24             	mov    %eax,(%esp)
    15ed:	e8 a6 fd ff ff       	call   1398 <semaphore_up>
  return item;
    15f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    15f5:	c9                   	leave  
    15f6:	c3                   	ret    
