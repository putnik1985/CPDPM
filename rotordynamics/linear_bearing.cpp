#include "linear_bearing.h"

linear_bearing::linear_bearing(double k):
k{k}
{
       unsigned int dofs = 2; // vertical and latteral deflection for the grounded bearing
	   M = Matrix<double>(dofs);
	   K = Matrix<double>(dofs);
	   K(1,1) = k;
	   K(2,2) = k;
}