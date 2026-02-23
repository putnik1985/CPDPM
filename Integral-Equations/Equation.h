#ifndef EQUATION_H
#define EQUATION_H
#include "stl.h"

/******************************
 Integral[a,b] {K(x,s)*z(s)} ds = u(x)
*******************************/
template<class T> T u(T x){
                    return 2. * x - M_PI;
}

template<class T> T K(T x, T s){
                    return x - s;
}

#endif
