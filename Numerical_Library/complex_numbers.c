#include "numeric_c.h"

fcomplex complex(double a, double b)
{
   fcomplex c;
   c.r = a;
   c.i = b;
   return c;
}

fcomplex csum(fcomplex a, fcomplex b)
{
   fcomplex c;
   c.r = a.r + b.r;
   c.i = a.i + b.i;
   return c;
}

fcomplex cadd(fcomplex a, fcomplex b)
{
   fcomplex c;
   c.r = a.r + b.r;
   c.i = a.i + b.i;
   return c;
}

fcomplex csub(fcomplex a, fcomplex b)
{
   fcomplex c;
   c.r = a.r - b.r;
   c.i = a.i - b.i;
   return c;
}

fcomplex cmult(fcomplex a, fcomplex b)
{
   fcomplex c;
   c.r = a.r * b.r - a.i * b.i;
   c.i = a.r * b.i + a.i * b.r;
   return c;
}

fcomplex cmul(fcomplex a, fcomplex b)
{
   fcomplex c;
   c.r = a.r * b.r - a.i * b.i;
   c.i = a.r * b.i + a.i * b.r;
   return c;
}

fcomplex cdiv(fcomplex a, fcomplex b)
{
   fcomplex c;
   double mag = b.r * b.r + b.i * b.i;
   c.r = (a.r * b.r + a.i * b.i) / mag;
   c.i = (a.i * b.r - a.r * b.i) / mag;
   return c;
}

fcomplex conj(fcomplex a)
{
  fcomplex c;
  c.r = a.r;
  c.i = - a.i;
  return c;
}

double cabs(fcomplex a)
{
   double mag = sqrt(a.r * a.r + a.i * a.i);
   return mag;
}

fcomplex rcmul(double a, fcomplex b)
{
  fcomplex c;
  c.r = a * b.r;
  c.i = a * b.i;
  return c;
}

fcomplex csqrt(fcomplex z)
{
  fcomplex c;
  double x, y, w, r;
  if ((z.r == 0.0) && (z.i == 0.)) {
       c.r = 0.;
       c.i = 0.;
       return c;
  } else {
         x = fabs(z.r);
         y = fabs(z.i);
         if (x>=y) {
             r = y/x;
             w = sqrt(x) * sqrt(0.5 * (1. + sqrt(1. + r * r)));
         } else {
             r = x/y;
             w = sqrt(y) * sqrt(0.5 * (r + sqrt(1. + r * r)));
         }
         if (z.r >=0.){
             c.r = w;
             c.i = z.i/(2*w);
         } else {
             c.i=(z.i >= 0.) ? w : -w;
             c.r = z.i/(2.*c.i);
         }
             return c;
   }
}

