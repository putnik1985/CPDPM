
#ifndef NEWTON_H
#define NEWTON_H

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

struct response {
	char ok;
	double x;
};


struct responseR2 {
	char ok;
	double x[2];
};

double f(double x);
double J(double x);
struct response newton(double x0, double (*f)(double), double (*J)(double));

/* Dimension of the problem */
#define N 2
double f1(double*);
double f2(double*);
#endif
