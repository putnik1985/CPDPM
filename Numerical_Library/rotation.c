#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <errno.h>
#include <math.h>


/* rotation: solve linear system of n equations Ax=b applying rotation from the left side*/
double* rotation(int n, double* A, double* b)
{
        for(int i = 0; i < n - 1; ++i){

		double mag = sqrt(A[i*n + i] * A[i*n + i] + A[(i+1)*n + i ] * A[(i+1)*n + i]);
		double c, s; /* cosine and sine */

		if (mag == 0.){
			c = 1.;
		        s = 0.;
	        } else {
			c = A[i*n + i] / mag;
			s = - A[(i+1)*n + i] / mag;
		}

		double y[n];
		double z[n];

		for(int k = i; k < n; ++k){
			y[k] = A[i*n + k];
			z[k] = A[(i+1)*n  + k];
		}
                
		double f = b[i];
		double g = b[i+1];

		for(int k = i; k < n; ++k){
			A[i*n + k] = c * y[k] - s * z[k];
			A[(i+1) *n + k] = s * y[k] + c * z[k];
		}

		b[i] = c * f - s * g;
		b[i+1] = s * f + c * g;

	}
    
	double* x = calloc(n, sizeof(double));
	if ( x == NULL) return NULL;

	for(int k = n - 1; k >= 0; --k){
		double s = 0.;
		for(int j = k + 1; j < n; ++j)
			s += A[k*n + j] * x[j];
		x[k] = (b[k] - s) / A[k *n + k];
	}
	return x;
}
