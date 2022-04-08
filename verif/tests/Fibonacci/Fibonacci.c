int fib(int n)
{
  if (n <= 1)
    return n;
  return fib(n - 1) + fib(n - 2);
}

int main()
{
  int n = 20;
  int res=0;
  res=fib(n);
  return 0;
}
