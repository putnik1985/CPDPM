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


double df11(double *x){
	return 2.*x[0];
}
double df12(double *x){
	return 2.*x[1];
}

double df21(double *x){
	return 2.*x[0]-4.;
}
double df22(double *x){
	return 2.*x[1];
}

double norm(double (*F[N])(double*), double* x){
       return sqrt(F[0](x) * F[0](x) + F[1](x) * F[1](x));
}

double jacobian(double (*dF[N][N])(double*), double* x){
       return dF[0][0](x) * dF[1][1](x) - dF[0][1](x) * dF[1][0](x);
}

double* inverse(double A[N][N]){
	double* inv = calloc(N*N, sizeof(double));
	double det = A[0][0] * A[1][1] - A[0][1]*A[1][0];
        inv[0*N + 0] =  A[1][1]/det;
	inv[1*N + 0] = -A[1][0]/det;
	inv[0*N + 1] = -A[0][1]/det;
	inv[1*N + 1] =  A[0][0]/det;
	return inv;
}

double* multMatrixVector(double A[N][N], double b[N]){
        double* x = calloc(N, sizeof(double));
	for(int i=0; i<=N; ++i)
            for(int k=0; k<=N; ++k)
		x[i] += A[i][k] * b[k];

	return x;
}

int diffVectorVector(double x[N], double a[N]){
	for(int i=0; i<=N; ++i)
		x[i] -= a[i];
	return 0;
}

int equal(double A[N][N], double* a){
	for(int i=0; i<N; ++i)
		for(int j=0; j<N; ++j)
			A[i][j] = a[i*N+j];
	return 0;
}

int print(double A[N][N]){
	for(int i=0; i<N; ++i){
		for(int j=0; j<N; ++j)
			printf("%12.6f", A[i][j]);
	        printf("\n");
	}
	return 0;
}

struct responseR2 newtonR2(double* x0, double (*F[N])(double*), double (*dF[N][N])(double*)){
  struct responseR2 output;
  double epsilon = 1.e-8;
  double* empty = calloc(N, sizeof(double));

  if (norm(F, x0) < epsilon) {
	  output.ok = 1;
	  output.x = x0;
	  return output;
  }
  
  int iterations = 0;
  int maxiter = 64;
  
  while (norm(F, x0) > epsilon){
	     if(fabs(jacobian(dF, x0)) > 0.) {
		         //printf("x=%.6f, y=%.6f\n", x0[0], x0[1]);
		         //printf("jacobian: %f\n", jacobian(dF, x0));
		         double A[N][N];
			 double b[N];
                         for(int i=0; i<N; ++i){
			     b[i] = F[i](x0);	 
			     for(int j=0; j<N; ++j)
				 A[i][j] = dF[i][j](x0);    
                         }
			 //printf("Jacobian:\n");
			 //print(A);

			 double invJ[N][N];
			 equal(invJ, inverse(A));
			 //printf("Inverse Jacobian:\n");
			 //print(invJ);
			 diffVectorVector(x0, multMatrixVector(invJ,b));
			 
		 } else {
                         output.ok = 0;
			 output.x = empty;
			 return output;
		 }
		 
		 if (++iterations > maxiter){
			 output.ok = 0;
			 output.x = empty;
			 return output;
		 }
  }
  
	  output.ok = 1;
	  output.x = x0;
	  free(empty);
  return output;
}
