#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>


double f(double, double);
double g(double, double);
double df(double, double, double, double(*f)(double, double));

int main(int argc, char** argv){
	double x0, y0, dt, t0;
	int n;
    FILE* file;
    char input[256];
	
	x0 = 0.5;
	y0 = 0.0;
    
	n = 1000000; // default value
	for(int i=1; i<argc; ++i){
		if (strcmp("-n",argv[i]) == 0) n = atoi(argv[i+1]);
		if (strcmp("-x0",argv[i]) == 0) x0 = atof(argv[i+1]);
	}
        t0 = 0.;
        dt = 0.0001;
	    sprintf(input,"torsvib-%f.dat",x0);
        file = fopen(input,"w");

	fprintf(file, "%12.8f%12.8f%12.8f\n", t0, x0, y0);
	for(int i=1; i<=n && x0>=0.24 && y0>=0.; ++i){
		t0 = i * dt;
		double x1 = x0 + df(dt, x0, y0, f);
		double y1 = y0 + df(dt, x0, y0, g);
		x0 = x1;
		y0 = y1;
		    if (x0>=0 && y0>=0) fprintf(file, "%12.8f%12.8f%12.8f\n", t0, x0, y0);
	}
	fclose(file);
return 0;
}

double df(double dt, double x0, double y0, double (*f)(double, double)){
	double k1 = f(x0, y0);
	double k2 = f(x0 + k1 * dt/2., y0 + k1 * dt/2.);
	double k3 = f(x0 + k2 * dt/2., y0 + k2 * dt/2.);
	double k4 = f(x0 + k3 * dt, y0 + k3 * dt);
	return dt/6. * (k1 + 2.*k2 + 2.*k3 + k4);
}

double f(double x, double y){
	double lambda = 0.2;
	double mu = 0.001;
	return 1./(2.*x) * (x - x*x - lambda * (x*x  + mu) / (x*x - y));
}

double g(double x, double y){
	double lambda = 0.2;
	double mu = 0.001;
	return -y - lambda + lambda * (x*x + mu) / (x*x - y);
}
