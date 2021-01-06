int strnlen (const char *s, int maxlen)
{
  int i;

  for (i = 0; i < maxlen && s[i]; ++i);
  return i;
}
