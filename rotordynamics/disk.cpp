#include "disk.h"

disk::disk(double m, double Jp, double Jd):
m(m), Jp(Jp), Jd(Jd) 
{
  unsigned int dofs = 4; // ffor the disk with two defelctions and rotations	

  M = Matrix<double>(dofs);
  M(1,1) = m;
  M(2,2) = m;
  M(3,3) = Jd;
  M(4,4) = Jd;
  
  K = Matrix<double>(dofs);
  D = Matrix<double>(dofs);

  G = Matrix<double>(dofs);
  G(3,4) = Jp;
  G(4,3) = -Jp;
    
}
