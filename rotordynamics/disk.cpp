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
