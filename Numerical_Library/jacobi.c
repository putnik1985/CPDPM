#include "numeric_c.h"

void eigsort(double* d, double *v, int n){

     int k, j, i;
     double p;
     for(i=0; i<n-1; ++i){
         p = d[k=i];
         for(j=i+1; j<n; ++j)
             if (d[j] <= p) p = d[k=j];
         if (k != i) {
             d[k] = d[i];
             d[i] = p;
             for(j=0; j<n; ++j) {
                 p = v[j*n+i];
                 v[j*n+i] = v[j*n+k];
                 v[j*n+k] = p;
             }
         }
      }
}

int jacobi(double *a, int n, double* d, double* v)
{
 int j, iq, ip, i;
 double tresh, theta, tau, t, sm, s, h, g, c, *b, *z;

 b = (double *)calloc(n, sizeof(double));
 z = (double *)calloc(n, sizeof(double));

 if (!b) {
          fprintf(stderr, "allocation failure in b\n");
          return;
 }
 if (!z) {
          fprintf(stderr, "allocation failure in z\n");
          return;
 }

 for(ip = 0; ip < n; ip++){
     for(iq = 0; iq < n; iq++) 
         v[ip * n + iq] = 0.0;
     v[ip * n + ip] = 1.0;
 }

 for(ip = 0; ip < n; ip++){
     b[ip]=d[ip]=a[ip * n + ip];
     z[ip] = 0.0;
 }

  int nrot = 0;
  for(i=1; i<= JACOBI_MAX_ITER; ++i){
      sm = 0.;
      for(ip=0; ip < n-1; ip++){
          for(iq = ip + 1; iq < n; iq++){
              //////////////printf("a=%f\n",fabs(a[ip*n+iq]));
              sm+=fabs(a[ip * n + iq]);
          }
      }
      ////////////////////printf("sum = %f\n",sm);
      if (sm == 0.) {
          free(z);
          free(b);
          eigsort(d, v, n);
          return nrot;
      }

      if (i<4)
          tresh = 0.2*sm / (n*n);
      else
          tresh = 0.;

      for(ip = 0; ip < n-1; ip++){
          for(iq = ip + 1; iq<n; iq++) {
              g = 100. * fabs(a[ip*n+iq]);
              if (i>4 && (fabs(d[ip])+g == fabs(d[ip]))  
                      && (fabs(d[iq])+g == fabs(d[iq])) )
                  a[ip * n + iq] = 0.;
              else if ( fabs(a[ip*n+iq]) > tresh ) {
                        h = d[iq] - d[ip];
                        if ( (fabs(h)+g) == fabs(h) )
                              t = a[ip * n + iq] / h;
                        else {
                              theta = 0.5 * h / a[ip * n + iq];
                              t = 1. /( fabs(theta) + sqrt(1. + theta * theta));
                              if (theta < 0.0) t = -t;
                        }
                        c = 1. / sqrt(1 + t * t);
                        s = t * c;

                        tau = s / (1. + c);
                        h = t * a[ip * n + iq];
                        z[ip] -= h;
                        z[iq] += h;
                        d[ip] -= h;
                        d[iq] += h;
                        a[ip*n+iq] = 0.;
                        for(j=0; j<=ip-1; ++j){
                            ROTATE(a,j,ip,j,iq)
                        }
                        for(j=ip+1;j<=iq-1;++j){
                            ROTATE(a,ip,j,j,iq) 
                        }
                        for(j=iq+1;j<n;++j){
                            ROTATE(a,ip,j,iq,j)
                        }
                        for(j=0;j<n;++j){
                            ROTATE(v,j,ip,j,iq)
                        }
/***************************************************************************************
                        printf("iteration = %d\n",nrot);
                        for(int i=0; i<n; ++i){
                            for(int j=0; j<n; ++j)
                                printf("%f,",v[i*n+j]);
                            printf("\n");
                        }
***************************************************************************************/
                        ++(nrot);
              }
          }
        }
        for(ip=0; ip<n; ip++){
            b[ip]+= z[ip];
            d[ip]=b[ip];
            z[ip]=0.0;
         }
      }
      fprintf(stderr, "Too many iterations in routine jacobi\n");
      exit(1);
}
