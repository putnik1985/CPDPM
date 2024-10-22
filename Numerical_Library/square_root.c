#include "numeric_c.h"

/* square_root: solve linear system of n equations Ax=b using symmetry if the matrix A*/
double* square_root(int n, double* A, double* b)
{
	double *s = calloc(n*n, sizeof(double));
	if ( s == NULL)
		return NULL;

	s[0*n + 0] = sqrt(A[0*n + 0]);
	for(int j = 0; j < n; ++j)
		s[0*n + j] = A[0*n + j] / s[0*n +0];

	for(int i = 1; i < n; ++i){
		double sum = 0.;
		for(int k = 0; k < i; ++k)
			sum += s[k*n + i] * s[k*n + i];
		s[i*n + i] = sqrt(A[i*n + i] - sum);
	}

	for(int i = 0; i < n; ++i)
		for(int j = i+1; j < n; ++j){
			double sum = 0.;
			for(int k = 0; k < i; ++k)
				sum += s[k*n + i] * s[k*n + j];

			s[i*n + j] = (A[i*n+j] - sum)/s[i*n+i];
		}

        for(int j = 0; j < n; ++j)
		for(int i = j + 1; i < n; ++i)
			s[i*n + j] = 0.;
/*
	for(int i = 0; i < n; ++i){
		for(int j = 0; j < n; ++j)
			printf("%12.1f",s[i*n+j]);
		printf("\n");
	}
        printf("\n");
	double check[n*n];
	for(int i = 0; i<n; ++i){
		for(int j = 0; j<n;++j){
			check[i*n+j] = 0.;
			for(int k = 0; k<n; ++k)
				check[i*n + j] += s[k*n+i] * s[k*n+j];
			printf("%12.1f",check[i*n+j]);

		}
		printf("\n");
	}
*/
	double z[n];

	for(int i = 0; i < n; ++i){
		double sum = 0.;
		for(int k = 0; k < i; ++k)
			sum += s[k*n + i] * z[k];
		z[i] = (b[i] - sum)/s[i*n + i];
	}

	double* x = calloc(n, sizeof(double));
	if ( x == NULL) 
		return NULL;

	for(int k = n - 1; k >= 0; --k){
		double sum = 0.;
		for(int i = k + 1; i < n; ++i)
			sum += s[k*n + i] * x[i];
		x[k] = (z[k] - sum) / s[k*n + k];
	}
	return x;
}
