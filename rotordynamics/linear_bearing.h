#ifndef LIN_BEARING_H
#define LIN_BEARING_H

#include "structure.h"   

class linear_bearing: public structure {
 public:
 linear_bearing(double k):
 k(k) {}

 Matrix M();
 Matrix K();

 private:
 double k;
};

#endif
