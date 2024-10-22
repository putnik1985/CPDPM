#ifndef NUMERIC_C_H
#define NUMERIC_C_H

#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <errno.h>
#include <math.h>

/* gauss: solve linear system of n equations Ax=b */
double* gauss(int n, double* A, double* b);

/* rotation: solve linear system of n equations Ax=b applying rotation from the left side*/
double* rotation(int n, double* A, double* b);

/* hausholder: solve linear system of n equations Ax=b using reflection matrix*/
double* hausholder(int n, double* A, double* b);

/* square_root: solve linear system of n equations Ax=b using symmetry of the matrix A*/
double* square_root(int n, double* A, double* b);

#endif
