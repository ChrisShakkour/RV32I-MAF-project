int main()
{
  char s[1000]="Hello this is a c code attempting to asave some string value in the D-mem to valid\
ate the D-mem functionality";
  char c='a';
  int i,count=0;

  for(i=0;s[i];i++)
    {
      if(s[i]==c)
	{
	  count++;
	}
    }

  return 0;
}
