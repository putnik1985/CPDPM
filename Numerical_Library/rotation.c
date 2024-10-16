#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <errno.h>
#include <math.h>


/* rotation: solve linear system of n equations Ax=b applying rotation from the left side*/
double* rotation(int n, double A[n][n], double b[n])
{
        for(int i = 0; i < n - 1; ++i){

		double mag = sqrt(A[i][i] * A[i][i] + A[i+1][i] * A[i+1][i]);
		double c, s; /* cosine and sine */

		if (mag == 0.){
			c = 1.;
		        s = 0.;
	        } else {
			c = A[i][i] / mag;
			s = - A[i+1][i] / mag;
		}

		double y[n];
		double z[n];

		for(int k = i; k < n; ++k){
			y[k] = A[i][k];
			z[k] = A[i+1][k];
		}
                
		double f = b[i];
		double g = b[i+1];

		for(int k = i; k < n; ++k){
			A[i][k] = c * y[k] - s * z[k];
			A[i+1][k] = s * y[k] + c * z[k];
		}

		b[i] = c * f - s * g;
		b[i+1] = s * f + c * g;

	}
    
	double* x = calloc(n, sizeof(double));
	if ( x == NULL) return NULL;

	for(int k = n - 1; k >= 0; --k){
		double s = 0.;
		for(int j = k + 1; j < n; ++j)
			s += A[k][j] * x[j];
		x[k] = (b[k] - s) / A[k][k];
	}
	return x;
}
