
_sysinfotest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  }
}

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 0c             	sub    $0xc,%esp
  printf(1,"sysinfotest: start\n");
  15:	68 19 0b 00 00       	push   $0xb19
  1a:	6a 01                	push   $0x1
  1c:	e8 3f 07 00 00       	call   760 <printf>
  testcall();
  21:	e8 ea 01 00 00       	call   210 <testcall>
  testmem();
  26:	e8 f5 00 00 00       	call   120 <testmem>
  testproc();
  2b:	e8 40 02 00 00       	call   270 <testproc>
  printf(1,"sysinfotest: OK\n");
  30:	58                   	pop    %eax
  31:	5a                   	pop    %edx
  32:	68 2d 0b 00 00       	push   $0xb2d
  37:	6a 01                	push   $0x1
  39:	e8 22 07 00 00       	call   760 <printf>
  exit();
  3e:	e8 b0 05 00 00       	call   5f3 <exit>
  43:	66 90                	xchg   %ax,%ax
  45:	66 90                	xchg   %ax,%ax
  47:	66 90                	xchg   %ax,%ax
  49:	66 90                	xchg   %ax,%ax
  4b:	66 90                	xchg   %ax,%ax
  4d:	66 90                	xchg   %ax,%ax
  4f:	90                   	nop

00000050 <sinfo.part.0>:
sinfo(struct sysinfo *info) {
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	83 ec 10             	sub    $0x10,%esp
    printf(1,"FAIL: sysinfo failed");
  56:	68 c8 0a 00 00       	push   $0xac8
  5b:	6a 01                	push   $0x1
  5d:	e8 fe 06 00 00       	call   760 <printf>
    exit();
  62:	e8 8c 05 00 00       	call   5f3 <exit>
  67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  6e:	66 90                	xchg   %ax,%ax

00000070 <sinfo>:
sinfo(struct sysinfo *info) {
  70:	f3 0f 1e fb          	endbr32 
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	83 ec 14             	sub    $0x14,%esp
  if (sysinfo(info) < 0) {
  7a:	ff 75 08             	pushl  0x8(%ebp)
  7d:	e8 19 06 00 00       	call   69b <sysinfo>
  82:	83 c4 10             	add    $0x10,%esp
  85:	85 c0                	test   %eax,%eax
  87:	78 02                	js     8b <sinfo+0x1b>
}
  89:	c9                   	leave  
  8a:	c3                   	ret    
  8b:	e8 c0 ff ff ff       	call   50 <sinfo.part.0>

00000090 <countfree>:
{
  90:	f3 0f 1e fb          	endbr32 
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	56                   	push   %esi
  98:	53                   	push   %ebx
  uint n = 0;
  99:	31 db                	xor    %ebx,%ebx
{
  9b:	83 ec 1c             	sub    $0x1c,%esp
  uint sz0 = (uint)sbrk(0);
  9e:	6a 00                	push   $0x0
  a0:	e8 d6 05 00 00       	call   67b <sbrk>
  a5:	83 c4 10             	add    $0x10,%esp
  a8:	89 c6                	mov    %eax,%esi
  uint n = 0;
  aa:	eb 0a                	jmp    b6 <countfree+0x26>
  ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    n += PGSIZE;
  b0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((uint)sbrk(PGSIZE) == 0xffffffff){
  b6:	83 ec 0c             	sub    $0xc,%esp
  b9:	68 00 10 00 00       	push   $0x1000
  be:	e8 b8 05 00 00       	call   67b <sbrk>
  c3:	83 c4 10             	add    $0x10,%esp
  c6:	83 f8 ff             	cmp    $0xffffffff,%eax
  c9:	75 e5                	jne    b0 <countfree+0x20>
  if (sysinfo(info) < 0) {
  cb:	83 ec 0c             	sub    $0xc,%esp
  ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
  d1:	50                   	push   %eax
  d2:	e8 c4 05 00 00       	call   69b <sysinfo>
  d7:	83 c4 10             	add    $0x10,%esp
  da:	85 c0                	test   %eax,%eax
  dc:	78 24                	js     102 <countfree+0x72>
  if (info.memfree != 0) {
  de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  e1:	85 c0                	test   %eax,%eax
  e3:	75 22                	jne    107 <countfree+0x77>
  sbrk(-((int)sbrk(0) - sz0));
  e5:	83 ec 0c             	sub    $0xc,%esp
  e8:	6a 00                	push   $0x0
  ea:	e8 8c 05 00 00       	call   67b <sbrk>
  ef:	29 c6                	sub    %eax,%esi
  f1:	89 34 24             	mov    %esi,(%esp)
  f4:	e8 82 05 00 00       	call   67b <sbrk>
}
  f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  fc:	89 d8                	mov    %ebx,%eax
  fe:	5b                   	pop    %ebx
  ff:	5e                   	pop    %esi
 100:	5d                   	pop    %ebp
 101:	c3                   	ret    
 102:	e8 49 ff ff ff       	call   50 <sinfo.part.0>
    printf(1,"FAIL: there is no free mem, but sysinfo.memfree=%d\n",
 107:	52                   	push   %edx
 108:	50                   	push   %eax
 109:	68 40 0b 00 00       	push   $0xb40
 10e:	6a 01                	push   $0x1
 110:	e8 4b 06 00 00       	call   760 <printf>
    exit();
 115:	e8 d9 04 00 00       	call   5f3 <exit>
 11a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000120 <testmem>:
testmem() {
 120:	f3 0f 1e fb          	endbr32 
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	57                   	push   %edi
 128:	56                   	push   %esi
  if (sysinfo(info) < 0) {
 129:	8d 75 e0             	lea    -0x20(%ebp),%esi
testmem() {
 12c:	53                   	push   %ebx
 12d:	83 ec 1c             	sub    $0x1c,%esp
  uint n = countfree();
 130:	e8 5b ff ff ff       	call   90 <countfree>
  if (sysinfo(info) < 0) {
 135:	83 ec 0c             	sub    $0xc,%esp
 138:	56                   	push   %esi
  uint n = countfree();
 139:	89 c7                	mov    %eax,%edi
  if (sysinfo(info) < 0) {
 13b:	e8 5b 05 00 00       	call   69b <sysinfo>
 140:	83 c4 10             	add    $0x10,%esp
 143:	85 c0                	test   %eax,%eax
 145:	0f 88 83 00 00 00    	js     1ce <testmem+0xae>
  info.memfree *= 1024;
 14b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
 14e:	c1 e3 0a             	shl    $0xa,%ebx
 151:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  if (info.memfree != n) {
 154:	39 fb                	cmp    %edi,%ebx
 156:	0f 85 8a 00 00 00    	jne    1e6 <testmem+0xc6>
  if((uint)sbrk(PGSIZE) == 0xffffffff){
 15c:	83 ec 0c             	sub    $0xc,%esp
 15f:	68 00 10 00 00       	push   $0x1000
 164:	e8 12 05 00 00       	call   67b <sbrk>
 169:	83 c4 10             	add    $0x10,%esp
 16c:	83 f8 ff             	cmp    $0xffffffff,%eax
 16f:	74 62                	je     1d3 <testmem+0xb3>
  if (sysinfo(info) < 0) {
 171:	83 ec 0c             	sub    $0xc,%esp
 174:	56                   	push   %esi
 175:	e8 21 05 00 00       	call   69b <sysinfo>
 17a:	83 c4 10             	add    $0x10,%esp
 17d:	85 c0                	test   %eax,%eax
 17f:	78 4d                	js     1ce <testmem+0xae>
  info.memfree *= 1024;
 181:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if (info.memfree != n-PGSIZE) {
 184:	8d 93 00 f0 ff ff    	lea    -0x1000(%ebx),%edx
  info.memfree *= 1024;
 18a:	c1 e0 0a             	shl    $0xa,%eax
 18d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (info.memfree != n-PGSIZE) {
 190:	39 d0                	cmp    %edx,%eax
 192:	75 68                	jne    1fc <testmem+0xdc>
  if((uint)sbrk(-PGSIZE) == 0xffffffff){
 194:	83 ec 0c             	sub    $0xc,%esp
 197:	68 00 f0 ff ff       	push   $0xfffff000
 19c:	e8 da 04 00 00       	call   67b <sbrk>
 1a1:	83 c4 10             	add    $0x10,%esp
 1a4:	83 f8 ff             	cmp    $0xffffffff,%eax
 1a7:	74 2a                	je     1d3 <testmem+0xb3>
  if (sysinfo(info) < 0) {
 1a9:	83 ec 0c             	sub    $0xc,%esp
 1ac:	56                   	push   %esi
 1ad:	e8 e9 04 00 00       	call   69b <sysinfo>
 1b2:	83 c4 10             	add    $0x10,%esp
 1b5:	85 c0                	test   %eax,%eax
 1b7:	78 15                	js     1ce <testmem+0xae>
  info.memfree *= 1024;
 1b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1bc:	c1 e0 0a             	shl    $0xa,%eax
 1bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if (info.memfree != n) {
 1c2:	39 d8                	cmp    %ebx,%eax
 1c4:	75 33                	jne    1f9 <testmem+0xd9>
}
 1c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1c9:	5b                   	pop    %ebx
 1ca:	5e                   	pop    %esi
 1cb:	5f                   	pop    %edi
 1cc:	5d                   	pop    %ebp
 1cd:	c3                   	ret    
 1ce:	e8 7d fe ff ff       	call   50 <sinfo.part.0>
    printf(1,"sbrk failed");
 1d3:	50                   	push   %eax
 1d4:	50                   	push   %eax
 1d5:	68 dd 0a 00 00       	push   $0xadd
 1da:	6a 01                	push   $0x1
 1dc:	e8 7f 05 00 00       	call   760 <printf>
    exit();
 1e1:	e8 0d 04 00 00       	call   5f3 <exit>
    printf(1,"FAIL: free mem %d (bytes) instead of %d\n", info.memfree, n);
 1e6:	57                   	push   %edi
    printf(1,"FAIL: free mem %d (bytes) instead of %d\n", n, info.memfree);
 1e7:	53                   	push   %ebx
 1e8:	68 74 0b 00 00       	push   $0xb74
 1ed:	6a 01                	push   $0x1
 1ef:	e8 6c 05 00 00       	call   760 <printf>
    exit();
 1f4:	e8 fa 03 00 00       	call   5f3 <exit>
    printf(1,"FAIL: free mem %d (bytes) instead of %d\n", n, info.memfree);
 1f9:	50                   	push   %eax
 1fa:	eb eb                	jmp    1e7 <testmem+0xc7>
    printf(1,"FAIL: free mem %d (bytes) instead of %d\n", n-PGSIZE, info.memfree);
 1fc:	50                   	push   %eax
 1fd:	52                   	push   %edx
 1fe:	68 74 0b 00 00       	push   $0xb74
 203:	6a 01                	push   $0x1
 205:	e8 56 05 00 00       	call   760 <printf>
    exit();
 20a:	e8 e4 03 00 00       	call   5f3 <exit>
 20f:	90                   	nop

00000210 <testcall>:
testcall() {
 210:	f3 0f 1e fb          	endbr32 
 214:	55                   	push   %ebp
 215:	89 e5                	mov    %esp,%ebp
 217:	83 ec 24             	sub    $0x24,%esp
  if (sysinfo(&info) < 0) {
 21a:	8d 45 f0             	lea    -0x10(%ebp),%eax
 21d:	50                   	push   %eax
 21e:	e8 78 04 00 00       	call   69b <sysinfo>
 223:	83 c4 10             	add    $0x10,%esp
 226:	85 c0                	test   %eax,%eax
 228:	78 17                	js     241 <testcall+0x31>
  if (sysinfo((struct sysinfo *) 0xeaeb0b5b) !=  0xffffffff) {
 22a:	83 ec 0c             	sub    $0xc,%esp
 22d:	68 5b 0b eb ea       	push   $0xeaeb0b5b
 232:	e8 64 04 00 00       	call   69b <sysinfo>
 237:	83 c4 10             	add    $0x10,%esp
 23a:	83 f8 ff             	cmp    $0xffffffff,%eax
 23d:	75 15                	jne    254 <testcall+0x44>
}
 23f:	c9                   	leave  
 240:	c3                   	ret    
    printf(1,"FAIL: sysinfo failed\n");
 241:	52                   	push   %edx
 242:	52                   	push   %edx
 243:	68 e9 0a 00 00       	push   $0xae9
 248:	6a 01                	push   $0x1
 24a:	e8 11 05 00 00       	call   760 <printf>
    exit();
 24f:	e8 9f 03 00 00       	call   5f3 <exit>
    printf(1,"FAIL: sysinfo succeeded with bad argument\n");
 254:	50                   	push   %eax
 255:	50                   	push   %eax
 256:	68 a0 0b 00 00       	push   $0xba0
 25b:	6a 01                	push   $0x1
 25d:	e8 fe 04 00 00       	call   760 <printf>
    exit();
 262:	e8 8c 03 00 00       	call   5f3 <exit>
 267:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 26e:	66 90                	xchg   %ax,%ax

00000270 <testproc>:
void testproc() {
 270:	f3 0f 1e fb          	endbr32 
 274:	55                   	push   %ebp
 275:	89 e5                	mov    %esp,%ebp
 277:	56                   	push   %esi
 278:	53                   	push   %ebx
  if (sysinfo(info) < 0) {
 279:	8d 75 f0             	lea    -0x10(%ebp),%esi
void testproc() {
 27c:	83 ec 1c             	sub    $0x1c,%esp
  if (sysinfo(info) < 0) {
 27f:	56                   	push   %esi
 280:	e8 16 04 00 00       	call   69b <sysinfo>
 285:	83 c4 10             	add    $0x10,%esp
 288:	85 c0                	test   %eax,%eax
 28a:	78 71                	js     2fd <testproc+0x8d>
  numproc = info.numproc;
 28c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  pid = fork();
 28f:	e8 57 03 00 00       	call   5eb <fork>
  if(pid < 0){
 294:	85 c0                	test   %eax,%eax
 296:	78 6a                	js     302 <testproc+0x92>
  if(pid == 0){
 298:	74 2e                	je     2c8 <testproc+0x58>
  status = wait();
 29a:	e8 5c 03 00 00       	call   5fb <wait>
  if( status == -1 ) {
 29f:	83 f8 ff             	cmp    $0xffffffff,%eax
 2a2:	74 71                	je     315 <testproc+0xa5>
  if (sysinfo(info) < 0) {
 2a4:	83 ec 0c             	sub    $0xc,%esp
 2a7:	56                   	push   %esi
 2a8:	e8 ee 03 00 00       	call   69b <sysinfo>
 2ad:	83 c4 10             	add    $0x10,%esp
 2b0:	85 c0                	test   %eax,%eax
 2b2:	78 49                	js     2fd <testproc+0x8d>
  	if(info.numproc != numproc) {
 2b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2b7:	39 d8                	cmp    %ebx,%eax
 2b9:	75 27                	jne    2e2 <testproc+0x72>
}
 2bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2be:	5b                   	pop    %ebx
 2bf:	5e                   	pop    %esi
 2c0:	5d                   	pop    %ebp
 2c1:	c3                   	ret    
 2c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if (sysinfo(info) < 0) {
 2c8:	83 ec 0c             	sub    $0xc,%esp
 2cb:	56                   	push   %esi
 2cc:	e8 ca 03 00 00       	call   69b <sysinfo>
 2d1:	83 c4 10             	add    $0x10,%esp
 2d4:	85 c0                	test   %eax,%eax
 2d6:	78 25                	js     2fd <testproc+0x8d>
    if(info.numproc != numproc+1) {
 2d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 2db:	83 c3 01             	add    $0x1,%ebx
 2de:	39 d8                	cmp    %ebx,%eax
 2e0:	74 16                	je     2f8 <testproc+0x88>
      	printf(1,"sysinfotest: FAIL numproc is %d instead of %d\n", info.numproc, numproc);
 2e2:	53                   	push   %ebx
 2e3:	50                   	push   %eax
 2e4:	68 cc 0b 00 00       	push   $0xbcc
 2e9:	6a 01                	push   $0x1
 2eb:	e8 70 04 00 00       	call   760 <printf>
      	exit();
 2f0:	e8 fe 02 00 00       	call   5f3 <exit>
 2f5:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
 2f8:	e8 f6 02 00 00       	call   5f3 <exit>
 2fd:	e8 4e fd ff ff       	call   50 <sinfo.part.0>
    printf(1,"sysinfotest: fork failed\n");
 302:	52                   	push   %edx
 303:	52                   	push   %edx
 304:	68 ff 0a 00 00       	push   $0xaff
 309:	6a 01                	push   $0x1
 30b:	e8 50 04 00 00       	call   760 <printf>
    exit();
 310:	e8 de 02 00 00       	call   5f3 <exit>
	  printf(1,"sysinfotest: testproc failed: no child\n" );
 315:	50                   	push   %eax
 316:	50                   	push   %eax
 317:	68 fc 0b 00 00       	push   $0xbfc
 31c:	6a 01                	push   $0x1
 31e:	e8 3d 04 00 00       	call   760 <printf>
	  exit();
 323:	e8 cb 02 00 00       	call   5f3 <exit>
 328:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 32f:	90                   	nop

00000330 <testbad>:
void testbad() {
 330:	f3 0f 1e fb          	endbr32 
 334:	55                   	push   %ebp
 335:	89 e5                	mov    %esp,%ebp
 337:	83 ec 08             	sub    $0x8,%esp
  int pid = fork();
 33a:	e8 ac 02 00 00       	call   5eb <fork>
  if(pid < 0){
 33f:	85 c0                	test   %eax,%eax
 341:	78 35                	js     378 <testbad+0x48>
  if(pid == 0){
 343:	75 16                	jne    35b <testbad+0x2b>
  if (sysinfo(info) < 0) {
 345:	83 ec 0c             	sub    $0xc,%esp
 348:	6a 00                	push   $0x0
 34a:	e8 4c 03 00 00       	call   69b <sysinfo>
 34f:	83 c4 10             	add    $0x10,%esp
 352:	85 c0                	test   %eax,%eax
 354:	78 35                	js     38b <testbad+0x5b>
      exit();
 356:	e8 98 02 00 00       	call   5f3 <exit>
  xstatus = wait();
 35b:	e8 9b 02 00 00       	call   5fb <wait>
  if(xstatus == -1)  // kernel killed child?
 360:	83 f8 ff             	cmp    $0xffffffff,%eax
 363:	74 f1                	je     356 <testbad+0x26>
    printf(1,"sysinfotest: testbad succeeded %d\n", xstatus);
 365:	52                   	push   %edx
 366:	50                   	push   %eax
 367:	68 24 0c 00 00       	push   $0xc24
 36c:	6a 01                	push   $0x1
 36e:	e8 ed 03 00 00       	call   760 <printf>
    exit();
 373:	e8 7b 02 00 00       	call   5f3 <exit>
    printf(1,"sysinfotest: fork failed\n");
 378:	51                   	push   %ecx
 379:	51                   	push   %ecx
 37a:	68 ff 0a 00 00       	push   $0xaff
 37f:	6a 01                	push   $0x1
 381:	e8 da 03 00 00       	call   760 <printf>
    exit();
 386:	e8 68 02 00 00       	call   5f3 <exit>
 38b:	e8 c0 fc ff ff       	call   50 <sinfo.part.0>

00000390 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 390:	f3 0f 1e fb          	endbr32 
 394:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 395:	31 c0                	xor    %eax,%eax
{
 397:	89 e5                	mov    %esp,%ebp
 399:	53                   	push   %ebx
 39a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 39d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while((*s++ = *t++) != 0)
 3a0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 3a4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 3a7:	83 c0 01             	add    $0x1,%eax
 3aa:	84 d2                	test   %dl,%dl
 3ac:	75 f2                	jne    3a0 <strcpy+0x10>
    ;
  return os;
}
 3ae:	89 c8                	mov    %ecx,%eax
 3b0:	5b                   	pop    %ebx
 3b1:	5d                   	pop    %ebp
 3b2:	c3                   	ret    
 3b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 3ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3c0:	f3 0f 1e fb          	endbr32 
 3c4:	55                   	push   %ebp
 3c5:	89 e5                	mov    %esp,%ebp
 3c7:	53                   	push   %ebx
 3c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
 3cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 3ce:	0f b6 01             	movzbl (%ecx),%eax
 3d1:	0f b6 1a             	movzbl (%edx),%ebx
 3d4:	84 c0                	test   %al,%al
 3d6:	75 19                	jne    3f1 <strcmp+0x31>
 3d8:	eb 26                	jmp    400 <strcmp+0x40>
 3da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3e0:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    p++, q++;
 3e4:	83 c1 01             	add    $0x1,%ecx
 3e7:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 3ea:	0f b6 1a             	movzbl (%edx),%ebx
 3ed:	84 c0                	test   %al,%al
 3ef:	74 0f                	je     400 <strcmp+0x40>
 3f1:	38 d8                	cmp    %bl,%al
 3f3:	74 eb                	je     3e0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 3f5:	29 d8                	sub    %ebx,%eax
}
 3f7:	5b                   	pop    %ebx
 3f8:	5d                   	pop    %ebp
 3f9:	c3                   	ret    
 3fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 400:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 402:	29 d8                	sub    %ebx,%eax
}
 404:	5b                   	pop    %ebx
 405:	5d                   	pop    %ebp
 406:	c3                   	ret    
 407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 40e:	66 90                	xchg   %ax,%ax

00000410 <strlen>:

uint
strlen(const char *s)
{
 410:	f3 0f 1e fb          	endbr32 
 414:	55                   	push   %ebp
 415:	89 e5                	mov    %esp,%ebp
 417:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 41a:	80 3a 00             	cmpb   $0x0,(%edx)
 41d:	74 21                	je     440 <strlen+0x30>
 41f:	31 c0                	xor    %eax,%eax
 421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 428:	83 c0 01             	add    $0x1,%eax
 42b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 42f:	89 c1                	mov    %eax,%ecx
 431:	75 f5                	jne    428 <strlen+0x18>
    ;
  return n;
}
 433:	89 c8                	mov    %ecx,%eax
 435:	5d                   	pop    %ebp
 436:	c3                   	ret    
 437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 43e:	66 90                	xchg   %ax,%ax
  for(n = 0; s[n]; n++)
 440:	31 c9                	xor    %ecx,%ecx
}
 442:	5d                   	pop    %ebp
 443:	89 c8                	mov    %ecx,%eax
 445:	c3                   	ret    
 446:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 44d:	8d 76 00             	lea    0x0(%esi),%esi

00000450 <memset>:

void*
memset(void *dst, int c, uint n)
{
 450:	f3 0f 1e fb          	endbr32 
 454:	55                   	push   %ebp
 455:	89 e5                	mov    %esp,%ebp
 457:	57                   	push   %edi
 458:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 45b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 45e:	8b 45 0c             	mov    0xc(%ebp),%eax
 461:	89 d7                	mov    %edx,%edi
 463:	fc                   	cld    
 464:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 466:	89 d0                	mov    %edx,%eax
 468:	5f                   	pop    %edi
 469:	5d                   	pop    %ebp
 46a:	c3                   	ret    
 46b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 46f:	90                   	nop

00000470 <strchr>:

char*
strchr(const char *s, char c)
{
 470:	f3 0f 1e fb          	endbr32 
 474:	55                   	push   %ebp
 475:	89 e5                	mov    %esp,%ebp
 477:	8b 45 08             	mov    0x8(%ebp),%eax
 47a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 47e:	0f b6 10             	movzbl (%eax),%edx
 481:	84 d2                	test   %dl,%dl
 483:	75 16                	jne    49b <strchr+0x2b>
 485:	eb 21                	jmp    4a8 <strchr+0x38>
 487:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 48e:	66 90                	xchg   %ax,%ax
 490:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 494:	83 c0 01             	add    $0x1,%eax
 497:	84 d2                	test   %dl,%dl
 499:	74 0d                	je     4a8 <strchr+0x38>
    if(*s == c)
 49b:	38 d1                	cmp    %dl,%cl
 49d:	75 f1                	jne    490 <strchr+0x20>
      return (char*)s;
  return 0;
}
 49f:	5d                   	pop    %ebp
 4a0:	c3                   	ret    
 4a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 4a8:	31 c0                	xor    %eax,%eax
}
 4aa:	5d                   	pop    %ebp
 4ab:	c3                   	ret    
 4ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004b0 <gets>:

char*
gets(char *buf, int max)
{
 4b0:	f3 0f 1e fb          	endbr32 
 4b4:	55                   	push   %ebp
 4b5:	89 e5                	mov    %esp,%ebp
 4b7:	57                   	push   %edi
 4b8:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4b9:	31 f6                	xor    %esi,%esi
{
 4bb:	53                   	push   %ebx
 4bc:	89 f3                	mov    %esi,%ebx
 4be:	83 ec 1c             	sub    $0x1c,%esp
 4c1:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 4c4:	eb 33                	jmp    4f9 <gets+0x49>
 4c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4cd:	8d 76 00             	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 4d0:	83 ec 04             	sub    $0x4,%esp
 4d3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4d6:	6a 01                	push   $0x1
 4d8:	50                   	push   %eax
 4d9:	6a 00                	push   $0x0
 4db:	e8 2b 01 00 00       	call   60b <read>
    if(cc < 1)
 4e0:	83 c4 10             	add    $0x10,%esp
 4e3:	85 c0                	test   %eax,%eax
 4e5:	7e 1c                	jle    503 <gets+0x53>
      break;
    buf[i++] = c;
 4e7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4eb:	83 c7 01             	add    $0x1,%edi
 4ee:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 4f1:	3c 0a                	cmp    $0xa,%al
 4f3:	74 23                	je     518 <gets+0x68>
 4f5:	3c 0d                	cmp    $0xd,%al
 4f7:	74 1f                	je     518 <gets+0x68>
  for(i=0; i+1 < max; ){
 4f9:	83 c3 01             	add    $0x1,%ebx
 4fc:	89 fe                	mov    %edi,%esi
 4fe:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 501:	7c cd                	jl     4d0 <gets+0x20>
 503:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 505:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 508:	c6 03 00             	movb   $0x0,(%ebx)
}
 50b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 50e:	5b                   	pop    %ebx
 50f:	5e                   	pop    %esi
 510:	5f                   	pop    %edi
 511:	5d                   	pop    %ebp
 512:	c3                   	ret    
 513:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 517:	90                   	nop
 518:	8b 75 08             	mov    0x8(%ebp),%esi
 51b:	8b 45 08             	mov    0x8(%ebp),%eax
 51e:	01 de                	add    %ebx,%esi
 520:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 522:	c6 03 00             	movb   $0x0,(%ebx)
}
 525:	8d 65 f4             	lea    -0xc(%ebp),%esp
 528:	5b                   	pop    %ebx
 529:	5e                   	pop    %esi
 52a:	5f                   	pop    %edi
 52b:	5d                   	pop    %ebp
 52c:	c3                   	ret    
 52d:	8d 76 00             	lea    0x0(%esi),%esi

00000530 <stat>:

int
stat(const char *n, struct stat *st)
{
 530:	f3 0f 1e fb          	endbr32 
 534:	55                   	push   %ebp
 535:	89 e5                	mov    %esp,%ebp
 537:	56                   	push   %esi
 538:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 539:	83 ec 08             	sub    $0x8,%esp
 53c:	6a 00                	push   $0x0
 53e:	ff 75 08             	pushl  0x8(%ebp)
 541:	e8 ed 00 00 00       	call   633 <open>
  if(fd < 0)
 546:	83 c4 10             	add    $0x10,%esp
 549:	85 c0                	test   %eax,%eax
 54b:	78 2b                	js     578 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 54d:	83 ec 08             	sub    $0x8,%esp
 550:	ff 75 0c             	pushl  0xc(%ebp)
 553:	89 c3                	mov    %eax,%ebx
 555:	50                   	push   %eax
 556:	e8 f0 00 00 00       	call   64b <fstat>
  close(fd);
 55b:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 55e:	89 c6                	mov    %eax,%esi
  close(fd);
 560:	e8 b6 00 00 00       	call   61b <close>
  return r;
 565:	83 c4 10             	add    $0x10,%esp
}
 568:	8d 65 f8             	lea    -0x8(%ebp),%esp
 56b:	89 f0                	mov    %esi,%eax
 56d:	5b                   	pop    %ebx
 56e:	5e                   	pop    %esi
 56f:	5d                   	pop    %ebp
 570:	c3                   	ret    
 571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 578:	be ff ff ff ff       	mov    $0xffffffff,%esi
 57d:	eb e9                	jmp    568 <stat+0x38>
 57f:	90                   	nop

00000580 <atoi>:

int
atoi(const char *s)
{
 580:	f3 0f 1e fb          	endbr32 
 584:	55                   	push   %ebp
 585:	89 e5                	mov    %esp,%ebp
 587:	53                   	push   %ebx
 588:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 58b:	0f be 02             	movsbl (%edx),%eax
 58e:	8d 48 d0             	lea    -0x30(%eax),%ecx
 591:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 594:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 599:	77 1a                	ja     5b5 <atoi+0x35>
 59b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 59f:	90                   	nop
    n = n*10 + *s++ - '0';
 5a0:	83 c2 01             	add    $0x1,%edx
 5a3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 5a6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 5aa:	0f be 02             	movsbl (%edx),%eax
 5ad:	8d 58 d0             	lea    -0x30(%eax),%ebx
 5b0:	80 fb 09             	cmp    $0x9,%bl
 5b3:	76 eb                	jbe    5a0 <atoi+0x20>
  return n;
}
 5b5:	89 c8                	mov    %ecx,%eax
 5b7:	5b                   	pop    %ebx
 5b8:	5d                   	pop    %ebp
 5b9:	c3                   	ret    
 5ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000005c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5c0:	f3 0f 1e fb          	endbr32 
 5c4:	55                   	push   %ebp
 5c5:	89 e5                	mov    %esp,%ebp
 5c7:	57                   	push   %edi
 5c8:	8b 45 10             	mov    0x10(%ebp),%eax
 5cb:	8b 55 08             	mov    0x8(%ebp),%edx
 5ce:	56                   	push   %esi
 5cf:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5d2:	85 c0                	test   %eax,%eax
 5d4:	7e 0f                	jle    5e5 <memmove+0x25>
 5d6:	01 d0                	add    %edx,%eax
  dst = vdst;
 5d8:	89 d7                	mov    %edx,%edi
 5da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    *dst++ = *src++;
 5e0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 5e1:	39 f8                	cmp    %edi,%eax
 5e3:	75 fb                	jne    5e0 <memmove+0x20>
  return vdst;
}
 5e5:	5e                   	pop    %esi
 5e6:	89 d0                	mov    %edx,%eax
 5e8:	5f                   	pop    %edi
 5e9:	5d                   	pop    %ebp
 5ea:	c3                   	ret    

000005eb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 5eb:	b8 01 00 00 00       	mov    $0x1,%eax
 5f0:	cd 40                	int    $0x40
 5f2:	c3                   	ret    

000005f3 <exit>:
SYSCALL(exit)
 5f3:	b8 02 00 00 00       	mov    $0x2,%eax
 5f8:	cd 40                	int    $0x40
 5fa:	c3                   	ret    

000005fb <wait>:
SYSCALL(wait)
 5fb:	b8 03 00 00 00       	mov    $0x3,%eax
 600:	cd 40                	int    $0x40
 602:	c3                   	ret    

00000603 <pipe>:
SYSCALL(pipe)
 603:	b8 04 00 00 00       	mov    $0x4,%eax
 608:	cd 40                	int    $0x40
 60a:	c3                   	ret    

0000060b <read>:
SYSCALL(read)
 60b:	b8 05 00 00 00       	mov    $0x5,%eax
 610:	cd 40                	int    $0x40
 612:	c3                   	ret    

00000613 <write>:
SYSCALL(write)
 613:	b8 10 00 00 00       	mov    $0x10,%eax
 618:	cd 40                	int    $0x40
 61a:	c3                   	ret    

0000061b <close>:
SYSCALL(close)
 61b:	b8 15 00 00 00       	mov    $0x15,%eax
 620:	cd 40                	int    $0x40
 622:	c3                   	ret    

00000623 <kill>:
SYSCALL(kill)
 623:	b8 06 00 00 00       	mov    $0x6,%eax
 628:	cd 40                	int    $0x40
 62a:	c3                   	ret    

0000062b <exec>:
SYSCALL(exec)
 62b:	b8 07 00 00 00       	mov    $0x7,%eax
 630:	cd 40                	int    $0x40
 632:	c3                   	ret    

00000633 <open>:
SYSCALL(open)
 633:	b8 0f 00 00 00       	mov    $0xf,%eax
 638:	cd 40                	int    $0x40
 63a:	c3                   	ret    

0000063b <mknod>:
SYSCALL(mknod)
 63b:	b8 11 00 00 00       	mov    $0x11,%eax
 640:	cd 40                	int    $0x40
 642:	c3                   	ret    

00000643 <unlink>:
SYSCALL(unlink)
 643:	b8 12 00 00 00       	mov    $0x12,%eax
 648:	cd 40                	int    $0x40
 64a:	c3                   	ret    

0000064b <fstat>:
SYSCALL(fstat)
 64b:	b8 08 00 00 00       	mov    $0x8,%eax
 650:	cd 40                	int    $0x40
 652:	c3                   	ret    

00000653 <link>:
SYSCALL(link)
 653:	b8 13 00 00 00       	mov    $0x13,%eax
 658:	cd 40                	int    $0x40
 65a:	c3                   	ret    

0000065b <mkdir>:
SYSCALL(mkdir)
 65b:	b8 14 00 00 00       	mov    $0x14,%eax
 660:	cd 40                	int    $0x40
 662:	c3                   	ret    

00000663 <chdir>:
SYSCALL(chdir)
 663:	b8 09 00 00 00       	mov    $0x9,%eax
 668:	cd 40                	int    $0x40
 66a:	c3                   	ret    

0000066b <dup>:
SYSCALL(dup)
 66b:	b8 0a 00 00 00       	mov    $0xa,%eax
 670:	cd 40                	int    $0x40
 672:	c3                   	ret    

00000673 <getpid>:
SYSCALL(getpid)
 673:	b8 0b 00 00 00       	mov    $0xb,%eax
 678:	cd 40                	int    $0x40
 67a:	c3                   	ret    

0000067b <sbrk>:
SYSCALL(sbrk)
 67b:	b8 0c 00 00 00       	mov    $0xc,%eax
 680:	cd 40                	int    $0x40
 682:	c3                   	ret    

00000683 <sleep>:
SYSCALL(sleep)
 683:	b8 0d 00 00 00       	mov    $0xd,%eax
 688:	cd 40                	int    $0x40
 68a:	c3                   	ret    

0000068b <uptime>:
SYSCALL(uptime)
 68b:	b8 0e 00 00 00       	mov    $0xe,%eax
 690:	cd 40                	int    $0x40
 692:	c3                   	ret    

00000693 <trace>:
SYSCALL(trace)
 693:	b8 16 00 00 00       	mov    $0x16,%eax
 698:	cd 40                	int    $0x40
 69a:	c3                   	ret    

0000069b <sysinfo>:
SYSCALL(sysinfo)
 69b:	b8 17 00 00 00       	mov    $0x17,%eax
 6a0:	cd 40                	int    $0x40
 6a2:	c3                   	ret    

000006a3 <halt>:
SYSCALL(halt)
 6a3:	b8 18 00 00 00       	mov    $0x18,%eax
 6a8:	cd 40                	int    $0x40
 6aa:	c3                   	ret    
 6ab:	66 90                	xchg   %ax,%ax
 6ad:	66 90                	xchg   %ax,%ax
 6af:	90                   	nop

000006b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6b0:	55                   	push   %ebp
 6b1:	89 e5                	mov    %esp,%ebp
 6b3:	57                   	push   %edi
 6b4:	56                   	push   %esi
 6b5:	53                   	push   %ebx
 6b6:	83 ec 3c             	sub    $0x3c,%esp
 6b9:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 6bc:	89 d1                	mov    %edx,%ecx
{
 6be:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
 6c1:	85 d2                	test   %edx,%edx
 6c3:	0f 89 7f 00 00 00    	jns    748 <printint+0x98>
 6c9:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 6cd:	74 79                	je     748 <printint+0x98>
    neg = 1;
 6cf:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
 6d6:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
 6d8:	31 db                	xor    %ebx,%ebx
 6da:	8d 75 d7             	lea    -0x29(%ebp),%esi
 6dd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 6e0:	89 c8                	mov    %ecx,%eax
 6e2:	31 d2                	xor    %edx,%edx
 6e4:	89 cf                	mov    %ecx,%edi
 6e6:	f7 75 c4             	divl   -0x3c(%ebp)
 6e9:	0f b6 92 50 0c 00 00 	movzbl 0xc50(%edx),%edx
 6f0:	89 45 c0             	mov    %eax,-0x40(%ebp)
 6f3:	89 d8                	mov    %ebx,%eax
 6f5:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
 6f8:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
 6fb:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
 6fe:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
 701:	76 dd                	jbe    6e0 <printint+0x30>
  if(neg)
 703:	8b 4d bc             	mov    -0x44(%ebp),%ecx
 706:	85 c9                	test   %ecx,%ecx
 708:	74 0c                	je     716 <printint+0x66>
    buf[i++] = '-';
 70a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
 70f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
 711:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
 716:	8b 7d b8             	mov    -0x48(%ebp),%edi
 719:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
 71d:	eb 07                	jmp    726 <printint+0x76>
 71f:	90                   	nop
 720:	0f b6 13             	movzbl (%ebx),%edx
 723:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
 726:	83 ec 04             	sub    $0x4,%esp
 729:	88 55 d7             	mov    %dl,-0x29(%ebp)
 72c:	6a 01                	push   $0x1
 72e:	56                   	push   %esi
 72f:	57                   	push   %edi
 730:	e8 de fe ff ff       	call   613 <write>
  while(--i >= 0)
 735:	83 c4 10             	add    $0x10,%esp
 738:	39 de                	cmp    %ebx,%esi
 73a:	75 e4                	jne    720 <printint+0x70>
    putc(fd, buf[i]);
}
 73c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 73f:	5b                   	pop    %ebx
 740:	5e                   	pop    %esi
 741:	5f                   	pop    %edi
 742:	5d                   	pop    %ebp
 743:	c3                   	ret    
 744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 748:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
 74f:	eb 87                	jmp    6d8 <printint+0x28>
 751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 758:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 75f:	90                   	nop

00000760 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 760:	f3 0f 1e fb          	endbr32 
 764:	55                   	push   %ebp
 765:	89 e5                	mov    %esp,%ebp
 767:	57                   	push   %edi
 768:	56                   	push   %esi
 769:	53                   	push   %ebx
 76a:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 76d:	8b 75 0c             	mov    0xc(%ebp),%esi
 770:	0f b6 1e             	movzbl (%esi),%ebx
 773:	84 db                	test   %bl,%bl
 775:	0f 84 b4 00 00 00    	je     82f <printf+0xcf>
  ap = (uint*)(void*)&fmt + 1;
 77b:	8d 45 10             	lea    0x10(%ebp),%eax
 77e:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 781:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
 784:	31 d2                	xor    %edx,%edx
  ap = (uint*)(void*)&fmt + 1;
 786:	89 45 d0             	mov    %eax,-0x30(%ebp)
 789:	eb 33                	jmp    7be <printf+0x5e>
 78b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 78f:	90                   	nop
 790:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 793:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 798:	83 f8 25             	cmp    $0x25,%eax
 79b:	74 17                	je     7b4 <printf+0x54>
  write(fd, &c, 1);
 79d:	83 ec 04             	sub    $0x4,%esp
 7a0:	88 5d e7             	mov    %bl,-0x19(%ebp)
 7a3:	6a 01                	push   $0x1
 7a5:	57                   	push   %edi
 7a6:	ff 75 08             	pushl  0x8(%ebp)
 7a9:	e8 65 fe ff ff       	call   613 <write>
 7ae:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 7b1:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 7b4:	0f b6 1e             	movzbl (%esi),%ebx
 7b7:	83 c6 01             	add    $0x1,%esi
 7ba:	84 db                	test   %bl,%bl
 7bc:	74 71                	je     82f <printf+0xcf>
    c = fmt[i] & 0xff;
 7be:	0f be cb             	movsbl %bl,%ecx
 7c1:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 7c4:	85 d2                	test   %edx,%edx
 7c6:	74 c8                	je     790 <printf+0x30>
      }
    } else if(state == '%'){
 7c8:	83 fa 25             	cmp    $0x25,%edx
 7cb:	75 e7                	jne    7b4 <printf+0x54>
      if(c == 'd'){
 7cd:	83 f8 64             	cmp    $0x64,%eax
 7d0:	0f 84 9a 00 00 00    	je     870 <printf+0x110>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 7d6:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 7dc:	83 f9 70             	cmp    $0x70,%ecx
 7df:	74 5f                	je     840 <printf+0xe0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 7e1:	83 f8 73             	cmp    $0x73,%eax
 7e4:	0f 84 d6 00 00 00    	je     8c0 <printf+0x160>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7ea:	83 f8 63             	cmp    $0x63,%eax
 7ed:	0f 84 8d 00 00 00    	je     880 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 7f3:	83 f8 25             	cmp    $0x25,%eax
 7f6:	0f 84 b4 00 00 00    	je     8b0 <printf+0x150>
  write(fd, &c, 1);
 7fc:	83 ec 04             	sub    $0x4,%esp
 7ff:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 803:	6a 01                	push   $0x1
 805:	57                   	push   %edi
 806:	ff 75 08             	pushl  0x8(%ebp)
 809:	e8 05 fe ff ff       	call   613 <write>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 80e:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 811:	83 c4 0c             	add    $0xc,%esp
 814:	6a 01                	push   $0x1
 816:	83 c6 01             	add    $0x1,%esi
 819:	57                   	push   %edi
 81a:	ff 75 08             	pushl  0x8(%ebp)
 81d:	e8 f1 fd ff ff       	call   613 <write>
  for(i = 0; fmt[i]; i++){
 822:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
        putc(fd, c);
 826:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 829:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 82b:	84 db                	test   %bl,%bl
 82d:	75 8f                	jne    7be <printf+0x5e>
    }
  }
}
 82f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 832:	5b                   	pop    %ebx
 833:	5e                   	pop    %esi
 834:	5f                   	pop    %edi
 835:	5d                   	pop    %ebp
 836:	c3                   	ret    
 837:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 83e:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 16, 0);
 840:	83 ec 0c             	sub    $0xc,%esp
 843:	b9 10 00 00 00       	mov    $0x10,%ecx
 848:	6a 00                	push   $0x0
 84a:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 84d:	8b 45 08             	mov    0x8(%ebp),%eax
 850:	8b 13                	mov    (%ebx),%edx
 852:	e8 59 fe ff ff       	call   6b0 <printint>
        ap++;
 857:	89 d8                	mov    %ebx,%eax
 859:	83 c4 10             	add    $0x10,%esp
      state = 0;
 85c:	31 d2                	xor    %edx,%edx
        ap++;
 85e:	83 c0 04             	add    $0x4,%eax
 861:	89 45 d0             	mov    %eax,-0x30(%ebp)
 864:	e9 4b ff ff ff       	jmp    7b4 <printf+0x54>
 869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printint(fd, *ap, 10, 1);
 870:	83 ec 0c             	sub    $0xc,%esp
 873:	b9 0a 00 00 00       	mov    $0xa,%ecx
 878:	6a 01                	push   $0x1
 87a:	eb ce                	jmp    84a <printf+0xea>
 87c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 880:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 883:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 886:	8b 03                	mov    (%ebx),%eax
  write(fd, &c, 1);
 888:	6a 01                	push   $0x1
        ap++;
 88a:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 88d:	57                   	push   %edi
 88e:	ff 75 08             	pushl  0x8(%ebp)
        putc(fd, *ap);
 891:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 894:	e8 7a fd ff ff       	call   613 <write>
        ap++;
 899:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 89c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 89f:	31 d2                	xor    %edx,%edx
 8a1:	e9 0e ff ff ff       	jmp    7b4 <printf+0x54>
 8a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ad:	8d 76 00             	lea    0x0(%esi),%esi
        putc(fd, c);
 8b0:	88 5d e7             	mov    %bl,-0x19(%ebp)
  write(fd, &c, 1);
 8b3:	83 ec 04             	sub    $0x4,%esp
 8b6:	e9 59 ff ff ff       	jmp    814 <printf+0xb4>
 8bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8bf:	90                   	nop
        s = (char*)*ap;
 8c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 8c3:	8b 18                	mov    (%eax),%ebx
        ap++;
 8c5:	83 c0 04             	add    $0x4,%eax
 8c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 8cb:	85 db                	test   %ebx,%ebx
 8cd:	74 17                	je     8e6 <printf+0x186>
        while(*s != 0){
 8cf:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 8d2:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 8d4:	84 c0                	test   %al,%al
 8d6:	0f 84 d8 fe ff ff    	je     7b4 <printf+0x54>
 8dc:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 8df:	89 de                	mov    %ebx,%esi
 8e1:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8e4:	eb 1a                	jmp    900 <printf+0x1a0>
          s = "(null)";
 8e6:	bb 47 0c 00 00       	mov    $0xc47,%ebx
        while(*s != 0){
 8eb:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 8ee:	b8 28 00 00 00       	mov    $0x28,%eax
 8f3:	89 de                	mov    %ebx,%esi
 8f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8ff:	90                   	nop
  write(fd, &c, 1);
 900:	83 ec 04             	sub    $0x4,%esp
          s++;
 903:	83 c6 01             	add    $0x1,%esi
 906:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 909:	6a 01                	push   $0x1
 90b:	57                   	push   %edi
 90c:	53                   	push   %ebx
 90d:	e8 01 fd ff ff       	call   613 <write>
        while(*s != 0){
 912:	0f b6 06             	movzbl (%esi),%eax
 915:	83 c4 10             	add    $0x10,%esp
 918:	84 c0                	test   %al,%al
 91a:	75 e4                	jne    900 <printf+0x1a0>
 91c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
      state = 0;
 91f:	31 d2                	xor    %edx,%edx
 921:	e9 8e fe ff ff       	jmp    7b4 <printf+0x54>
 926:	66 90                	xchg   %ax,%ax
 928:	66 90                	xchg   %ax,%ax
 92a:	66 90                	xchg   %ax,%ax
 92c:	66 90                	xchg   %ax,%ax
 92e:	66 90                	xchg   %ax,%ax

00000930 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 930:	f3 0f 1e fb          	endbr32 
 934:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 935:	a1 00 10 00 00       	mov    0x1000,%eax
{
 93a:	89 e5                	mov    %esp,%ebp
 93c:	57                   	push   %edi
 93d:	56                   	push   %esi
 93e:	53                   	push   %ebx
 93f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 942:	8b 10                	mov    (%eax),%edx
  bp = (Header*)ap - 1;
 944:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 947:	39 c8                	cmp    %ecx,%eax
 949:	73 15                	jae    960 <free+0x30>
 94b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 94f:	90                   	nop
 950:	39 d1                	cmp    %edx,%ecx
 952:	72 14                	jb     968 <free+0x38>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 954:	39 d0                	cmp    %edx,%eax
 956:	73 10                	jae    968 <free+0x38>
{
 958:	89 d0                	mov    %edx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 95a:	8b 10                	mov    (%eax),%edx
 95c:	39 c8                	cmp    %ecx,%eax
 95e:	72 f0                	jb     950 <free+0x20>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 960:	39 d0                	cmp    %edx,%eax
 962:	72 f4                	jb     958 <free+0x28>
 964:	39 d1                	cmp    %edx,%ecx
 966:	73 f0                	jae    958 <free+0x28>
      break;
  if(bp + bp->s.size == p->s.ptr){
 968:	8b 73 fc             	mov    -0x4(%ebx),%esi
 96b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 96e:	39 fa                	cmp    %edi,%edx
 970:	74 1e                	je     990 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 972:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 975:	8b 50 04             	mov    0x4(%eax),%edx
 978:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 97b:	39 f1                	cmp    %esi,%ecx
 97d:	74 28                	je     9a7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 97f:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 981:	5b                   	pop    %ebx
  freep = p;
 982:	a3 00 10 00 00       	mov    %eax,0x1000
}
 987:	5e                   	pop    %esi
 988:	5f                   	pop    %edi
 989:	5d                   	pop    %ebp
 98a:	c3                   	ret    
 98b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 98f:	90                   	nop
    bp->s.size += p->s.ptr->s.size;
 990:	03 72 04             	add    0x4(%edx),%esi
 993:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 996:	8b 10                	mov    (%eax),%edx
 998:	8b 12                	mov    (%edx),%edx
 99a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 99d:	8b 50 04             	mov    0x4(%eax),%edx
 9a0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 9a3:	39 f1                	cmp    %esi,%ecx
 9a5:	75 d8                	jne    97f <free+0x4f>
    p->s.size += bp->s.size;
 9a7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 9aa:	a3 00 10 00 00       	mov    %eax,0x1000
    p->s.size += bp->s.size;
 9af:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9b2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 9b5:	89 10                	mov    %edx,(%eax)
}
 9b7:	5b                   	pop    %ebx
 9b8:	5e                   	pop    %esi
 9b9:	5f                   	pop    %edi
 9ba:	5d                   	pop    %ebp
 9bb:	c3                   	ret    
 9bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000009c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9c0:	f3 0f 1e fb          	endbr32 
 9c4:	55                   	push   %ebp
 9c5:	89 e5                	mov    %esp,%ebp
 9c7:	57                   	push   %edi
 9c8:	56                   	push   %esi
 9c9:	53                   	push   %ebx
 9ca:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9cd:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 9d0:	8b 3d 00 10 00 00    	mov    0x1000,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d6:	8d 70 07             	lea    0x7(%eax),%esi
 9d9:	c1 ee 03             	shr    $0x3,%esi
 9dc:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
 9df:	85 ff                	test   %edi,%edi
 9e1:	0f 84 a9 00 00 00    	je     a90 <malloc+0xd0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e7:	8b 07                	mov    (%edi),%eax
    if(p->s.size >= nunits){
 9e9:	8b 48 04             	mov    0x4(%eax),%ecx
 9ec:	39 f1                	cmp    %esi,%ecx
 9ee:	73 6d                	jae    a5d <malloc+0x9d>
 9f0:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 9f6:	bb 00 10 00 00       	mov    $0x1000,%ebx
 9fb:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
 9fe:	8d 0c dd 00 00 00 00 	lea    0x0(,%ebx,8),%ecx
 a05:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
 a08:	eb 17                	jmp    a21 <malloc+0x61>
 a0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a10:	8b 10                	mov    (%eax),%edx
    if(p->s.size >= nunits){
 a12:	8b 4a 04             	mov    0x4(%edx),%ecx
 a15:	39 f1                	cmp    %esi,%ecx
 a17:	73 4f                	jae    a68 <malloc+0xa8>
 a19:	8b 3d 00 10 00 00    	mov    0x1000,%edi
 a1f:	89 d0                	mov    %edx,%eax
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a21:	39 c7                	cmp    %eax,%edi
 a23:	75 eb                	jne    a10 <malloc+0x50>
  p = sbrk(nu * sizeof(Header));
 a25:	83 ec 0c             	sub    $0xc,%esp
 a28:	ff 75 e4             	pushl  -0x1c(%ebp)
 a2b:	e8 4b fc ff ff       	call   67b <sbrk>
  if(p == (char*)-1)
 a30:	83 c4 10             	add    $0x10,%esp
 a33:	83 f8 ff             	cmp    $0xffffffff,%eax
 a36:	74 1b                	je     a53 <malloc+0x93>
  hp->s.size = nu;
 a38:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a3b:	83 ec 0c             	sub    $0xc,%esp
 a3e:	83 c0 08             	add    $0x8,%eax
 a41:	50                   	push   %eax
 a42:	e8 e9 fe ff ff       	call   930 <free>
  return freep;
 a47:	a1 00 10 00 00       	mov    0x1000,%eax
      if((p = morecore(nunits)) == 0)
 a4c:	83 c4 10             	add    $0x10,%esp
 a4f:	85 c0                	test   %eax,%eax
 a51:	75 bd                	jne    a10 <malloc+0x50>
        return 0;
  }
}
 a53:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a56:	31 c0                	xor    %eax,%eax
}
 a58:	5b                   	pop    %ebx
 a59:	5e                   	pop    %esi
 a5a:	5f                   	pop    %edi
 a5b:	5d                   	pop    %ebp
 a5c:	c3                   	ret    
    if(p->s.size >= nunits){
 a5d:	89 c2                	mov    %eax,%edx
 a5f:	89 f8                	mov    %edi,%eax
 a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 a68:	39 ce                	cmp    %ecx,%esi
 a6a:	74 54                	je     ac0 <malloc+0x100>
        p->s.size -= nunits;
 a6c:	29 f1                	sub    %esi,%ecx
 a6e:	89 4a 04             	mov    %ecx,0x4(%edx)
        p += p->s.size;
 a71:	8d 14 ca             	lea    (%edx,%ecx,8),%edx
        p->s.size = nunits;
 a74:	89 72 04             	mov    %esi,0x4(%edx)
      freep = prevp;
 a77:	a3 00 10 00 00       	mov    %eax,0x1000
}
 a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a7f:	8d 42 08             	lea    0x8(%edx),%eax
}
 a82:	5b                   	pop    %ebx
 a83:	5e                   	pop    %esi
 a84:	5f                   	pop    %edi
 a85:	5d                   	pop    %ebp
 a86:	c3                   	ret    
 a87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a8e:	66 90                	xchg   %ax,%ax
    base.s.ptr = freep = prevp = &base;
 a90:	c7 05 00 10 00 00 04 	movl   $0x1004,0x1000
 a97:	10 00 00 
    base.s.size = 0;
 a9a:	bf 04 10 00 00       	mov    $0x1004,%edi
    base.s.ptr = freep = prevp = &base;
 a9f:	c7 05 04 10 00 00 04 	movl   $0x1004,0x1004
 aa6:	10 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aa9:	89 f8                	mov    %edi,%eax
    base.s.size = 0;
 aab:	c7 05 08 10 00 00 00 	movl   $0x0,0x1008
 ab2:	00 00 00 
    if(p->s.size >= nunits){
 ab5:	e9 36 ff ff ff       	jmp    9f0 <malloc+0x30>
 aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
 ac0:	8b 0a                	mov    (%edx),%ecx
 ac2:	89 08                	mov    %ecx,(%eax)
 ac4:	eb b1                	jmp    a77 <malloc+0xb7>
