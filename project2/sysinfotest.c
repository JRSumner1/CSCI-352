#include "types.h"
#include "user.h"
#include "sysinfo.h"

// from mmu.h
#define	PGSIZE	4096

void
sinfo(struct sysinfo *info) {
  if (sysinfo(info) < 0) {
    printf(1,"FAIL: sysinfo failed");
    exit();
  }
}

//
// use sbrk() to count how many free physical memory pages there are.
//
uint
countfree()
{
  uint sz0 = (uint)sbrk(0);
  struct sysinfo info;
  uint n = 0;

  while(1){
    if((uint)sbrk(PGSIZE) == 0xffffffff){
      break;
    }
    n += PGSIZE;
  }
  sinfo(&info);
  if (info.memfree != 0) {
    printf(1,"FAIL: there is no free mem, but sysinfo.memfree=%d\n",
      info.memfree);
    exit();
  }
  sbrk(-((int)sbrk(0) - sz0));
  return n;
}

void
testmem() {
  struct sysinfo info;
  uint n = countfree();
  
  sinfo(&info);

  info.memfree *= 1024;
  if (info.memfree != n) {
    printf(1,"FAIL: free mem %d (bytes) instead of %d\n", info.memfree, n);
    exit();
  }
  
  if((uint)sbrk(PGSIZE) == 0xffffffff){
    printf(1,"sbrk failed");
    exit();
  }

  sinfo(&info);
    
  info.memfree *= 1024;
  if (info.memfree != n-PGSIZE) {
    printf(1,"FAIL: free mem %d (bytes) instead of %d\n", n-PGSIZE, info.memfree);
    exit();
  }
  
  if((uint)sbrk(-PGSIZE) == 0xffffffff){
    printf(1,"sbrk failed");
    exit();
  }

  sinfo(&info);
    
  info.memfree *= 1024;
  if (info.memfree != n) {
    printf(1,"FAIL: free mem %d (bytes) instead of %d\n", n, info.memfree);
    exit();
  }
}

void
testcall() {
  struct sysinfo info;
  
  if (sysinfo(&info) < 0) {
    printf(1,"FAIL: sysinfo failed\n");
    exit();
  }

  if (sysinfo((struct sysinfo *) 0xeaeb0b5b) !=  0xffffffff) {
    printf(1,"FAIL: sysinfo succeeded with bad argument\n");
    exit();
  }
}

void testproc() {
  struct sysinfo info;
  uint numproc;
  int status;
  int pid;
  
  sinfo(&info);
  numproc = info.numproc;

  pid = fork();
  if(pid < 0){
    printf(1,"sysinfotest: fork failed\n");
    exit();
  }
  if(pid == 0){
    sinfo(&info);
    if(info.numproc != numproc+1) {
      printf(1,"sysinfotest: FAIL numproc is %d instead of %d\n", info.numproc, numproc+1);
      exit();
    }
    exit();
  }
  status = wait();
  if( status == -1 ) {
	  printf(1,"sysinfotest: testproc failed: no child\n" );
	  exit();
  }else {
  	sinfo(&info);
  	if(info.numproc != numproc) {
      	printf(1,"sysinfotest: FAIL numproc is %d instead of %d\n", info.numproc, numproc);
      	exit();
  	}
  }
}

void testbad() {
  int pid = fork();
  int xstatus;
  
  if(pid < 0){
    printf(1,"sysinfotest: fork failed\n");
    exit();
  }
  if(pid == 0){
      sinfo(0x0);
      exit();
  }
  xstatus = wait();
  if(xstatus == -1)  // kernel killed child?
    exit();
  else {
    printf(1,"sysinfotest: testbad succeeded %d\n", xstatus);
    exit();
  }
}

int
main(int argc, char *argv[])
{
  printf(1,"sysinfotest: start\n");
  testcall();
  testmem();
  testproc();
  printf(1,"sysinfotest: OK\n");
  exit();
}
