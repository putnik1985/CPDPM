#include "numeric_c.h"

/* gauss: solve linear system of n equations Ax=b */
double* gauss(int n, double A[n][n], double b[n])
{
        for(int i = 0; i < n - 1; ++i)
		for(int j = i + 1; j < n; ++j){
			double factor = A[j][i] / A[i][i];
			for(int k = i; k < n; ++k)
				A[j][k] -= factor * A[i][k];

			b[j] -= factor * b[i];
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
