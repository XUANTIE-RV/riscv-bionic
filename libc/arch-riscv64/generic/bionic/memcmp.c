int memcmp (const char *s1, const char *s2, int n)
{
  int ret = 0;

  while (n-- && (ret = *(unsigned char *) s1++ - *(unsigned char *) s2++) == 0);
  return ret;
}
