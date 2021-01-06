#include <unistd.h>

void *memset(void * s, int c, unsigned long n)
{
  char *r = s, *end = s + n;
  while (r < end)
    *r++ = c;
  return s;
}

extern void* __memset_chk_fail();
void *
__memset_chk (void *dstpp, int c, unsigned long len, unsigned long dstlen)
{
  if (dstlen < len)
    __memset_chk_fail ();

  return memset (dstpp, c, len);
}
