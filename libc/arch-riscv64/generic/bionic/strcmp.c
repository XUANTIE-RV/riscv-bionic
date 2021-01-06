int
strcmp (const char *s1, const char *s2)
{
  int ret;

  while ((ret = *(unsigned char *) s1 - *(unsigned char*) s2++) == 0 && *s1++);
  return ret;
}
