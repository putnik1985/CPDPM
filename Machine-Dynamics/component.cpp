#include "component.h"

component::component(double k, double d):
k{k}, damp{d}
{
           unsigned int dofs = 2; // vertical and latteral deflection for the grounded bearing
	   M = Matrix<double>(dofs);
	   K = Matrix<double>(dofs);
           D = Matrix<double>(dofs); 
        
	   K(1,1) = k; K(1,2) = -k;
	   K(2,2) = k; K(2,1) = -k;
	   D(1,1) = damp; D(1,2) = -damp;
	   D(2,2) = damp; D(2,1) = -damp;
}
