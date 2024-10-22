#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <errno.h>
#include <math.h>


/* rotation: solve linear system of n equations Ax=b applying rotation from the left side*/
double* rotation(int n, double* A, double* b)
{
    for(int row = 0;  row < n - 1; row++)
        for(int i = row + 1; i < n; ++i){

		double mag = sqrt(A[row*n + row] * A[row*n + row] + A[i*n + row ] * A[i*n + row]);
		double c, s; /* cosine and sine */

		if (mag == 0.){
			c = 1.;
		        s = 0.;
	        } else {
			c =  A[row*n + row] / mag;
			s = -A[i*n + row] / mag;
		}

               /* 
		printf("elem: %12.2f%12.2f\n",A[row*n+row],A[i*n+row]);
                printf("cos: %12.2f%12.2f\n",c,s);
		*/
		double y[n];
		double z[n];

		for(int k = row; k < n; ++k){
			y[k] = A[row*n + k];
			z[k] = A[i*n  + k];
		}
                
		double f = b[row];
		double g = b[i];

		for(int k = row; k < n; ++k){
			A[row*n + k] = c * y[k] - s * z[k];
			A[i*n + k] = s * y[k] + c * z[k];
		}

		b[row] = c * f - s * g;
		b[i] = s * f + c * g;

	}
   /* 
	for(int i = 0; i < n; ++i){
		for(int j = 0; j < n; ++j)
			printf("%12.2f",A[i*n+j]);
		printf("\n");
	}
   */
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
