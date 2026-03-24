#ifndef LUMPED_H
#define LUMPED_H

#include "structure.h"

class lumped_mass: public structure{
 
 public:
   lumped_mass(double m);
   double const get_m() const {return m;};

 private:
   double m;
};

#endif

