#include <iostream>
#include <thrust/device_vector.h>
template <typename L, typename OP, typename R>
struct X{
  const L& l; const R& r;
  X(const L& l_, const R& r_): l(l_), r(r_){}
  
  __host__ __device__ double give(int i) const {return OP::apply(l.give(i), r.give(i));}
};

struct Times{
  
  __host__ __device__ static double apply(const double & a, const double & b){return a*b;}
};

struct Plus{
  __host__ __device__ inline static double apply ( const double & a, const double & b) {return a+b;}
};

class Vector{
  thrust::device_vector<double> data;
  const int N_;
public:
  Vector(int N, double val): N_(N)
  {
    data.resize(N);
    for(int i = 0; i < N_; ++i){
      data[i] = val;
    }
  }

  Vector(int N):N_(N){
    data.resize(N);
  }

  double& operator[](int idx) const
  {
    return data[idx];
  }

  __host__ __device__ double give(int i ) const {return data[i];}
  
  template<typename L, typename OP, typename R>
  __host__ __device__
  void operator=(const X<L, OP, R>& x){
    for(int i = 0; i < N_; ++i) data[i] = x.give(i);  
  }

  void toString() const
  {
    for(int i = 0; i < N_; ++i)
      {
	std::cout << data[i] << std::endl;
      }
  }

};

template<typename L>
X<L, Times, Vector> operator*( const L& l, const Vector& r){
  return X<L, Times, Vector>(l, r);
};

template<typename L, typename R>
X<L, Times, R> operator*(const L& l, const R& r){
  return X<L, Times, R>(l, r);
};


template<typename L>
X<L, Plus, Vector> operator+( const L& l, const Vector& v){
  return X<L, Plus, Vector> ( l, v);
};

template<typename L, typename R>
X<L, Plus, R> operator+(const L& l, const R& r){
  return X<L, Plus, R> (l, r);
};
