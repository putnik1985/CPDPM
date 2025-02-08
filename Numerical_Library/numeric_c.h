#ifndef NUMERIC_C_H
#define NUMERIC_C_H

#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <errno.h>
#include <math.h>
// this section is from the Numerical Reciepes in C
#define ROTATE(a,i,j,k,l) g=a[i*n+j]; h=a[k*n+l]; a[i*n+j]=g-s*(h+g*tau);\
                          a[k*n+l]=h+s*(g-h*tau);

#define JACOBI_MAX_ITER 50
#define EPSS 1.e-7
#define MR 8
#define MT 10
#define MAXIT (MR*MT)
#define EPS 2.0E-6
#define MAXM 100

#define RADIX 2.0
#define SWAP(g,h) {y=(g);(g)=(h);(h)=y;}


static double maxarg1,maxarg2;
#define FMAX(a,b) (maxarg1=(a),maxarg2=(b),(maxarg1)>(maxarg2)?\
(maxarg1) : (maxarg2))

#define SIGN(a,b) ((b) >= 0.0 ? fabs(a) : -fabs(a))

static int iminarg1, iminarg2;
#define IMIN(a,b) (iminarg1=(a), iminarg2=(b), (iminarg1) < (iminarg2) ?\
(iminarg1) : (iminarg2))

static int imaxarg1, imaxarg2;
#define IMAX(a,b) (imaxarg1=(a), imaxarg2=(b), (imaxarg1) > (imaxarg2) ?\
(imaxarg1) : (imaxarg2))


typedef struct complex_number {
       double r;
       double i;
} fcomplex;

/* gauss: solve linear system of n equations Ax=b */
double* gauss(int n, double* A, double* b);
/* det_gauss: calculate matrix A determinant and transform to triangular form */
double  det_gauss(int n, double* A);

/* cgauss: solve linear system of n equations Ax=b */
fcomplex* cgauss(int n, fcomplex* A, fcomplex* b);

/* rotation: solve linear system of n equations Ax=b applying rotation from the left side*/
double* rotation(int n, double* A, double* b);
/* det_rotation: calculate determinant and transform to triangle form*/
double  det_rotation(int n, double* A);

/* hausholder: solve linear system of n equations Ax=b using reflection matrix*/
double* hausholder(int n, double* A, double* b);
/* det_hausholder: calculate determinant and transform to triangular form determinant is not calculated correctly*/
double  det_hausholder(int n, double* A);

/* square_root: solve linear system of n equations Ax=b using symmetry of the matrix A*/
double* square_root(int n, double* A, double* b);
/* det_square_root: calculate determinant and transform to S'S*/
double det_square_root(int n, double* A);

fcomplex csum(fcomplex a, fcomplex b);
fcomplex cadd(fcomplex a, fcomplex b);
fcomplex csub(fcomplex a, fcomplex b);
fcomplex cmult(fcomplex a, fcomplex b);
fcomplex cmul(fcomplex a, fcomplex b);
fcomplex cdiv(fcomplex a, fcomplex b);
fcomplex conj(fcomplex a);
double cabs(fcomplex a);
fcomplex rcmul(double a, fcomplex b);
fcomplex csqrt(fcomplex a);
fcomplex complex(double a, double b);


int jacobi(double *a, int n, double *d, double *v);

double* krylov(double* a, int n);

/* Laguerre method from Numerical Recieps in C */
void laguer(fcomplex a[], int m, fcomplex *x, int *its);
void zroots(fcomplex a[], int m, fcomplex roots[], int polish);

void balanc(double* a, int n);
void elmhes(double* a, int n);
void hqr(double *a, int n, double *wr, double *wi);

#endif
