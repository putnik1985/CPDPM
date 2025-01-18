#include "numeric_c.h"
void laguer(fcomplex* a, int m, fcomplex *x, int *its)
{
     int iter, j;
     double abx, abp, abm, err;
     fcomplex dx, x1, b, g, h, sq, gp, gm, g2;
     static double frac[MR+1] = {0., 0.5, 0.25, 0.75, 0.13, 0.38, 0.62, 0.88, 1.};
/*******************************
     printf("initial guess (%.2f,%.2f)\n", x->r, x->i); 
     for(int i=0; i<=m; ++i)
         printf("(%.2f,%.2f)*x^%d+",a[i].r, a[i].i,i);
     printf("\n");
********************************/

     for(iter = 1; iter <= MAXIT; ++iter){
         *its = iter;
          b = a[m];
          err = cabs(*x);
          fcomplex d = {0., 0.};
          fcomplex f = {0., 0.};
          abx = cabs(*x);
          for(j=m-1; j>=0; --j){
              f = cadd(cmul(*x,f), d);
              d = cadd(cmul(*x,d), b);
              b = cadd(cmul(*x,b), a[j]);
              err = cabs(b) + abx * err;
          }
/*************************************************
          printf("p(x0)=(%.2f,%.2f)\n",b.r, b.i);
          printf("p'(x0)=(%.2f,%.2f)\n",d.r, d.i);
          printf("p''(x0)=(%.2f,%.2f)\n",f.r, f.i);
**********************************************/

          err *= EPSS;
          if (cabs(b) <= err ) 
              return;

           g = cdiv(d, b);
          g2 = cmul(g, g);
           h = csub(g2, rcmul(2., cdiv(f,b)));
          sq = csqrt(rcmul((double)(m-1), csub(rcmul((double)m,h),g2)));  
          gp = cadd(g,sq);
          gm = csub(g,sq);
          abp = cabs(gp);
          abm = cabs(gm);
          if(abp < abm) gp=gm;
          fcomplex temp = {(double)m, 0.0};
          fcomplex temp2 = {cos((double)iter),sin((double)iter)};

          dx = ((FMAX(abp,abm) > 0.0 ? cdiv(temp , gp)
                                     : rcmul(exp(log(1.+abx)), temp2)));
          x1 = csub(*x, dx);
          if(x->r == x1.r && x->i == x1.i) return;
          if (iter % MT) *x = x1;
          else *x = csub(*x, rcmul(frac[iter/MT], dx));
       }
       fprintf(stderr, "too many itrations in laguer\n");
       return;
}

void zroots(fcomplex a[], int m, fcomplex roots[], int polish){
     int i, its, j, jj;
     fcomplex x, b, c, ad[MAXM];

     for(j=0; j<=m; j++) ad[j]=a[j];

     for(j=m; j>=1; j--) {
         x = complex(0., 0.);
         laguer(ad, j, &x, &its);
//         printf("----------------------------------\n");
//         printf("root: (%f, %f)\n", x.r, x.i);
         if (fabs(x.i) <= 2. * EPS * fabs(x.r)) x.i = 0.;
         roots[j] = x;
         b = ad[j];
         for(jj=j-1; jj>=0; jj--) {
             c=ad[jj];
             ad[jj]=b;
             b=cadd(cmul(x,b),c);
         }
      }

      if (polish)
          for (j=1; j<=m; j++)
               laguer(a,m,&roots[j],&its);

          for(j=2; j<=m; j++){
              x=roots[j];
              for(i=j-1; i>=1; i--){
                  if (roots[i].r <= x.r) break;
                  roots[i+1]=roots[i];
              }
              roots[i+1]=x;
          }
}
