#include "macro.hpp"
#include <algorithm>
#include <iostream>
#include <cstdlib>

#define double float

int RandomNumber(){return static_cast<double>(rand() % 1000);}

__global__ void sum3(double * a,
		     double * b,
		     double * c,
		     double * result,
		     unsigned size)
		     
{
  unsigned i = blockDim.x * blockIdx.x + threadIdx.x;
  if(i < size)
    {
      result[i] = (a[i] + b[i] + c[i]);
    }
};

int main()
{
  
  unsigned size = 1e7;
  srand(0);
  double* a = new double[size];
  double* b = new double[size];
  double* c = new double[size];
  double* result = new double[size];
  
  std::generate(a, a+size, RandomNumber);
  std::generate(b, b+size, RandomNumber);
  std::generate(c, c+size, RandomNumber);

  double* ad, *bd,* cd;
  double* resultd;

  unsigned * sized;
 cudaMalloc((void**) &ad, size*sizeof(double)) ;
 cudaMalloc((void**) &bd, size*sizeof(double)) ;
 cudaMalloc((void**) &cd, size*sizeof(double)) ;
 cudaMalloc((void**) &resultd, size*sizeof(double));
 cudaMalloc((void**) &sized, sizeof(unsigned)) ;

  for(int i = 0; i < 1000; ++i)
    {
      unsigned block_size = 515;
      unsigned num_blocks = (size + block_size - 1) / block_size;
      cudaMemcpy(ad, a, size*sizeof(double), cudaMemcpyHostToDevice);
      cudaMemcpy(bd, b, size*sizeof(double), cudaMemcpyHostToDevice);
      cudaMemcpy(cd, c, size*sizeof(double), cudaMemcpyHostToDevice);            
      sum3<<<num_blocks, block_size>>>(ad, bd, cd, resultd, size);
      cudaMemcpy(result, resultd, size*sizeof(double), cudaMemcpyDeviceToHost);
    }

#ifdef PRINT
  for( int i = 0; i < size; ++i)
    {
      std::cout << a[i] << ", "<< b[i] <<"," << c[i] << "," << result[i]<< std::endl;
    }
#endif

  cudaFree(ad);
  cudaFree(bd);
  cudaFree(cd);
  cudaFree(resultd);

  delete[] a;
  delete[] b;
  delete[] c;
  delete[] result;
  
  return 0;
}
