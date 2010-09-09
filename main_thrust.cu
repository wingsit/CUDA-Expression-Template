#include "macro.hpp"
//#include <algorithm>
#include <iostream>

#include <thrust/host_vector.h>
#include <thrust/device_vector.h>
#include <thrust/copy.h>
#include <thrust/generate.h>
#include <thrust/functional.h>
#include <thrust/transform.h>
#include <thrust/iterator/zip_iterator.h>
#include <thrust/tuple.h>

#include <cstdlib>


#define double float


int RandomNumber(){return static_cast<double>(std::rand() % 1000);}

struct sum3{
  __host__ __device__ double operator()(const thrust::tuple<double, double, double>& a) const
  {
    return thrust::get<0>(a) + thrust::get<1>(a) + thrust::get<2>(a);
  }
};

void sum(const thrust::device_vector<double>& a,
	 const thrust::device_vector<double>& b,
	 const thrust::device_vector<double>& c,
	 thrust::device_vector<double>& result)
{
  thrust::transform(thrust::make_zip_iterator(thrust::make_tuple(a.begin(), b.begin(), c.begin())),
		    thrust::make_zip_iterator(thrust::make_tuple(a.end(), b.end(), c.end())),
		    result.begin(),
		    sum3());
					      
};



int main()
{
  
  unsigned size = 1e7;
  srand(0);
  double* a = new double[size];
  double* b = new double[size];
  double* c = new double[size];
  double* result = new double[size];
  
  thrust::generate(a, a+size, RandomNumber);
  thrust::generate(b, b+size, RandomNumber);
  thrust::generate(c, c+size, RandomNumber);

  thrust::device_vector<double> dev_a(a, a+size);
  thrust::device_vector<double> dev_b(b, b+size);
  thrust::device_vector<double> dev_c(c, c+size);
  thrust::device_vector<double> dev_result(size);

  for(int i = 0; i < 1000; ++i)
    {
      thrust::copy(a, a+size, dev_a.begin());
      thrust::copy(b, b+size, dev_b.begin());
      thrust::copy(c, c+size, dev_c.begin());
      sum(dev_a,dev_b,dev_c,dev_result);  
      thrust::copy(dev_result.begin(), dev_result.end(), result);
    }

#ifdef PRINT
  for(int i = 0; i < size; ++i)
    {
      std::cout << a[i] << "," << b[i] << ","<< c[i] << "," << result[i] << std::endl;
    }
#endif

	delete[] a;
	delete[] b;
	delete[] c;
	delete[] result;
  
};
