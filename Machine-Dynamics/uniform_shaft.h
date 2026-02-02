#ifndef UNIFORM_SHAFT_H
#define UNIFORM_SHAFT_H

#include "structure.h"
#include "gyro.h"

class uniform_shaft: public structure, public gyro {
 public:
 explicit uniform_shaft(double L, double rho, double E, double Ri, double Ro);

 private:
 double L;
 double rho;
 double E;
 double Ri;
 double Ro;
};

#endif
