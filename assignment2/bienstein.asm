
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
       6:	a1 e4 1d 00 00       	mov    0x1de4,%eax
       b:	89 04 24             	mov    %eax,(%esp)
       e:	e8 76 13 00 00       	call   1389 <semaphore_down>
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
      1b:	a1 e4 1d 00 00       	mov    0x1de4,%eax
      20:	89 04 24             	mov    %eax,(%esp)
      23:	e8 b7 13 00 00       	call   13df <semaphore_up>
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
      30:	a1 f4 1d 00 00       	mov    0x1df4,%eax
      35:	8b 55 08             	mov    0x8(%ebp),%edx
      38:	89 54 24 04          	mov    %edx,0x4(%esp)
      3c:	89 04 24             	mov    %eax,(%esp)
      3f:	e8 db 14 00 00       	call   151f <BB_put>
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
      4c:	a1 f4 1d 00 00       	mov    0x1df4,%eax
      51:	89 04 24             	mov    %eax,(%esp)
      54:	e8 43 15 00 00       	call   159c <BB_pop>
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
      61:	a1 00 1e 00 00       	mov    0x1e00,%eax
      66:	8b 55 08             	mov    0x8(%ebp),%edx
      69:	89 54 24 04          	mov    %edx,0x4(%esp)
      6d:	89 04 24             	mov    %eax,(%esp)
      70:	e8 aa 14 00 00       	call   151f <BB_put>
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
      7d:	a1 00 1e 00 00       	mov    0x1e00,%eax
      82:	89 04 24             	mov    %eax,(%esp)
      85:	e8 12 15 00 00       	call   159c <BB_pop>
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
      92:	a1 0c 1e 00 00       	mov    0x1e0c,%eax
      97:	89 04 24             	mov    %eax,(%esp)
      9a:	e8 fd 14 00 00       	call   159c <BB_pop>
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
      a7:	a1 0c 1e 00 00       	mov    0x1e0c,%eax
      ac:	8b 55 08             	mov    0x8(%ebp),%edx
      af:	89 54 24 04          	mov    %edx,0x4(%esp)
      b3:	89 04 24             	mov    %eax,(%esp)
      b6:	e8 64 14 00 00       	call   151f <BB_put>
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
      c3:	a1 fc 1d 00 00       	mov    0x1dfc,%eax
      c8:	8b 55 08             	mov    0x8(%ebp),%edx
      cb:	89 54 24 04          	mov    %edx,0x4(%esp)
      cf:	89 04 24             	mov    %eax,(%esp)
      d2:	e8 48 14 00 00       	call   151f <BB_put>
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
      df:	a1 fc 1d 00 00       	mov    0x1dfc,%eax
      e4:	89 04 24             	mov    %eax,(%esp)
      e7:	e8 b0 14 00 00       	call   159c <BB_pop>
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
     110:	e8 ce 0a 00 00       	call   be3 <memset>
  
  if((fdin = open("con.conf",O_RDONLY)) < 0)
     115:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     11c:	00 
     11d:	c7 04 24 38 16 00 00 	movl   $0x1638,(%esp)
     124:	e8 9f 0c 00 00       	call   dc8 <open>
     129:	89 45 f0             	mov    %eax,-0x10(%ebp)
     12c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     130:	79 1e                	jns    150 <getconf+0x62>
  {
    printf(1,"Couldn't open the conf file\n");
     132:	c7 44 24 04 41 16 00 	movl   $0x1641,0x4(%esp)
     139:	00 
     13a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     141:	e8 f9 0d 00 00       	call   f3f <printf>
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
     168:	e8 33 0c 00 00       	call   da0 <read>
     16d:	89 45 ec             	mov    %eax,-0x14(%ebp)
     170:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     174:	7f 1e                	jg     194 <getconf+0xa6>
  {
    printf(1,"Couldn't read from conf file\n");
     176:	c7 44 24 04 5e 16 00 	movl   $0x165e,0x4(%esp)
     17d:	00 
     17e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     185:	e8 b5 0d 00 00       	call   f3f <printf>
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
    printf(1,"Couldn't read from conf file\n");
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
     202:	8b 04 85 7c 16 00 00 	mov    0x167c(,%eax,4),%eax
     209:	ff e0                	jmp    *%eax
      {
	case 'M':
	  M = atoi(&buf[i+1]);
     20b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     20e:	8d 50 01             	lea    0x1(%eax),%edx
     211:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     217:	01 d0                	add    %edx,%eax
     219:	89 04 24             	mov    %eax,(%esp)
     21c:	e8 d6 0a 00 00       	call   cf7 <atoi>
     221:	a3 04 1e 00 00       	mov    %eax,0x1e04
	  break;
     226:	eb 73                	jmp    29b <getconf+0x1ad>
	case 'A':
	   A = atoi(&buf[i+1]);
     228:	8b 45 f4             	mov    -0xc(%ebp),%eax
     22b:	8d 50 01             	lea    0x1(%eax),%edx
     22e:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     234:	01 d0                	add    %edx,%eax
     236:	89 04 24             	mov    %eax,(%esp)
     239:	e8 b9 0a 00 00       	call   cf7 <atoi>
     23e:	a3 e0 1d 00 00       	mov    %eax,0x1de0
	  break;
     243:	eb 56                	jmp    29b <getconf+0x1ad>
	case 'C':
	   C = atoi(&buf[i+1]);
     245:	8b 45 f4             	mov    -0xc(%ebp),%eax
     248:	8d 50 01             	lea    0x1(%eax),%edx
     24b:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     251:	01 d0                	add    %edx,%eax
     253:	89 04 24             	mov    %eax,(%esp)
     256:	e8 9c 0a 00 00       	call   cf7 <atoi>
     25b:	a3 f8 1d 00 00       	mov    %eax,0x1df8
	  break;
     260:	eb 39                	jmp    29b <getconf+0x1ad>
	case 'S':
	   S = atoi(&buf[i+1]);
     262:	8b 45 f4             	mov    -0xc(%ebp),%eax
     265:	8d 50 01             	lea    0x1(%eax),%edx
     268:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     26e:	01 d0                	add    %edx,%eax
     270:	89 04 24             	mov    %eax,(%esp)
     273:	e8 7f 0a 00 00       	call   cf7 <atoi>
     278:	a3 ec 1d 00 00       	mov    %eax,0x1dec
	  break;
     27d:	eb 1c                	jmp    29b <getconf+0x1ad>
	case 'B':
	   B = atoi(&buf[i+1]);
     27f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     282:	8d 50 01             	lea    0x1(%eax),%edx
     285:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     28b:	01 d0                	add    %edx,%eax
     28d:	89 04 24             	mov    %eax,(%esp)
     290:	e8 62 0a 00 00       	call   cf7 <atoi>
     295:	a3 f0 1d 00 00       	mov    %eax,0x1df0
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
     2b8:	e8 73 0b 00 00       	call   e30 <thread_getId>
     2bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i = 0;
     2c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
  enter_bar();
     2c7:	e8 34 fd ff ff       	call   0 <enter_bar>
  printf(1,"student tid = %d entered bar\n",tid);
     2cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
     2cf:	89 44 24 08          	mov    %eax,0x8(%esp)
     2d3:	c7 44 24 04 c8 16 00 	movl   $0x16c8,0x4(%esp)
     2da:	00 
     2db:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     2e2:	e8 58 0c 00 00       	call   f3f <printf>
  for(;i < tid%5;i++)
     2e7:	e9 cd 00 00 00       	jmp    3b9 <student_func+0x107>
  {
    struct Action* get = malloc(sizeof(struct Action));
     2ec:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     2f3:	e8 2b 0f 00 00       	call   1223 <malloc>
     2f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    get->type = GET_DRINK;
     2fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
     2fe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    get->cup = 0;
     304:	8b 45 ec             	mov    -0x14(%ebp),%eax
     307:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    get->tid = tid;
     30e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     311:	8b 55 f0             	mov    -0x10(%ebp),%edx
     314:	89 50 08             	mov    %edx,0x8(%eax)
    printf(1,"student tid = %d places action\n",tid);
     317:	8b 45 f0             	mov    -0x10(%ebp),%eax
     31a:	89 44 24 08          	mov    %eax,0x8(%esp)
     31e:	c7 44 24 04 e8 16 00 	movl   $0x16e8,0x4(%esp)
     325:	00 
     326:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     32d:	e8 0d 0c 00 00       	call   f3f <printf>
    place_action(get);
     332:	8b 45 ec             	mov    -0x14(%ebp),%eax
     335:	89 04 24             	mov    %eax,(%esp)
     338:	e8 ed fc ff ff       	call   2a <place_action>
    struct Cup * cup = get_drink();
     33d:	e8 35 fd ff ff       	call   77 <get_drink>
     342:	89 45 e8             	mov    %eax,-0x18(%ebp)
    printf(fd,"Student %d is having his %d drink, with cup %d\n",tid,i+1,cup->id);
     345:	8b 45 e8             	mov    -0x18(%ebp),%eax
     348:	8b 10                	mov    (%eax),%edx
     34a:	8b 45 f4             	mov    -0xc(%ebp),%eax
     34d:	8d 48 01             	lea    0x1(%eax),%ecx
     350:	a1 e8 1d 00 00       	mov    0x1de8,%eax
     355:	89 54 24 10          	mov    %edx,0x10(%esp)
     359:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
     35d:	8b 55 f0             	mov    -0x10(%ebp),%edx
     360:	89 54 24 08          	mov    %edx,0x8(%esp)
     364:	c7 44 24 04 08 17 00 	movl   $0x1708,0x4(%esp)
     36b:	00 
     36c:	89 04 24             	mov    %eax,(%esp)
     36f:	e8 cb 0b 00 00       	call   f3f <printf>
    sleep(1);
     374:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     37b:	e8 98 0a 00 00       	call   e18 <sleep>
    struct Action* put = malloc(sizeof(struct Action));
     380:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     387:	e8 97 0e 00 00       	call   1223 <malloc>
     38c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    put->type = PUT_DRINK;
     38f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     392:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    put->cup = cup;
     398:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     39b:	8b 55 e8             	mov    -0x18(%ebp),%edx
     39e:	89 50 04             	mov    %edx,0x4(%eax)
    //printf(1,"cup address = %d, cup value = %d\n",cup,cup->id);
    put->tid = tid;
     3a1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     3a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
     3a7:	89 50 08             	mov    %edx,0x8(%eax)
    place_action(put);
     3aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     3ad:	89 04 24             	mov    %eax,(%esp)
     3b0:	e8 75 fc ff ff       	call   2a <place_action>
  int tid = thread_getId();
  int i = 0;
  
  enter_bar();
  printf(1,"student tid = %d entered bar\n",tid);
  for(;i < tid%5;i++)
     3b5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     3b9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
     3bc:	ba 67 66 66 66       	mov    $0x66666667,%edx
     3c1:	89 c8                	mov    %ecx,%eax
     3c3:	f7 ea                	imul   %edx
     3c5:	d1 fa                	sar    %edx
     3c7:	89 c8                	mov    %ecx,%eax
     3c9:	c1 f8 1f             	sar    $0x1f,%eax
     3cc:	29 c2                	sub    %eax,%edx
     3ce:	89 d0                	mov    %edx,%eax
     3d0:	c1 e0 02             	shl    $0x2,%eax
     3d3:	01 d0                	add    %edx,%eax
     3d5:	89 ca                	mov    %ecx,%edx
     3d7:	29 c2                	sub    %eax,%edx
     3d9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
     3dc:	0f 8f 0a ff ff ff    	jg     2ec <student_func+0x3a>
    put->cup = cup;
    //printf(1,"cup address = %d, cup value = %d\n",cup,cup->id);
    put->tid = tid;
    place_action(put);
  }
  printf(fd,"Student %d is drunk, and trying to go home\n",tid);
     3e2:	a1 e8 1d 00 00       	mov    0x1de8,%eax
     3e7:	8b 55 f0             	mov    -0x10(%ebp),%edx
     3ea:	89 54 24 08          	mov    %edx,0x8(%esp)
     3ee:	c7 44 24 04 38 17 00 	movl   $0x1738,0x4(%esp)
     3f5:	00 
     3f6:	89 04 24             	mov    %eax,(%esp)
     3f9:	e8 41 0b 00 00       	call   f3f <printf>
  leave_bar();
     3fe:	e8 12 fc ff ff       	call   15 <leave_bar>
  thread_exit(0);
     403:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     40a:	e8 39 0a 00 00       	call   e48 <thread_exit>
  return 0;
     40f:	b8 00 00 00 00       	mov    $0x0,%eax
}
     414:	c9                   	leave  
     415:	c3                   	ret    

00000416 <bartender_func>:

void* bartender_func(void)
{
     416:	55                   	push   %ebp
     417:	89 e5                	mov    %esp,%ebp
     419:	83 ec 48             	sub    $0x48,%esp
  double n,bufSize;
  int tid = thread_getId();
     41c:	e8 0f 0a 00 00       	call   e30 <thread_getId>
     421:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(;;)
  {
    struct Action * act = get_action();
     424:	e8 1d fc ff ff       	call   46 <get_action>
     429:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"type = %d, cup = %d, tid = %d\n",act->type,act->cup->id,act->tid);
    if(act->type == GET_DRINK)
     42c:	8b 45 f0             	mov    -0x10(%ebp),%eax
     42f:	8b 00                	mov    (%eax),%eax
     431:	83 f8 01             	cmp    $0x1,%eax
     434:	75 3d                	jne    473 <bartender_func+0x5d>
    {
      struct Cup * cup = get_clean_cup();
     436:	e8 51 fc ff ff       	call   8c <get_clean_cup>
     43b:	89 45 ec             	mov    %eax,-0x14(%ebp)
      printf(fd,"Bartender %d is making drink with cup #%d\n",tid,cup->id);
     43e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     441:	8b 10                	mov    (%eax),%edx
     443:	a1 e8 1d 00 00       	mov    0x1de8,%eax
     448:	89 54 24 0c          	mov    %edx,0xc(%esp)
     44c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     44f:	89 54 24 08          	mov    %edx,0x8(%esp)
     453:	c7 44 24 04 64 17 00 	movl   $0x1764,0x4(%esp)
     45a:	00 
     45b:	89 04 24             	mov    %eax,(%esp)
     45e:	e8 dc 0a 00 00       	call   f3f <printf>
      serve_drink(cup);
     463:	8b 45 ec             	mov    -0x14(%ebp),%eax
     466:	89 04 24             	mov    %eax,(%esp)
     469:	e8 ed fb ff ff       	call   5b <serve_drink>
     46e:	e9 b0 00 00 00       	jmp    523 <bartender_func+0x10d>
    }
    else if(act->type == PUT_DRINK)
     473:	8b 45 f0             	mov    -0x10(%ebp),%eax
     476:	8b 00                	mov    (%eax),%eax
     478:	83 f8 02             	cmp    $0x2,%eax
     47b:	0f 85 a2 00 00 00    	jne    523 <bartender_func+0x10d>
    {
      struct Cup * cup = act->cup;
     481:	8b 45 f0             	mov    -0x10(%ebp),%eax
     484:	8b 40 04             	mov    0x4(%eax),%eax
     487:	89 45 e8             	mov    %eax,-0x18(%ebp)
      return_cup(cup);
     48a:	8b 45 e8             	mov    -0x18(%ebp),%eax
     48d:	89 04 24             	mov    %eax,(%esp)
     490:	e8 28 fc ff ff       	call   bd <return_cup>
      printf(fd,"Bartender %d returned cup #%d\n",tid,cup->id);
     495:	8b 45 e8             	mov    -0x18(%ebp),%eax
     498:	8b 10                	mov    (%eax),%edx
     49a:	a1 e8 1d 00 00       	mov    0x1de8,%eax
     49f:	89 54 24 0c          	mov    %edx,0xc(%esp)
     4a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     4a6:	89 54 24 08          	mov    %edx,0x8(%esp)
     4aa:	c7 44 24 04 90 17 00 	movl   $0x1790,0x4(%esp)
     4b1:	00 
     4b2:	89 04 24             	mov    %eax,(%esp)
     4b5:	e8 85 0a 00 00       	call   f3f <printf>
      
      semaphore_down(DBB->full);
     4ba:	a1 fc 1d 00 00       	mov    0x1dfc,%eax
     4bf:	8b 40 0c             	mov    0xc(%eax),%eax
     4c2:	89 04 24             	mov    %eax,(%esp)
     4c5:	e8 bf 0e 00 00       	call   1389 <semaphore_down>
      n = DBB->full->value;
     4ca:	a1 fc 1d 00 00       	mov    0x1dfc,%eax
     4cf:	8b 40 0c             	mov    0xc(%eax),%eax
     4d2:	8b 00                	mov    (%eax),%eax
     4d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     4d7:	db 45 d4             	fildl  -0x2c(%ebp)
     4da:	dd 5d e0             	fstpl  -0x20(%ebp)
      semaphore_up(DBB->full);
     4dd:	a1 fc 1d 00 00       	mov    0x1dfc,%eax
     4e2:	8b 40 0c             	mov    0xc(%eax),%eax
     4e5:	89 04 24             	mov    %eax,(%esp)
     4e8:	e8 f2 0e 00 00       	call   13df <semaphore_up>
      bufSize = DBB->BUFFER_SIZE;
     4ed:	a1 fc 1d 00 00       	mov    0x1dfc,%eax
     4f2:	8b 00                	mov    (%eax),%eax
     4f4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     4f7:	db 45 d4             	fildl  -0x2c(%ebp)
     4fa:	dd 5d d8             	fstpl  -0x28(%ebp)
      if(n/bufSize >= 0.6)
     4fd:	dd 45 e0             	fldl   -0x20(%ebp)
     500:	dc 75 d8             	fdivl  -0x28(%ebp)
     503:	dd 05 e0 18 00 00    	fldl   0x18e0
     509:	d9 c9                	fxch   %st(1)
     50b:	df e9                	fucomip %st(1),%st
     50d:	dd d8                	fstp   %st(0)
     50f:	0f 93 c0             	setae  %al
     512:	84 c0                	test   %al,%al
     514:	74 0d                	je     523 <bartender_func+0x10d>
	semaphore_up(cupsem);
     516:	a1 08 1e 00 00       	mov    0x1e08,%eax
     51b:	89 04 24             	mov    %eax,(%esp)
     51e:	e8 bc 0e 00 00       	call   13df <semaphore_up>
    }
    free(act);
     523:	8b 45 f0             	mov    -0x10(%ebp),%eax
     526:	89 04 24             	mov    %eax,(%esp)
     529:	e8 c6 0b 00 00       	call   10f4 <free>
  }
     52e:	e9 f1 fe ff ff       	jmp    424 <bartender_func+0xe>

00000533 <cupboy_func>:
  
  return 0;
}

void* cupboy_func(void)
{
     533:	55                   	push   %ebp
     534:	89 e5                	mov    %esp,%ebp
     536:	83 ec 28             	sub    $0x28,%esp
  int i = 0, n;
     539:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
  for(;;)
  {
    semaphore_down(DBB->full);
     540:	a1 fc 1d 00 00       	mov    0x1dfc,%eax
     545:	8b 40 0c             	mov    0xc(%eax),%eax
     548:	89 04 24             	mov    %eax,(%esp)
     54b:	e8 39 0e 00 00       	call   1389 <semaphore_down>
    n = DBB->full->value;
     550:	a1 fc 1d 00 00       	mov    0x1dfc,%eax
     555:	8b 40 0c             	mov    0xc(%eax),%eax
     558:	8b 00                	mov    (%eax),%eax
     55a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    semaphore_up(DBB->full);
     55d:	a1 fc 1d 00 00       	mov    0x1dfc,%eax
     562:	8b 40 0c             	mov    0xc(%eax),%eax
     565:	89 04 24             	mov    %eax,(%esp)
     568:	e8 72 0e 00 00       	call   13df <semaphore_up>
    
    for(;i<n;i++)
     56d:	eb 41                	jmp    5b0 <cupboy_func+0x7d>
    {
      struct Cup * cup = wash_dirty();
     56f:	e8 65 fb ff ff       	call   d9 <wash_dirty>
     574:	89 45 ec             	mov    %eax,-0x14(%ebp)
      sleep(1);
     577:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     57e:	e8 95 08 00 00       	call   e18 <sleep>
      add_clean_cup(cup);
     583:	8b 45 ec             	mov    -0x14(%ebp),%eax
     586:	89 04 24             	mov    %eax,(%esp)
     589:	e8 13 fb ff ff       	call   a1 <add_clean_cup>
      printf(fd,"Cup boy added clean cup #%d\n",cup->id);    
     58e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     591:	8b 10                	mov    (%eax),%edx
     593:	a1 e8 1d 00 00       	mov    0x1de8,%eax
     598:	89 54 24 08          	mov    %edx,0x8(%esp)
     59c:	c7 44 24 04 af 17 00 	movl   $0x17af,0x4(%esp)
     5a3:	00 
     5a4:	89 04 24             	mov    %eax,(%esp)
     5a7:	e8 93 09 00 00       	call   f3f <printf>
  {
    semaphore_down(DBB->full);
    n = DBB->full->value;
    semaphore_up(DBB->full);
    
    for(;i<n;i++)
     5ac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     5b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
     5b3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     5b6:	7c b7                	jl     56f <cupboy_func+0x3c>
      struct Cup * cup = wash_dirty();
      sleep(1);
      add_clean_cup(cup);
      printf(fd,"Cup boy added clean cup #%d\n",cup->id);    
    }
    semaphore_down(cupsem);
     5b8:	a1 08 1e 00 00       	mov    0x1e08,%eax
     5bd:	89 04 24             	mov    %eax,(%esp)
     5c0:	e8 c4 0d 00 00       	call   1389 <semaphore_down>
  }
     5c5:	e9 76 ff ff ff       	jmp    540 <cupboy_func+0xd>

000005ca <main>:
}


int 
main(void)
{
     5ca:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     5ce:	83 e4 f0             	and    $0xfffffff0,%esp
     5d1:	ff 71 fc             	pushl  -0x4(%ecx)
     5d4:	55                   	push   %ebp
     5d5:	89 e5                	mov    %esp,%ebp
     5d7:	53                   	push   %ebx
     5d8:	51                   	push   %ecx
     5d9:	83 ec 50             	sub    $0x50,%esp
     5dc:	89 e0                	mov    %esp,%eax
     5de:	89 c3                	mov    %eax,%ebx
  if((fd = open("Synch_problem_log.txt",(O_WRONLY | O_CREATE))) < 0)
     5e0:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     5e7:	00 
     5e8:	c7 04 24 cc 17 00 00 	movl   $0x17cc,(%esp)
     5ef:	e8 d4 07 00 00       	call   dc8 <open>
     5f4:	a3 e8 1d 00 00       	mov    %eax,0x1de8
     5f9:	a1 e8 1d 00 00       	mov    0x1de8,%eax
     5fe:	85 c0                	test   %eax,%eax
     600:	79 1e                	jns    620 <main+0x56>
  {
    printf(1,"Couldn't open the log file\n");
     602:	c7 44 24 04 e2 17 00 	movl   $0x17e2,0x4(%esp)
     609:	00 
     60a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     611:	e8 29 09 00 00       	call   f3f <printf>
    return -1;
     616:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     61b:	e9 f5 04 00 00       	jmp    b15 <main+0x54b>
  }
  if (getconf() == -1)
     620:	e8 c9 fa ff ff       	call   ee <getconf>
     625:	83 f8 ff             	cmp    $0xffffffff,%eax
     628:	75 1e                	jne    648 <main+0x7e>
  {
    printf(1,"Couldn't open the conf file\n");
     62a:	c7 44 24 04 41 16 00 	movl   $0x1641,0x4(%esp)
     631:	00 
     632:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     639:	e8 01 09 00 00       	call   f3f <printf>
    return -1;
     63e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     643:	e9 cd 04 00 00       	jmp    b15 <main+0x54b>
  }
  fd=1;
     648:	c7 05 e8 1d 00 00 01 	movl   $0x1,0x1de8
     64f:	00 00 00 
  void * barStack[B];
     652:	a1 f0 1d 00 00       	mov    0x1df0,%eax
     657:	8d 50 ff             	lea    -0x1(%eax),%edx
     65a:	89 55 f0             	mov    %edx,-0x10(%ebp)
     65d:	c1 e0 02             	shl    $0x2,%eax
     660:	8d 50 0f             	lea    0xf(%eax),%edx
     663:	b8 10 00 00 00       	mov    $0x10,%eax
     668:	83 e8 01             	sub    $0x1,%eax
     66b:	01 d0                	add    %edx,%eax
     66d:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
     674:	ba 00 00 00 00       	mov    $0x0,%edx
     679:	f7 75 c4             	divl   -0x3c(%ebp)
     67c:	6b c0 10             	imul   $0x10,%eax,%eax
     67f:	29 c4                	sub    %eax,%esp
     681:	8d 44 24 0c          	lea    0xc(%esp),%eax
     685:	83 c0 0f             	add    $0xf,%eax
     688:	c1 e8 04             	shr    $0x4,%eax
     68b:	c1 e0 04             	shl    $0x4,%eax
     68e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  void * studStack[S];
     691:	a1 ec 1d 00 00       	mov    0x1dec,%eax
     696:	8d 50 ff             	lea    -0x1(%eax),%edx
     699:	89 55 e8             	mov    %edx,-0x18(%ebp)
     69c:	c1 e0 02             	shl    $0x2,%eax
     69f:	8d 50 0f             	lea    0xf(%eax),%edx
     6a2:	b8 10 00 00 00       	mov    $0x10,%eax
     6a7:	83 e8 01             	sub    $0x1,%eax
     6aa:	01 d0                	add    %edx,%eax
     6ac:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
     6b3:	ba 00 00 00 00       	mov    $0x0,%edx
     6b8:	f7 75 c4             	divl   -0x3c(%ebp)
     6bb:	6b c0 10             	imul   $0x10,%eax,%eax
     6be:	29 c4                	sub    %eax,%esp
     6c0:	8d 44 24 0c          	lea    0xc(%esp),%eax
     6c4:	83 c0 0f             	add    $0xf,%eax
     6c7:	c1 e8 04             	shr    $0x4,%eax
     6ca:	c1 e0 04             	shl    $0x4,%eax
     6cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int studTid[S];
     6d0:	a1 ec 1d 00 00       	mov    0x1dec,%eax
     6d5:	8d 50 ff             	lea    -0x1(%eax),%edx
     6d8:	89 55 e0             	mov    %edx,-0x20(%ebp)
     6db:	c1 e0 02             	shl    $0x2,%eax
     6de:	8d 50 0f             	lea    0xf(%eax),%edx
     6e1:	b8 10 00 00 00       	mov    $0x10,%eax
     6e6:	83 e8 01             	sub    $0x1,%eax
     6e9:	01 d0                	add    %edx,%eax
     6eb:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
     6f2:	ba 00 00 00 00       	mov    $0x0,%edx
     6f7:	f7 75 c4             	divl   -0x3c(%ebp)
     6fa:	6b c0 10             	imul   $0x10,%eax,%eax
     6fd:	29 c4                	sub    %eax,%esp
     6ff:	8d 44 24 0c          	lea    0xc(%esp),%eax
     703:	83 c0 0f             	add    $0xf,%eax
     706:	c1 e8 04             	shr    $0x4,%eax
     709:	c1 e0 04             	shl    $0x4,%eax
     70c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  int i = 0;  
     70f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  bouncer = semaphore_create(M);
     716:	a1 04 1e 00 00       	mov    0x1e04,%eax
     71b:	89 04 24             	mov    %eax,(%esp)
     71e:	e8 e1 0b 00 00       	call   1304 <semaphore_create>
     723:	a3 e4 1d 00 00       	mov    %eax,0x1de4
  cupsem = semaphore_create(1);
     728:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     72f:	e8 d0 0b 00 00       	call   1304 <semaphore_create>
     734:	a3 08 1e 00 00       	mov    %eax,0x1e08
  ABB = BB_create(A,"ABB");
     739:	a1 e0 1d 00 00       	mov    0x1de0,%eax
     73e:	c7 44 24 04 fe 17 00 	movl   $0x17fe,0x4(%esp)
     745:	00 
     746:	89 04 24             	mov    %eax,(%esp)
     749:	e8 da 0c 00 00       	call   1428 <BB_create>
     74e:	a3 f4 1d 00 00       	mov    %eax,0x1df4
  DrinkBB = BB_create(A,"DrinkBB");
     753:	a1 e0 1d 00 00       	mov    0x1de0,%eax
     758:	c7 44 24 04 02 18 00 	movl   $0x1802,0x4(%esp)
     75f:	00 
     760:	89 04 24             	mov    %eax,(%esp)
     763:	e8 c0 0c 00 00       	call   1428 <BB_create>
     768:	a3 00 1e 00 00       	mov    %eax,0x1e00
  CBB = BB_create(C,"CBB");
     76d:	a1 f8 1d 00 00       	mov    0x1df8,%eax
     772:	c7 44 24 04 0a 18 00 	movl   $0x180a,0x4(%esp)
     779:	00 
     77a:	89 04 24             	mov    %eax,(%esp)
     77d:	e8 a6 0c 00 00       	call   1428 <BB_create>
     782:	a3 0c 1e 00 00       	mov    %eax,0x1e0c
  DBB = BB_create(C,"DBB");
     787:	a1 f8 1d 00 00       	mov    0x1df8,%eax
     78c:	c7 44 24 04 0e 18 00 	movl   $0x180e,0x4(%esp)
     793:	00 
     794:	89 04 24             	mov    %eax,(%esp)
     797:	e8 8c 0c 00 00       	call   1428 <BB_create>
     79c:	a3 fc 1d 00 00       	mov    %eax,0x1dfc
  struct Cup* cups[C];
     7a1:	a1 f8 1d 00 00       	mov    0x1df8,%eax
     7a6:	8d 50 ff             	lea    -0x1(%eax),%edx
     7a9:	89 55 d8             	mov    %edx,-0x28(%ebp)
     7ac:	c1 e0 02             	shl    $0x2,%eax
     7af:	8d 50 0f             	lea    0xf(%eax),%edx
     7b2:	b8 10 00 00 00       	mov    $0x10,%eax
     7b7:	83 e8 01             	sub    $0x1,%eax
     7ba:	01 d0                	add    %edx,%eax
     7bc:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
     7c3:	ba 00 00 00 00       	mov    $0x0,%edx
     7c8:	f7 75 c4             	divl   -0x3c(%ebp)
     7cb:	6b c0 10             	imul   $0x10,%eax,%eax
     7ce:	29 c4                	sub    %eax,%esp
     7d0:	8d 44 24 0c          	lea    0xc(%esp),%eax
     7d4:	83 c0 0f             	add    $0xf,%eax
     7d7:	c1 e8 04             	shr    $0x4,%eax
     7da:	c1 e0 04             	shl    $0x4,%eax
     7dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  for(;i<C;i++)
     7e0:	eb 41                	jmp    823 <main+0x259>
  {
    cups[i] = malloc(sizeof(struct Cup));
     7e2:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     7e9:	e8 35 0a 00 00       	call   1223 <malloc>
     7ee:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     7f1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     7f4:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    cups[i]->id = i;
     7f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     7fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
     7fd:	8b 04 90             	mov    (%eax,%edx,4),%eax
     800:	8b 55 f4             	mov    -0xc(%ebp),%edx
     803:	89 10                	mov    %edx,(%eax)
    BB_put(CBB,cups[i]);
     805:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     808:	8b 55 f4             	mov    -0xc(%ebp),%edx
     80b:	8b 14 90             	mov    (%eax,%edx,4),%edx
     80e:	a1 0c 1e 00 00       	mov    0x1e0c,%eax
     813:	89 54 24 04          	mov    %edx,0x4(%esp)
     817:	89 04 24             	mov    %eax,(%esp)
     81a:	e8 00 0d 00 00       	call   151f <BB_put>
  DrinkBB = BB_create(A,"DrinkBB");
  CBB = BB_create(C,"CBB");
  DBB = BB_create(C,"DBB");
  struct Cup* cups[C];
  
  for(;i<C;i++)
     81f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     823:	a1 f8 1d 00 00       	mov    0x1df8,%eax
     828:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     82b:	7c b5                	jl     7e2 <main+0x218>
    cups[i] = malloc(sizeof(struct Cup));
    cups[i]->id = i;
    BB_put(CBB,cups[i]);
  }
  
  void* cupStack = malloc(1024);
     82d:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
     834:	e8 ea 09 00 00       	call   1223 <malloc>
     839:	89 45 d0             	mov    %eax,-0x30(%ebp)
  memset(cupStack,0,1024);
     83c:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
     843:	00 
     844:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     84b:	00 
     84c:	8b 45 d0             	mov    -0x30(%ebp),%eax
     84f:	89 04 24             	mov    %eax,(%esp)
     852:	e8 8c 03 00 00       	call   be3 <memset>
  if(thread_create(cupboy_func,cupStack,1024) < 0)
     857:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
     85e:	00 
     85f:	8b 45 d0             	mov    -0x30(%ebp),%eax
     862:	89 44 24 04          	mov    %eax,0x4(%esp)
     866:	c7 04 24 33 05 00 00 	movl   $0x533,(%esp)
     86d:	e8 b6 05 00 00       	call   e28 <thread_create>
     872:	85 c0                	test   %eax,%eax
     874:	79 19                	jns    88f <main+0x2c5>
  {
    printf(1,"Failed to create cupboy thread. Exiting...\n");
     876:	c7 44 24 04 14 18 00 	movl   $0x1814,0x4(%esp)
     87d:	00 
     87e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     885:	e8 b5 06 00 00       	call   f3f <printf>
    exit();
     88a:	e8 f9 04 00 00       	call   d88 <exit>
  }
  
  for(i=0;i<B;i++)
     88f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     896:	e9 82 00 00 00       	jmp    91d <main+0x353>
  {
    barStack[i] = malloc(1024);
     89b:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
     8a2:	e8 7c 09 00 00       	call   1223 <malloc>
     8a7:	8b 55 ec             	mov    -0x14(%ebp),%edx
     8aa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     8ad:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    memset(barStack[i],0,1024);
     8b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
     8b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8b6:	8b 04 90             	mov    (%eax,%edx,4),%eax
     8b9:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
     8c0:	00 
     8c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     8c8:	00 
     8c9:	89 04 24             	mov    %eax,(%esp)
     8cc:	e8 12 03 00 00       	call   be3 <memset>
    if(thread_create(bartender_func,barStack[i],1024) < 0)
     8d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
     8d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8d7:	8b 04 90             	mov    (%eax,%edx,4),%eax
     8da:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
     8e1:	00 
     8e2:	89 44 24 04          	mov    %eax,0x4(%esp)
     8e6:	c7 04 24 16 04 00 00 	movl   $0x416,(%esp)
     8ed:	e8 36 05 00 00       	call   e28 <thread_create>
     8f2:	85 c0                	test   %eax,%eax
     8f4:	79 23                	jns    919 <main+0x34f>
    {
      printf(1,"Failed to create bartender thread #%d. Exiting...\n",i+1);
     8f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8f9:	83 c0 01             	add    $0x1,%eax
     8fc:	89 44 24 08          	mov    %eax,0x8(%esp)
     900:	c7 44 24 04 40 18 00 	movl   $0x1840,0x4(%esp)
     907:	00 
     908:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     90f:	e8 2b 06 00 00       	call   f3f <printf>
      exit();
     914:	e8 6f 04 00 00       	call   d88 <exit>
  {
    printf(1,"Failed to create cupboy thread. Exiting...\n");
    exit();
  }
  
  for(i=0;i<B;i++)
     919:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     91d:	a1 f0 1d 00 00       	mov    0x1df0,%eax
     922:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     925:	0f 8c 70 ff ff ff    	jl     89b <main+0x2d1>
      printf(1,"Failed to create bartender thread #%d. Exiting...\n",i+1);
      exit();
    } 
  }
  
  for(i=0;i<S;i++)
     92b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     932:	e9 94 00 00 00       	jmp    9cb <main+0x401>
  {
    studStack[i] = malloc(1024);
     937:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
     93e:	e8 e0 08 00 00       	call   1223 <malloc>
     943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     946:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     949:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    memset(studStack[i],0,1024);
     94c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     94f:	8b 55 f4             	mov    -0xc(%ebp),%edx
     952:	8b 04 90             	mov    (%eax,%edx,4),%eax
     955:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
     95c:	00 
     95d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     964:	00 
     965:	89 04 24             	mov    %eax,(%esp)
     968:	e8 76 02 00 00       	call   be3 <memset>
    if((studTid[i] = thread_create(student_func,studStack[i],1024)) < 0)
     96d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     970:	8b 55 f4             	mov    -0xc(%ebp),%edx
     973:	8b 04 90             	mov    (%eax,%edx,4),%eax
     976:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
     97d:	00 
     97e:	89 44 24 04          	mov    %eax,0x4(%esp)
     982:	c7 04 24 b2 02 00 00 	movl   $0x2b2,(%esp)
     989:	e8 9a 04 00 00       	call   e28 <thread_create>
     98e:	8b 55 dc             	mov    -0x24(%ebp),%edx
     991:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     994:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
     997:	8b 45 dc             	mov    -0x24(%ebp),%eax
     99a:	8b 55 f4             	mov    -0xc(%ebp),%edx
     99d:	8b 04 90             	mov    (%eax,%edx,4),%eax
     9a0:	85 c0                	test   %eax,%eax
     9a2:	79 23                	jns    9c7 <main+0x3fd>
    {
      printf(1,"Failed to create student thread #%d. Exiting...\n",i+1);
     9a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9a7:	83 c0 01             	add    $0x1,%eax
     9aa:	89 44 24 08          	mov    %eax,0x8(%esp)
     9ae:	c7 44 24 04 74 18 00 	movl   $0x1874,0x4(%esp)
     9b5:	00 
     9b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9bd:	e8 7d 05 00 00       	call   f3f <printf>
      exit();
     9c2:	e8 c1 03 00 00       	call   d88 <exit>
      printf(1,"Failed to create bartender thread #%d. Exiting...\n",i+1);
      exit();
    } 
  }
  
  for(i=0;i<S;i++)
     9c7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     9cb:	a1 ec 1d 00 00       	mov    0x1dec,%eax
     9d0:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     9d3:	0f 8c 5e ff ff ff    	jl     937 <main+0x36d>
      printf(1,"Failed to create student thread #%d. Exiting...\n",i+1);
      exit();
    } 
  }

  for(i=0;i<S;i++)
     9d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     9e0:	eb 55                	jmp    a37 <main+0x46d>
  {
    if(thread_join(studTid[i],0) != 0)
     9e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
     9e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9e8:	8b 04 90             	mov    (%eax,%edx,4),%eax
     9eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     9f2:	00 
     9f3:	89 04 24             	mov    %eax,(%esp)
     9f6:	e8 45 04 00 00       	call   e40 <thread_join>
     9fb:	85 c0                	test   %eax,%eax
     9fd:	74 23                	je     a22 <main+0x458>
    {
      printf(1,"Failed to join on student thread #%d. Exiting...\n",i+1);
     9ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
     a02:	83 c0 01             	add    $0x1,%eax
     a05:	89 44 24 08          	mov    %eax,0x8(%esp)
     a09:	c7 44 24 04 a8 18 00 	movl   $0x18a8,0x4(%esp)
     a10:	00 
     a11:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     a18:	e8 22 05 00 00       	call   f3f <printf>
      exit();
     a1d:	e8 66 03 00 00       	call   d88 <exit>
    }
    
    free(studStack[i]);
     a22:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     a25:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a28:	8b 04 90             	mov    (%eax,%edx,4),%eax
     a2b:	89 04 24             	mov    %eax,(%esp)
     a2e:	e8 c1 06 00 00       	call   10f4 <free>
      printf(1,"Failed to create student thread #%d. Exiting...\n",i+1);
      exit();
    } 
  }

  for(i=0;i<S;i++)
     a33:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a37:	a1 ec 1d 00 00       	mov    0x1dec,%eax
     a3c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     a3f:	7c a1                	jl     9e2 <main+0x418>
    }
    
    free(studStack[i]);
  }
  
  for(i=0;i<B;i++)
     a41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     a48:	eb 15                	jmp    a5f <main+0x495>
    free(barStack[i]);
     a4a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     a4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a50:	8b 04 90             	mov    (%eax,%edx,4),%eax
     a53:	89 04 24             	mov    %eax,(%esp)
     a56:	e8 99 06 00 00       	call   10f4 <free>
    }
    
    free(studStack[i]);
  }
  
  for(i=0;i<B;i++)
     a5b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a5f:	a1 f0 1d 00 00       	mov    0x1df0,%eax
     a64:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     a67:	7c e1                	jl     a4a <main+0x480>
    free(barStack[i]);
  free(cupStack);
     a69:	8b 45 d0             	mov    -0x30(%ebp),%eax
     a6c:	89 04 24             	mov    %eax,(%esp)
     a6f:	e8 80 06 00 00       	call   10f4 <free>
  
  for(i=0;i<C;i++)
     a74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     a7b:	eb 15                	jmp    a92 <main+0x4c8>
    free(cups[i]);
     a7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     a80:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a83:	8b 04 90             	mov    (%eax,%edx,4),%eax
     a86:	89 04 24             	mov    %eax,(%esp)
     a89:	e8 66 06 00 00       	call   10f4 <free>
  
  for(i=0;i<B;i++)
    free(barStack[i]);
  free(cupStack);
  
  for(i=0;i<C;i++)
     a8e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a92:	a1 f8 1d 00 00       	mov    0x1df8,%eax
     a97:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     a9a:	7c e1                	jl     a7d <main+0x4b3>
    free(cups[i]);
  

  free(CBB->elements);
     a9c:	a1 0c 1e 00 00       	mov    0x1e0c,%eax
     aa1:	8b 40 1c             	mov    0x1c(%eax),%eax
     aa4:	89 04 24             	mov    %eax,(%esp)
     aa7:	e8 48 06 00 00       	call   10f4 <free>
  free(DBB->elements);
     aac:	a1 fc 1d 00 00       	mov    0x1dfc,%eax
     ab1:	8b 40 1c             	mov    0x1c(%eax),%eax
     ab4:	89 04 24             	mov    %eax,(%esp)
     ab7:	e8 38 06 00 00       	call   10f4 <free>
  free(CBB);
     abc:	a1 0c 1e 00 00       	mov    0x1e0c,%eax
     ac1:	89 04 24             	mov    %eax,(%esp)
     ac4:	e8 2b 06 00 00       	call   10f4 <free>
  free(DBB);
     ac9:	a1 fc 1d 00 00       	mov    0x1dfc,%eax
     ace:	89 04 24             	mov    %eax,(%esp)
     ad1:	e8 1e 06 00 00       	call   10f4 <free>
  
  free(ABB->elements);
     ad6:	a1 f4 1d 00 00       	mov    0x1df4,%eax
     adb:	8b 40 1c             	mov    0x1c(%eax),%eax
     ade:	89 04 24             	mov    %eax,(%esp)
     ae1:	e8 0e 06 00 00       	call   10f4 <free>
  free(DrinkBB->elements);
     ae6:	a1 00 1e 00 00       	mov    0x1e00,%eax
     aeb:	8b 40 1c             	mov    0x1c(%eax),%eax
     aee:	89 04 24             	mov    %eax,(%esp)
     af1:	e8 fe 05 00 00       	call   10f4 <free>
  free(ABB);
     af6:	a1 f4 1d 00 00       	mov    0x1df4,%eax
     afb:	89 04 24             	mov    %eax,(%esp)
     afe:	e8 f1 05 00 00       	call   10f4 <free>
  free(DrinkBB);
     b03:	a1 00 1e 00 00       	mov    0x1e00,%eax
     b08:	89 04 24             	mov    %eax,(%esp)
     b0b:	e8 e4 05 00 00       	call   10f4 <free>

  exit();
     b10:	e8 73 02 00 00       	call   d88 <exit>
     b15:	89 dc                	mov    %ebx,%esp
  return 0;
}
     b17:	8d 65 f8             	lea    -0x8(%ebp),%esp
     b1a:	59                   	pop    %ecx
     b1b:	5b                   	pop    %ebx
     b1c:	5d                   	pop    %ebp
     b1d:	8d 61 fc             	lea    -0x4(%ecx),%esp
     b20:	c3                   	ret    
     b21:	90                   	nop
     b22:	90                   	nop
     b23:	90                   	nop

00000b24 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     b24:	55                   	push   %ebp
     b25:	89 e5                	mov    %esp,%ebp
     b27:	57                   	push   %edi
     b28:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     b29:	8b 4d 08             	mov    0x8(%ebp),%ecx
     b2c:	8b 55 10             	mov    0x10(%ebp),%edx
     b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
     b32:	89 cb                	mov    %ecx,%ebx
     b34:	89 df                	mov    %ebx,%edi
     b36:	89 d1                	mov    %edx,%ecx
     b38:	fc                   	cld    
     b39:	f3 aa                	rep stos %al,%es:(%edi)
     b3b:	89 ca                	mov    %ecx,%edx
     b3d:	89 fb                	mov    %edi,%ebx
     b3f:	89 5d 08             	mov    %ebx,0x8(%ebp)
     b42:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     b45:	5b                   	pop    %ebx
     b46:	5f                   	pop    %edi
     b47:	5d                   	pop    %ebp
     b48:	c3                   	ret    

00000b49 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     b49:	55                   	push   %ebp
     b4a:	89 e5                	mov    %esp,%ebp
     b4c:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     b4f:	8b 45 08             	mov    0x8(%ebp),%eax
     b52:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     b55:	90                   	nop
     b56:	8b 45 0c             	mov    0xc(%ebp),%eax
     b59:	0f b6 10             	movzbl (%eax),%edx
     b5c:	8b 45 08             	mov    0x8(%ebp),%eax
     b5f:	88 10                	mov    %dl,(%eax)
     b61:	8b 45 08             	mov    0x8(%ebp),%eax
     b64:	0f b6 00             	movzbl (%eax),%eax
     b67:	84 c0                	test   %al,%al
     b69:	0f 95 c0             	setne  %al
     b6c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     b70:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     b74:	84 c0                	test   %al,%al
     b76:	75 de                	jne    b56 <strcpy+0xd>
    ;
  return os;
     b78:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     b7b:	c9                   	leave  
     b7c:	c3                   	ret    

00000b7d <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b7d:	55                   	push   %ebp
     b7e:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     b80:	eb 08                	jmp    b8a <strcmp+0xd>
    p++, q++;
     b82:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     b86:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     b8a:	8b 45 08             	mov    0x8(%ebp),%eax
     b8d:	0f b6 00             	movzbl (%eax),%eax
     b90:	84 c0                	test   %al,%al
     b92:	74 10                	je     ba4 <strcmp+0x27>
     b94:	8b 45 08             	mov    0x8(%ebp),%eax
     b97:	0f b6 10             	movzbl (%eax),%edx
     b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
     b9d:	0f b6 00             	movzbl (%eax),%eax
     ba0:	38 c2                	cmp    %al,%dl
     ba2:	74 de                	je     b82 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     ba4:	8b 45 08             	mov    0x8(%ebp),%eax
     ba7:	0f b6 00             	movzbl (%eax),%eax
     baa:	0f b6 d0             	movzbl %al,%edx
     bad:	8b 45 0c             	mov    0xc(%ebp),%eax
     bb0:	0f b6 00             	movzbl (%eax),%eax
     bb3:	0f b6 c0             	movzbl %al,%eax
     bb6:	89 d1                	mov    %edx,%ecx
     bb8:	29 c1                	sub    %eax,%ecx
     bba:	89 c8                	mov    %ecx,%eax
}
     bbc:	5d                   	pop    %ebp
     bbd:	c3                   	ret    

00000bbe <strlen>:

uint
strlen(char *s)
{
     bbe:	55                   	push   %ebp
     bbf:	89 e5                	mov    %esp,%ebp
     bc1:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     bc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     bcb:	eb 04                	jmp    bd1 <strlen+0x13>
     bcd:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     bd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
     bd4:	03 45 08             	add    0x8(%ebp),%eax
     bd7:	0f b6 00             	movzbl (%eax),%eax
     bda:	84 c0                	test   %al,%al
     bdc:	75 ef                	jne    bcd <strlen+0xf>
    ;
  return n;
     bde:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     be1:	c9                   	leave  
     be2:	c3                   	ret    

00000be3 <memset>:

void*
memset(void *dst, int c, uint n)
{
     be3:	55                   	push   %ebp
     be4:	89 e5                	mov    %esp,%ebp
     be6:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     be9:	8b 45 10             	mov    0x10(%ebp),%eax
     bec:	89 44 24 08          	mov    %eax,0x8(%esp)
     bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
     bf3:	89 44 24 04          	mov    %eax,0x4(%esp)
     bf7:	8b 45 08             	mov    0x8(%ebp),%eax
     bfa:	89 04 24             	mov    %eax,(%esp)
     bfd:	e8 22 ff ff ff       	call   b24 <stosb>
  return dst;
     c02:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c05:	c9                   	leave  
     c06:	c3                   	ret    

00000c07 <strchr>:

char*
strchr(const char *s, char c)
{
     c07:	55                   	push   %ebp
     c08:	89 e5                	mov    %esp,%ebp
     c0a:	83 ec 04             	sub    $0x4,%esp
     c0d:	8b 45 0c             	mov    0xc(%ebp),%eax
     c10:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     c13:	eb 14                	jmp    c29 <strchr+0x22>
    if(*s == c)
     c15:	8b 45 08             	mov    0x8(%ebp),%eax
     c18:	0f b6 00             	movzbl (%eax),%eax
     c1b:	3a 45 fc             	cmp    -0x4(%ebp),%al
     c1e:	75 05                	jne    c25 <strchr+0x1e>
      return (char*)s;
     c20:	8b 45 08             	mov    0x8(%ebp),%eax
     c23:	eb 13                	jmp    c38 <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     c25:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     c29:	8b 45 08             	mov    0x8(%ebp),%eax
     c2c:	0f b6 00             	movzbl (%eax),%eax
     c2f:	84 c0                	test   %al,%al
     c31:	75 e2                	jne    c15 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     c33:	b8 00 00 00 00       	mov    $0x0,%eax
}
     c38:	c9                   	leave  
     c39:	c3                   	ret    

00000c3a <gets>:

char*
gets(char *buf, int max)
{
     c3a:	55                   	push   %ebp
     c3b:	89 e5                	mov    %esp,%ebp
     c3d:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     c47:	eb 44                	jmp    c8d <gets+0x53>
    cc = read(0, &c, 1);
     c49:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     c50:	00 
     c51:	8d 45 ef             	lea    -0x11(%ebp),%eax
     c54:	89 44 24 04          	mov    %eax,0x4(%esp)
     c58:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c5f:	e8 3c 01 00 00       	call   da0 <read>
     c64:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     c67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c6b:	7e 2d                	jle    c9a <gets+0x60>
      break;
    buf[i++] = c;
     c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c70:	03 45 08             	add    0x8(%ebp),%eax
     c73:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
     c77:	88 10                	mov    %dl,(%eax)
     c79:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
     c7d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     c81:	3c 0a                	cmp    $0xa,%al
     c83:	74 16                	je     c9b <gets+0x61>
     c85:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     c89:	3c 0d                	cmp    $0xd,%al
     c8b:	74 0e                	je     c9b <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c90:	83 c0 01             	add    $0x1,%eax
     c93:	3b 45 0c             	cmp    0xc(%ebp),%eax
     c96:	7c b1                	jl     c49 <gets+0xf>
     c98:	eb 01                	jmp    c9b <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     c9a:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c9e:	03 45 08             	add    0x8(%ebp),%eax
     ca1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     ca4:	8b 45 08             	mov    0x8(%ebp),%eax
}
     ca7:	c9                   	leave  
     ca8:	c3                   	ret    

00000ca9 <stat>:

int
stat(char *n, struct stat *st)
{
     ca9:	55                   	push   %ebp
     caa:	89 e5                	mov    %esp,%ebp
     cac:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     caf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     cb6:	00 
     cb7:	8b 45 08             	mov    0x8(%ebp),%eax
     cba:	89 04 24             	mov    %eax,(%esp)
     cbd:	e8 06 01 00 00       	call   dc8 <open>
     cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     cc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     cc9:	79 07                	jns    cd2 <stat+0x29>
    return -1;
     ccb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     cd0:	eb 23                	jmp    cf5 <stat+0x4c>
  r = fstat(fd, st);
     cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
     cd5:	89 44 24 04          	mov    %eax,0x4(%esp)
     cd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cdc:	89 04 24             	mov    %eax,(%esp)
     cdf:	e8 fc 00 00 00       	call   de0 <fstat>
     ce4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     ce7:	8b 45 f4             	mov    -0xc(%ebp),%eax
     cea:	89 04 24             	mov    %eax,(%esp)
     ced:	e8 be 00 00 00       	call   db0 <close>
  return r;
     cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     cf5:	c9                   	leave  
     cf6:	c3                   	ret    

00000cf7 <atoi>:

int
atoi(const char *s)
{
     cf7:	55                   	push   %ebp
     cf8:	89 e5                	mov    %esp,%ebp
     cfa:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     cfd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     d04:	eb 23                	jmp    d29 <atoi+0x32>
    n = n*10 + *s++ - '0';
     d06:	8b 55 fc             	mov    -0x4(%ebp),%edx
     d09:	89 d0                	mov    %edx,%eax
     d0b:	c1 e0 02             	shl    $0x2,%eax
     d0e:	01 d0                	add    %edx,%eax
     d10:	01 c0                	add    %eax,%eax
     d12:	89 c2                	mov    %eax,%edx
     d14:	8b 45 08             	mov    0x8(%ebp),%eax
     d17:	0f b6 00             	movzbl (%eax),%eax
     d1a:	0f be c0             	movsbl %al,%eax
     d1d:	01 d0                	add    %edx,%eax
     d1f:	83 e8 30             	sub    $0x30,%eax
     d22:	89 45 fc             	mov    %eax,-0x4(%ebp)
     d25:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     d29:	8b 45 08             	mov    0x8(%ebp),%eax
     d2c:	0f b6 00             	movzbl (%eax),%eax
     d2f:	3c 2f                	cmp    $0x2f,%al
     d31:	7e 0a                	jle    d3d <atoi+0x46>
     d33:	8b 45 08             	mov    0x8(%ebp),%eax
     d36:	0f b6 00             	movzbl (%eax),%eax
     d39:	3c 39                	cmp    $0x39,%al
     d3b:	7e c9                	jle    d06 <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     d3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     d40:	c9                   	leave  
     d41:	c3                   	ret    

00000d42 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     d42:	55                   	push   %ebp
     d43:	89 e5                	mov    %esp,%ebp
     d45:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     d48:	8b 45 08             	mov    0x8(%ebp),%eax
     d4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
     d51:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     d54:	eb 13                	jmp    d69 <memmove+0x27>
    *dst++ = *src++;
     d56:	8b 45 f8             	mov    -0x8(%ebp),%eax
     d59:	0f b6 10             	movzbl (%eax),%edx
     d5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
     d5f:	88 10                	mov    %dl,(%eax)
     d61:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     d65:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     d6d:	0f 9f c0             	setg   %al
     d70:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     d74:	84 c0                	test   %al,%al
     d76:	75 de                	jne    d56 <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     d78:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d7b:	c9                   	leave  
     d7c:	c3                   	ret    
     d7d:	90                   	nop
     d7e:	90                   	nop
     d7f:	90                   	nop

00000d80 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     d80:	b8 01 00 00 00       	mov    $0x1,%eax
     d85:	cd 40                	int    $0x40
     d87:	c3                   	ret    

00000d88 <exit>:
SYSCALL(exit)
     d88:	b8 02 00 00 00       	mov    $0x2,%eax
     d8d:	cd 40                	int    $0x40
     d8f:	c3                   	ret    

00000d90 <wait>:
SYSCALL(wait)
     d90:	b8 03 00 00 00       	mov    $0x3,%eax
     d95:	cd 40                	int    $0x40
     d97:	c3                   	ret    

00000d98 <pipe>:
SYSCALL(pipe)
     d98:	b8 04 00 00 00       	mov    $0x4,%eax
     d9d:	cd 40                	int    $0x40
     d9f:	c3                   	ret    

00000da0 <read>:
SYSCALL(read)
     da0:	b8 05 00 00 00       	mov    $0x5,%eax
     da5:	cd 40                	int    $0x40
     da7:	c3                   	ret    

00000da8 <write>:
SYSCALL(write)
     da8:	b8 10 00 00 00       	mov    $0x10,%eax
     dad:	cd 40                	int    $0x40
     daf:	c3                   	ret    

00000db0 <close>:
SYSCALL(close)
     db0:	b8 15 00 00 00       	mov    $0x15,%eax
     db5:	cd 40                	int    $0x40
     db7:	c3                   	ret    

00000db8 <kill>:
SYSCALL(kill)
     db8:	b8 06 00 00 00       	mov    $0x6,%eax
     dbd:	cd 40                	int    $0x40
     dbf:	c3                   	ret    

00000dc0 <exec>:
SYSCALL(exec)
     dc0:	b8 07 00 00 00       	mov    $0x7,%eax
     dc5:	cd 40                	int    $0x40
     dc7:	c3                   	ret    

00000dc8 <open>:
SYSCALL(open)
     dc8:	b8 0f 00 00 00       	mov    $0xf,%eax
     dcd:	cd 40                	int    $0x40
     dcf:	c3                   	ret    

00000dd0 <mknod>:
SYSCALL(mknod)
     dd0:	b8 11 00 00 00       	mov    $0x11,%eax
     dd5:	cd 40                	int    $0x40
     dd7:	c3                   	ret    

00000dd8 <unlink>:
SYSCALL(unlink)
     dd8:	b8 12 00 00 00       	mov    $0x12,%eax
     ddd:	cd 40                	int    $0x40
     ddf:	c3                   	ret    

00000de0 <fstat>:
SYSCALL(fstat)
     de0:	b8 08 00 00 00       	mov    $0x8,%eax
     de5:	cd 40                	int    $0x40
     de7:	c3                   	ret    

00000de8 <link>:
SYSCALL(link)
     de8:	b8 13 00 00 00       	mov    $0x13,%eax
     ded:	cd 40                	int    $0x40
     def:	c3                   	ret    

00000df0 <mkdir>:
SYSCALL(mkdir)
     df0:	b8 14 00 00 00       	mov    $0x14,%eax
     df5:	cd 40                	int    $0x40
     df7:	c3                   	ret    

00000df8 <chdir>:
SYSCALL(chdir)
     df8:	b8 09 00 00 00       	mov    $0x9,%eax
     dfd:	cd 40                	int    $0x40
     dff:	c3                   	ret    

00000e00 <dup>:
SYSCALL(dup)
     e00:	b8 0a 00 00 00       	mov    $0xa,%eax
     e05:	cd 40                	int    $0x40
     e07:	c3                   	ret    

00000e08 <getpid>:
SYSCALL(getpid)
     e08:	b8 0b 00 00 00       	mov    $0xb,%eax
     e0d:	cd 40                	int    $0x40
     e0f:	c3                   	ret    

00000e10 <sbrk>:
SYSCALL(sbrk)
     e10:	b8 0c 00 00 00       	mov    $0xc,%eax
     e15:	cd 40                	int    $0x40
     e17:	c3                   	ret    

00000e18 <sleep>:
SYSCALL(sleep)
     e18:	b8 0d 00 00 00       	mov    $0xd,%eax
     e1d:	cd 40                	int    $0x40
     e1f:	c3                   	ret    

00000e20 <uptime>:
SYSCALL(uptime)
     e20:	b8 0e 00 00 00       	mov    $0xe,%eax
     e25:	cd 40                	int    $0x40
     e27:	c3                   	ret    

00000e28 <thread_create>:
SYSCALL(thread_create)
     e28:	b8 16 00 00 00       	mov    $0x16,%eax
     e2d:	cd 40                	int    $0x40
     e2f:	c3                   	ret    

00000e30 <thread_getId>:
SYSCALL(thread_getId)
     e30:	b8 17 00 00 00       	mov    $0x17,%eax
     e35:	cd 40                	int    $0x40
     e37:	c3                   	ret    

00000e38 <thread_getProcId>:
SYSCALL(thread_getProcId)
     e38:	b8 18 00 00 00       	mov    $0x18,%eax
     e3d:	cd 40                	int    $0x40
     e3f:	c3                   	ret    

00000e40 <thread_join>:
SYSCALL(thread_join)
     e40:	b8 19 00 00 00       	mov    $0x19,%eax
     e45:	cd 40                	int    $0x40
     e47:	c3                   	ret    

00000e48 <thread_exit>:
SYSCALL(thread_exit)
     e48:	b8 1a 00 00 00       	mov    $0x1a,%eax
     e4d:	cd 40                	int    $0x40
     e4f:	c3                   	ret    

00000e50 <binary_semaphore_create>:
SYSCALL(binary_semaphore_create)
     e50:	b8 1b 00 00 00       	mov    $0x1b,%eax
     e55:	cd 40                	int    $0x40
     e57:	c3                   	ret    

00000e58 <binary_semaphore_down>:
SYSCALL(binary_semaphore_down)
     e58:	b8 1c 00 00 00       	mov    $0x1c,%eax
     e5d:	cd 40                	int    $0x40
     e5f:	c3                   	ret    

00000e60 <binary_semaphore_up>:
SYSCALL(binary_semaphore_up)
     e60:	b8 1d 00 00 00       	mov    $0x1d,%eax
     e65:	cd 40                	int    $0x40
     e67:	c3                   	ret    

00000e68 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     e68:	55                   	push   %ebp
     e69:	89 e5                	mov    %esp,%ebp
     e6b:	83 ec 28             	sub    $0x28,%esp
     e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
     e71:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     e74:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e7b:	00 
     e7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
     e7f:	89 44 24 04          	mov    %eax,0x4(%esp)
     e83:	8b 45 08             	mov    0x8(%ebp),%eax
     e86:	89 04 24             	mov    %eax,(%esp)
     e89:	e8 1a ff ff ff       	call   da8 <write>
}
     e8e:	c9                   	leave  
     e8f:	c3                   	ret    

00000e90 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e90:	55                   	push   %ebp
     e91:	89 e5                	mov    %esp,%ebp
     e93:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     e96:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     e9d:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     ea1:	74 17                	je     eba <printint+0x2a>
     ea3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     ea7:	79 11                	jns    eba <printint+0x2a>
    neg = 1;
     ea9:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     eb0:	8b 45 0c             	mov    0xc(%ebp),%eax
     eb3:	f7 d8                	neg    %eax
     eb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
     eb8:	eb 06                	jmp    ec0 <printint+0x30>
  } else {
    x = xx;
     eba:	8b 45 0c             	mov    0xc(%ebp),%eax
     ebd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     ec0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     ec7:	8b 4d 10             	mov    0x10(%ebp),%ecx
     eca:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ecd:	ba 00 00 00 00       	mov    $0x0,%edx
     ed2:	f7 f1                	div    %ecx
     ed4:	89 d0                	mov    %edx,%eax
     ed6:	0f b6 90 c0 1d 00 00 	movzbl 0x1dc0(%eax),%edx
     edd:	8d 45 dc             	lea    -0x24(%ebp),%eax
     ee0:	03 45 f4             	add    -0xc(%ebp),%eax
     ee3:	88 10                	mov    %dl,(%eax)
     ee5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
     ee9:	8b 55 10             	mov    0x10(%ebp),%edx
     eec:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     eef:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ef2:	ba 00 00 00 00       	mov    $0x0,%edx
     ef7:	f7 75 d4             	divl   -0x2c(%ebp)
     efa:	89 45 ec             	mov    %eax,-0x14(%ebp)
     efd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f01:	75 c4                	jne    ec7 <printint+0x37>
  if(neg)
     f03:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     f07:	74 2a                	je     f33 <printint+0xa3>
    buf[i++] = '-';
     f09:	8d 45 dc             	lea    -0x24(%ebp),%eax
     f0c:	03 45 f4             	add    -0xc(%ebp),%eax
     f0f:	c6 00 2d             	movb   $0x2d,(%eax)
     f12:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
     f16:	eb 1b                	jmp    f33 <printint+0xa3>
    putc(fd, buf[i]);
     f18:	8d 45 dc             	lea    -0x24(%ebp),%eax
     f1b:	03 45 f4             	add    -0xc(%ebp),%eax
     f1e:	0f b6 00             	movzbl (%eax),%eax
     f21:	0f be c0             	movsbl %al,%eax
     f24:	89 44 24 04          	mov    %eax,0x4(%esp)
     f28:	8b 45 08             	mov    0x8(%ebp),%eax
     f2b:	89 04 24             	mov    %eax,(%esp)
     f2e:	e8 35 ff ff ff       	call   e68 <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     f33:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     f37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     f3b:	79 db                	jns    f18 <printint+0x88>
    putc(fd, buf[i]);
}
     f3d:	c9                   	leave  
     f3e:	c3                   	ret    

00000f3f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     f3f:	55                   	push   %ebp
     f40:	89 e5                	mov    %esp,%ebp
     f42:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     f45:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     f4c:	8d 45 0c             	lea    0xc(%ebp),%eax
     f4f:	83 c0 04             	add    $0x4,%eax
     f52:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     f55:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     f5c:	e9 7d 01 00 00       	jmp    10de <printf+0x19f>
    c = fmt[i] & 0xff;
     f61:	8b 55 0c             	mov    0xc(%ebp),%edx
     f64:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f67:	01 d0                	add    %edx,%eax
     f69:	0f b6 00             	movzbl (%eax),%eax
     f6c:	0f be c0             	movsbl %al,%eax
     f6f:	25 ff 00 00 00       	and    $0xff,%eax
     f74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     f77:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f7b:	75 2c                	jne    fa9 <printf+0x6a>
      if(c == '%'){
     f7d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     f81:	75 0c                	jne    f8f <printf+0x50>
        state = '%';
     f83:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     f8a:	e9 4b 01 00 00       	jmp    10da <printf+0x19b>
      } else {
        putc(fd, c);
     f8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     f92:	0f be c0             	movsbl %al,%eax
     f95:	89 44 24 04          	mov    %eax,0x4(%esp)
     f99:	8b 45 08             	mov    0x8(%ebp),%eax
     f9c:	89 04 24             	mov    %eax,(%esp)
     f9f:	e8 c4 fe ff ff       	call   e68 <putc>
     fa4:	e9 31 01 00 00       	jmp    10da <printf+0x19b>
      }
    } else if(state == '%'){
     fa9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     fad:	0f 85 27 01 00 00    	jne    10da <printf+0x19b>
      if(c == 'd'){
     fb3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     fb7:	75 2d                	jne    fe6 <printf+0xa7>
        printint(fd, *ap, 10, 1);
     fb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fbc:	8b 00                	mov    (%eax),%eax
     fbe:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     fc5:	00 
     fc6:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     fcd:	00 
     fce:	89 44 24 04          	mov    %eax,0x4(%esp)
     fd2:	8b 45 08             	mov    0x8(%ebp),%eax
     fd5:	89 04 24             	mov    %eax,(%esp)
     fd8:	e8 b3 fe ff ff       	call   e90 <printint>
        ap++;
     fdd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     fe1:	e9 ed 00 00 00       	jmp    10d3 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
     fe6:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     fea:	74 06                	je     ff2 <printf+0xb3>
     fec:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     ff0:	75 2d                	jne    101f <printf+0xe0>
        printint(fd, *ap, 16, 0);
     ff2:	8b 45 e8             	mov    -0x18(%ebp),%eax
     ff5:	8b 00                	mov    (%eax),%eax
     ff7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     ffe:	00 
     fff:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
    1006:	00 
    1007:	89 44 24 04          	mov    %eax,0x4(%esp)
    100b:	8b 45 08             	mov    0x8(%ebp),%eax
    100e:	89 04 24             	mov    %eax,(%esp)
    1011:	e8 7a fe ff ff       	call   e90 <printint>
        ap++;
    1016:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    101a:	e9 b4 00 00 00       	jmp    10d3 <printf+0x194>
      } else if(c == 's'){
    101f:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
    1023:	75 46                	jne    106b <printf+0x12c>
        s = (char*)*ap;
    1025:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1028:	8b 00                	mov    (%eax),%eax
    102a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
    102d:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
    1031:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1035:	75 27                	jne    105e <printf+0x11f>
          s = "(null)";
    1037:	c7 45 f4 e8 18 00 00 	movl   $0x18e8,-0xc(%ebp)
        while(*s != 0){
    103e:	eb 1e                	jmp    105e <printf+0x11f>
          putc(fd, *s);
    1040:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1043:	0f b6 00             	movzbl (%eax),%eax
    1046:	0f be c0             	movsbl %al,%eax
    1049:	89 44 24 04          	mov    %eax,0x4(%esp)
    104d:	8b 45 08             	mov    0x8(%ebp),%eax
    1050:	89 04 24             	mov    %eax,(%esp)
    1053:	e8 10 fe ff ff       	call   e68 <putc>
          s++;
    1058:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    105c:	eb 01                	jmp    105f <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    105e:	90                   	nop
    105f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1062:	0f b6 00             	movzbl (%eax),%eax
    1065:	84 c0                	test   %al,%al
    1067:	75 d7                	jne    1040 <printf+0x101>
    1069:	eb 68                	jmp    10d3 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    106b:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    106f:	75 1d                	jne    108e <printf+0x14f>
        putc(fd, *ap);
    1071:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1074:	8b 00                	mov    (%eax),%eax
    1076:	0f be c0             	movsbl %al,%eax
    1079:	89 44 24 04          	mov    %eax,0x4(%esp)
    107d:	8b 45 08             	mov    0x8(%ebp),%eax
    1080:	89 04 24             	mov    %eax,(%esp)
    1083:	e8 e0 fd ff ff       	call   e68 <putc>
        ap++;
    1088:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    108c:	eb 45                	jmp    10d3 <printf+0x194>
      } else if(c == '%'){
    108e:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1092:	75 17                	jne    10ab <printf+0x16c>
        putc(fd, c);
    1094:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1097:	0f be c0             	movsbl %al,%eax
    109a:	89 44 24 04          	mov    %eax,0x4(%esp)
    109e:	8b 45 08             	mov    0x8(%ebp),%eax
    10a1:	89 04 24             	mov    %eax,(%esp)
    10a4:	e8 bf fd ff ff       	call   e68 <putc>
    10a9:	eb 28                	jmp    10d3 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    10ab:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    10b2:	00 
    10b3:	8b 45 08             	mov    0x8(%ebp),%eax
    10b6:	89 04 24             	mov    %eax,(%esp)
    10b9:	e8 aa fd ff ff       	call   e68 <putc>
        putc(fd, c);
    10be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10c1:	0f be c0             	movsbl %al,%eax
    10c4:	89 44 24 04          	mov    %eax,0x4(%esp)
    10c8:	8b 45 08             	mov    0x8(%ebp),%eax
    10cb:	89 04 24             	mov    %eax,(%esp)
    10ce:	e8 95 fd ff ff       	call   e68 <putc>
      }
      state = 0;
    10d3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    10da:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    10de:	8b 55 0c             	mov    0xc(%ebp),%edx
    10e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
    10e4:	01 d0                	add    %edx,%eax
    10e6:	0f b6 00             	movzbl (%eax),%eax
    10e9:	84 c0                	test   %al,%al
    10eb:	0f 85 70 fe ff ff    	jne    f61 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    10f1:	c9                   	leave  
    10f2:	c3                   	ret    
    10f3:	90                   	nop

000010f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10f4:	55                   	push   %ebp
    10f5:	89 e5                	mov    %esp,%ebp
    10f7:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10fa:	8b 45 08             	mov    0x8(%ebp),%eax
    10fd:	83 e8 08             	sub    $0x8,%eax
    1100:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1103:	a1 dc 1d 00 00       	mov    0x1ddc,%eax
    1108:	89 45 fc             	mov    %eax,-0x4(%ebp)
    110b:	eb 24                	jmp    1131 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    110d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1110:	8b 00                	mov    (%eax),%eax
    1112:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1115:	77 12                	ja     1129 <free+0x35>
    1117:	8b 45 f8             	mov    -0x8(%ebp),%eax
    111a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    111d:	77 24                	ja     1143 <free+0x4f>
    111f:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1122:	8b 00                	mov    (%eax),%eax
    1124:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1127:	77 1a                	ja     1143 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1129:	8b 45 fc             	mov    -0x4(%ebp),%eax
    112c:	8b 00                	mov    (%eax),%eax
    112e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    1131:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1134:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    1137:	76 d4                	jbe    110d <free+0x19>
    1139:	8b 45 fc             	mov    -0x4(%ebp),%eax
    113c:	8b 00                	mov    (%eax),%eax
    113e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1141:	76 ca                	jbe    110d <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    1143:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1146:	8b 40 04             	mov    0x4(%eax),%eax
    1149:	c1 e0 03             	shl    $0x3,%eax
    114c:	89 c2                	mov    %eax,%edx
    114e:	03 55 f8             	add    -0x8(%ebp),%edx
    1151:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1154:	8b 00                	mov    (%eax),%eax
    1156:	39 c2                	cmp    %eax,%edx
    1158:	75 24                	jne    117e <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
    115a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    115d:	8b 50 04             	mov    0x4(%eax),%edx
    1160:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1163:	8b 00                	mov    (%eax),%eax
    1165:	8b 40 04             	mov    0x4(%eax),%eax
    1168:	01 c2                	add    %eax,%edx
    116a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    116d:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1170:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1173:	8b 00                	mov    (%eax),%eax
    1175:	8b 10                	mov    (%eax),%edx
    1177:	8b 45 f8             	mov    -0x8(%ebp),%eax
    117a:	89 10                	mov    %edx,(%eax)
    117c:	eb 0a                	jmp    1188 <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
    117e:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1181:	8b 10                	mov    (%eax),%edx
    1183:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1186:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    1188:	8b 45 fc             	mov    -0x4(%ebp),%eax
    118b:	8b 40 04             	mov    0x4(%eax),%eax
    118e:	c1 e0 03             	shl    $0x3,%eax
    1191:	03 45 fc             	add    -0x4(%ebp),%eax
    1194:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    1197:	75 20                	jne    11b9 <free+0xc5>
    p->s.size += bp->s.size;
    1199:	8b 45 fc             	mov    -0x4(%ebp),%eax
    119c:	8b 50 04             	mov    0x4(%eax),%edx
    119f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11a2:	8b 40 04             	mov    0x4(%eax),%eax
    11a5:	01 c2                	add    %eax,%edx
    11a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11aa:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    11ad:	8b 45 f8             	mov    -0x8(%ebp),%eax
    11b0:	8b 10                	mov    (%eax),%edx
    11b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11b5:	89 10                	mov    %edx,(%eax)
    11b7:	eb 08                	jmp    11c1 <free+0xcd>
  } else
    p->s.ptr = bp;
    11b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11bc:	8b 55 f8             	mov    -0x8(%ebp),%edx
    11bf:	89 10                	mov    %edx,(%eax)
  freep = p;
    11c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    11c4:	a3 dc 1d 00 00       	mov    %eax,0x1ddc
}
    11c9:	c9                   	leave  
    11ca:	c3                   	ret    

000011cb <morecore>:

static Header*
morecore(uint nu)
{
    11cb:	55                   	push   %ebp
    11cc:	89 e5                	mov    %esp,%ebp
    11ce:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    11d1:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    11d8:	77 07                	ja     11e1 <morecore+0x16>
    nu = 4096;
    11da:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    11e1:	8b 45 08             	mov    0x8(%ebp),%eax
    11e4:	c1 e0 03             	shl    $0x3,%eax
    11e7:	89 04 24             	mov    %eax,(%esp)
    11ea:	e8 21 fc ff ff       	call   e10 <sbrk>
    11ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    11f2:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    11f6:	75 07                	jne    11ff <morecore+0x34>
    return 0;
    11f8:	b8 00 00 00 00       	mov    $0x0,%eax
    11fd:	eb 22                	jmp    1221 <morecore+0x56>
  hp = (Header*)p;
    11ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1202:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    1205:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1208:	8b 55 08             	mov    0x8(%ebp),%edx
    120b:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    120e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1211:	83 c0 08             	add    $0x8,%eax
    1214:	89 04 24             	mov    %eax,(%esp)
    1217:	e8 d8 fe ff ff       	call   10f4 <free>
  return freep;
    121c:	a1 dc 1d 00 00       	mov    0x1ddc,%eax
}
    1221:	c9                   	leave  
    1222:	c3                   	ret    

00001223 <malloc>:

void*
malloc(uint nbytes)
{
    1223:	55                   	push   %ebp
    1224:	89 e5                	mov    %esp,%ebp
    1226:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1229:	8b 45 08             	mov    0x8(%ebp),%eax
    122c:	83 c0 07             	add    $0x7,%eax
    122f:	c1 e8 03             	shr    $0x3,%eax
    1232:	83 c0 01             	add    $0x1,%eax
    1235:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    1238:	a1 dc 1d 00 00       	mov    0x1ddc,%eax
    123d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    1240:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    1244:	75 23                	jne    1269 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    1246:	c7 45 f0 d4 1d 00 00 	movl   $0x1dd4,-0x10(%ebp)
    124d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1250:	a3 dc 1d 00 00       	mov    %eax,0x1ddc
    1255:	a1 dc 1d 00 00       	mov    0x1ddc,%eax
    125a:	a3 d4 1d 00 00       	mov    %eax,0x1dd4
    base.s.size = 0;
    125f:	c7 05 d8 1d 00 00 00 	movl   $0x0,0x1dd8
    1266:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1269:	8b 45 f0             	mov    -0x10(%ebp),%eax
    126c:	8b 00                	mov    (%eax),%eax
    126e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1271:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1274:	8b 40 04             	mov    0x4(%eax),%eax
    1277:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    127a:	72 4d                	jb     12c9 <malloc+0xa6>
      if(p->s.size == nunits)
    127c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    127f:	8b 40 04             	mov    0x4(%eax),%eax
    1282:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1285:	75 0c                	jne    1293 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    1287:	8b 45 f4             	mov    -0xc(%ebp),%eax
    128a:	8b 10                	mov    (%eax),%edx
    128c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    128f:	89 10                	mov    %edx,(%eax)
    1291:	eb 26                	jmp    12b9 <malloc+0x96>
      else {
        p->s.size -= nunits;
    1293:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1296:	8b 40 04             	mov    0x4(%eax),%eax
    1299:	89 c2                	mov    %eax,%edx
    129b:	2b 55 ec             	sub    -0x14(%ebp),%edx
    129e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12a1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    12a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12a7:	8b 40 04             	mov    0x4(%eax),%eax
    12aa:	c1 e0 03             	shl    $0x3,%eax
    12ad:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    12b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
    12b6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    12b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    12bc:	a3 dc 1d 00 00       	mov    %eax,0x1ddc
      return (void*)(p + 1);
    12c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12c4:	83 c0 08             	add    $0x8,%eax
    12c7:	eb 38                	jmp    1301 <malloc+0xde>
    }
    if(p == freep)
    12c9:	a1 dc 1d 00 00       	mov    0x1ddc,%eax
    12ce:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    12d1:	75 1b                	jne    12ee <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    12d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
    12d6:	89 04 24             	mov    %eax,(%esp)
    12d9:	e8 ed fe ff ff       	call   11cb <morecore>
    12de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    12e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    12e5:	75 07                	jne    12ee <malloc+0xcb>
        return 0;
    12e7:	b8 00 00 00 00       	mov    $0x0,%eax
    12ec:	eb 13                	jmp    1301 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    12f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12f7:	8b 00                	mov    (%eax),%eax
    12f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    12fc:	e9 70 ff ff ff       	jmp    1271 <malloc+0x4e>
}
    1301:	c9                   	leave  
    1302:	c3                   	ret    
    1303:	90                   	nop

00001304 <semaphore_create>:
#include "semaphore.h"

struct semaphore* 
semaphore_create(int initial_semaphore_value)
{
    1304:	55                   	push   %ebp
    1305:	89 e5                	mov    %esp,%ebp
    1307:	83 ec 28             	sub    $0x28,%esp
  int min = 1;
    130a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  struct semaphore* s = malloc(sizeof(struct semaphore));
    1311:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    1318:	e8 06 ff ff ff       	call   1223 <malloc>
    131d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((s->s1 = binary_semaphore_create(1)) != -1)
    1320:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1327:	e8 24 fb ff ff       	call   e50 <binary_semaphore_create>
    132c:	8b 55 f0             	mov    -0x10(%ebp),%edx
    132f:	89 42 04             	mov    %eax,0x4(%edx)
    1332:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1335:	8b 40 04             	mov    0x4(%eax),%eax
    1338:	83 f8 ff             	cmp    $0xffffffff,%eax
    133b:	74 35                	je     1372 <semaphore_create+0x6e>
  {
    if(initial_semaphore_value < 1)
    133d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    1341:	7f 06                	jg     1349 <semaphore_create+0x45>
      min = initial_semaphore_value;
    1343:	8b 45 08             	mov    0x8(%ebp),%eax
    1346:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if((s->s2 = binary_semaphore_create(min)) != -1)
    1349:	8b 45 f4             	mov    -0xc(%ebp),%eax
    134c:	89 04 24             	mov    %eax,(%esp)
    134f:	e8 fc fa ff ff       	call   e50 <binary_semaphore_create>
    1354:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1357:	89 42 08             	mov    %eax,0x8(%edx)
    135a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    135d:	8b 40 08             	mov    0x8(%eax),%eax
    1360:	83 f8 ff             	cmp    $0xffffffff,%eax
    1363:	74 0d                	je     1372 <semaphore_create+0x6e>
    {
      s->value = initial_semaphore_value;
    1365:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1368:	8b 55 08             	mov    0x8(%ebp),%edx
    136b:	89 10                	mov    %edx,(%eax)
      return s;
    136d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1370:	eb 15                	jmp    1387 <semaphore_create+0x83>
    }
  }
  free(s);
    1372:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1375:	89 04 24             	mov    %eax,(%esp)
    1378:	e8 77 fd ff ff       	call   10f4 <free>
  s = 0;
    137d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  return s;
    1384:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1387:	c9                   	leave  
    1388:	c3                   	ret    

00001389 <semaphore_down>:

void 
semaphore_down(struct semaphore* sem )
{
    1389:	55                   	push   %ebp
    138a:	89 e5                	mov    %esp,%ebp
    138c:	83 ec 18             	sub    $0x18,%esp
 //printf(1,"semaphore_down for tid = %d\n",thread_getId());
 binary_semaphore_down(sem->s2);
    138f:	8b 45 08             	mov    0x8(%ebp),%eax
    1392:	8b 40 08             	mov    0x8(%eax),%eax
    1395:	89 04 24             	mov    %eax,(%esp)
    1398:	e8 bb fa ff ff       	call   e58 <binary_semaphore_down>
 binary_semaphore_down(sem->s1);
    139d:	8b 45 08             	mov    0x8(%ebp),%eax
    13a0:	8b 40 04             	mov    0x4(%eax),%eax
    13a3:	89 04 24             	mov    %eax,(%esp)
    13a6:	e8 ad fa ff ff       	call   e58 <binary_semaphore_down>
 sem->value--;
    13ab:	8b 45 08             	mov    0x8(%ebp),%eax
    13ae:	8b 00                	mov    (%eax),%eax
    13b0:	8d 50 ff             	lea    -0x1(%eax),%edx
    13b3:	8b 45 08             	mov    0x8(%ebp),%eax
    13b6:	89 10                	mov    %edx,(%eax)
 //printf(1,"semaphore_value = %d for tid = %d\n",sem->value,thread_getId());
 if(sem->value>0)
    13b8:	8b 45 08             	mov    0x8(%ebp),%eax
    13bb:	8b 00                	mov    (%eax),%eax
    13bd:	85 c0                	test   %eax,%eax
    13bf:	7e 0e                	jle    13cf <semaphore_down+0x46>
  binary_semaphore_up(sem->s2);
    13c1:	8b 45 08             	mov    0x8(%ebp),%eax
    13c4:	8b 40 08             	mov    0x8(%eax),%eax
    13c7:	89 04 24             	mov    %eax,(%esp)
    13ca:	e8 91 fa ff ff       	call   e60 <binary_semaphore_up>
 binary_semaphore_up(sem->s1);
    13cf:	8b 45 08             	mov    0x8(%ebp),%eax
    13d2:	8b 40 04             	mov    0x4(%eax),%eax
    13d5:	89 04 24             	mov    %eax,(%esp)
    13d8:	e8 83 fa ff ff       	call   e60 <binary_semaphore_up>
}
    13dd:	c9                   	leave  
    13de:	c3                   	ret    

000013df <semaphore_up>:

void 
semaphore_up(struct semaphore* sem )
{
    13df:	55                   	push   %ebp
    13e0:	89 e5                	mov    %esp,%ebp
    13e2:	83 ec 18             	sub    $0x18,%esp
  //printf(1,"semaphore_up for tid = %d\n",thread_getId());
  binary_semaphore_down(sem->s1);
    13e5:	8b 45 08             	mov    0x8(%ebp),%eax
    13e8:	8b 40 04             	mov    0x4(%eax),%eax
    13eb:	89 04 24             	mov    %eax,(%esp)
    13ee:	e8 65 fa ff ff       	call   e58 <binary_semaphore_down>
  sem->value++;
    13f3:	8b 45 08             	mov    0x8(%ebp),%eax
    13f6:	8b 00                	mov    (%eax),%eax
    13f8:	8d 50 01             	lea    0x1(%eax),%edx
    13fb:	8b 45 08             	mov    0x8(%ebp),%eax
    13fe:	89 10                	mov    %edx,(%eax)
  //printf(1,"semaphore_value = %d for tid = %d\n",sem->value,thread_getId());
  if(sem->value == 1)
    1400:	8b 45 08             	mov    0x8(%ebp),%eax
    1403:	8b 00                	mov    (%eax),%eax
    1405:	83 f8 01             	cmp    $0x1,%eax
    1408:	75 0e                	jne    1418 <semaphore_up+0x39>
    binary_semaphore_up(sem->s2);
    140a:	8b 45 08             	mov    0x8(%ebp),%eax
    140d:	8b 40 08             	mov    0x8(%eax),%eax
    1410:	89 04 24             	mov    %eax,(%esp)
    1413:	e8 48 fa ff ff       	call   e60 <binary_semaphore_up>
  binary_semaphore_up(sem->s1);
    1418:	8b 45 08             	mov    0x8(%ebp),%eax
    141b:	8b 40 04             	mov    0x4(%eax),%eax
    141e:	89 04 24             	mov    %eax,(%esp)
    1421:	e8 3a fa ff ff       	call   e60 <binary_semaphore_up>
}
    1426:	c9                   	leave  
    1427:	c3                   	ret    

00001428 <BB_create>:
#include "boundedbuffer.h"

struct BB* 
BB_create(int max_capacity,char* name)
{
    1428:	55                   	push   %ebp
    1429:	89 e5                	mov    %esp,%ebp
    142b:	83 ec 28             	sub    $0x28,%esp
  struct BB* buf = malloc(sizeof(struct BB));
    142e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
    1435:	e8 e9 fd ff ff       	call   1223 <malloc>
    143a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(buf,0,sizeof(struct BB));
    143d:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
    1444:	00 
    1445:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    144c:	00 
    144d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1450:	89 04 24             	mov    %eax,(%esp)
    1453:	e8 8b f7 ff ff       	call   be3 <memset>
  buf->elements = malloc(sizeof(void*)*max_capacity);
    1458:	8b 45 08             	mov    0x8(%ebp),%eax
    145b:	c1 e0 02             	shl    $0x2,%eax
    145e:	89 04 24             	mov    %eax,(%esp)
    1461:	e8 bd fd ff ff       	call   1223 <malloc>
    1466:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1469:	89 42 1c             	mov    %eax,0x1c(%edx)
  memset(buf->elements,0,sizeof(void*)*max_capacity);
    146c:	8b 45 08             	mov    0x8(%ebp),%eax
    146f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    1476:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1479:	8b 40 1c             	mov    0x1c(%eax),%eax
    147c:	89 54 24 08          	mov    %edx,0x8(%esp)
    1480:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1487:	00 
    1488:	89 04 24             	mov    %eax,(%esp)
    148b:	e8 53 f7 ff ff       	call   be3 <memset>
  buf->name = name;
    1490:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1493:	8b 55 0c             	mov    0xc(%ebp),%edx
    1496:	89 50 18             	mov    %edx,0x18(%eax)
  if((buf->mutex = binary_semaphore_create(1)) != -1)
    1499:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14a0:	e8 ab f9 ff ff       	call   e50 <binary_semaphore_create>
    14a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14a8:	89 42 04             	mov    %eax,0x4(%edx)
    14ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ae:	8b 40 04             	mov    0x4(%eax),%eax
    14b1:	83 f8 ff             	cmp    $0xffffffff,%eax
    14b4:	74 44                	je     14fa <BB_create+0xd2>
  {
    buf->BUFFER_SIZE = max_capacity;
    14b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14b9:	8b 55 08             	mov    0x8(%ebp),%edx
    14bc:	89 10                	mov    %edx,(%eax)
    if((buf->empty = semaphore_create(max_capacity))!= 0 && (buf->full = semaphore_create(0))!= 0)
    14be:	8b 45 08             	mov    0x8(%ebp),%eax
    14c1:	89 04 24             	mov    %eax,(%esp)
    14c4:	e8 3b fe ff ff       	call   1304 <semaphore_create>
    14c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14cc:	89 42 08             	mov    %eax,0x8(%edx)
    14cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14d2:	8b 40 08             	mov    0x8(%eax),%eax
    14d5:	85 c0                	test   %eax,%eax
    14d7:	74 21                	je     14fa <BB_create+0xd2>
    14d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    14e0:	e8 1f fe ff ff       	call   1304 <semaphore_create>
    14e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14e8:	89 42 0c             	mov    %eax,0xc(%edx)
    14eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14ee:	8b 40 0c             	mov    0xc(%eax),%eax
    14f1:	85 c0                	test   %eax,%eax
    14f3:	74 05                	je     14fa <BB_create+0xd2>
      return buf;
    14f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14f8:	eb 23                	jmp    151d <BB_create+0xf5>
  }
  free(buf->elements);
    14fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14fd:	8b 40 1c             	mov    0x1c(%eax),%eax
    1500:	89 04 24             	mov    %eax,(%esp)
    1503:	e8 ec fb ff ff       	call   10f4 <free>
  free(buf);
    1508:	8b 45 f4             	mov    -0xc(%ebp),%eax
    150b:	89 04 24             	mov    %eax,(%esp)
    150e:	e8 e1 fb ff ff       	call   10f4 <free>
  buf = 0;
    1513:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  return buf;
    151a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    151d:	c9                   	leave  
    151e:	c3                   	ret    

0000151f <BB_put>:

void 
BB_put(struct BB* bb, void* element)
{
    151f:	55                   	push   %ebp
    1520:	89 e5                	mov    %esp,%ebp
    1522:	83 ec 18             	sub    $0x18,%esp
  //printf(1,"bb name = %s, tid = %d\n",bb->name,thread_getId());
  semaphore_down(bb->empty);
    1525:	8b 45 08             	mov    0x8(%ebp),%eax
    1528:	8b 40 08             	mov    0x8(%eax),%eax
    152b:	89 04 24             	mov    %eax,(%esp)
    152e:	e8 56 fe ff ff       	call   1389 <semaphore_down>
  binary_semaphore_down(bb->mutex);
    1533:	8b 45 08             	mov    0x8(%ebp),%eax
    1536:	8b 40 04             	mov    0x4(%eax),%eax
    1539:	89 04 24             	mov    %eax,(%esp)
    153c:	e8 17 f9 ff ff       	call   e58 <binary_semaphore_down>
  bb->elements[bb->end] = element;
    1541:	8b 45 08             	mov    0x8(%ebp),%eax
    1544:	8b 50 1c             	mov    0x1c(%eax),%edx
    1547:	8b 45 08             	mov    0x8(%ebp),%eax
    154a:	8b 40 14             	mov    0x14(%eax),%eax
    154d:	c1 e0 02             	shl    $0x2,%eax
    1550:	01 c2                	add    %eax,%edx
    1552:	8b 45 0c             	mov    0xc(%ebp),%eax
    1555:	89 02                	mov    %eax,(%edx)
  ++bb->end;
    1557:	8b 45 08             	mov    0x8(%ebp),%eax
    155a:	8b 40 14             	mov    0x14(%eax),%eax
    155d:	8d 50 01             	lea    0x1(%eax),%edx
    1560:	8b 45 08             	mov    0x8(%ebp),%eax
    1563:	89 50 14             	mov    %edx,0x14(%eax)
  bb->end = bb->end%bb->BUFFER_SIZE;
    1566:	8b 45 08             	mov    0x8(%ebp),%eax
    1569:	8b 40 14             	mov    0x14(%eax),%eax
    156c:	8b 55 08             	mov    0x8(%ebp),%edx
    156f:	8b 0a                	mov    (%edx),%ecx
    1571:	89 c2                	mov    %eax,%edx
    1573:	c1 fa 1f             	sar    $0x1f,%edx
    1576:	f7 f9                	idiv   %ecx
    1578:	8b 45 08             	mov    0x8(%ebp),%eax
    157b:	89 50 14             	mov    %edx,0x14(%eax)
  binary_semaphore_up(bb->mutex);
    157e:	8b 45 08             	mov    0x8(%ebp),%eax
    1581:	8b 40 04             	mov    0x4(%eax),%eax
    1584:	89 04 24             	mov    %eax,(%esp)
    1587:	e8 d4 f8 ff ff       	call   e60 <binary_semaphore_up>
  semaphore_up(bb->full);
    158c:	8b 45 08             	mov    0x8(%ebp),%eax
    158f:	8b 40 0c             	mov    0xc(%eax),%eax
    1592:	89 04 24             	mov    %eax,(%esp)
    1595:	e8 45 fe ff ff       	call   13df <semaphore_up>
}
    159a:	c9                   	leave  
    159b:	c3                   	ret    

0000159c <BB_pop>:

void* 
BB_pop(struct BB* bb)
{
    159c:	55                   	push   %ebp
    159d:	89 e5                	mov    %esp,%ebp
    159f:	83 ec 28             	sub    $0x28,%esp
  void* item;
  //printf(1,"bb name = %s, tid = %d\n",bb->name,thread_getId());
  semaphore_down(bb->full);
    15a2:	8b 45 08             	mov    0x8(%ebp),%eax
    15a5:	8b 40 0c             	mov    0xc(%eax),%eax
    15a8:	89 04 24             	mov    %eax,(%esp)
    15ab:	e8 d9 fd ff ff       	call   1389 <semaphore_down>
  binary_semaphore_down(bb->mutex);
    15b0:	8b 45 08             	mov    0x8(%ebp),%eax
    15b3:	8b 40 04             	mov    0x4(%eax),%eax
    15b6:	89 04 24             	mov    %eax,(%esp)
    15b9:	e8 9a f8 ff ff       	call   e58 <binary_semaphore_down>
  item = bb->elements[bb->start];
    15be:	8b 45 08             	mov    0x8(%ebp),%eax
    15c1:	8b 50 1c             	mov    0x1c(%eax),%edx
    15c4:	8b 45 08             	mov    0x8(%ebp),%eax
    15c7:	8b 40 10             	mov    0x10(%eax),%eax
    15ca:	c1 e0 02             	shl    $0x2,%eax
    15cd:	01 d0                	add    %edx,%eax
    15cf:	8b 00                	mov    (%eax),%eax
    15d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bb->elements[bb->start] = 0;
    15d4:	8b 45 08             	mov    0x8(%ebp),%eax
    15d7:	8b 50 1c             	mov    0x1c(%eax),%edx
    15da:	8b 45 08             	mov    0x8(%ebp),%eax
    15dd:	8b 40 10             	mov    0x10(%eax),%eax
    15e0:	c1 e0 02             	shl    $0x2,%eax
    15e3:	01 d0                	add    %edx,%eax
    15e5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  ++bb->start;
    15eb:	8b 45 08             	mov    0x8(%ebp),%eax
    15ee:	8b 40 10             	mov    0x10(%eax),%eax
    15f1:	8d 50 01             	lea    0x1(%eax),%edx
    15f4:	8b 45 08             	mov    0x8(%ebp),%eax
    15f7:	89 50 10             	mov    %edx,0x10(%eax)
  bb->start = bb->start%bb->BUFFER_SIZE;
    15fa:	8b 45 08             	mov    0x8(%ebp),%eax
    15fd:	8b 40 10             	mov    0x10(%eax),%eax
    1600:	8b 55 08             	mov    0x8(%ebp),%edx
    1603:	8b 0a                	mov    (%edx),%ecx
    1605:	89 c2                	mov    %eax,%edx
    1607:	c1 fa 1f             	sar    $0x1f,%edx
    160a:	f7 f9                	idiv   %ecx
    160c:	8b 45 08             	mov    0x8(%ebp),%eax
    160f:	89 50 10             	mov    %edx,0x10(%eax)
  binary_semaphore_up(bb->mutex);
    1612:	8b 45 08             	mov    0x8(%ebp),%eax
    1615:	8b 40 04             	mov    0x4(%eax),%eax
    1618:	89 04 24             	mov    %eax,(%esp)
    161b:	e8 40 f8 ff ff       	call   e60 <binary_semaphore_up>
  semaphore_up(bb->empty);
    1620:	8b 45 08             	mov    0x8(%ebp),%eax
    1623:	8b 40 08             	mov    0x8(%eax),%eax
    1626:	89 04 24             	mov    %eax,(%esp)
    1629:	e8 b1 fd ff ff       	call   13df <semaphore_up>
  return item;
    162e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    1631:	c9                   	leave  
    1632:	c3                   	ret    
