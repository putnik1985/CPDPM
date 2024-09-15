#ifndef DISK_H
#define DISK_H

#include "structure.h"

class disk: public structure {
 
 public:
   disk(double m, double Jp, double Jd):
   m(m), Jp(Jp), Jd(Jd) {}

   Matrix M();
   Matrix K();

 private:
   double m;
   double Jp; 
   double Jd;
};

#endif

