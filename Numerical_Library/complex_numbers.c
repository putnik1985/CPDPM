#include "numeric_c.h"
fcomplex csum(fcomplex a, fcomplex b)
{
   fcomplex c;
   c.re = a.re + b.re;
   c.i = a.i + b.i;
   return c;
}

fcomplex csub(fcomplex a, fcomplex b)
{
   fcomplex c;
   c.re = a.re - b.re;
   c.i = a.i - b.i;
   return c;
}

fcomplex cmult(fcomplex a, fcomplex b)
{
   fcomplex c;
   c.re = a.re * b.re - a.i * b.i;
   c.i = a.re * b.i + a.i * b.re;
   return c;
}

fcomplex cdiv(fcomplex a, fcomplex b)
{
   fcomplex c;
   double mag = b.re * b.re + b.i * b.i;
   c.re = (a.re * b.re + a.i * b.i) / mag;
   c.i = (a.i * b.re - a.re * b.i) / mag;
   return c;
}

fcomplex conj(fcomplex a)
{
  fcomplex c;
  c.re = a.re;
  c.i = - a.i;
  return c;
}

double cabs(fcomplex a)
{
   double mag = sqrt(a.re * a.re + a.i * a.i);
   return mag;
}
