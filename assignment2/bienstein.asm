
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
       6:	a1 6c 1d 00 00       	mov    0x1d6c,%eax
       b:	89 04 24             	mov    %eax,(%esp)
       e:	e8 27 13 00 00       	call   133a <semaphore_down>
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
      1b:	a1 6c 1d 00 00       	mov    0x1d6c,%eax
      20:	89 04 24             	mov    %eax,(%esp)
      23:	e8 68 13 00 00       	call   1390 <semaphore_up>
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
      30:	a1 80 1d 00 00       	mov    0x1d80,%eax
      35:	8b 55 08             	mov    0x8(%ebp),%edx
      38:	89 54 24 04          	mov    %edx,0x4(%esp)
      3c:	89 04 24             	mov    %eax,(%esp)
      3f:	e8 97 14 00 00       	call   14db <BB_put>
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
      4c:	a1 80 1d 00 00       	mov    0x1d80,%eax
      51:	89 04 24             	mov    %eax,(%esp)
      54:	e8 ff 14 00 00       	call   1558 <BB_pop>
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
      61:	a1 8c 1d 00 00       	mov    0x1d8c,%eax
      66:	8b 55 08             	mov    0x8(%ebp),%edx
      69:	89 54 24 04          	mov    %edx,0x4(%esp)
      6d:	89 04 24             	mov    %eax,(%esp)
      70:	e8 66 14 00 00       	call   14db <BB_put>
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
      7d:	a1 8c 1d 00 00       	mov    0x1d8c,%eax
      82:	89 04 24             	mov    %eax,(%esp)
      85:	e8 ce 14 00 00       	call   1558 <BB_pop>
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
      92:	a1 98 1d 00 00       	mov    0x1d98,%eax
      97:	89 04 24             	mov    %eax,(%esp)
      9a:	e8 b9 14 00 00       	call   1558 <BB_pop>
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
      a7:	a1 98 1d 00 00       	mov    0x1d98,%eax
      ac:	8b 55 08             	mov    0x8(%ebp),%edx
      af:	89 54 24 04          	mov    %edx,0x4(%esp)
      b3:	89 04 24             	mov    %eax,(%esp)
      b6:	e8 20 14 00 00       	call   14db <BB_put>
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
      c3:	a1 88 1d 00 00       	mov    0x1d88,%eax
      c8:	8b 55 08             	mov    0x8(%ebp),%edx
      cb:	89 54 24 04          	mov    %edx,0x4(%esp)
      cf:	89 04 24             	mov    %eax,(%esp)
      d2:	e8 04 14 00 00       	call   14db <BB_put>
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
      df:	a1 88 1d 00 00       	mov    0x1d88,%eax
      e4:	89 04 24             	mov    %eax,(%esp)
      e7:	e8 6c 14 00 00       	call   1558 <BB_pop>
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
     110:	e8 82 0a 00 00       	call   b97 <memset>
  
  if((fdin = open("con.conf",O_RDONLY)) < 0)
     115:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     11c:	00 
     11d:	c7 04 24 f0 15 00 00 	movl   $0x15f0,(%esp)
     124:	e8 53 0c 00 00       	call   d7c <open>
     129:	89 45 f0             	mov    %eax,-0x10(%ebp)
     12c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     130:	79 1e                	jns    150 <getconf+0x62>
  {
    printf(1,"Couldn't open the conf file\n");
     132:	c7 44 24 04 f9 15 00 	movl   $0x15f9,0x4(%esp)
     139:	00 
     13a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     141:	e8 ad 0d 00 00       	call   ef3 <printf>
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
     168:	e8 e7 0b 00 00       	call   d54 <read>
     16d:	89 45 ec             	mov    %eax,-0x14(%ebp)
     170:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     174:	7f 1e                	jg     194 <getconf+0xa6>
  {
    printf(1,"Couldn't read from conf file\n");
     176:	c7 44 24 04 16 16 00 	movl   $0x1616,0x4(%esp)
     17d:	00 
     17e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     185:	e8 69 0d 00 00       	call   ef3 <printf>
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
     202:	8b 04 85 34 16 00 00 	mov    0x1634(,%eax,4),%eax
     209:	ff e0                	jmp    *%eax
      {
	case 'M':
	  M = atoi(&buf[i+1]);
     20b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     20e:	8d 50 01             	lea    0x1(%eax),%edx
     211:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     217:	01 d0                	add    %edx,%eax
     219:	89 04 24             	mov    %eax,(%esp)
     21c:	e8 8a 0a 00 00       	call   cab <atoi>
     221:	a3 90 1d 00 00       	mov    %eax,0x1d90
	  break;
     226:	eb 73                	jmp    29b <getconf+0x1ad>
	case 'A':
	   A = atoi(&buf[i+1]);
     228:	8b 45 f4             	mov    -0xc(%ebp),%eax
     22b:	8d 50 01             	lea    0x1(%eax),%edx
     22e:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     234:	01 d0                	add    %edx,%eax
     236:	89 04 24             	mov    %eax,(%esp)
     239:	e8 6d 0a 00 00       	call   cab <atoi>
     23e:	a3 68 1d 00 00       	mov    %eax,0x1d68
	  break;
     243:	eb 56                	jmp    29b <getconf+0x1ad>
	case 'C':
	   C = atoi(&buf[i+1]);
     245:	8b 45 f4             	mov    -0xc(%ebp),%eax
     248:	8d 50 01             	lea    0x1(%eax),%edx
     24b:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     251:	01 d0                	add    %edx,%eax
     253:	89 04 24             	mov    %eax,(%esp)
     256:	e8 50 0a 00 00       	call   cab <atoi>
     25b:	a3 84 1d 00 00       	mov    %eax,0x1d84
	  break;
     260:	eb 39                	jmp    29b <getconf+0x1ad>
	case 'S':
	   S = atoi(&buf[i+1]);
     262:	8b 45 f4             	mov    -0xc(%ebp),%eax
     265:	8d 50 01             	lea    0x1(%eax),%edx
     268:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     26e:	01 d0                	add    %edx,%eax
     270:	89 04 24             	mov    %eax,(%esp)
     273:	e8 33 0a 00 00       	call   cab <atoi>
     278:	a3 78 1d 00 00       	mov    %eax,0x1d78
	  break;
     27d:	eb 1c                	jmp    29b <getconf+0x1ad>
	case 'B':
	   B = atoi(&buf[i+1]);
     27f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     282:	8d 50 01             	lea    0x1(%eax),%edx
     285:	8d 85 ec fd ff ff    	lea    -0x214(%ebp),%eax
     28b:	01 d0                	add    %edx,%eax
     28d:	89 04 24             	mov    %eax,(%esp)
     290:	e8 16 0a 00 00       	call   cab <atoi>
     295:	a3 7c 1d 00 00       	mov    %eax,0x1d7c
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
     2b8:	e8 27 0b 00 00       	call   de4 <thread_getId>
     2bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  int i = 0;
     2c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  
  enter_bar();
     2c7:	e8 34 fd ff ff       	call   0 <enter_bar>
  //printf(1,"student tid = %d entered bar\n",tid);
  for(;i < tid%5;i++)
     2cc:	e9 b2 00 00 00       	jmp    383 <student_func+0xd1>
  {
    struct Action* get = malloc(sizeof(struct Action)); //create the get_drink action
     2d1:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     2d8:	e8 fa 0e 00 00       	call   11d7 <malloc>
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
    //printf(1,"student tid = %d places action\n",tid);
    place_action(get);
     2fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
     2ff:	89 04 24             	mov    %eax,(%esp)
     302:	e8 23 fd ff ff       	call   2a <place_action>
    //printf(fd,"Student %d placed action\n",tid);
    //put action in ABB buffer
    struct Cup * cup = get_drink();			//get cup from DrinkBB buffer
     307:	e8 6b fd ff ff       	call   77 <get_drink>
     30c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    printf(fd,"Student %d is having his %d drink, with cup %d\n",tid,i+1,cup->id);
     30f:	8b 45 e8             	mov    -0x18(%ebp),%eax
     312:	8b 10                	mov    (%eax),%edx
     314:	8b 45 f4             	mov    -0xc(%ebp),%eax
     317:	8d 48 01             	lea    0x1(%eax),%ecx
     31a:	a1 70 1d 00 00       	mov    0x1d70,%eax
     31f:	89 54 24 10          	mov    %edx,0x10(%esp)
     323:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
     327:	8b 55 f0             	mov    -0x10(%ebp),%edx
     32a:	89 54 24 08          	mov    %edx,0x8(%esp)
     32e:	c7 44 24 04 80 16 00 	movl   $0x1680,0x4(%esp)
     335:	00 
     336:	89 04 24             	mov    %eax,(%esp)
     339:	e8 b5 0b 00 00       	call   ef3 <printf>
    sleep(1);
     33e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     345:	e8 82 0a 00 00       	call   dcc <sleep>
    struct Action* put = malloc(sizeof(struct Action));
     34a:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     351:	e8 81 0e 00 00       	call   11d7 <malloc>
     356:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    put->type = PUT_DRINK;
     359:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     35c:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    put->cup = cup;
     362:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     365:	8b 55 e8             	mov    -0x18(%ebp),%edx
     368:	89 50 04             	mov    %edx,0x4(%eax)
    //printf(1,"cup address = %d, cup value = %d\n",cup,cup->id);
    put->tid = tid;
     36b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     36e:	8b 55 f0             	mov    -0x10(%ebp),%edx
     371:	89 50 08             	mov    %edx,0x8(%eax)
    place_action(put);
     374:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     377:	89 04 24             	mov    %eax,(%esp)
     37a:	e8 ab fc ff ff       	call   2a <place_action>
  int tid = thread_getId();
  int i = 0;
  
  enter_bar();
  //printf(1,"student tid = %d entered bar\n",tid);
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
    put->cup = cup;
    //printf(1,"cup address = %d, cup value = %d\n",cup,cup->id);
    put->tid = tid;
    place_action(put);
  }
  printf(fd,"Student %d is drunk, and trying to go home\n",tid);
     3ac:	a1 70 1d 00 00       	mov    0x1d70,%eax
     3b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
     3b4:	89 54 24 08          	mov    %edx,0x8(%esp)
     3b8:	c7 44 24 04 b0 16 00 	movl   $0x16b0,0x4(%esp)
     3bf:	00 
     3c0:	89 04 24             	mov    %eax,(%esp)
     3c3:	e8 2b 0b 00 00       	call   ef3 <printf>
  leave_bar();
     3c8:	e8 48 fc ff ff       	call   15 <leave_bar>
  //printf(fd,"Student %d left\n",tid);
  thread_exit(0);
     3cd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     3d4:	e8 23 0a 00 00       	call   dfc <thread_exit>
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
     3e6:	e8 f9 09 00 00       	call   de4 <thread_getId>
     3eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(;;)
  {
    struct Action * act = get_action();
     3ee:	e8 53 fc ff ff       	call   46 <get_action>
     3f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //printf(1,"type = %d, cup = %d, tid = %d\n",act->type,act->cup->id,act->tid);
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
     40d:	a1 70 1d 00 00       	mov    0x1d70,%eax
     412:	89 54 24 0c          	mov    %edx,0xc(%esp)
     416:	8b 55 f4             	mov    -0xc(%ebp),%edx
     419:	89 54 24 08          	mov    %edx,0x8(%esp)
     41d:	c7 44 24 04 dc 16 00 	movl   $0x16dc,0x4(%esp)
     424:	00 
     425:	89 04 24             	mov    %eax,(%esp)
     428:	e8 c6 0a 00 00       	call   ef3 <printf>
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
     464:	a1 70 1d 00 00       	mov    0x1d70,%eax
     469:	89 54 24 0c          	mov    %edx,0xc(%esp)
     46d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     470:	89 54 24 08          	mov    %edx,0x8(%esp)
     474:	c7 44 24 04 08 17 00 	movl   $0x1708,0x4(%esp)
     47b:	00 
     47c:	89 04 24             	mov    %eax,(%esp)
     47f:	e8 6f 0a 00 00       	call   ef3 <printf>
      
     // semaphore_down(DBB->full);
      n = DBB->full->value;
     484:	a1 88 1d 00 00       	mov    0x1d88,%eax
     489:	8b 40 0c             	mov    0xc(%eax),%eax
     48c:	8b 00                	mov    (%eax),%eax
     48e:	89 45 d0             	mov    %eax,-0x30(%ebp)
     491:	db 45 d0             	fildl  -0x30(%ebp)
     494:	dd 5d e0             	fstpl  -0x20(%ebp)
     // semaphore_up(DBB->full);
      bufSize = DBB->BUFFER_SIZE;
     497:	a1 88 1d 00 00       	mov    0x1d88,%eax
     49c:	8b 00                	mov    (%eax),%eax
     49e:	89 45 d0             	mov    %eax,-0x30(%ebp)
     4a1:	db 45 d0             	fildl  -0x30(%ebp)
     4a4:	dd 5d d8             	fstpl  -0x28(%ebp)
      if(n/bufSize >= 0.6)
     4a7:	dd 45 e0             	fldl   -0x20(%ebp)
     4aa:	dc 75 d8             	fdivl  -0x28(%ebp)
     4ad:	dd 05 68 18 00 00    	fldl   0x1868
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
     4dc:	a3 74 1d 00 00       	mov    %eax,0x1d74
	//printf(fd,"Bartender %d waking up cupboy with %d dirty cups\n",tid,dirtycups);
	semaphore_up(cupsem);
     4e1:	a1 94 1d 00 00       	mov    0x1d94,%eax
     4e6:	89 04 24             	mov    %eax,(%esp)
     4e9:	e8 a2 0e 00 00       	call   1390 <semaphore_up>
      }
    }
    free(act);
     4ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
     4f1:	89 04 24             	mov    %eax,(%esp)
     4f4:	e8 af 0b 00 00       	call   10a8 <free>
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
    //semaphore_down(DBB->full);
    n = dirtycups;
     504:	a1 74 1d 00 00       	mov    0x1d74,%eax
     509:	89 45 f0             	mov    %eax,-0x10(%ebp)
    //semaphore_up(DBB->full);
    //printf(fd,"Cup boy washing %d dirty cups\n",n);    
    for(i=0;i<n;i++)
     50c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     513:	eb 41                	jmp    556 <cupboy_func+0x58>
    {
      struct Cup * cup = wash_dirty();
     515:	e8 bf fb ff ff       	call   d9 <wash_dirty>
     51a:	89 45 ec             	mov    %eax,-0x14(%ebp)
      sleep(1);
     51d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     524:	e8 a3 08 00 00       	call   dcc <sleep>
      add_clean_cup(cup);
     529:	8b 45 ec             	mov    -0x14(%ebp),%eax
     52c:	89 04 24             	mov    %eax,(%esp)
     52f:	e8 6d fb ff ff       	call   a1 <add_clean_cup>
      printf(fd,"Cup boy added clean cup #%d\n",cup->id);    
     534:	8b 45 ec             	mov    -0x14(%ebp),%eax
     537:	8b 10                	mov    (%eax),%edx
     539:	a1 70 1d 00 00       	mov    0x1d70,%eax
     53e:	89 54 24 08          	mov    %edx,0x8(%esp)
     542:	c7 44 24 04 27 17 00 	movl   $0x1727,0x4(%esp)
     549:	00 
     54a:	89 04 24             	mov    %eax,(%esp)
     54d:	e8 a1 09 00 00       	call   ef3 <printf>
  {
    //semaphore_down(DBB->full);
    n = dirtycups;
    //semaphore_up(DBB->full);
    //printf(fd,"Cup boy washing %d dirty cups\n",n);    
    for(i=0;i<n;i++)
     552:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     556:	8b 45 f4             	mov    -0xc(%ebp),%eax
     559:	3b 45 f0             	cmp    -0x10(%ebp),%eax
     55c:	7c b7                	jl     515 <cupboy_func+0x17>
      struct Cup * cup = wash_dirty();
      sleep(1);
      add_clean_cup(cup);
      printf(fd,"Cup boy added clean cup #%d\n",cup->id);    
    }
    semaphore_down(cupsem);
     55e:	a1 94 1d 00 00       	mov    0x1d94,%eax
     563:	89 04 24             	mov    %eax,(%esp)
     566:	e8 cf 0d 00 00       	call   133a <semaphore_down>
  }
     56b:	eb 97                	jmp    504 <cupboy_func+0x6>

0000056d <main>:
}


int 
main(void)
{
     56d:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     571:	83 e4 f0             	and    $0xfffffff0,%esp
     574:	ff 71 fc             	pushl  -0x4(%ecx)
     577:	55                   	push   %ebp
     578:	89 e5                	mov    %esp,%ebp
     57a:	53                   	push   %ebx
     57b:	51                   	push   %ecx
     57c:	83 ec 50             	sub    $0x50,%esp
     57f:	89 e0                	mov    %esp,%eax
     581:	89 c3                	mov    %eax,%ebx
  if((fd = open("Synch_problem_log.txt",(O_WRONLY | O_CREATE))) < 0)
     583:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
     58a:	00 
     58b:	c7 04 24 44 17 00 00 	movl   $0x1744,(%esp)
     592:	e8 e5 07 00 00       	call   d7c <open>
     597:	a3 70 1d 00 00       	mov    %eax,0x1d70
     59c:	a1 70 1d 00 00       	mov    0x1d70,%eax
     5a1:	85 c0                	test   %eax,%eax
     5a3:	79 1e                	jns    5c3 <main+0x56>
  {
    printf(1,"Couldn't open the log file\n");
     5a5:	c7 44 24 04 5a 17 00 	movl   $0x175a,0x4(%esp)
     5ac:	00 
     5ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5b4:	e8 3a 09 00 00       	call   ef3 <printf>
    return -1;
     5b9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     5be:	e9 08 05 00 00       	jmp    acb <main+0x55e>
  }
  if (getconf() == -1)
     5c3:	e8 26 fb ff ff       	call   ee <getconf>
     5c8:	83 f8 ff             	cmp    $0xffffffff,%eax
     5cb:	75 1e                	jne    5eb <main+0x7e>
  {
    printf(1,"Couldn't open the conf file\n");
     5cd:	c7 44 24 04 f9 15 00 	movl   $0x15f9,0x4(%esp)
     5d4:	00 
     5d5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     5dc:	e8 12 09 00 00       	call   ef3 <printf>
    return -1;
     5e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     5e6:	e9 e0 04 00 00       	jmp    acb <main+0x55e>
  }
  //fd=1;
  void * barStack[B];
     5eb:	a1 7c 1d 00 00       	mov    0x1d7c,%eax
     5f0:	8d 50 ff             	lea    -0x1(%eax),%edx
     5f3:	89 55 f0             	mov    %edx,-0x10(%ebp)
     5f6:	c1 e0 02             	shl    $0x2,%eax
     5f9:	8d 50 0f             	lea    0xf(%eax),%edx
     5fc:	b8 10 00 00 00       	mov    $0x10,%eax
     601:	83 e8 01             	sub    $0x1,%eax
     604:	01 d0                	add    %edx,%eax
     606:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
     60d:	ba 00 00 00 00       	mov    $0x0,%edx
     612:	f7 75 c4             	divl   -0x3c(%ebp)
     615:	6b c0 10             	imul   $0x10,%eax,%eax
     618:	29 c4                	sub    %eax,%esp
     61a:	8d 44 24 0c          	lea    0xc(%esp),%eax
     61e:	83 c0 0f             	add    $0xf,%eax
     621:	c1 e8 04             	shr    $0x4,%eax
     624:	c1 e0 04             	shl    $0x4,%eax
     627:	89 45 ec             	mov    %eax,-0x14(%ebp)
  void * studStack[S];
     62a:	a1 78 1d 00 00       	mov    0x1d78,%eax
     62f:	8d 50 ff             	lea    -0x1(%eax),%edx
     632:	89 55 e8             	mov    %edx,-0x18(%ebp)
     635:	c1 e0 02             	shl    $0x2,%eax
     638:	8d 50 0f             	lea    0xf(%eax),%edx
     63b:	b8 10 00 00 00       	mov    $0x10,%eax
     640:	83 e8 01             	sub    $0x1,%eax
     643:	01 d0                	add    %edx,%eax
     645:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
     64c:	ba 00 00 00 00       	mov    $0x0,%edx
     651:	f7 75 c4             	divl   -0x3c(%ebp)
     654:	6b c0 10             	imul   $0x10,%eax,%eax
     657:	29 c4                	sub    %eax,%esp
     659:	8d 44 24 0c          	lea    0xc(%esp),%eax
     65d:	83 c0 0f             	add    $0xf,%eax
     660:	c1 e8 04             	shr    $0x4,%eax
     663:	c1 e0 04             	shl    $0x4,%eax
     666:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int studTid[S];
     669:	a1 78 1d 00 00       	mov    0x1d78,%eax
     66e:	8d 50 ff             	lea    -0x1(%eax),%edx
     671:	89 55 e0             	mov    %edx,-0x20(%ebp)
     674:	c1 e0 02             	shl    $0x2,%eax
     677:	8d 50 0f             	lea    0xf(%eax),%edx
     67a:	b8 10 00 00 00       	mov    $0x10,%eax
     67f:	83 e8 01             	sub    $0x1,%eax
     682:	01 d0                	add    %edx,%eax
     684:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
     68b:	ba 00 00 00 00       	mov    $0x0,%edx
     690:	f7 75 c4             	divl   -0x3c(%ebp)
     693:	6b c0 10             	imul   $0x10,%eax,%eax
     696:	29 c4                	sub    %eax,%esp
     698:	8d 44 24 0c          	lea    0xc(%esp),%eax
     69c:	83 c0 0f             	add    $0xf,%eax
     69f:	c1 e8 04             	shr    $0x4,%eax
     6a2:	c1 e0 04             	shl    $0x4,%eax
     6a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
  int i = 0;  
     6a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  bouncer = semaphore_create(M,"bouncer");
     6af:	a1 90 1d 00 00       	mov    0x1d90,%eax
     6b4:	c7 44 24 04 76 17 00 	movl   $0x1776,0x4(%esp)
     6bb:	00 
     6bc:	89 04 24             	mov    %eax,(%esp)
     6bf:	e8 f4 0b 00 00       	call   12b8 <semaphore_create>
     6c4:	a3 6c 1d 00 00       	mov    %eax,0x1d6c
  cupsem = semaphore_create(1,"cupboy");
     6c9:	c7 44 24 04 7e 17 00 	movl   $0x177e,0x4(%esp)
     6d0:	00 
     6d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6d8:	e8 db 0b 00 00       	call   12b8 <semaphore_create>
     6dd:	a3 94 1d 00 00       	mov    %eax,0x1d94
  ABB = BB_create(A,"ABB");
     6e2:	a1 68 1d 00 00       	mov    0x1d68,%eax
     6e7:	c7 44 24 04 85 17 00 	movl   $0x1785,0x4(%esp)
     6ee:	00 
     6ef:	89 04 24             	mov    %eax,(%esp)
     6f2:	e8 e5 0c 00 00       	call   13dc <BB_create>
     6f7:	a3 80 1d 00 00       	mov    %eax,0x1d80
  DrinkBB = BB_create(A,"DrinkBB");
     6fc:	a1 68 1d 00 00       	mov    0x1d68,%eax
     701:	c7 44 24 04 89 17 00 	movl   $0x1789,0x4(%esp)
     708:	00 
     709:	89 04 24             	mov    %eax,(%esp)
     70c:	e8 cb 0c 00 00       	call   13dc <BB_create>
     711:	a3 8c 1d 00 00       	mov    %eax,0x1d8c
  CBB = BB_create(C,"CBB");
     716:	a1 84 1d 00 00       	mov    0x1d84,%eax
     71b:	c7 44 24 04 91 17 00 	movl   $0x1791,0x4(%esp)
     722:	00 
     723:	89 04 24             	mov    %eax,(%esp)
     726:	e8 b1 0c 00 00       	call   13dc <BB_create>
     72b:	a3 98 1d 00 00       	mov    %eax,0x1d98
  DBB = BB_create(C,"DBB");
     730:	a1 84 1d 00 00       	mov    0x1d84,%eax
     735:	c7 44 24 04 95 17 00 	movl   $0x1795,0x4(%esp)
     73c:	00 
     73d:	89 04 24             	mov    %eax,(%esp)
     740:	e8 97 0c 00 00       	call   13dc <BB_create>
     745:	a3 88 1d 00 00       	mov    %eax,0x1d88
  struct Cup* cups[C];
     74a:	a1 84 1d 00 00       	mov    0x1d84,%eax
     74f:	8d 50 ff             	lea    -0x1(%eax),%edx
     752:	89 55 d8             	mov    %edx,-0x28(%ebp)
     755:	c1 e0 02             	shl    $0x2,%eax
     758:	8d 50 0f             	lea    0xf(%eax),%edx
     75b:	b8 10 00 00 00       	mov    $0x10,%eax
     760:	83 e8 01             	sub    $0x1,%eax
     763:	01 d0                	add    %edx,%eax
     765:	c7 45 c4 10 00 00 00 	movl   $0x10,-0x3c(%ebp)
     76c:	ba 00 00 00 00       	mov    $0x0,%edx
     771:	f7 75 c4             	divl   -0x3c(%ebp)
     774:	6b c0 10             	imul   $0x10,%eax,%eax
     777:	29 c4                	sub    %eax,%esp
     779:	8d 44 24 0c          	lea    0xc(%esp),%eax
     77d:	83 c0 0f             	add    $0xf,%eax
     780:	c1 e8 04             	shr    $0x4,%eax
     783:	c1 e0 04             	shl    $0x4,%eax
     786:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  
  for(;i<C;i++)
     789:	eb 41                	jmp    7cc <main+0x25f>
  {
    cups[i] = malloc(sizeof(struct Cup));
     78b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
     792:	e8 40 0a 00 00       	call   11d7 <malloc>
     797:	8b 55 d4             	mov    -0x2c(%ebp),%edx
     79a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     79d:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    cups[i]->id = i;
     7a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     7a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
     7a6:	8b 04 90             	mov    (%eax,%edx,4),%eax
     7a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
     7ac:	89 10                	mov    %edx,(%eax)
    BB_put(CBB,cups[i]);
     7ae:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     7b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
     7b4:	8b 14 90             	mov    (%eax,%edx,4),%edx
     7b7:	a1 98 1d 00 00       	mov    0x1d98,%eax
     7bc:	89 54 24 04          	mov    %edx,0x4(%esp)
     7c0:	89 04 24             	mov    %eax,(%esp)
     7c3:	e8 13 0d 00 00       	call   14db <BB_put>
  DrinkBB = BB_create(A,"DrinkBB");
  CBB = BB_create(C,"CBB");
  DBB = BB_create(C,"DBB");
  struct Cup* cups[C];
  
  for(;i<C;i++)
     7c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     7cc:	a1 84 1d 00 00       	mov    0x1d84,%eax
     7d1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     7d4:	7c b5                	jl     78b <main+0x21e>
    cups[i] = malloc(sizeof(struct Cup));
    cups[i]->id = i;
    BB_put(CBB,cups[i]);
  }
  
  void* cupStack = malloc(sizeof(void*)*1024);
     7d6:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     7dd:	e8 f5 09 00 00       	call   11d7 <malloc>
     7e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  memset(cupStack,0,sizeof(void*)*1024);
     7e5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     7ec:	00 
     7ed:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     7f4:	00 
     7f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
     7f8:	89 04 24             	mov    %eax,(%esp)
     7fb:	e8 97 03 00 00       	call   b97 <memset>
  if(thread_create(cupboy_func,cupStack,sizeof(void*)*1024) < 0)
     800:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     807:	00 
     808:	8b 45 d0             	mov    -0x30(%ebp),%eax
     80b:	89 44 24 04          	mov    %eax,0x4(%esp)
     80f:	c7 04 24 fe 04 00 00 	movl   $0x4fe,(%esp)
     816:	e8 c1 05 00 00       	call   ddc <thread_create>
     81b:	85 c0                	test   %eax,%eax
     81d:	79 19                	jns    838 <main+0x2cb>
  {
    printf(1,"Failed to create cupboy thread. Exiting...\n");
     81f:	c7 44 24 04 9c 17 00 	movl   $0x179c,0x4(%esp)
     826:	00 
     827:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     82e:	e8 c0 06 00 00       	call   ef3 <printf>
    exit();
     833:	e8 04 05 00 00       	call   d3c <exit>
  }
  
  for(i=0;i<B;i++)
     838:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     83f:	e9 82 00 00 00       	jmp    8c6 <main+0x359>
  {
    barStack[i] = malloc(sizeof(void*)*1024);
     844:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     84b:	e8 87 09 00 00       	call   11d7 <malloc>
     850:	8b 55 ec             	mov    -0x14(%ebp),%edx
     853:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     856:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    memset(barStack[i],0,sizeof(void*)*1024);
     859:	8b 45 ec             	mov    -0x14(%ebp),%eax
     85c:	8b 55 f4             	mov    -0xc(%ebp),%edx
     85f:	8b 04 90             	mov    (%eax,%edx,4),%eax
     862:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     869:	00 
     86a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     871:	00 
     872:	89 04 24             	mov    %eax,(%esp)
     875:	e8 1d 03 00 00       	call   b97 <memset>
    if(thread_create(bartender_func,barStack[i],sizeof(void*)*1024) < 0)
     87a:	8b 45 ec             	mov    -0x14(%ebp),%eax
     87d:	8b 55 f4             	mov    -0xc(%ebp),%edx
     880:	8b 04 90             	mov    (%eax,%edx,4),%eax
     883:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     88a:	00 
     88b:	89 44 24 04          	mov    %eax,0x4(%esp)
     88f:	c7 04 24 e0 03 00 00 	movl   $0x3e0,(%esp)
     896:	e8 41 05 00 00       	call   ddc <thread_create>
     89b:	85 c0                	test   %eax,%eax
     89d:	79 23                	jns    8c2 <main+0x355>
    {
      printf(1,"Failed to create bartender thread #%d. Exiting...\n",i+1);
     89f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     8a2:	83 c0 01             	add    $0x1,%eax
     8a5:	89 44 24 08          	mov    %eax,0x8(%esp)
     8a9:	c7 44 24 04 c8 17 00 	movl   $0x17c8,0x4(%esp)
     8b0:	00 
     8b1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     8b8:	e8 36 06 00 00       	call   ef3 <printf>
      exit();
     8bd:	e8 7a 04 00 00       	call   d3c <exit>
  {
    printf(1,"Failed to create cupboy thread. Exiting...\n");
    exit();
  }
  
  for(i=0;i<B;i++)
     8c2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     8c6:	a1 7c 1d 00 00       	mov    0x1d7c,%eax
     8cb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     8ce:	0f 8c 70 ff ff ff    	jl     844 <main+0x2d7>
    {
      printf(1,"Failed to create bartender thread #%d. Exiting...\n",i+1);
      exit();
    } 
  }
  for(i=0;i<S;i++)
     8d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     8db:	e9 94 00 00 00       	jmp    974 <main+0x407>
  {
    studStack[i] = malloc(sizeof(void*)*1024);
     8e0:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
     8e7:	e8 eb 08 00 00       	call   11d7 <malloc>
     8ec:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     8ef:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     8f2:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
    memset(studStack[i],0,sizeof(void*)*1024);
     8f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     8f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
     8fb:	8b 04 90             	mov    (%eax,%edx,4),%eax
     8fe:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     905:	00 
     906:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     90d:	00 
     90e:	89 04 24             	mov    %eax,(%esp)
     911:	e8 81 02 00 00       	call   b97 <memset>
    if((studTid[i] = thread_create(student_func,studStack[i],sizeof(void*)*1024)) < 0)
     916:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     919:	8b 55 f4             	mov    -0xc(%ebp),%edx
     91c:	8b 04 90             	mov    (%eax,%edx,4),%eax
     91f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
     926:	00 
     927:	89 44 24 04          	mov    %eax,0x4(%esp)
     92b:	c7 04 24 b2 02 00 00 	movl   $0x2b2,(%esp)
     932:	e8 a5 04 00 00       	call   ddc <thread_create>
     937:	8b 55 dc             	mov    -0x24(%ebp),%edx
     93a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
     93d:	89 04 8a             	mov    %eax,(%edx,%ecx,4)
     940:	8b 45 dc             	mov    -0x24(%ebp),%eax
     943:	8b 55 f4             	mov    -0xc(%ebp),%edx
     946:	8b 04 90             	mov    (%eax,%edx,4),%eax
     949:	85 c0                	test   %eax,%eax
     94b:	79 23                	jns    970 <main+0x403>
    {
      printf(1,"Failed to create student thread #%d. Exiting...\n",i+1);
     94d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     950:	83 c0 01             	add    $0x1,%eax
     953:	89 44 24 08          	mov    %eax,0x8(%esp)
     957:	c7 44 24 04 fc 17 00 	movl   $0x17fc,0x4(%esp)
     95e:	00 
     95f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     966:	e8 88 05 00 00       	call   ef3 <printf>
      exit();
     96b:	e8 cc 03 00 00       	call   d3c <exit>
    {
      printf(1,"Failed to create bartender thread #%d. Exiting...\n",i+1);
      exit();
    } 
  }
  for(i=0;i<S;i++)
     970:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     974:	a1 78 1d 00 00       	mov    0x1d78,%eax
     979:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     97c:	0f 8c 5e ff ff ff    	jl     8e0 <main+0x373>
      printf(1,"Failed to create student thread #%d. Exiting...\n",i+1);
      exit();
    } 
  }

  for(i=0;i<S;i++)
     982:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     989:	eb 55                	jmp    9e0 <main+0x473>
  {
    if(thread_join(studTid[i],0) != 0)
     98b:	8b 45 dc             	mov    -0x24(%ebp),%eax
     98e:	8b 55 f4             	mov    -0xc(%ebp),%edx
     991:	8b 04 90             	mov    (%eax,%edx,4),%eax
     994:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     99b:	00 
     99c:	89 04 24             	mov    %eax,(%esp)
     99f:	e8 50 04 00 00       	call   df4 <thread_join>
     9a4:	85 c0                	test   %eax,%eax
     9a6:	74 23                	je     9cb <main+0x45e>
    {
      printf(1,"Failed to join on student thread #%d. Exiting...\n",i+1);
     9a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
     9ab:	83 c0 01             	add    $0x1,%eax
     9ae:	89 44 24 08          	mov    %eax,0x8(%esp)
     9b2:	c7 44 24 04 30 18 00 	movl   $0x1830,0x4(%esp)
     9b9:	00 
     9ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     9c1:	e8 2d 05 00 00       	call   ef3 <printf>
      exit();
     9c6:	e8 71 03 00 00       	call   d3c <exit>
    }
    
    free(studStack[i]);
     9cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     9ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9d1:	8b 04 90             	mov    (%eax,%edx,4),%eax
     9d4:	89 04 24             	mov    %eax,(%esp)
     9d7:	e8 cc 06 00 00       	call   10a8 <free>
      printf(1,"Failed to create student thread #%d. Exiting...\n",i+1);
      exit();
    } 
  }

  for(i=0;i<S;i++)
     9dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     9e0:	a1 78 1d 00 00       	mov    0x1d78,%eax
     9e5:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     9e8:	7c a1                	jl     98b <main+0x41e>
    }
    
    free(studStack[i]);
  }
  
  for(i=0;i<B;i++)
     9ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     9f1:	eb 15                	jmp    a08 <main+0x49b>
    free(barStack[i]);
     9f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
     9f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
     9f9:	8b 04 90             	mov    (%eax,%edx,4),%eax
     9fc:	89 04 24             	mov    %eax,(%esp)
     9ff:	e8 a4 06 00 00       	call   10a8 <free>
    }
    
    free(studStack[i]);
  }
  
  for(i=0;i<B;i++)
     a04:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a08:	a1 7c 1d 00 00       	mov    0x1d7c,%eax
     a0d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     a10:	7c e1                	jl     9f3 <main+0x486>
    free(barStack[i]);
  free(cupStack);
     a12:	8b 45 d0             	mov    -0x30(%ebp),%eax
     a15:	89 04 24             	mov    %eax,(%esp)
     a18:	e8 8b 06 00 00       	call   10a8 <free>
  
  for(i=0;i<C;i++)
     a1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     a24:	eb 15                	jmp    a3b <main+0x4ce>
    free(cups[i]);
     a26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     a29:	8b 55 f4             	mov    -0xc(%ebp),%edx
     a2c:	8b 04 90             	mov    (%eax,%edx,4),%eax
     a2f:	89 04 24             	mov    %eax,(%esp)
     a32:	e8 71 06 00 00       	call   10a8 <free>
  
  for(i=0;i<B;i++)
    free(barStack[i]);
  free(cupStack);
  
  for(i=0;i<C;i++)
     a37:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
     a3b:	a1 84 1d 00 00       	mov    0x1d84,%eax
     a40:	39 45 f4             	cmp    %eax,-0xc(%ebp)
     a43:	7c e1                	jl     a26 <main+0x4b9>
    free(cups[i]);
  

  free(CBB->elements);
     a45:	a1 98 1d 00 00       	mov    0x1d98,%eax
     a4a:	8b 40 1c             	mov    0x1c(%eax),%eax
     a4d:	89 04 24             	mov    %eax,(%esp)
     a50:	e8 53 06 00 00       	call   10a8 <free>
  free(DBB->elements);
     a55:	a1 88 1d 00 00       	mov    0x1d88,%eax
     a5a:	8b 40 1c             	mov    0x1c(%eax),%eax
     a5d:	89 04 24             	mov    %eax,(%esp)
     a60:	e8 43 06 00 00       	call   10a8 <free>
  free(CBB);
     a65:	a1 98 1d 00 00       	mov    0x1d98,%eax
     a6a:	89 04 24             	mov    %eax,(%esp)
     a6d:	e8 36 06 00 00       	call   10a8 <free>
  free(DBB);
     a72:	a1 88 1d 00 00       	mov    0x1d88,%eax
     a77:	89 04 24             	mov    %eax,(%esp)
     a7a:	e8 29 06 00 00       	call   10a8 <free>
  
  free(ABB->elements);
     a7f:	a1 80 1d 00 00       	mov    0x1d80,%eax
     a84:	8b 40 1c             	mov    0x1c(%eax),%eax
     a87:	89 04 24             	mov    %eax,(%esp)
     a8a:	e8 19 06 00 00       	call   10a8 <free>
  free(DrinkBB->elements);
     a8f:	a1 8c 1d 00 00       	mov    0x1d8c,%eax
     a94:	8b 40 1c             	mov    0x1c(%eax),%eax
     a97:	89 04 24             	mov    %eax,(%esp)
     a9a:	e8 09 06 00 00       	call   10a8 <free>
  free(ABB);
     a9f:	a1 80 1d 00 00       	mov    0x1d80,%eax
     aa4:	89 04 24             	mov    %eax,(%esp)
     aa7:	e8 fc 05 00 00       	call   10a8 <free>
  free(DrinkBB);
     aac:	a1 8c 1d 00 00       	mov    0x1d8c,%eax
     ab1:	89 04 24             	mov    %eax,(%esp)
     ab4:	e8 ef 05 00 00       	call   10a8 <free>
  close(fd);
     ab9:	a1 70 1d 00 00       	mov    0x1d70,%eax
     abe:	89 04 24             	mov    %eax,(%esp)
     ac1:	e8 9e 02 00 00       	call   d64 <close>
  exit();
     ac6:	e8 71 02 00 00       	call   d3c <exit>
     acb:	89 dc                	mov    %ebx,%esp
  return 0;
}
     acd:	8d 65 f8             	lea    -0x8(%ebp),%esp
     ad0:	59                   	pop    %ecx
     ad1:	5b                   	pop    %ebx
     ad2:	5d                   	pop    %ebp
     ad3:	8d 61 fc             	lea    -0x4(%ecx),%esp
     ad6:	c3                   	ret    
     ad7:	90                   	nop

00000ad8 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
     ad8:	55                   	push   %ebp
     ad9:	89 e5                	mov    %esp,%ebp
     adb:	57                   	push   %edi
     adc:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
     add:	8b 4d 08             	mov    0x8(%ebp),%ecx
     ae0:	8b 55 10             	mov    0x10(%ebp),%edx
     ae3:	8b 45 0c             	mov    0xc(%ebp),%eax
     ae6:	89 cb                	mov    %ecx,%ebx
     ae8:	89 df                	mov    %ebx,%edi
     aea:	89 d1                	mov    %edx,%ecx
     aec:	fc                   	cld    
     aed:	f3 aa                	rep stos %al,%es:(%edi)
     aef:	89 ca                	mov    %ecx,%edx
     af1:	89 fb                	mov    %edi,%ebx
     af3:	89 5d 08             	mov    %ebx,0x8(%ebp)
     af6:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
     af9:	5b                   	pop    %ebx
     afa:	5f                   	pop    %edi
     afb:	5d                   	pop    %ebp
     afc:	c3                   	ret    

00000afd <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
     afd:	55                   	push   %ebp
     afe:	89 e5                	mov    %esp,%ebp
     b00:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
     b03:	8b 45 08             	mov    0x8(%ebp),%eax
     b06:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
     b09:	90                   	nop
     b0a:	8b 45 0c             	mov    0xc(%ebp),%eax
     b0d:	0f b6 10             	movzbl (%eax),%edx
     b10:	8b 45 08             	mov    0x8(%ebp),%eax
     b13:	88 10                	mov    %dl,(%eax)
     b15:	8b 45 08             	mov    0x8(%ebp),%eax
     b18:	0f b6 00             	movzbl (%eax),%eax
     b1b:	84 c0                	test   %al,%al
     b1d:	0f 95 c0             	setne  %al
     b20:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     b24:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
     b28:	84 c0                	test   %al,%al
     b2a:	75 de                	jne    b0a <strcpy+0xd>
    ;
  return os;
     b2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     b2f:	c9                   	leave  
     b30:	c3                   	ret    

00000b31 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     b31:	55                   	push   %ebp
     b32:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
     b34:	eb 08                	jmp    b3e <strcmp+0xd>
    p++, q++;
     b36:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     b3a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
     b3e:	8b 45 08             	mov    0x8(%ebp),%eax
     b41:	0f b6 00             	movzbl (%eax),%eax
     b44:	84 c0                	test   %al,%al
     b46:	74 10                	je     b58 <strcmp+0x27>
     b48:	8b 45 08             	mov    0x8(%ebp),%eax
     b4b:	0f b6 10             	movzbl (%eax),%edx
     b4e:	8b 45 0c             	mov    0xc(%ebp),%eax
     b51:	0f b6 00             	movzbl (%eax),%eax
     b54:	38 c2                	cmp    %al,%dl
     b56:	74 de                	je     b36 <strcmp+0x5>
    p++, q++;
  return (uchar)*p - (uchar)*q;
     b58:	8b 45 08             	mov    0x8(%ebp),%eax
     b5b:	0f b6 00             	movzbl (%eax),%eax
     b5e:	0f b6 d0             	movzbl %al,%edx
     b61:	8b 45 0c             	mov    0xc(%ebp),%eax
     b64:	0f b6 00             	movzbl (%eax),%eax
     b67:	0f b6 c0             	movzbl %al,%eax
     b6a:	89 d1                	mov    %edx,%ecx
     b6c:	29 c1                	sub    %eax,%ecx
     b6e:	89 c8                	mov    %ecx,%eax
}
     b70:	5d                   	pop    %ebp
     b71:	c3                   	ret    

00000b72 <strlen>:

uint
strlen(char *s)
{
     b72:	55                   	push   %ebp
     b73:	89 e5                	mov    %esp,%ebp
     b75:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
     b78:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
     b7f:	eb 04                	jmp    b85 <strlen+0x13>
     b81:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     b85:	8b 45 fc             	mov    -0x4(%ebp),%eax
     b88:	03 45 08             	add    0x8(%ebp),%eax
     b8b:	0f b6 00             	movzbl (%eax),%eax
     b8e:	84 c0                	test   %al,%al
     b90:	75 ef                	jne    b81 <strlen+0xf>
    ;
  return n;
     b92:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     b95:	c9                   	leave  
     b96:	c3                   	ret    

00000b97 <memset>:

void*
memset(void *dst, int c, uint n)
{
     b97:	55                   	push   %ebp
     b98:	89 e5                	mov    %esp,%ebp
     b9a:	83 ec 0c             	sub    $0xc,%esp
  stosb(dst, c, n);
     b9d:	8b 45 10             	mov    0x10(%ebp),%eax
     ba0:	89 44 24 08          	mov    %eax,0x8(%esp)
     ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
     ba7:	89 44 24 04          	mov    %eax,0x4(%esp)
     bab:	8b 45 08             	mov    0x8(%ebp),%eax
     bae:	89 04 24             	mov    %eax,(%esp)
     bb1:	e8 22 ff ff ff       	call   ad8 <stosb>
  return dst;
     bb6:	8b 45 08             	mov    0x8(%ebp),%eax
}
     bb9:	c9                   	leave  
     bba:	c3                   	ret    

00000bbb <strchr>:

char*
strchr(const char *s, char c)
{
     bbb:	55                   	push   %ebp
     bbc:	89 e5                	mov    %esp,%ebp
     bbe:	83 ec 04             	sub    $0x4,%esp
     bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
     bc4:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
     bc7:	eb 14                	jmp    bdd <strchr+0x22>
    if(*s == c)
     bc9:	8b 45 08             	mov    0x8(%ebp),%eax
     bcc:	0f b6 00             	movzbl (%eax),%eax
     bcf:	3a 45 fc             	cmp    -0x4(%ebp),%al
     bd2:	75 05                	jne    bd9 <strchr+0x1e>
      return (char*)s;
     bd4:	8b 45 08             	mov    0x8(%ebp),%eax
     bd7:	eb 13                	jmp    bec <strchr+0x31>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
     bd9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
     bdd:	8b 45 08             	mov    0x8(%ebp),%eax
     be0:	0f b6 00             	movzbl (%eax),%eax
     be3:	84 c0                	test   %al,%al
     be5:	75 e2                	jne    bc9 <strchr+0xe>
    if(*s == c)
      return (char*)s;
  return 0;
     be7:	b8 00 00 00 00       	mov    $0x0,%eax
}
     bec:	c9                   	leave  
     bed:	c3                   	ret    

00000bee <gets>:

char*
gets(char *buf, int max)
{
     bee:	55                   	push   %ebp
     bef:	89 e5                	mov    %esp,%ebp
     bf1:	83 ec 28             	sub    $0x28,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     bf4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
     bfb:	eb 44                	jmp    c41 <gets+0x53>
    cc = read(0, &c, 1);
     bfd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     c04:	00 
     c05:	8d 45 ef             	lea    -0x11(%ebp),%eax
     c08:	89 44 24 04          	mov    %eax,0x4(%esp)
     c0c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     c13:	e8 3c 01 00 00       	call   d54 <read>
     c18:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
     c1b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     c1f:	7e 2d                	jle    c4e <gets+0x60>
      break;
    buf[i++] = c;
     c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c24:	03 45 08             	add    0x8(%ebp),%eax
     c27:	0f b6 55 ef          	movzbl -0x11(%ebp),%edx
     c2b:	88 10                	mov    %dl,(%eax)
     c2d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(c == '\n' || c == '\r')
     c31:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     c35:	3c 0a                	cmp    $0xa,%al
     c37:	74 16                	je     c4f <gets+0x61>
     c39:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
     c3d:	3c 0d                	cmp    $0xd,%al
     c3f:	74 0e                	je     c4f <gets+0x61>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c44:	83 c0 01             	add    $0x1,%eax
     c47:	3b 45 0c             	cmp    0xc(%ebp),%eax
     c4a:	7c b1                	jl     bfd <gets+0xf>
     c4c:	eb 01                	jmp    c4f <gets+0x61>
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
     c4e:	90                   	nop
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
     c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c52:	03 45 08             	add    0x8(%ebp),%eax
     c55:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
     c58:	8b 45 08             	mov    0x8(%ebp),%eax
}
     c5b:	c9                   	leave  
     c5c:	c3                   	ret    

00000c5d <stat>:

int
stat(char *n, struct stat *st)
{
     c5d:	55                   	push   %ebp
     c5e:	89 e5                	mov    %esp,%ebp
     c60:	83 ec 28             	sub    $0x28,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     c63:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
     c6a:	00 
     c6b:	8b 45 08             	mov    0x8(%ebp),%eax
     c6e:	89 04 24             	mov    %eax,(%esp)
     c71:	e8 06 01 00 00       	call   d7c <open>
     c76:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
     c79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     c7d:	79 07                	jns    c86 <stat+0x29>
    return -1;
     c7f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     c84:	eb 23                	jmp    ca9 <stat+0x4c>
  r = fstat(fd, st);
     c86:	8b 45 0c             	mov    0xc(%ebp),%eax
     c89:	89 44 24 04          	mov    %eax,0x4(%esp)
     c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c90:	89 04 24             	mov    %eax,(%esp)
     c93:	e8 fc 00 00 00       	call   d94 <fstat>
     c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
     c9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
     c9e:	89 04 24             	mov    %eax,(%esp)
     ca1:	e8 be 00 00 00       	call   d64 <close>
  return r;
     ca6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
     ca9:	c9                   	leave  
     caa:	c3                   	ret    

00000cab <atoi>:

int
atoi(const char *s)
{
     cab:	55                   	push   %ebp
     cac:	89 e5                	mov    %esp,%ebp
     cae:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
     cb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
     cb8:	eb 23                	jmp    cdd <atoi+0x32>
    n = n*10 + *s++ - '0';
     cba:	8b 55 fc             	mov    -0x4(%ebp),%edx
     cbd:	89 d0                	mov    %edx,%eax
     cbf:	c1 e0 02             	shl    $0x2,%eax
     cc2:	01 d0                	add    %edx,%eax
     cc4:	01 c0                	add    %eax,%eax
     cc6:	89 c2                	mov    %eax,%edx
     cc8:	8b 45 08             	mov    0x8(%ebp),%eax
     ccb:	0f b6 00             	movzbl (%eax),%eax
     cce:	0f be c0             	movsbl %al,%eax
     cd1:	01 d0                	add    %edx,%eax
     cd3:	83 e8 30             	sub    $0x30,%eax
     cd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
     cd9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     cdd:	8b 45 08             	mov    0x8(%ebp),%eax
     ce0:	0f b6 00             	movzbl (%eax),%eax
     ce3:	3c 2f                	cmp    $0x2f,%al
     ce5:	7e 0a                	jle    cf1 <atoi+0x46>
     ce7:	8b 45 08             	mov    0x8(%ebp),%eax
     cea:	0f b6 00             	movzbl (%eax),%eax
     ced:	3c 39                	cmp    $0x39,%al
     cef:	7e c9                	jle    cba <atoi+0xf>
    n = n*10 + *s++ - '0';
  return n;
     cf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
     cf4:	c9                   	leave  
     cf5:	c3                   	ret    

00000cf6 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
     cf6:	55                   	push   %ebp
     cf7:	89 e5                	mov    %esp,%ebp
     cf9:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
     cfc:	8b 45 08             	mov    0x8(%ebp),%eax
     cff:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
     d02:	8b 45 0c             	mov    0xc(%ebp),%eax
     d05:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
     d08:	eb 13                	jmp    d1d <memmove+0x27>
    *dst++ = *src++;
     d0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
     d0d:	0f b6 10             	movzbl (%eax),%edx
     d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
     d13:	88 10                	mov    %dl,(%eax)
     d15:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
     d19:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  char *dst, *src;
  
  dst = vdst;
  src = vsrc;
  while(n-- > 0)
     d1d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
     d21:	0f 9f c0             	setg   %al
     d24:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
     d28:	84 c0                	test   %al,%al
     d2a:	75 de                	jne    d0a <memmove+0x14>
    *dst++ = *src++;
  return vdst;
     d2c:	8b 45 08             	mov    0x8(%ebp),%eax
}
     d2f:	c9                   	leave  
     d30:	c3                   	ret    
     d31:	90                   	nop
     d32:	90                   	nop
     d33:	90                   	nop

00000d34 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     d34:	b8 01 00 00 00       	mov    $0x1,%eax
     d39:	cd 40                	int    $0x40
     d3b:	c3                   	ret    

00000d3c <exit>:
SYSCALL(exit)
     d3c:	b8 02 00 00 00       	mov    $0x2,%eax
     d41:	cd 40                	int    $0x40
     d43:	c3                   	ret    

00000d44 <wait>:
SYSCALL(wait)
     d44:	b8 03 00 00 00       	mov    $0x3,%eax
     d49:	cd 40                	int    $0x40
     d4b:	c3                   	ret    

00000d4c <pipe>:
SYSCALL(pipe)
     d4c:	b8 04 00 00 00       	mov    $0x4,%eax
     d51:	cd 40                	int    $0x40
     d53:	c3                   	ret    

00000d54 <read>:
SYSCALL(read)
     d54:	b8 05 00 00 00       	mov    $0x5,%eax
     d59:	cd 40                	int    $0x40
     d5b:	c3                   	ret    

00000d5c <write>:
SYSCALL(write)
     d5c:	b8 10 00 00 00       	mov    $0x10,%eax
     d61:	cd 40                	int    $0x40
     d63:	c3                   	ret    

00000d64 <close>:
SYSCALL(close)
     d64:	b8 15 00 00 00       	mov    $0x15,%eax
     d69:	cd 40                	int    $0x40
     d6b:	c3                   	ret    

00000d6c <kill>:
SYSCALL(kill)
     d6c:	b8 06 00 00 00       	mov    $0x6,%eax
     d71:	cd 40                	int    $0x40
     d73:	c3                   	ret    

00000d74 <exec>:
SYSCALL(exec)
     d74:	b8 07 00 00 00       	mov    $0x7,%eax
     d79:	cd 40                	int    $0x40
     d7b:	c3                   	ret    

00000d7c <open>:
SYSCALL(open)
     d7c:	b8 0f 00 00 00       	mov    $0xf,%eax
     d81:	cd 40                	int    $0x40
     d83:	c3                   	ret    

00000d84 <mknod>:
SYSCALL(mknod)
     d84:	b8 11 00 00 00       	mov    $0x11,%eax
     d89:	cd 40                	int    $0x40
     d8b:	c3                   	ret    

00000d8c <unlink>:
SYSCALL(unlink)
     d8c:	b8 12 00 00 00       	mov    $0x12,%eax
     d91:	cd 40                	int    $0x40
     d93:	c3                   	ret    

00000d94 <fstat>:
SYSCALL(fstat)
     d94:	b8 08 00 00 00       	mov    $0x8,%eax
     d99:	cd 40                	int    $0x40
     d9b:	c3                   	ret    

00000d9c <link>:
SYSCALL(link)
     d9c:	b8 13 00 00 00       	mov    $0x13,%eax
     da1:	cd 40                	int    $0x40
     da3:	c3                   	ret    

00000da4 <mkdir>:
SYSCALL(mkdir)
     da4:	b8 14 00 00 00       	mov    $0x14,%eax
     da9:	cd 40                	int    $0x40
     dab:	c3                   	ret    

00000dac <chdir>:
SYSCALL(chdir)
     dac:	b8 09 00 00 00       	mov    $0x9,%eax
     db1:	cd 40                	int    $0x40
     db3:	c3                   	ret    

00000db4 <dup>:
SYSCALL(dup)
     db4:	b8 0a 00 00 00       	mov    $0xa,%eax
     db9:	cd 40                	int    $0x40
     dbb:	c3                   	ret    

00000dbc <getpid>:
SYSCALL(getpid)
     dbc:	b8 0b 00 00 00       	mov    $0xb,%eax
     dc1:	cd 40                	int    $0x40
     dc3:	c3                   	ret    

00000dc4 <sbrk>:
SYSCALL(sbrk)
     dc4:	b8 0c 00 00 00       	mov    $0xc,%eax
     dc9:	cd 40                	int    $0x40
     dcb:	c3                   	ret    

00000dcc <sleep>:
SYSCALL(sleep)
     dcc:	b8 0d 00 00 00       	mov    $0xd,%eax
     dd1:	cd 40                	int    $0x40
     dd3:	c3                   	ret    

00000dd4 <uptime>:
SYSCALL(uptime)
     dd4:	b8 0e 00 00 00       	mov    $0xe,%eax
     dd9:	cd 40                	int    $0x40
     ddb:	c3                   	ret    

00000ddc <thread_create>:
SYSCALL(thread_create)
     ddc:	b8 16 00 00 00       	mov    $0x16,%eax
     de1:	cd 40                	int    $0x40
     de3:	c3                   	ret    

00000de4 <thread_getId>:
SYSCALL(thread_getId)
     de4:	b8 17 00 00 00       	mov    $0x17,%eax
     de9:	cd 40                	int    $0x40
     deb:	c3                   	ret    

00000dec <thread_getProcId>:
SYSCALL(thread_getProcId)
     dec:	b8 18 00 00 00       	mov    $0x18,%eax
     df1:	cd 40                	int    $0x40
     df3:	c3                   	ret    

00000df4 <thread_join>:
SYSCALL(thread_join)
     df4:	b8 19 00 00 00       	mov    $0x19,%eax
     df9:	cd 40                	int    $0x40
     dfb:	c3                   	ret    

00000dfc <thread_exit>:
SYSCALL(thread_exit)
     dfc:	b8 1a 00 00 00       	mov    $0x1a,%eax
     e01:	cd 40                	int    $0x40
     e03:	c3                   	ret    

00000e04 <binary_semaphore_create>:
SYSCALL(binary_semaphore_create)
     e04:	b8 1b 00 00 00       	mov    $0x1b,%eax
     e09:	cd 40                	int    $0x40
     e0b:	c3                   	ret    

00000e0c <binary_semaphore_down>:
SYSCALL(binary_semaphore_down)
     e0c:	b8 1c 00 00 00       	mov    $0x1c,%eax
     e11:	cd 40                	int    $0x40
     e13:	c3                   	ret    

00000e14 <binary_semaphore_up>:
SYSCALL(binary_semaphore_up)
     e14:	b8 1d 00 00 00       	mov    $0x1d,%eax
     e19:	cd 40                	int    $0x40
     e1b:	c3                   	ret    

00000e1c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     e1c:	55                   	push   %ebp
     e1d:	89 e5                	mov    %esp,%ebp
     e1f:	83 ec 28             	sub    $0x28,%esp
     e22:	8b 45 0c             	mov    0xc(%ebp),%eax
     e25:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
     e28:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
     e2f:	00 
     e30:	8d 45 f4             	lea    -0xc(%ebp),%eax
     e33:	89 44 24 04          	mov    %eax,0x4(%esp)
     e37:	8b 45 08             	mov    0x8(%ebp),%eax
     e3a:	89 04 24             	mov    %eax,(%esp)
     e3d:	e8 1a ff ff ff       	call   d5c <write>
}
     e42:	c9                   	leave  
     e43:	c3                   	ret    

00000e44 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     e44:	55                   	push   %ebp
     e45:	89 e5                	mov    %esp,%ebp
     e47:	83 ec 48             	sub    $0x48,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
     e4a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
     e51:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     e55:	74 17                	je     e6e <printint+0x2a>
     e57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
     e5b:	79 11                	jns    e6e <printint+0x2a>
    neg = 1;
     e5d:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
     e64:	8b 45 0c             	mov    0xc(%ebp),%eax
     e67:	f7 d8                	neg    %eax
     e69:	89 45 ec             	mov    %eax,-0x14(%ebp)
     e6c:	eb 06                	jmp    e74 <printint+0x30>
  } else {
    x = xx;
     e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
     e71:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
     e74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
     e7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
     e7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
     e81:	ba 00 00 00 00       	mov    $0x0,%edx
     e86:	f7 f1                	div    %ecx
     e88:	89 d0                	mov    %edx,%eax
     e8a:	0f b6 90 48 1d 00 00 	movzbl 0x1d48(%eax),%edx
     e91:	8d 45 dc             	lea    -0x24(%ebp),%eax
     e94:	03 45 f4             	add    -0xc(%ebp),%eax
     e97:	88 10                	mov    %dl,(%eax)
     e99:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  }while((x /= base) != 0);
     e9d:	8b 55 10             	mov    0x10(%ebp),%edx
     ea0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
     ea3:	8b 45 ec             	mov    -0x14(%ebp),%eax
     ea6:	ba 00 00 00 00       	mov    $0x0,%edx
     eab:	f7 75 d4             	divl   -0x2c(%ebp)
     eae:	89 45 ec             	mov    %eax,-0x14(%ebp)
     eb1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     eb5:	75 c4                	jne    e7b <printint+0x37>
  if(neg)
     eb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
     ebb:	74 2a                	je     ee7 <printint+0xa3>
    buf[i++] = '-';
     ebd:	8d 45 dc             	lea    -0x24(%ebp),%eax
     ec0:	03 45 f4             	add    -0xc(%ebp),%eax
     ec3:	c6 00 2d             	movb   $0x2d,(%eax)
     ec6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)

  while(--i >= 0)
     eca:	eb 1b                	jmp    ee7 <printint+0xa3>
    putc(fd, buf[i]);
     ecc:	8d 45 dc             	lea    -0x24(%ebp),%eax
     ecf:	03 45 f4             	add    -0xc(%ebp),%eax
     ed2:	0f b6 00             	movzbl (%eax),%eax
     ed5:	0f be c0             	movsbl %al,%eax
     ed8:	89 44 24 04          	mov    %eax,0x4(%esp)
     edc:	8b 45 08             	mov    0x8(%ebp),%eax
     edf:	89 04 24             	mov    %eax,(%esp)
     ee2:	e8 35 ff ff ff       	call   e1c <putc>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
     ee7:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
     eeb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     eef:	79 db                	jns    ecc <printint+0x88>
    putc(fd, buf[i]);
}
     ef1:	c9                   	leave  
     ef2:	c3                   	ret    

00000ef3 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
     ef3:	55                   	push   %ebp
     ef4:	89 e5                	mov    %esp,%ebp
     ef6:	83 ec 38             	sub    $0x38,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
     ef9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
     f00:	8d 45 0c             	lea    0xc(%ebp),%eax
     f03:	83 c0 04             	add    $0x4,%eax
     f06:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
     f09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     f10:	e9 7d 01 00 00       	jmp    1092 <printf+0x19f>
    c = fmt[i] & 0xff;
     f15:	8b 55 0c             	mov    0xc(%ebp),%edx
     f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
     f1b:	01 d0                	add    %edx,%eax
     f1d:	0f b6 00             	movzbl (%eax),%eax
     f20:	0f be c0             	movsbl %al,%eax
     f23:	25 ff 00 00 00       	and    $0xff,%eax
     f28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
     f2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
     f2f:	75 2c                	jne    f5d <printf+0x6a>
      if(c == '%'){
     f31:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
     f35:	75 0c                	jne    f43 <printf+0x50>
        state = '%';
     f37:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
     f3e:	e9 4b 01 00 00       	jmp    108e <printf+0x19b>
      } else {
        putc(fd, c);
     f43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     f46:	0f be c0             	movsbl %al,%eax
     f49:	89 44 24 04          	mov    %eax,0x4(%esp)
     f4d:	8b 45 08             	mov    0x8(%ebp),%eax
     f50:	89 04 24             	mov    %eax,(%esp)
     f53:	e8 c4 fe ff ff       	call   e1c <putc>
     f58:	e9 31 01 00 00       	jmp    108e <printf+0x19b>
      }
    } else if(state == '%'){
     f5d:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
     f61:	0f 85 27 01 00 00    	jne    108e <printf+0x19b>
      if(c == 'd'){
     f67:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
     f6b:	75 2d                	jne    f9a <printf+0xa7>
        printint(fd, *ap, 10, 1);
     f6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
     f70:	8b 00                	mov    (%eax),%eax
     f72:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
     f79:	00 
     f7a:	c7 44 24 08 0a 00 00 	movl   $0xa,0x8(%esp)
     f81:	00 
     f82:	89 44 24 04          	mov    %eax,0x4(%esp)
     f86:	8b 45 08             	mov    0x8(%ebp),%eax
     f89:	89 04 24             	mov    %eax,(%esp)
     f8c:	e8 b3 fe ff ff       	call   e44 <printint>
        ap++;
     f91:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     f95:	e9 ed 00 00 00       	jmp    1087 <printf+0x194>
      } else if(c == 'x' || c == 'p'){
     f9a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
     f9e:	74 06                	je     fa6 <printf+0xb3>
     fa0:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
     fa4:	75 2d                	jne    fd3 <printf+0xe0>
        printint(fd, *ap, 16, 0);
     fa6:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fa9:	8b 00                	mov    (%eax),%eax
     fab:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
     fb2:	00 
     fb3:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
     fba:	00 
     fbb:	89 44 24 04          	mov    %eax,0x4(%esp)
     fbf:	8b 45 08             	mov    0x8(%ebp),%eax
     fc2:	89 04 24             	mov    %eax,(%esp)
     fc5:	e8 7a fe ff ff       	call   e44 <printint>
        ap++;
     fca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
     fce:	e9 b4 00 00 00       	jmp    1087 <printf+0x194>
      } else if(c == 's'){
     fd3:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
     fd7:	75 46                	jne    101f <printf+0x12c>
        s = (char*)*ap;
     fd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
     fdc:	8b 00                	mov    (%eax),%eax
     fde:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
     fe1:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
     fe5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
     fe9:	75 27                	jne    1012 <printf+0x11f>
          s = "(null)";
     feb:	c7 45 f4 70 18 00 00 	movl   $0x1870,-0xc(%ebp)
        while(*s != 0){
     ff2:	eb 1e                	jmp    1012 <printf+0x11f>
          putc(fd, *s);
     ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
     ff7:	0f b6 00             	movzbl (%eax),%eax
     ffa:	0f be c0             	movsbl %al,%eax
     ffd:	89 44 24 04          	mov    %eax,0x4(%esp)
    1001:	8b 45 08             	mov    0x8(%ebp),%eax
    1004:	89 04 24             	mov    %eax,(%esp)
    1007:	e8 10 fe ff ff       	call   e1c <putc>
          s++;
    100c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    1010:	eb 01                	jmp    1013 <printf+0x120>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
    1012:	90                   	nop
    1013:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1016:	0f b6 00             	movzbl (%eax),%eax
    1019:	84 c0                	test   %al,%al
    101b:	75 d7                	jne    ff4 <printf+0x101>
    101d:	eb 68                	jmp    1087 <printf+0x194>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    101f:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
    1023:	75 1d                	jne    1042 <printf+0x14f>
        putc(fd, *ap);
    1025:	8b 45 e8             	mov    -0x18(%ebp),%eax
    1028:	8b 00                	mov    (%eax),%eax
    102a:	0f be c0             	movsbl %al,%eax
    102d:	89 44 24 04          	mov    %eax,0x4(%esp)
    1031:	8b 45 08             	mov    0x8(%ebp),%eax
    1034:	89 04 24             	mov    %eax,(%esp)
    1037:	e8 e0 fd ff ff       	call   e1c <putc>
        ap++;
    103c:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
    1040:	eb 45                	jmp    1087 <printf+0x194>
      } else if(c == '%'){
    1042:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
    1046:	75 17                	jne    105f <printf+0x16c>
        putc(fd, c);
    1048:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    104b:	0f be c0             	movsbl %al,%eax
    104e:	89 44 24 04          	mov    %eax,0x4(%esp)
    1052:	8b 45 08             	mov    0x8(%ebp),%eax
    1055:	89 04 24             	mov    %eax,(%esp)
    1058:	e8 bf fd ff ff       	call   e1c <putc>
    105d:	eb 28                	jmp    1087 <printf+0x194>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    105f:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
    1066:	00 
    1067:	8b 45 08             	mov    0x8(%ebp),%eax
    106a:	89 04 24             	mov    %eax,(%esp)
    106d:	e8 aa fd ff ff       	call   e1c <putc>
        putc(fd, c);
    1072:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    1075:	0f be c0             	movsbl %al,%eax
    1078:	89 44 24 04          	mov    %eax,0x4(%esp)
    107c:	8b 45 08             	mov    0x8(%ebp),%eax
    107f:	89 04 24             	mov    %eax,(%esp)
    1082:	e8 95 fd ff ff       	call   e1c <putc>
      }
      state = 0;
    1087:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    108e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    1092:	8b 55 0c             	mov    0xc(%ebp),%edx
    1095:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1098:	01 d0                	add    %edx,%eax
    109a:	0f b6 00             	movzbl (%eax),%eax
    109d:	84 c0                	test   %al,%al
    109f:	0f 85 70 fe ff ff    	jne    f15 <printf+0x22>
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    10a5:	c9                   	leave  
    10a6:	c3                   	ret    
    10a7:	90                   	nop

000010a8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    10a8:	55                   	push   %ebp
    10a9:	89 e5                	mov    %esp,%ebp
    10ab:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
    10ae:	8b 45 08             	mov    0x8(%ebp),%eax
    10b1:	83 e8 08             	sub    $0x8,%eax
    10b4:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10b7:	a1 64 1d 00 00       	mov    0x1d64,%eax
    10bc:	89 45 fc             	mov    %eax,-0x4(%ebp)
    10bf:	eb 24                	jmp    10e5 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    10c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10c4:	8b 00                	mov    (%eax),%eax
    10c6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    10c9:	77 12                	ja     10dd <free+0x35>
    10cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10ce:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    10d1:	77 24                	ja     10f7 <free+0x4f>
    10d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10d6:	8b 00                	mov    (%eax),%eax
    10d8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    10db:	77 1a                	ja     10f7 <free+0x4f>
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    10dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10e0:	8b 00                	mov    (%eax),%eax
    10e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    10e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10e8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
    10eb:	76 d4                	jbe    10c1 <free+0x19>
    10ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
    10f0:	8b 00                	mov    (%eax),%eax
    10f2:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    10f5:	76 ca                	jbe    10c1 <free+0x19>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    10f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
    10fa:	8b 40 04             	mov    0x4(%eax),%eax
    10fd:	c1 e0 03             	shl    $0x3,%eax
    1100:	89 c2                	mov    %eax,%edx
    1102:	03 55 f8             	add    -0x8(%ebp),%edx
    1105:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1108:	8b 00                	mov    (%eax),%eax
    110a:	39 c2                	cmp    %eax,%edx
    110c:	75 24                	jne    1132 <free+0x8a>
    bp->s.size += p->s.ptr->s.size;
    110e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1111:	8b 50 04             	mov    0x4(%eax),%edx
    1114:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1117:	8b 00                	mov    (%eax),%eax
    1119:	8b 40 04             	mov    0x4(%eax),%eax
    111c:	01 c2                	add    %eax,%edx
    111e:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1121:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
    1124:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1127:	8b 00                	mov    (%eax),%eax
    1129:	8b 10                	mov    (%eax),%edx
    112b:	8b 45 f8             	mov    -0x8(%ebp),%eax
    112e:	89 10                	mov    %edx,(%eax)
    1130:	eb 0a                	jmp    113c <free+0x94>
  } else
    bp->s.ptr = p->s.ptr;
    1132:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1135:	8b 10                	mov    (%eax),%edx
    1137:	8b 45 f8             	mov    -0x8(%ebp),%eax
    113a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
    113c:	8b 45 fc             	mov    -0x4(%ebp),%eax
    113f:	8b 40 04             	mov    0x4(%eax),%eax
    1142:	c1 e0 03             	shl    $0x3,%eax
    1145:	03 45 fc             	add    -0x4(%ebp),%eax
    1148:	3b 45 f8             	cmp    -0x8(%ebp),%eax
    114b:	75 20                	jne    116d <free+0xc5>
    p->s.size += bp->s.size;
    114d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1150:	8b 50 04             	mov    0x4(%eax),%edx
    1153:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1156:	8b 40 04             	mov    0x4(%eax),%eax
    1159:	01 c2                	add    %eax,%edx
    115b:	8b 45 fc             	mov    -0x4(%ebp),%eax
    115e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1161:	8b 45 f8             	mov    -0x8(%ebp),%eax
    1164:	8b 10                	mov    (%eax),%edx
    1166:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1169:	89 10                	mov    %edx,(%eax)
    116b:	eb 08                	jmp    1175 <free+0xcd>
  } else
    p->s.ptr = bp;
    116d:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1170:	8b 55 f8             	mov    -0x8(%ebp),%edx
    1173:	89 10                	mov    %edx,(%eax)
  freep = p;
    1175:	8b 45 fc             	mov    -0x4(%ebp),%eax
    1178:	a3 64 1d 00 00       	mov    %eax,0x1d64
}
    117d:	c9                   	leave  
    117e:	c3                   	ret    

0000117f <morecore>:

static Header*
morecore(uint nu)
{
    117f:	55                   	push   %ebp
    1180:	89 e5                	mov    %esp,%ebp
    1182:	83 ec 28             	sub    $0x28,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
    1185:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
    118c:	77 07                	ja     1195 <morecore+0x16>
    nu = 4096;
    118e:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
    1195:	8b 45 08             	mov    0x8(%ebp),%eax
    1198:	c1 e0 03             	shl    $0x3,%eax
    119b:	89 04 24             	mov    %eax,(%esp)
    119e:	e8 21 fc ff ff       	call   dc4 <sbrk>
    11a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
    11a6:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
    11aa:	75 07                	jne    11b3 <morecore+0x34>
    return 0;
    11ac:	b8 00 00 00 00       	mov    $0x0,%eax
    11b1:	eb 22                	jmp    11d5 <morecore+0x56>
  hp = (Header*)p;
    11b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
    11b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
    11b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11bc:	8b 55 08             	mov    0x8(%ebp),%edx
    11bf:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
    11c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    11c5:	83 c0 08             	add    $0x8,%eax
    11c8:	89 04 24             	mov    %eax,(%esp)
    11cb:	e8 d8 fe ff ff       	call   10a8 <free>
  return freep;
    11d0:	a1 64 1d 00 00       	mov    0x1d64,%eax
}
    11d5:	c9                   	leave  
    11d6:	c3                   	ret    

000011d7 <malloc>:

void*
malloc(uint nbytes)
{
    11d7:	55                   	push   %ebp
    11d8:	89 e5                	mov    %esp,%ebp
    11da:	83 ec 28             	sub    $0x28,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11dd:	8b 45 08             	mov    0x8(%ebp),%eax
    11e0:	83 c0 07             	add    $0x7,%eax
    11e3:	c1 e8 03             	shr    $0x3,%eax
    11e6:	83 c0 01             	add    $0x1,%eax
    11e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
    11ec:	a1 64 1d 00 00       	mov    0x1d64,%eax
    11f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    11f4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
    11f8:	75 23                	jne    121d <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
    11fa:	c7 45 f0 5c 1d 00 00 	movl   $0x1d5c,-0x10(%ebp)
    1201:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1204:	a3 64 1d 00 00       	mov    %eax,0x1d64
    1209:	a1 64 1d 00 00       	mov    0x1d64,%eax
    120e:	a3 5c 1d 00 00       	mov    %eax,0x1d5c
    base.s.size = 0;
    1213:	c7 05 60 1d 00 00 00 	movl   $0x0,0x1d60
    121a:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    121d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1220:	8b 00                	mov    (%eax),%eax
    1222:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
    1225:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1228:	8b 40 04             	mov    0x4(%eax),%eax
    122b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    122e:	72 4d                	jb     127d <malloc+0xa6>
      if(p->s.size == nunits)
    1230:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1233:	8b 40 04             	mov    0x4(%eax),%eax
    1236:	3b 45 ec             	cmp    -0x14(%ebp),%eax
    1239:	75 0c                	jne    1247 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
    123b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    123e:	8b 10                	mov    (%eax),%edx
    1240:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1243:	89 10                	mov    %edx,(%eax)
    1245:	eb 26                	jmp    126d <malloc+0x96>
      else {
        p->s.size -= nunits;
    1247:	8b 45 f4             	mov    -0xc(%ebp),%eax
    124a:	8b 40 04             	mov    0x4(%eax),%eax
    124d:	89 c2                	mov    %eax,%edx
    124f:	2b 55 ec             	sub    -0x14(%ebp),%edx
    1252:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1255:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1258:	8b 45 f4             	mov    -0xc(%ebp),%eax
    125b:	8b 40 04             	mov    0x4(%eax),%eax
    125e:	c1 e0 03             	shl    $0x3,%eax
    1261:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
    1264:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1267:	8b 55 ec             	mov    -0x14(%ebp),%edx
    126a:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
    126d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1270:	a3 64 1d 00 00       	mov    %eax,0x1d64
      return (void*)(p + 1);
    1275:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1278:	83 c0 08             	add    $0x8,%eax
    127b:	eb 38                	jmp    12b5 <malloc+0xde>
    }
    if(p == freep)
    127d:	a1 64 1d 00 00       	mov    0x1d64,%eax
    1282:	39 45 f4             	cmp    %eax,-0xc(%ebp)
    1285:	75 1b                	jne    12a2 <malloc+0xcb>
      if((p = morecore(nunits)) == 0)
    1287:	8b 45 ec             	mov    -0x14(%ebp),%eax
    128a:	89 04 24             	mov    %eax,(%esp)
    128d:	e8 ed fe ff ff       	call   117f <morecore>
    1292:	89 45 f4             	mov    %eax,-0xc(%ebp)
    1295:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
    1299:	75 07                	jne    12a2 <malloc+0xcb>
        return 0;
    129b:	b8 00 00 00 00       	mov    $0x0,%eax
    12a0:	eb 13                	jmp    12b5 <malloc+0xde>
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    12a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12ab:	8b 00                	mov    (%eax),%eax
    12ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
    12b0:	e9 70 ff ff ff       	jmp    1225 <malloc+0x4e>
}
    12b5:	c9                   	leave  
    12b6:	c3                   	ret    
    12b7:	90                   	nop

000012b8 <semaphore_create>:
#include "semaphore.h"

struct semaphore* 
semaphore_create(int initial_semaphore_value, char* name)
{
    12b8:	55                   	push   %ebp
    12b9:	89 e5                	mov    %esp,%ebp
    12bb:	83 ec 28             	sub    $0x28,%esp
  int min = 1;
    12be:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  struct semaphore* s = malloc(sizeof(struct semaphore));
    12c5:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
    12cc:	e8 06 ff ff ff       	call   11d7 <malloc>
    12d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if((s->s1 = binary_semaphore_create(1)) != -1)
    12d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    12db:	e8 24 fb ff ff       	call   e04 <binary_semaphore_create>
    12e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
    12e3:	89 42 04             	mov    %eax,0x4(%edx)
    12e6:	83 f8 ff             	cmp    $0xffffffff,%eax
    12e9:	74 38                	je     1323 <semaphore_create+0x6b>
  {
    if(initial_semaphore_value < 1)
    12eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    12ef:	7f 06                	jg     12f7 <semaphore_create+0x3f>
      min = initial_semaphore_value;
    12f1:	8b 45 08             	mov    0x8(%ebp),%eax
    12f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if((s->s2 = binary_semaphore_create(min)) != -1)
    12f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    12fa:	89 04 24             	mov    %eax,(%esp)
    12fd:	e8 02 fb ff ff       	call   e04 <binary_semaphore_create>
    1302:	8b 55 f0             	mov    -0x10(%ebp),%edx
    1305:	89 42 08             	mov    %eax,0x8(%edx)
    1308:	83 f8 ff             	cmp    $0xffffffff,%eax
    130b:	74 16                	je     1323 <semaphore_create+0x6b>
    {
      s->value = initial_semaphore_value;
    130d:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1310:	8b 55 08             	mov    0x8(%ebp),%edx
    1313:	89 10                	mov    %edx,(%eax)
      s->name = name;
    1315:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1318:	8b 55 0c             	mov    0xc(%ebp),%edx
    131b:	89 50 0c             	mov    %edx,0xc(%eax)
      return s;
    131e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1321:	eb 15                	jmp    1338 <semaphore_create+0x80>
    }
  }
  free(s);
    1323:	8b 45 f0             	mov    -0x10(%ebp),%eax
    1326:	89 04 24             	mov    %eax,(%esp)
    1329:	e8 7a fd ff ff       	call   10a8 <free>
  s = 0;
    132e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  return s;
    1335:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
    1338:	c9                   	leave  
    1339:	c3                   	ret    

0000133a <semaphore_down>:

void 
semaphore_down(struct semaphore* sem )
{
    133a:	55                   	push   %ebp
    133b:	89 e5                	mov    %esp,%ebp
    133d:	83 ec 18             	sub    $0x18,%esp
 //printf(1,"semaphore_down for tid = %d\n",thread_getId());
 binary_semaphore_down(sem->s2);
    1340:	8b 45 08             	mov    0x8(%ebp),%eax
    1343:	8b 40 08             	mov    0x8(%eax),%eax
    1346:	89 04 24             	mov    %eax,(%esp)
    1349:	e8 be fa ff ff       	call   e0c <binary_semaphore_down>
 binary_semaphore_down(sem->s1);
    134e:	8b 45 08             	mov    0x8(%ebp),%eax
    1351:	8b 40 04             	mov    0x4(%eax),%eax
    1354:	89 04 24             	mov    %eax,(%esp)
    1357:	e8 b0 fa ff ff       	call   e0c <binary_semaphore_down>
 sem->value--;
    135c:	8b 45 08             	mov    0x8(%ebp),%eax
    135f:	8b 00                	mov    (%eax),%eax
    1361:	8d 50 ff             	lea    -0x1(%eax),%edx
    1364:	8b 45 08             	mov    0x8(%ebp),%eax
    1367:	89 10                	mov    %edx,(%eax)
 //printf(1,"DOWN - sem %s semaphore_value = %d for tid = %d\n",sem->name,sem->value,thread_getId());
 if(sem->value>0)
    1369:	8b 45 08             	mov    0x8(%ebp),%eax
    136c:	8b 00                	mov    (%eax),%eax
    136e:	85 c0                	test   %eax,%eax
    1370:	7e 0e                	jle    1380 <semaphore_down+0x46>
  binary_semaphore_up(sem->s2);
    1372:	8b 45 08             	mov    0x8(%ebp),%eax
    1375:	8b 40 08             	mov    0x8(%eax),%eax
    1378:	89 04 24             	mov    %eax,(%esp)
    137b:	e8 94 fa ff ff       	call   e14 <binary_semaphore_up>
 binary_semaphore_up(sem->s1);
    1380:	8b 45 08             	mov    0x8(%ebp),%eax
    1383:	8b 40 04             	mov    0x4(%eax),%eax
    1386:	89 04 24             	mov    %eax,(%esp)
    1389:	e8 86 fa ff ff       	call   e14 <binary_semaphore_up>
}
    138e:	c9                   	leave  
    138f:	c3                   	ret    

00001390 <semaphore_up>:

void 
semaphore_up(struct semaphore* sem )
{
    1390:	55                   	push   %ebp
    1391:	89 e5                	mov    %esp,%ebp
    1393:	83 ec 18             	sub    $0x18,%esp
  //printf(1,"semaphore_up for tid = %d\n",thread_getId());
  binary_semaphore_down(sem->s1);
    1396:	8b 45 08             	mov    0x8(%ebp),%eax
    1399:	8b 40 04             	mov    0x4(%eax),%eax
    139c:	89 04 24             	mov    %eax,(%esp)
    139f:	e8 68 fa ff ff       	call   e0c <binary_semaphore_down>
  sem->value++;
    13a4:	8b 45 08             	mov    0x8(%ebp),%eax
    13a7:	8b 00                	mov    (%eax),%eax
    13a9:	8d 50 01             	lea    0x1(%eax),%edx
    13ac:	8b 45 08             	mov    0x8(%ebp),%eax
    13af:	89 10                	mov    %edx,(%eax)
  //printf(1,"UP - sem %s semaphore_value = %d for tid = %d\n",sem->name,sem->value,thread_getId());
  if(sem->value == 1)
    13b1:	8b 45 08             	mov    0x8(%ebp),%eax
    13b4:	8b 00                	mov    (%eax),%eax
    13b6:	83 f8 01             	cmp    $0x1,%eax
    13b9:	75 0e                	jne    13c9 <semaphore_up+0x39>
    binary_semaphore_up(sem->s2);
    13bb:	8b 45 08             	mov    0x8(%ebp),%eax
    13be:	8b 40 08             	mov    0x8(%eax),%eax
    13c1:	89 04 24             	mov    %eax,(%esp)
    13c4:	e8 4b fa ff ff       	call   e14 <binary_semaphore_up>
  binary_semaphore_up(sem->s1);
    13c9:	8b 45 08             	mov    0x8(%ebp),%eax
    13cc:	8b 40 04             	mov    0x4(%eax),%eax
    13cf:	89 04 24             	mov    %eax,(%esp)
    13d2:	e8 3d fa ff ff       	call   e14 <binary_semaphore_up>
}
    13d7:	c9                   	leave  
    13d8:	c3                   	ret    
    13d9:	90                   	nop
    13da:	90                   	nop
    13db:	90                   	nop

000013dc <BB_create>:
#include "boundedbuffer.h"

struct BB* 
BB_create(int max_capacity,char* name)
{
    13dc:	55                   	push   %ebp
    13dd:	89 e5                	mov    %esp,%ebp
    13df:	83 ec 28             	sub    $0x28,%esp
  struct BB* buf = malloc(sizeof(struct BB));
    13e2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
    13e9:	e8 e9 fd ff ff       	call   11d7 <malloc>
    13ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(buf,0,sizeof(struct BB));
    13f1:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
    13f8:	00 
    13f9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    1400:	00 
    1401:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1404:	89 04 24             	mov    %eax,(%esp)
    1407:	e8 8b f7 ff ff       	call   b97 <memset>
  buf->elements = malloc(sizeof(void*)*max_capacity);
    140c:	8b 45 08             	mov    0x8(%ebp),%eax
    140f:	c1 e0 02             	shl    $0x2,%eax
    1412:	89 04 24             	mov    %eax,(%esp)
    1415:	e8 bd fd ff ff       	call   11d7 <malloc>
    141a:	8b 55 f4             	mov    -0xc(%ebp),%edx
    141d:	89 42 1c             	mov    %eax,0x1c(%edx)
  memset(buf->elements,0,sizeof(void*)*max_capacity);
    1420:	8b 45 08             	mov    0x8(%ebp),%eax
    1423:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
    142a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    142d:	8b 40 1c             	mov    0x1c(%eax),%eax
    1430:	89 54 24 08          	mov    %edx,0x8(%esp)
    1434:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
    143b:	00 
    143c:	89 04 24             	mov    %eax,(%esp)
    143f:	e8 53 f7 ff ff       	call   b97 <memset>
  buf->name = name;
    1444:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1447:	8b 55 0c             	mov    0xc(%ebp),%edx
    144a:	89 50 18             	mov    %edx,0x18(%eax)
  if((buf->mutex = binary_semaphore_create(1)) != -1)
    144d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    1454:	e8 ab f9 ff ff       	call   e04 <binary_semaphore_create>
    1459:	8b 55 f4             	mov    -0xc(%ebp),%edx
    145c:	89 42 04             	mov    %eax,0x4(%edx)
    145f:	83 f8 ff             	cmp    $0xffffffff,%eax
    1462:	74 52                	je     14b6 <BB_create+0xda>
  {
    buf->BUFFER_SIZE = max_capacity;
    1464:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1467:	8b 55 08             	mov    0x8(%ebp),%edx
    146a:	89 10                	mov    %edx,(%eax)
    if((buf->empty = semaphore_create(max_capacity, name))!= 0 && (buf->full = semaphore_create(0, name))!= 0)
    146c:	8b 45 0c             	mov    0xc(%ebp),%eax
    146f:	89 44 24 04          	mov    %eax,0x4(%esp)
    1473:	8b 45 08             	mov    0x8(%ebp),%eax
    1476:	89 04 24             	mov    %eax,(%esp)
    1479:	e8 3a fe ff ff       	call   12b8 <semaphore_create>
    147e:	8b 55 f4             	mov    -0xc(%ebp),%edx
    1481:	89 42 08             	mov    %eax,0x8(%edx)
    1484:	8b 45 f4             	mov    -0xc(%ebp),%eax
    1487:	8b 40 08             	mov    0x8(%eax),%eax
    148a:	85 c0                	test   %eax,%eax
    148c:	74 28                	je     14b6 <BB_create+0xda>
    148e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1491:	89 44 24 04          	mov    %eax,0x4(%esp)
    1495:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    149c:	e8 17 fe ff ff       	call   12b8 <semaphore_create>
    14a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
    14a4:	89 42 0c             	mov    %eax,0xc(%edx)
    14a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14aa:	8b 40 0c             	mov    0xc(%eax),%eax
    14ad:	85 c0                	test   %eax,%eax
    14af:	74 05                	je     14b6 <BB_create+0xda>
      return buf;
    14b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14b4:	eb 23                	jmp    14d9 <BB_create+0xfd>
  }
  free(buf->elements);
    14b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14b9:	8b 40 1c             	mov    0x1c(%eax),%eax
    14bc:	89 04 24             	mov    %eax,(%esp)
    14bf:	e8 e4 fb ff ff       	call   10a8 <free>
  free(buf);
    14c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    14c7:	89 04 24             	mov    %eax,(%esp)
    14ca:	e8 d9 fb ff ff       	call   10a8 <free>
  buf = 0;
    14cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  return buf;
    14d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    14d9:	c9                   	leave  
    14da:	c3                   	ret    

000014db <BB_put>:

void 
BB_put(struct BB* bb, void* element)
{
    14db:	55                   	push   %ebp
    14dc:	89 e5                	mov    %esp,%ebp
    14de:	83 ec 18             	sub    $0x18,%esp
 // printf(1,"put in %s, tid = %d\n",bb->name,thread_getId());
  semaphore_down(bb->empty);
    14e1:	8b 45 08             	mov    0x8(%ebp),%eax
    14e4:	8b 40 08             	mov    0x8(%eax),%eax
    14e7:	89 04 24             	mov    %eax,(%esp)
    14ea:	e8 4b fe ff ff       	call   133a <semaphore_down>
  binary_semaphore_down(bb->mutex);
    14ef:	8b 45 08             	mov    0x8(%ebp),%eax
    14f2:	8b 40 04             	mov    0x4(%eax),%eax
    14f5:	89 04 24             	mov    %eax,(%esp)
    14f8:	e8 0f f9 ff ff       	call   e0c <binary_semaphore_down>
  bb->elements[bb->end] = element;
    14fd:	8b 45 08             	mov    0x8(%ebp),%eax
    1500:	8b 50 1c             	mov    0x1c(%eax),%edx
    1503:	8b 45 08             	mov    0x8(%ebp),%eax
    1506:	8b 40 14             	mov    0x14(%eax),%eax
    1509:	c1 e0 02             	shl    $0x2,%eax
    150c:	01 c2                	add    %eax,%edx
    150e:	8b 45 0c             	mov    0xc(%ebp),%eax
    1511:	89 02                	mov    %eax,(%edx)
  ++bb->end;
    1513:	8b 45 08             	mov    0x8(%ebp),%eax
    1516:	8b 40 14             	mov    0x14(%eax),%eax
    1519:	8d 50 01             	lea    0x1(%eax),%edx
    151c:	8b 45 08             	mov    0x8(%ebp),%eax
    151f:	89 50 14             	mov    %edx,0x14(%eax)
  bb->end = bb->end%bb->BUFFER_SIZE;
    1522:	8b 45 08             	mov    0x8(%ebp),%eax
    1525:	8b 40 14             	mov    0x14(%eax),%eax
    1528:	8b 55 08             	mov    0x8(%ebp),%edx
    152b:	8b 0a                	mov    (%edx),%ecx
    152d:	89 c2                	mov    %eax,%edx
    152f:	c1 fa 1f             	sar    $0x1f,%edx
    1532:	f7 f9                	idiv   %ecx
    1534:	8b 45 08             	mov    0x8(%ebp),%eax
    1537:	89 50 14             	mov    %edx,0x14(%eax)
  binary_semaphore_up(bb->mutex);
    153a:	8b 45 08             	mov    0x8(%ebp),%eax
    153d:	8b 40 04             	mov    0x4(%eax),%eax
    1540:	89 04 24             	mov    %eax,(%esp)
    1543:	e8 cc f8 ff ff       	call   e14 <binary_semaphore_up>
  semaphore_up(bb->full);
    1548:	8b 45 08             	mov    0x8(%ebp),%eax
    154b:	8b 40 0c             	mov    0xc(%eax),%eax
    154e:	89 04 24             	mov    %eax,(%esp)
    1551:	e8 3a fe ff ff       	call   1390 <semaphore_up>
}
    1556:	c9                   	leave  
    1557:	c3                   	ret    

00001558 <BB_pop>:

void* 
BB_pop(struct BB* bb)
{
    1558:	55                   	push   %ebp
    1559:	89 e5                	mov    %esp,%ebp
    155b:	83 ec 28             	sub    $0x28,%esp
  void* item;
  //printf(1,"pop from  %s, tid = %d\n",bb->name,thread_getId());
  semaphore_down(bb->full);
    155e:	8b 45 08             	mov    0x8(%ebp),%eax
    1561:	8b 40 0c             	mov    0xc(%eax),%eax
    1564:	89 04 24             	mov    %eax,(%esp)
    1567:	e8 ce fd ff ff       	call   133a <semaphore_down>
  binary_semaphore_down(bb->mutex);
    156c:	8b 45 08             	mov    0x8(%ebp),%eax
    156f:	8b 40 04             	mov    0x4(%eax),%eax
    1572:	89 04 24             	mov    %eax,(%esp)
    1575:	e8 92 f8 ff ff       	call   e0c <binary_semaphore_down>
  item = bb->elements[bb->start];
    157a:	8b 45 08             	mov    0x8(%ebp),%eax
    157d:	8b 50 1c             	mov    0x1c(%eax),%edx
    1580:	8b 45 08             	mov    0x8(%ebp),%eax
    1583:	8b 40 10             	mov    0x10(%eax),%eax
    1586:	c1 e0 02             	shl    $0x2,%eax
    1589:	01 d0                	add    %edx,%eax
    158b:	8b 00                	mov    (%eax),%eax
    158d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bb->elements[bb->start] = 0;
    1590:	8b 45 08             	mov    0x8(%ebp),%eax
    1593:	8b 50 1c             	mov    0x1c(%eax),%edx
    1596:	8b 45 08             	mov    0x8(%ebp),%eax
    1599:	8b 40 10             	mov    0x10(%eax),%eax
    159c:	c1 e0 02             	shl    $0x2,%eax
    159f:	01 d0                	add    %edx,%eax
    15a1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  ++bb->start;
    15a7:	8b 45 08             	mov    0x8(%ebp),%eax
    15aa:	8b 40 10             	mov    0x10(%eax),%eax
    15ad:	8d 50 01             	lea    0x1(%eax),%edx
    15b0:	8b 45 08             	mov    0x8(%ebp),%eax
    15b3:	89 50 10             	mov    %edx,0x10(%eax)
  bb->start = bb->start%bb->BUFFER_SIZE;
    15b6:	8b 45 08             	mov    0x8(%ebp),%eax
    15b9:	8b 40 10             	mov    0x10(%eax),%eax
    15bc:	8b 55 08             	mov    0x8(%ebp),%edx
    15bf:	8b 0a                	mov    (%edx),%ecx
    15c1:	89 c2                	mov    %eax,%edx
    15c3:	c1 fa 1f             	sar    $0x1f,%edx
    15c6:	f7 f9                	idiv   %ecx
    15c8:	8b 45 08             	mov    0x8(%ebp),%eax
    15cb:	89 50 10             	mov    %edx,0x10(%eax)
  binary_semaphore_up(bb->mutex);
    15ce:	8b 45 08             	mov    0x8(%ebp),%eax
    15d1:	8b 40 04             	mov    0x4(%eax),%eax
    15d4:	89 04 24             	mov    %eax,(%esp)
    15d7:	e8 38 f8 ff ff       	call   e14 <binary_semaphore_up>
  semaphore_up(bb->empty);
    15dc:	8b 45 08             	mov    0x8(%ebp),%eax
    15df:	8b 40 08             	mov    0x8(%eax),%eax
    15e2:	89 04 24             	mov    %eax,(%esp)
    15e5:	e8 a6 fd ff ff       	call   1390 <semaphore_up>
  return item;
    15ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
    15ed:	c9                   	leave  
    15ee:	c3                   	ret    
