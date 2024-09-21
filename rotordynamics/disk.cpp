#include "disk.h"

Matrix disk::M()
{
  Matrix m1(4);
  m1(1,1) = m;
  m1(2,2) = m;
  m1(3,3) = Jd;
  m1(4,4) = Jd;
  return m1;
}

Matrix disk::K()
{
 Matrix k(4);
 return k;
}

Matrix disk::G()
{
 Matrix g(4);
 g(3,4) = Jp;
 g(4,3) = -Jp;
 return g;
}
