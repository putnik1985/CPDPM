#include "newton.h"

double (*F[N])(double*) = {f1, f2};
double (*dF[N][N])(double*) = { {df11, df12}, {df21, df22}};

int main(int argc, char** argv){
	printf("Newton-Raphson Solver:\n\n");
    
	double *x0 = calloc(N, sizeof(double));
	
        for(int i=0; i<argc; ++i){
            if (strcmp("-x0", argv[i]) == 0) x0[0] = atof(argv[i+1]);
            if (strcmp("-y0", argv[i]) == 0) x0[1] = atof(argv[i+1]);
        }		

        struct responseR2 output = newtonR2(x0, F, dF);
	if (output.ok){
            printf("Roots:\n");
	    printf("%.6f,%.6f\n", output.x[0], output.x[1]);
	    printf("Norm:\n");
	    printf("%12.4E\n",norm(F, output.x));
	}
	else
	    printf("no roots found\n");

        free(x0);	
	return 0;
}
