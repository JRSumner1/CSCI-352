#include "types.h"
#include "syscall.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  unsigned int res;

  res = trace((1 << SYS_read) | (1 << SYS_write), 1);
  printf(1, "Trace enabled, previous mask: %x\n", res);

  char buffer[10];
  read(0, buffer, 10);
  write(1, buffer, 10);

  res = trace(1 << SYS_write, 0);
  printf(1, "Trace updated, previous mask: %x\n", res);

  read(0, buffer, 10);
  write(1, buffer, 10);

  exit();
}
