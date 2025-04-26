#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
  halt();
  printf(1, "halt failed\n");
  return 0;
}
