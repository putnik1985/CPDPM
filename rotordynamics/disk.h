#ifndef DISK_H
#define DISK_H

#include "structure.h"
#include "gyro.h"

class disk: public structure, gyro {
 
 public:
   disk(double m, double Jp, double Jd):
   m(m), Jp(Jp), Jd(Jd) {}

   Matrix M();
   Matrix K();
   Matrix G();

 private:
   double m;
   double Jp; 
   double Jd;
};

#endif

