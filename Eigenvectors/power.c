#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>


#define NMAX 100 
#define MAXITER 100

double maxvalue(int n, double A[NMAX][NMAX], int iter);

int main(int argc, char** argv){
    double A[NMAX][NMAX] = {{0.22, 0.02, 0.12,  0.14},
                            {0.02, 0.14, 0.04, -0.06},
                            {0.12, 0.04, 0.28,  0.08},
                            {0.14, -0.06, 0.08, 0.26}};

   double B[NMAX][NMAX] = { {1.0, 0.0, 0.0, 0.0},
                            {0.0, 2.0, 0.0, 0.0},
                            {0.0, 0.0, 3.0, 0.0},
                            {0.0, 0.0, 0.0, 4.0}};
   int n = 4;
   int iter = 1;
   for(int i=0; i<argc; ++i){
       if (strcmp("-n", argv[i]) == 0) iter=atoi(argv[i+1]);
   }
   maxvalue(n, A, iter);
return 0;
}

double maxvalue(int n, double A[NMAX][NMAX], int iterations){

   printf("Input Matrix:\n");    
   for(int i=0; i<n; ++i){
       for(int j=0; j<n; ++j)
           printf("%12.4f", A[i][j]);
       printf("\n");
   } 

   double y0[] = {1., 0., 1., 0.};
   printf("\n");
   printf("Initial vector:\n");
   for(int i=0; i<n; ++i)
       printf("%12.4f",y0[i]);

   double*  y = calloc(n, sizeof(double));
   int iter = 0;
   printf("\n");
   double value; 
          while (iter < iterations){
                 ++iter;
                 for(int i=0; i<n; ++i){
                     y[i] = 0.;
                     for(int k=0; k<n; ++k){
                         y[i] += A[i][k] * y0[k]; //kth approximation
                     }
                 }

                 /***************************************
                 for(int i=0; i<n; ++i)
                     printf("%12.6f", y[i]);
                 printf("\n");
                 ***************************************/

                 for(int i=0; i<n; ++i){
                     if ( y0[i] != 0.) {
                             ////printf("%12.f\n",y[i]/y0[i]);
                             value = y[i] / y0[i];
                     }
                     y0[i] = y[i];
                 }
          } 

   printf("\n"); 
   printf("Iterations used:\n");
   printf("%12d\n", iterations);
   printf("Eigenvalue:\n");
   printf("%12.6f\n", value);
   printf("Eigenvector:\n");
   double maxv = 0.;  

   for(int i=0; i<n; ++i)
       if (fabs(y[i]) > maxv)
           maxv = fabs(y[i]);

   for(int i=0; i<n; ++i){
       printf("%12.6f", y[i]/=maxv);
   }
  
   printf("\n");
   if ( y != NULL) free(y);
   return value;
}
