
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


double f(double x);
double J(double x);
struct response newton(double x0, double (*f)(double), double (*J)(double));

#endif
