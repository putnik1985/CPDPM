#ifndef LIN_BEARING_H
#define LIN_BEARING_H

#include "structure.h"
#include "gyro.h"


class linear_bearing: public structure {
 public:
 linear_bearing(double k);

 private:
 double k;
};

#endif
