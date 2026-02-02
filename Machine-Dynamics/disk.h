#ifndef DISK_H
#define DISK_H

#include "structure.h"
#include "gyro.h"

class disk: public structure, public gyro {
 
 public:
   disk(double m, double Jp, double Jd);

 private:
   double m;
   double Jp; 
   double Jd;
};

#endif

