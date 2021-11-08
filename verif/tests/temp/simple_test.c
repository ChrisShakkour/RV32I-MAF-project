void towerOfHanoi(int n, char from_rod, char to_rod, char aux_rod)
{
  if (n == 1)
    {
      return;
    }
  towerOfHanoi(n-1, from_rod, aux_rod, to_rod);
  towerOfHanoi(n-1, aux_rod, to_rod, from_rod);
}


int main()
{
  int n = 4; // Number of disks
  towerOfHanoi(n, 'A', 'C', 'B');  // A, B and C are names of rods
  return 0;
}
