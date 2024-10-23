#include "numeric_c.h"

/* hausholder: solve linear system of n equations Ax=b using reflection matrix*/
double* hausholder(int n, double* A, double* b)
{
        double w[n];
	double e[n];
	double S[n];

	for(int i = 0; i < n; ++i){
		e[i] = 0.;
		S[i] = 0.;
		w[i] = 0.;
	}
	for(int step = 0; step < n - 1; ++step){
		e[step] = 1.;
		for(int k = step; k < n; ++k)
			S[k] = A[k * n + step];

		double alpha = 0.;
		for(int k = step; k < n; ++k)
			alpha += S[k] * S[k];
		alpha = sqrt(alpha);

		double rho;
		for(int k = step; k < n; ++k)
			rho += (S[k] - alpha * e[k]) * (S[k] - alpha * e[k]);
		rho = sqrt(rho);

		for(int k = step; k < n; ++k)
			w[k] = (S[k] - alpha * e[k])/rho;

		for(int col = step; col < n; ++col){
			double dot_product_a = 0.;
			double dot_product_b= 0.;
			for(int i = step; i < n; ++i){
				dot_product_a += w[i] * A[i*n + col];
				dot_product_b += w[i] * b[i];
			}

			for(int row = step; row < n; ++row){
				A[row*n+col] -= 2. * dot_product_a* w[row];
				b[row] -= 2. * dot_product_b * w[row];
			}
		}
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

/* det_hausholder: calculate determinant*/
/* does not work need to understand how to take into accout detU = -1 */
double det_hausholder(int n, double* A)
{
        double w[n];
	double e[n];
	double S[n];

	for(int i = 0; i < n; ++i){
		e[i] = 0.;
		S[i] = 0.;
		w[i] = 0.;
	}
	for(int step = 0; step < n - 1; ++step){
		e[step] = 1.;
		for(int k = step; k < n; ++k)
			S[k] = A[k * n + step];

		double alpha = 0.;
		for(int k = step; k < n; ++k)
			alpha += S[k] * S[k];
		alpha = sqrt(alpha);

		double rho;
		for(int k = step; k < n; ++k)
			rho += (S[k] - alpha * e[k]) * (S[k] - alpha * e[k]);
		rho = sqrt(rho);

		for(int k = step; k < n; ++k)
			w[k] = (S[k] - alpha * e[k])/rho;

		for(int col = step; col < n; ++col){
			double dot_product_a = 0.;
			for(int i = step; i < n; ++i){
				dot_product_a += w[i] * A[i*n + col];
			}

			for(int row = step; row < n; ++row){
				A[row*n+col] -= 2. * dot_product_a* w[row];
			}
		}
	}

	double x = 1.; 
	for(int i = 0; i < n; ++i)
		x *= A[i*n + i];
	return x;
}
