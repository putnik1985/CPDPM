#ifndef COMPONENT_H
#define COMPONENT_H

#include "structure.h"

class component: public structure {
 public:
 component(double k, double d);

 private:
 double k;
 double damp;
};

#endif
