#include "linear_bearing.h"

Matrix linear_bearing::M()
{
       Matrix m(4);
       return m;
}
        
Matrix linear_bearing::K()
{
       Matrix k1(4);
              k1(1,1) = k;  k1(1,3) = -k;
              k1(3,1) = -k; k1(3,3) = k;
              k1(2,2) = k;  k1(1,4) = -k;
              k1(4,1) = -k; k1(4,4) = k;
       return k1;
}
