#ifndef LUMPED_H
#define LUMPED_H

#include "structure.h"

class lumped_mass: public structure{
 
 public:
   lumped_mass(double m);

 private:
   double m;
};

#endif

