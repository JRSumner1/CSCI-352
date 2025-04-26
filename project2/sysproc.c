#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "syscall.h"
#include "sysinfo.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

unsigned int trace (unsigned int mask, unsigned int setting)
{
  uint ptracemask;
  acquire(&tracemasklock);
  ptracemask = tracemask;
  if (setting == 0) {
    tracemask = tracemask & (~mask);
  }else {
    tracemask = tracemask | mask;
  }
  release(&tracemasklock);
  return ptracemask;
}

int
sys_trace(void)
{
  int mask, setting;
  if(argint(0, &mask) < 0 || argint(1, &setting) < 0)
    return -1;
  return trace(mask, setting);
}

int 
sys_sysinfo(void) {
    struct sysinfo info;
    struct sysinfo *user_info;

    // Get the user-space pointer from the argument
    if (argptr(0, (void*)&user_info, sizeof(*user_info)) < 0)
        return -1;

    // Calculate free memory
    info.memfree = kgetfreemem();

    // Get the number of processes
    info.numproc = kgetnumproc();

    // Copy the info to user space
    if (copyout(myproc()->pgdir, (uint)user_info, &info, sizeof(info)) < 0)
        return -1;

    return 0;
}

int
sys_halt(void)
{
  outw(0x604, 0x2000);
  outw(0xb004, 0x2000);
  outw(0x501, 0x0);

  return 0;
}
