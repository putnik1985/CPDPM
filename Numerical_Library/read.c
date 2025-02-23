#include "numeric_c.h"

double* read_matrix(char* filename, int *dimension){
    FILE* f = fopen(filename, "r");
    char *field[MAXM]; // assume maximum size of matrix input 
    double a[MAXM];
    if (f == NULL) return NULL;
    char line[MAXM];
    int n = 0;
    int lines = 0;

    while(fgets(line, MAXM, f)){
          char *p, *q;
          ++lines;
          for(q = line; (p = strtok(q, ",\n\r")) != NULL; q = NULL){
              field[n] = p;
              a[n] = atof(p);
              n++;
          }
    }
    fclose(f);
    printf("\nMatrix Dimension:\n");
    printf("%12d%12d\n", lines, n);
    printf("\n%12s\n", "read: Input Matrix:");
    for(int i=0; i<lines; ++i){
        for(int j=0; j<lines; ++j){
            printf("%12.2f", a[i*lines+j]);
        }
        printf("\n");
    }

    double *output = calloc(n, sizeof(double));
    if (output == NULL) {
                  printf("allocation failure\n");
                  exit(1);
    } 

    for(int i=0; i<lines; ++i){
        for(int j=0; j<lines; ++j){
            output[i*lines+j] = a[i*lines+j];
        }
        printf("\n");
    }

    (*dimension) = lines;
    return output;
}
