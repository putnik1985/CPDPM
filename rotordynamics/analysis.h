#ifndef ANALYSIS_H
#define ANALYSIS_H

#include "Matrix.h"
/////#include "Matrix.cpp"

template<typename T>
int natural_modes(Matrix<T> M, Matrix<T> K, const nvector<T>& nodes);
#endif
