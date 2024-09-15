#include "linear_bearing.h"

Matrix linear_bearing::M()
{
       Matrix m;
              m(1,1) = 0.0; m(1,2) = 0.0;
              m(2,1) = 0.0; m(2,2) = 0.0;
       return m;
}
        
Matrix linear_bearing::K()
{
       Matrix k1;
              k1(1,1) = k;  k1(1,2) = -k;
              k1(2,1) = -k; k1(2,2) = k;
       return k1;
}
