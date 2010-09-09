#include "macro.hpp"
#include <algorithm>
#include <iostream>
#include <cstdlib>

int RandomNumber(){return (double)(rand() % 1000);}

template<typename NumType>
void sum3(NumType * a, NumType * b, NumType* c, NumType * result, unsigned const n)
{
  int i;
#pragma omp parallel for default(shared) shared(result,a,b,c,n) private(i)
  for(i = 0; i < n; ++i){
    result[i] = a[i] + b[i] + c[i];
  }
};

template<typename T>
void print_array(T const* arr, int size)
{
  for(int i = 0; i < size; ++i)
    {
      std::cout << arr[i] << std::endl;
    }
};

int main()
{
  
  static int size = 1e7;
  srand(0);
  double* a = new double[size];
  double* b = new double[size];
  double* c = new double[size];
  double* result = new double[size];
  
  std::generate(a, a+size, RandomNumber);
  std::generate(b, b+size, RandomNumber);
  std::generate(c, c+size, RandomNumber);
  //  print_array(a, size);
  for(int i = 0; i < 1000; ++i)
    sum3(a,b,c, result, size);

#ifdef PRINT
  for( int i = 0; i < size; ++i)
    {
      std::cout << a[i] << ", "<< b[i] <<"," << c[i] << "," << result[i]<< std::endl;
    }
#endif
}

