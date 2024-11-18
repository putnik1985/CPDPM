#include "nvector.h"

template<typename T>
T& nvector<T>::operator()(int i){
   return this->operator[](i-1);
}
