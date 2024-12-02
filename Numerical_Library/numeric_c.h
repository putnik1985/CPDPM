#ifndef NUMERIC_C_H
#define NUMERIC_C_H

#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <errno.h>
#include <math.h>
struct complex_number {
       double x;
       double y;
};

/* gauss: solve linear system of n equations Ax=b */
double* gauss(int n, double* A, double* b);
/* det_gauss: calculate matrix A determinant and transform to triangular form */
double  det_gauss(int n, double* A);

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

struct complex_number csum(struct complex_number a, struct complex_number b);
struct complex_number cmult(struct complex_number a, struct complex_number b);
struct complex_number cdiv(struct complex_number a, struct complex_number b);

#endif
