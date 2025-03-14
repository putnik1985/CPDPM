
#include "numeric_c.h"

void balanc(double* a, int n){
 int last, j, i;
 double s, r,g, f, c, sqrdx;

 sqrdx = RADIX * RADIX;
 last = 0.;
 while (last == 0){
        last = 1;
        for(i=1; i<=n; i++){
            r = c = 0.;
            for(j=1; j<=n; j++)
                if (j != i) {
                    c += fabs(a[(j-1)*n + i-1]);
                    r += fabs(a[(i-1)*n + j-1]);
                }
             if (c && r) {
                 g = r / RADIX; 
                 f = 1.;
                 s=c+r;
                 while (c<g) {
                        f *= RADIX;
                        c *= sqrdx;
                 }
                 g=r*RADIX;
                 while (c>g) {
                        f /= RADIX;
                        c /= sqrdx;
                 }
                 if ((c+r)/f < 0.95*s) {
                     last=0;
                     g=1./f;
                     for(j=1; j<=n; j++) a[(i-1) * n + j-1] *= g;
                     for(j=1; j<=n; j++) a[(j-1) * n + i-1] *= f;
                 }
           }
        }
   }
}

void elmhes(double* a, int n){
     int m, j, i;
     double y, x;
     
     for(m=2; m<n; m++) {
         x = 0.;
         i = m;
         for(j=m; j<=n; j++) {
             if (fabs(a[(j-1) * n + m-1-1]) > fabs(x)) {
                 x = a[(j-1) * n + m-1-1];
                 i = j;
             }
          }
          if ( i != m) {
               for(j=m-1; j<=n; j++) SWAP(a[(i-1) * n + j-1],a[(m-1) * n + j-1])
               for(j=1; j<=n; j++) SWAP(a[(j-1) * n + i-1],a[(j-1) * n + m-1])
          }
          if (x) {
              for (i=m+1; i<=n; i++) {
                   if ((y=a[(i-1) * n + m-1-1]) != 0.) {
                        y /= x;
                        a[(i-1) * n + m-1-1]=y;
                        for (j=m; j<=n; j++)
                             a[(i-1) * n + j-1] -= y*a[(m-1) * n + j-1];
                        for (j=1; j<=n; j++)
                             a[(j-1) * n + m-1] += y*a[(j-1) * n + i-1];
                    }
                }
           }
      }
      for(int j=1; j<=n; ++j)
       for(int i = j + 2; i <= n; ++i)
         a[ (i-1)*n + j - 1] =0.;
}

void hqr(double *a, int n, double *wr, double *wi)
{
     int nn, m, l, k, j, its, i, mmin;
     double z, y, x, w, v, u, t, s, r, q, p, anorm;
     
     anorm = 0.;
     for (i=1; i<=n; i++)
          for(j=IMAX(i-1,1); j<=n; j++)
              anorm+=fabs(a[(i-1) * n + j-1]);
     nn = n;
     t = 0.;
     while (nn >= 1) {
         its=0;
         do {
             for (l=nn; l>=2; l--) {
                  s=fabs(a[(l-1-1)*n + l-1-1])+fabs(a[(l-1) * n + l-1]);
                  if (s==0.) s = anorm;
                  if ((double)(fabs(a[(l-1) * n + l-1-1]) + s) == s) break;
             }
             x = a[(nn-1) * n + nn-1];
             if (l == nn) {
                 int nn1 = nn - 1;
                 wr[nn1]=x+t;
                 wi[nn1-1]=0.;
                 nn--;
             } else {
                 y = a[(nn-1-1) * n + nn-1-1];
                 w = a[(nn-1) * n + nn-1-1]*a[(nn-1-1) * n + nn-1];
                 if (l == (nn-1)) {
                     p = 0.5 * (y-x);
                     q = p * p + w;
                     z = sqrt(fabs(q));
                     x += t;
                     if (q >= 0. ) {
                         z = p + SIGN(z,p);
                         wr[nn-1 -1]=wr[nn-1]=x+z;
                         if (z) wr[nn-1]=x-w/z;
                         wi[nn-1-1]=wi[nn-1]=0.;
                      } else {
                          wr[nn-1-1]=wr[nn-1]=x+p;
                          wi[nn-1-1]= -(wi[nn-1]=z);
                      }
                      nn -= 2;
                  } else {
                         if (its == 30) {printf("Too many iterations in hqr\n"); exit(1); }
                         if (its == 10 || its == 20) {
                             t += x;
                             for (i=1; i<=nn; i++) a[(i-1) * n + i-1] -= x;
                             s = fabs(a[(nn-1) * n + nn-1-1]) + fabs(a[(nn-1-1)*n + nn-2-1]);
                             y = x = 0.75*s;
                             w = -0.4375*s*s;
                         }
                         ++its;
                         for (m=(nn-2); m>=l; m--) {
                              z = a[(m-1) * n + m-1];
                              r = x - z;
                              s = y - z;
                              p =(r*s-w)/a[(m+1-1)*n + m-1]+a[(m-1) * n + m+1-1];
                              q = a[(m+1-1) * n + m+1-1]-z-r-s;
                              r = a[(m+2-1) * n + m+1-1];
                              s = fabs(p)+fabs(q)+fabs(r);
                              p /= s;
                              q /= s;
                              r /= s;
                              if (m == l) break;
                              u = fabs(a[(m-1) * n + m-1-1])*(fabs(q)+fabs(r));
                              v = fabs(p)*(fabs(a[(m-1-1) * n + m-1-1])+fabs(z)+fabs(a[(m+1-1) * n + m+1-1]));
                              if ((double)(u+v) == v) break;
                          }
                          for(i=m+2; i<=nn; i++) {
                              a[(i-1) * n + i-2-1] = 0.;
                              if (i != (m+2)) a[(i-1) * n + i-3-1] = 0.;
                          }
                          for (k=m; k<=nn-1; k++) {
                               if (k != m) {
                                   p = a[(k-1) * n + k-1-1];
                                   q = a[(k+1-1)*n * k-1-1];
                                   r = 0.;
                                   if (k != (nn-1)) r=a[(k+2-1) * n + k-1-1];
                                   if ((x=fabs(p)+fabs(q)+fabs(r)) != 0.) {
                                        p /= x;
                                        q /= x;
                                        r /= x;
                                    }
                                }
                                if ((s=SIGN(sqrt(p*p+q*q+r*r), p)) != 0.) {
                                   if (k == m) {
                                       if (l != m)
                                       a[(k-1) *n + k-1-1] = -a[(k-1) * n + k-1-1];
                                   } else 
                                       a[(k-1) * n + k-1-1] = -s*x;
                                   p += s;
                                   x=p/s;
                                   y=q/s;
                                   z=r/s;
                                   q /= p;
                                   r /= p;
                                   for (j=k; j<=nn; j++) {
                                        p=a[(k-1) * n + j-1]+q*a[(k+1-1) * n + j-1];
                                        if (k != (nn-1)) {
                                            p += r * a[(k+2-1) * n + j-1];
                                            a[(k+2-1) * n + j-1] -= p*z;
                                        }
                                        a[(k+1-1) * n + j-1] -= p*y;
                                        a[(k-1) * n + j-1] -= p*x;
                                    }
                                    mmin = nn<k+3 ? nn : k+3;
                                    for (i=l;i<=mmin;i++) {
                                         p=x*a[(i-1) * n + k-1]+y*a[(i-1) * n + k+1-1];
                                         if (k != (nn-1)) {
                                             p += z*a[(i-1) * n + k+2-1];
                                             a[(i-1) * n + k+2-1] -= p*r;
                                         }
                                         a[(i-1) * n + k+1-1] -= p*q;
                                         a[(i-1) * n + k-1] -= p;
                                     }
                                  }
                              }
                          }
                       }
                    } while (l < nn-1);
             }
}

int hessenberg(double *a, double *H, double *Z, int n){

    for(int i = 0; i<n; ++i)
        for(int j=0; j<n; ++j)
            H[i*n+j] = 0.;

    for(int i=0; i<n-1; ++i)
        H[(i+1)*n + i] = -1.0;

    for(int i = 0; i<n; ++i)
        for(int j=0; j<n; ++j)
            Z[i*n+j] = 0.;
   
    Z[0*n+0] = 1.;
    for(int s = 0; s < n-1 ; ++s) {
        for(int i = 0; i < s+1; ++i){
            double sum = 0.0;
            for(int m = 0; m < n; ++m)
                sum += a[i*n + m] * Z[m*n+s];
                 
            double denom = 0.0;
            for(int m=0; m<i; ++m)
                denom += H[m*n+s] * Z[i*n+m];

                 H[i*n+s] = -(sum + denom) / Z[i*n+i];
            }

         for(int i = s+1; i < n; ++i) {
             double sum = 0.0;
             for(int j = 0; j<s+1; ++j)
                 sum += H[j*n+s] * Z[i*n+j];

             for(int m = 0; m < n; ++m)
                 sum += a[i*n+m] * Z[m*n+s];

             Z[i*n+s+1] = sum;
         }
     } // for(int s = 0....

     for(int i=0; i<n; ++i){

         double sum = 0.0;
         for(int m=0; m<n; ++m)
             sum += a[i*n+m] * Z[m*n + n-1];

         double denom = 0.0;
         for(int m=0; m<i; ++m)
             denom += H[m*n + n-1] * Z[i*n + m];

         if (Z[i*n + i] == 0.)
             return -1;

         H[i*n + n-1] = -(sum + denom) / Z[i*n + i];
     }

/*************************
    printf("check\n");
    for(int i =0; i<n; ++i){
     for(int j = 0; j <n; ++j){
         double s1 = 0.;
         double s2 = 0.;
         for(int k =0; k<n; ++k){
             s1 += a[i*n+k] * Z[k*n+j];
             s2 += Z[i*n+k] * H[k*n+j];
         }
         printf("%d,%d = %f\n", i, j, s1 + s2);
      }
    }
**************************/
    return 0;
}
