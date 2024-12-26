#include "nrutil.h"

double *vector(long nl, long nh){
        double *v;
        v = (double *)malloc((size_t)((nh-nl+1+NR_END)*sizeof(double)));
        if (!v) nerror("allocation failure in vector()");
        return v - nl + NR_END;
}

void free_vector(double* v, long nl, long nh){
     free((FREE_ARG) (v+nl-NR_END));
}

void nerror(char error_text[]){
     fprintf(stderr, "Numerical Recieps run-time error...\n");
     fprintf(stderr, "%s\n", error_text);
     exit(1);
}
