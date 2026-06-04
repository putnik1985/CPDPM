#ifndef EQUATION_H
#define EQUATION_H
#include "stl.h"

/******************************
 Integral[a,b] {K(x,s)*z(s)} ds = u(x)
*******************************/

template<class T> T K(T x, T s){
                    return 1./(1. + 100. * (x-s) * (x-s));
}

template<class T> T z(T s){
                    return (exp(-(s-0.3)*(s-0.3)/0.03) + exp(-(s-0.7)*(s-0.7)/0.03))/0.9550408-0.052130913;
}

#endif
