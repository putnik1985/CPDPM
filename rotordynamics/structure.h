#ifndef STRUCTURE_H
#define STRUCTURE_H

#include "Matrix.h"
#include "Matrix.cpp"   

struct structure {
 Matrix<double> M;
 Matrix<double> K;
 Matrix<double> D;
 Matrix<double> H;
};

#endif
