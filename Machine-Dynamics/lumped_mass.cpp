#include "lumped_mass.h"

lumped_mass::lumped_mass(double m):
m(m) 
{
  unsigned int dofs = 1; // for the lumped_mass with two defelctions and rotations	

  M = Matrix<double>(dofs);
  M(1,1) = m;
  
  K = Matrix<double>(dofs);
  D = Matrix<double>(dofs);
}
