#ifndef OPERATOR_H
#define OPERATOR_H
#include "stl.h"
#include "MatrixLib.cpp"

template<class T>
struct image{
	T operator()(T x) {return 2. * x - M_PI;}
	//T operator()(T x) {return M_PI;}
};

template<class T>
struct kernel{
       double operator()(T x, T s){return x - s;}
       //double operator()(T x, T s){return 1.;}	   
};

template<class F, class T>
class integral_operator{
  public:
  integral_operator(F K1, T a1, T b1, T c1, T d1, int n1, int n2):K(K1), a(a1), b(b1), c(c1), d(d1), nx(n1), ns(n2) {};
  template<class U> Numeric_lib::Matrix<T,1> operator()(U u){
	Numeric_lib::Matrix<T,1> g(ns);
	T dx = (d-c)/nx;
	T h  = (b-a)/ns;
	for(int i=0; i<ns; ++i){
	        T sum = 0.;
		T s = a + 0.5 * h + i * h;
		for(int j=0; j<nx; ++j){
			T x = c + 0.5 * dx + j * dx;
	                sum += K(x,s) * u(x) * dx;
		}
		g(i) = sum;
	}
	return g;
  }

  Numeric_lib::Matrix<T,2> operator()(F K1){
               Numeric_lib::Matrix<T,2> K_(ns, ns);
	       T dx = (d-c)/nx;
	       T h  = (b-a)/ns;
               for(int i=0; i<ns; ++i){
                   T s = a + 0.5 * h + i * h;
                   for(int j=0; j<ns; ++j){
                       T t = a + 0.5 * h + j * h;
                       T sum = 0.;
                       for(int k=0; k<nx; ++k){
			   T x = c + 0.5 * dx + k * dx;
                           sum += K(x,s) * K1(x,t) * dx;
                       }
                       K_(i,j) = sum;
                   }
                }
                return K_;
  }  

  private:
  T a, b, c, d;
  F K;
  int nx, ns;
};

#endif
