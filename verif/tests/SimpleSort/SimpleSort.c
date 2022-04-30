#define ARRAY_SIZE 8

int main()
{
  int i ,j ,temp;
  int numbers[] = {2, 5, 18, 10, 44, 52, 23, 90};
  
  // Array Sorting - Ascending Order
  for (i = 0; i < ARRAY_SIZE; ++i)
    {
      for (j = i + 1; j < ARRAY_SIZE; ++j)
	{
	  if (numbers[i] > numbers[j])
	    {
	      temp =  numbers[i];
	      numbers[i] = numbers[j];
	      numbers[j] = temp;
	    }
	}
    }
 
  return 0;
}
