#include "uniform_shaft.h"

#ifndef M_PI
#define M_PI 3.14159
#endif

uniform_shaft::uniform_shaft(double L, double rho, double E, double Ri, double Ro):
 L(L), rho(rho), E(E), Ri(Ri), Ro(Ro) 
 {
	   unsigned int dofs = 8;
	   K = Matrix<double>(dofs);
	   D = Matrix<double>(dofs);
	 
       auto J = M_PI * (pow(Ro, 4) - pow(Ri, 4))/4.;
       auto A = M_PI * (pow(Ro, 2) - pow(Ri, 2));

       auto nu = 0.3;
       auto G1 = E / (2 * ( 1 + nu));
       auto m1 = Ri/Ro;
       auto factor = 6 * (1+nu) * pow(1+m1 * m1, 2) / ( (7 + 6*nu) * pow(1. +m1 * m1, 2) + (20. + 12. * m1) * m1 * m1);
       auto eps = E * J / (factor * G1 * A * L * L);

       K(1,1) = 12.;     K(1,4) = 6. * L;
       K(2,2) = 12.;     K(2,3) = -6. * L;
       K(3,2) = -6. * L; K(3,3) = 4. * L * L * (1. + 3. * eps);
       K(4,1) =  6. * L; K(4,4) = 4. * L * L * (1.  + 3. * eps);
      
       for(int i = 1; i <= 4; ++i)
           for(int j = 1; j <= 4; ++j)
               K(4 + i,4 + j) = K(i,j);

       // change polarity 
       for(int i = 1; i<=4; ++i)
           K(4+i,4+5-i) = -K(i,5-i);

       K(1,5) = -12.;     K(1,8) = 6. * L;
       K(2,6) = -12.;     K(2,7) = -6. * L;
       K(3,6) =  6. * L;  K(3,7) = 2. * L * L * (1. - 6. * eps);
       K(4,5) = -6. * L; K(4,8) = 2. * L * L * (1.  - 6. * eps);

       for(int i = 1; i<=8; ++i)
           for(int j = i + 1; j<=8; ++j)
               K(j,i) = K(i,j); 

       K *= E * J / (pow(L,3) * (1. + 12. * eps));	 
	   
	   M = Matrix<double>(dofs);

       m1 = rho * A * L / 2.0; 
       auto Id = (rho * J * L + rho * A * pow(L, 3) / 12.) / 2.;

       M(1,1) = m1; M(2,2) = m1; M(3,3) = Id; M(4,4) = Id;

       for(int i = 1; i<=4; ++i)
           M(i + 4,i + 4) = M(i,i); 

	   G = Matrix<double>(dofs);
       auto Jp = rho * J * L; 

       G(3,4) = Jp;
       G(4,3) = -Jp;

       G(7,8) = Jp;
       G(8,7) = -Jp;
	   
 }
