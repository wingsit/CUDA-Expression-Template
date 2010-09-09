//#include <algorithm>
#include <thrust/generate.h>
#include "Expression_cu.hpp"

int RandomNumber(){return (double)(rand() % 1000);}
int main()
{
  srand(0);
  static int size = 1e7;
  static double val = 0.5;
  Vector a(size), b(size), c(size), result(size);

  std::generate(&(a[0]), &(a[size]), RandomNumber);
  std::generate(&(b[0]), &(b[size]), RandomNumber);
  std::generate(&(c[0]), &(c[size]), RandomNumber);

  for( int i = 0; i < 1000; ++i)
    result = a+b+c;
#ifdef PRINT  
  for( int i = 0; i < size; ++i)
    {
      std::cout << a[i] << ", "<< b[i] <<"," << c[i] << "," << result[i]<< std::endl;
    }
#endif
}
