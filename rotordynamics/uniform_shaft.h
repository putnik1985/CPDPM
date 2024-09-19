#ifndef UNIFORM_SHAFT_H
#define UNIFORM_SHAFT_H

#include "structure.h"   

class uniform_shaft: public structure {
 public:
 explicit uniform_shaft(double L, double E, double Ri, double Ro):
 L(L), E(E), Ri(Ri), Ro(Ro) {}

 Matrix M();
 Matrix K();

 private:
 double L;
 double E;
 double Ri;
 double Ro;
};

#endif
