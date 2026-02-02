#ifndef ROTOR_H
#define ROTOR_H

#include "linear_bearing.h"
#include "disk.h"
#include "uniform_shaft.h"

struct rotor: public structure, public gyro {

   rotor(): nodes{0}{};
   int append(const linear_bearing&); 
   int append(const disk&);
   int append(const uniform_shaft&);
   int nodes;

};

#endif
