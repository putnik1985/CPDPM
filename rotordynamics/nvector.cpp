#include "nvector.h"

template<typename T>
T& nvector<T>::operator()(int i){
   return this->operator[](i-1);
}

template<typename T>
const T& nvector<T>::operator()(int i) const{
   return this->operator[](i-1);
}
