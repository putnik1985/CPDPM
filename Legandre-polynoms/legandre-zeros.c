#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>

double p(int n, double x);
double dp(int n, double x);

int main(int argc, char** argv){
	int n = 2;
        
	for(int i=0; i<argc; ++i){
		if (strcmp("-n",argv[i]) == 0) n = atoi(argv[i+1]);
	}

	printf("%12s%12s\n","Root", "Weight");
        for(int m=1; m<=n; ++m){
            double teta = (4. * m - 1.) / (4. * n + 2.) * M_PI + 1./(8.*n*n) * 1. / tan(M_PI * (4.*m-1)/(4.*n+2));
	    double x = cos(teta);
            double a = 2./( (1.-x*x)*dp(n,x)*dp(n,x) );

	    printf("%12.6f%12.6f\n", x, a);
        }
	return 0;
}


double p(int n, double x) {

	if (n>1) {
		return (2.*n-1.)/n * x * p(n-1,x) - (n-1.)/n * p(n-2,x);
	} else if ( n == 1) {
		return x;
	} else {
		return 1;
	}
}

double dp(int n, double x){
       return 1./(1.-x*x) * ( -n*x*p(n,x) + n*p(n-1,x) );
}
