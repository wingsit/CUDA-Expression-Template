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
class array
{
private:
  T* arr;
  unsigned size;
  
public:
  array(unsigned size_):size(size_){
    arr = new T[size];
  }

  array(unsigned size_, T* ptr_, bool copy = false):size(size_)
  {
    if(copy){
      T* arr = new T[size];
      copy(ptr_, ptr_+size, arr);
    }else{
      arr = ptr_;
    }
  }
  
  double& operator[](unsigned i) const
  {
    return *(arr+i);
  }

  unsigned length() const
  {
    return size;
  }

  const array<T> operator+(array<T> const& rhs) const
  {
    array<T> result(*this);
    for(int i = 0; i < this->length(); ++i)
      {
	result[i] += rhs[i];
    }
    return result;    
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

template<typename T>
void print_array(array<T> const& arr)
{
  for(int i = 0; i < arr.length(); ++i)
    {
      std::cout << arr[i] << std::endl;
    }
};



int main()
{
  static int size = 1e7;
  srand(0);
  
  array<double> a(size);
  array<double> b(size);
  array<double> c(size);
  array<double> result(size);
  
  std::generate(&a[0], &(a[size]), RandomNumber);
  std::generate(&b[0], &(b[size]), RandomNumber);
  std::generate(&c[0], &(c[size]), RandomNumber);
  for(int i = 0; i < 1000; ++i)
    result = a + b + c;

#ifdef PRINT
  for( int i = 0; i < size; ++i)
    {
      std::cout << a[i] << ", "<< b[i] <<"," << c[i] << "," << result[i]<< std::endl;
    }
#endif
  //  print_array(a, size);
  //  for(int i = 0; i < 1000; ++i)
  //    sum3(a,b,c, result, size);
  //  print_array(result);
}
