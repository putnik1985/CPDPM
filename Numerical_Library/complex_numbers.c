#include "numeric_c.h"
struct complex_number csum(struct complex_number a, struct complex_number b)
{
   struct complex_number c;
   c.x = a.x + b.x;
   c.y = a.y + b.y;
   return c;
}

struct complex_number cmult(struct complex_number a, struct complex_number b)
{
   struct complex_number c;
   c.x = a.x * b.x - a.y * b.y;
   c.y = a.x * b.y + a.y * b.x;
   return c;
}

struct complex_number cdiv(struct complex_number a, struct complex_number b)
{
   struct complex_number c;
   double mag = b.x * b.x + b.y * b.y;
   c.x = (a.x * b.x + a.y * b.y) / mag;
   c.y = (a.y * b.x - a.x * b.y) / mag;
   return c;
}
