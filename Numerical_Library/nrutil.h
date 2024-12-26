#ifndef NRUTIL_H
#define NRUTIL_H
        #include <stdio.h>
        #include <stdlib.h>
        #define NR_END 1
        #define FREE_ARG char*
 
        double *vector(long nl, long nh);
        void free_vector(double* v, long nl, long nh);
        void nerror(char error_text[]);
#endif
