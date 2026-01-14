
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
	double* x;
};

double f(double x);
double J(double x);
struct response newton(double x0, double (*f)(double), double (*J)(double));

/* Dimension of the problem */
#define N 2
double norm(double (*F[N])(double*), double*);
double f1(double*);
double f2(double*);

double df11(double*);
double df12(double*);
double df21(double*);
double df22(double*);
struct responseR2 newtonR2(double* x0, double (*F[N])(double*), double (*dF[N][N])(double*));
#endif
