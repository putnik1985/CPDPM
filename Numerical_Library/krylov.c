#include "numeric_c.h"

double* krylov(double* a, int n){

double* B = calloc(n*n, sizeof(double));
        
        if (B == NULL){
            printf("krylov: B failure allocation\n");
            return B;  
        }

        for(int i=0; i<n; ++i)
            B[i*n+0] = 0.;
        B[0*n+0] = 1.;

        for(int j=1; j<n; ++j)
            for(int i=0; i<n; ++i){
                B[i*n+j] = 0.;
                for(int s=0; s<n; ++s)
                    B[i*n+j] += a[i*n+s] * B[s*n + j-1];
            }
/*************************************************
        printf("Calculations steps:\n");
        for(int i = 0; i<n; ++i){
            for(int j = 0; j<n; ++j)
                printf("%12.6f", B[i*n+j]);
            printf("\n");
        }
***********************************************/
        double* b = calloc(n, sizeof(double));

        if (b == NULL){
            printf("krylov vector b failure allocation\n");
            return b;  
        }

        for(int i=0; i<n; ++i){
            b[i] = 0.;
            for(int s=0; s<n; ++s)
                b[i] += a[i*n+s] * B[s*n + n-1];
        }

/**********************************************
        for(int i = 0; i<n; ++i)
            printf("%12.6f\n",b[i]);
**********************************************/

        double* p = gauss(n, B, b);
        if (p == NULL) {
            printf("krylov: no solution\n");
            return p;
        }

        int j = n-1;
        for(int i = 0; i<j; ++i, --j){
            double temp = p[i];
                   p[i] = p[j];
                   p[j] = temp;
        } 
/*********************************************************
        for(int i=0; i<n; ++i)
            printf("%12.6f", p[i]);
        printf("\n");
***********************************************************/
        free(b);
        free(B);
  return p;
}
