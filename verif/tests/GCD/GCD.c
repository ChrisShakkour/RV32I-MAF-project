
// declaring the recursive function
int find_gcd(int , int );

int main()
{
  int a, b, gcd;
  a = 5;
  b = 725;
  
  gcd = find_gcd(a, b);
  return 0;
}

// defining the function
int find_gcd(int x, int y)
{
  if(x > y)
    find_gcd(x-y, y);

  else if(y > x)
    find_gcd(x, y-x);
  else
    return x;
}
