#include <stdio.h>
#include <string.h>
#include <math.h>
#include <stdlib.h>

int main(int argc, char** argv){
	int n = 2;
        
	for(int i=0; i<argc; ++i){
		if (strcmp("-n",argv[i]) == 0) n = atoi(argv[i+1]);
	}

        for(int m=1; m<=n; ++m){
            double teta = (4. * m - 1.) / ( 4. * n + 2.) * M_PI + 1./(8.*n*n) * 1. / tan(M_PI * (4.*m-1)/(4.*n+2));
	    double x = cos(teta);

	    printf("x(%d) = %.6f\n", m, x);
        }
	return 0;
}
