#include "newton.h"

struct response newton(double x0, double (*f)(double), double (*J)(double)){
  struct response output;
  
  double epsilon = 1.e-8;
  
  if (fabs(f(x0)) < epsilon) {
	  output.ok = 1;
	  output.x = x0;
	  return output;
  }
  
  int iterations = 0;
  int maxiter = 64;
  
  while (fabs(f(x0)) > epsilon){
	     //printf("%.6f,%.6f\n", x0, f(x0));
	     if(fabs(J(x0)) > 0.) {
			 x0 = x0 - f(x0) / J(x0);
			 
		 } else {
             output.ok = 0;
			 output.x = -1.;
			 return output;
			 
		 }
		 
		 if (++iterations > maxiter){
			 output.ok = 0;
			 output.x = -1.;
			 return output;
		 }
  }
  
	  output.ok = 1;
	  output.x = x0;
  return output;
}

double f(double x) {
	return sin(x);
}

double J(double x){
	return cos(x);
}

double f1(double *x){
	return x[0]*x[0] + x[1]*x[1] - 4.;
}

double f2(double *x){
	return (x[0]-2.)*(x[0]-2.) + x[1]*x[1] - 1.;
}

