#include "uniform_shaft.h"

Matrix uniform_shaft::K()
{
       Matrix k(8);

       auto J = M_PI * (pow(Ro, 4) - pow(Ri, 4))/4.;
       auto A = M_PI * (pow(Ro, 2) - pow(Ri, 2));

       auto nu = 0.3;
       auto G = E / (2 * ( 1 + nu));
       auto m1 = Ri/Ro;
       auto factor = 6 * (1+nu) * pow(1+m1 * m1, 2) / ( (7 + 6*nu) * pow(1. +m1 * m1, 2) + (20. + 12. * m1) * m1 * m1);
       auto eps = E * J / (factor * G * A * L * L);

       k(1,1) = 12.;     k(1,4) = 6. * L;
       k(2,2) = 12.;     k(2,3) = -6. * L;
       k(3,2) = -6. * L; k(3,3) = 4. * L * L * (1. + 3. * eps);
       k(4,1) =  6. * L; k(4,4) = 4. * L * L * (1.  + 3. * eps);
      
       for(int i = 1; i <= 4; ++i)
           for(int j = 1; j <= 4; ++j)
               k(4 + i,4 + j) = k(i,j);

       // change polarity 
       for(int i = 1; i<=4; ++i)
           k(4+i,4+5-i) = -k(i,5-i);

       k(1,5) = -12.;     k(1,8) = 6. * L;
       k(2,6) = -12.;     k(2,7) = -6. * L;
       k(3,6) =  6. * L;  k(3,7) = 2. * L * L * (1. - 6. * eps);
       k(4,5) = -6. * L; k(4,8) = 2. * L * L * (1.  - 6. * eps);

       for(int i = 1; i<=8; ++i)
           for(int j = i + 1; j<=8; ++j)
               k(j,i) = k(i,j); 

       k *= E * J / (pow(L,3) * (1. + 12. * eps));
       return k;
}

Matrix uniform_shaft::M()
{
       Matrix m(8);

       return m;
}
