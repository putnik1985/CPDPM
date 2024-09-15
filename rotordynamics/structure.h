#ifndef STRUCTURE_H
#define STRUCTURE_H

#include "Matrix.h"

class structure {
 
 public:
 virtual Matrix M() = 0;
 virtual Matrix K() = 0;
};

#endif
