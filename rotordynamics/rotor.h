#ifndef ROTOR_H
#define ROTOR_H

#include "linear_bearing.h"
#include "disk.h"
#include "uniform_shaft.h"

class rotor: public structure, public gyro {
 public:
   rotor(){};
   int append(const linear_bearing&) const; 
   int append(const disk&) const;
   int append(const uniform_shaft&) const;

 private:
   int nodes;

};

#endif
