#include "numeric_c.h"

/* gauss: solve linear system of n equations Ax=b */
double* gauss(int n, double* A, double* b)
{
        for(int i = 0; i < n - 1; ++i)
		for(int j = i + 1; j < n; ++j){
			double factor = A[j*n + i] / A[i*n + i];
			for(int k = i; k < n; ++k)
				A[j*n + k] -= factor * A[i*n + k];

			b[j] -= factor * b[i];
		}

	double* x = calloc(n, sizeof(double));
	if ( x == NULL) return NULL;

	for(int k = n - 1; k >= 0; --k){
		double s = 0.;
		for(int j = k + 1; j < n; ++j)
			s += A[k*n + j] * x[j];
		x[k] = (b[k] - s) / A[k*n + k];
	}
	return x;
}
/* det_gauss: calculate determinant based on the gauss elimination */ 
double det_gauss(int n, double* A)
{
        for(int i = 0; i < n - 1; ++i)
		for(int j = i + 1; j < n; ++j){
			double factor = A[j*n + i] / A[i*n + i];
			for(int k = i; k < n; ++k)
				A[j*n + k] -= factor * A[i*n + k];
		}

	double x = 1.;
	for(int i = 0; i < n; ++i)
		x *= A[i*n + i];

 	return x;
}
/* cgauss: solve linear system of n equations Ax=b */
fcomplex* cgauss(int n, fcomplex* A, fcomplex* b)
{
        for(int i = 0; i < n - 1; ++i)
		for(int j = i + 1; j < n; ++j){
			fcomplex factor = cdiv(A[j*n + i],A[i*n + i]);
			for(int k = i; k < n; ++k)
				A[j*n + k] = csub(A[j*n + k], cmult(factor,A[i*n + k]));

			b[j] = csub(b[j], cmult(factor,b[i]));
		}

	fcomplex* x = calloc(n, sizeof(fcomplex));
	if ( x == NULL) return NULL;

	for(int k = n - 1; k >= 0; --k){
		fcomplex s = {0., 0.};
		for(int j = k + 1; j < n; ++j)
			s = csum(s, cmult(A[k*n + j], x[j]));
		x[k] = cdiv(csub(b[k],s),A[k*n + k]);
	}
	return x;
}
