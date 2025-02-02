
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
                  if ((double)fabs(a[(l-1) * n + l-1-1] + s) == s) break;
             }
             x = a[(nn-1) * n + nn-1];
             if (l == nn) {
                 int nn1 = nn - 1;
                 wr[nn1]=x+t;
                 wi[nn1--]=0.;
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
                         if (its == 30) nerror("Too many iterations in hqr");
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
