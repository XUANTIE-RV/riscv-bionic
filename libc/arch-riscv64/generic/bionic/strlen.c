long strlen(char *s)
{
  char *p;

  for (p = s; *p; ++p);
  return p - s;
}
