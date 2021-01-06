char *
memcpy (char *dst, const char *src, unsigned long n)
{
  char *ret = dst;
  while (n--)
    *dst++ = *src++;
  return ret;
}

char *
memmove (char *dst, const char *src, unsigned long n)
{
  char *ret = dst;
  if (src < dst)
    {
      dst += n;
      src += n;
      while (n--)
        *--dst = *--src;
    }
  else
    while (n--)
      *dst++ = *src++;
  return ret;
}
