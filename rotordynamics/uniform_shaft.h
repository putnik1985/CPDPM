#ifndef UNIFORM_SHAFT_H
#define UNIFORM_SHAFT_H

#include "structure.h"   
#include "gyro.h"

class uniform_shaft: public structure, gyro {
 public:
 explicit uniform_shaft(double L, double rho, double E, double Ri, double Ro):
 L(L), rho(rho), E(E), Ri(Ri), Ro(Ro) {}

 Matrix M();
 Matrix K();
 Matrix G();

 private:
 double L;
 double rho;
 double E;
 double Ri;
 double Ro;
};

#endif
