#include "newton.h"

double (*F[N])(double*) = {f1, f2};

int main(int argc, char** argv){
	printf("Newton-Raphson Solver:\n\n");
    
	double *x0 = calloc(N, sizeof(double));
	
        for(int i=0; i<argc; ++i){
            if (strcmp("-x0", argv[i]) == 0) x0[0] = atof(argv[i+1]);
            if (strcmp("-y0", argv[i]) == 0) x0[1] = atof(argv[i+1]);
        }		
        double x = F[0](x0);	
        double y = F[1](x0);	
	printf("%.6f,%.6f\n", x, y);
        free(x0);	
	return 0;
}
