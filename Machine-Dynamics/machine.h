#ifndef MACHINE_H
#define MACHINE_H

#include "component.h"
#include "lumped_mass.h"

struct machine: public structure{

   machine(): nodes{0}{};
   int append(const component&); 
   int append(const lumped_mass&);
   int nodes;

};

#endif
