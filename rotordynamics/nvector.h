#ifndef NVECT_H
#define NVECT_H

#include "stl.h"

template<typename T>
class nvector: public vector<T>{ // numberig starts from the 1

public:
     using vector<T>::vector;
     T& operator()(int i);
     const T& operator()(int i) const;
	
};// nvector class 

#endif
