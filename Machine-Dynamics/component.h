#ifndef COMPONENT_H
#define COMPONENT_H

#include "structure.h"

class component: public structure {
 public:
 component(double k, double d);
 const double& get_k() {return k;}
 const double& get_d() {return damp;}
 
 private:
 double k;
 double damp;
};

#endif
