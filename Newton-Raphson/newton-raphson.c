#include "newton.h"

int main(int argc, char** argv){
	printf("Newton-Raphson Solver:\n\n");
    
	double x0 = 0.;
        for(int i=0; i<argc; ++i){
            if (strcmp("-x0", argv[i]) == 0) x0 = atof(argv[i+1]);
        }		
	
	struct response output = newton(x0, f, J);
	if (output.ok) {
	    printf("root:%.6f\n", output.x);
	} else {
		printf("root not foiund\n");
	}
	
	return 0;
}
