#include "numeric_c.h" 
#include <string.h>

int main(int argc, char** argv)
{
	int n = 5;
	double a[25] = {0.71235, 0.33973, 0.28615, 0.30388, 0.29401,
                       0.33973, 1.18585, -0.21846, -0.06685, -0.37360,
                       0.28615, -0.21846, 0.18159, 0.27955, 0.38898,
                       0.30388, -0.06685, 0.27955, 0.23195, 0.20496,
                       0.29401, -0.37360, 0.38898, 0.20496, 0.46004};
/*************
	double a[25] = {1., 0., 0., 0., 0.,
                         0., 2., 0., 0., 0.,
                         0., 0., -1., 0., 0.,
                         0., 0.,  0., 3., 0.,
                         0., 0.,  0., 0.,-0.9};    
*******************/
	double b[5] = {4.,22.,42., 0., 0.};

	double* x;

        double (*(*functions[])(int, double* ,double*))  = {gauss, rotation, hausholder, square_root};
        double (*(*eigs[])(double*, int, double*, double*))  = {jacobi};
        double (*determinant[])(int, double*)  = {det_gauss, det_rotation, det_hausholder, det_square_root};
        char* messages[] = {"gauss", "rotation", "hausholder", "square_root"};

        int method = 0; /* gauss by default */
	for(int i = 0; i < argc; ++i){
		if (strcmp("-g",argv[i]) == 0) method = 0;
		if (strcmp("-r",argv[i]) == 0) method = 1;
		if (strcmp("-h",argv[i]) == 0) method = 2;
		if (strcmp("-s",argv[i]) == 0) method = 3;
		if (strcmp("-j",argv[i]) == 0) method = 4;
		if (strcmp("-krylov",argv[i]) == 0) method = 5;
		if (strcmp("-laguer",argv[i]) == 0) method = 6;
		if (strcmp("-hessenberg",argv[i]) == 0) method = 7;
	}
        if (method == 7) {
            double a[16] = { -5.509882, 1.870086, 0.422908, 0.008814,
                              0.287865,-11.811654, 5.71190, 0.058717,
                             0.049099, 4.308033, -12.970687, 0.229326,
                             0.006235, 0.269851, 1.397369, -17.596207};
            double b[16] = { 1., 0., 0. ,0.,
                             0., 1., 0., 0.,
                             0., 0., 2., 0.,
                             0., 0., 0., 2.};
            int n = 4;
        printf("\ninit matrix:\n");
        for(int i = 0; i<n; ++i){
            for(int j = 0; j < n; ++j)
                printf("%f,", a[i*n+j]);
            printf("\n");
        }
        double H[16];
        double Z[16];
        int err = hessenberg(a, H, Z, n);
        if (err < 0) {
                   printf("can not complete Hessenberg\n");
                   exit(1);
        }

        printf("\n\nhessenberg matrix:\n");
        for(int i = 0; i<n; ++i){
            for(int j = 0; j < n; ++j)
                printf("%f,", H[i*n+j]);
            printf("\n");
        }
            for(int i = 0; i<n; ++i)
                for(int j=0; j<n; ++j)
                    H[i*n+j] = -H[i*n+j];

            double* p = krylov(H, n);
            if (p == NULL) {
                           printf("no solution\n");
                           return -1;
            }
            printf("\nkrylov solution:\n");
            for(int i = 0; i<n; ++i)
                printf("p[%d] = %f,", i+1, p[i]);
            printf("\n");

        double wr[MAXM];
        double wi[MAXM];    
        printf("\nEigenvalues:\n");
        for(int i = 0; i < n; ++i)
           printf("(%f, %f)\n", wr[i], wi[i]);
        }
        if (method == 6) {
           int deg = 2;
           fcomplex a[MAXM] = {{3., 0.}, {-4., 0.}, {1., 0.}}; 
           fcomplex roots[MAXM] = {{0., 0.}, {0., 0.}, {0., 0.}};
           printf("equation:\n");
           for(int i=0; i<deg; ++i)
               printf("(%f+%fi)x^(%d)+",a[i].r, a[i].i, i);
           printf("(%f+%fi)x^(%d)=0\n",a[deg].r, a[deg].i, deg);

           zroots(a, deg, roots, 1);
           printf("laguer solution:\n");
           for(int i=1; i<=deg; ++i){
               fcomplex x = roots[i];
               printf("x = (%.4f,%.4f)\n", x.r, x.i);  
           }

        }
        if (method == 5) {
            double a[16] = { -5.509882, 1.870086, 0.422908, 0.008814,
                              0.287865,-11.811654, 5.71190, 0.058717,
                             0.049099, 4.308033, -12.970687, 0.229326,
                             0.006235, 0.269851, 1.397369, -17.596207};

            double* matrix = read_matrix("input-matrix.dat", &n);

            if (!matrix) {
                printf("can not read matrix\n");
                exit(1);
            }
            printf("Krylov Input matrix(with TOLERANCE):\n");
            for(int i=0; i<n; ++i){
                for(int j=0; j<n; ++j){
                    matrix[i*n+j] += TOLERANCE;
                    printf("%12.2f",matrix[i*n+j]);
                }
                printf("\n");
            }

            double* p = krylov(matrix, n);
            if (p == NULL) {
                           printf("Krylov: no solution\n");
                           return -1;
            }
            printf("\nKrylov Solution:\n");
            fcomplex eq[MAXM];
            for(int i = 0; i<n; ++i){
                printf("p[%d] = %f,", i+1, p[i]);
                eq[n-1-i] = complex(-p[i], 0.);
            }
            eq[n] = complex(1.0, 0.0);
            printf("\n");

            int deg = n;
            printf("\nEquation:\n");
/**********************
            for(int i=0; i<deg; ++i){
                char str[MAXM];
                sprintf(str, "%%d\d", 29+i);
                 printf("%s", str);
            }
            printf("\n");
**********************************/

            for(int i=0; i<deg; ++i)
               printf("(%f,%f)x^(%d)+",eq[i].r, eq[i].i, i);
            printf("(%f,%f)x^(%d)=0\n",eq[deg].r, eq[deg].i, deg);
            printf("\nEigenvalues:\n");
            fcomplex roots[MAXM];
            zroots(eq, deg, roots, 1);
            for(int i=1; i<=deg; ++i){
               fcomplex x = roots[i];
               printf("x = (%.4f,%.4f)\n", x.r, x.i);  
            }
            printf("\n");
        }
        if (method == 4) {
            double d[n];
            double v[n * n];
            int iter; 
            iter = (*eigs[0])(a, n, d, v);
            printf("\n                                         Jacobi Rotations Solution\n");
            printf("\nJacobi rotations: %d\n", iter);

            printf("\nEigenvalues:\n");
            for(int i=0; i<n; ++i)
                printf("%12.6f\n",d[i]);

            printf("\nEigenvectors:\n");
            for(int i = 0; i < n; ++i){
                for(int j = 0; j < n ; ++j)
                    printf("%12.6f", v[i*n+j]);
                printf("\n");
            }
            return 0;
        }
	x = (*functions[method])(n,a,b);
	if ( x == NULL) 
		return -1;
	printf("%s solution:\n", messages[method]);
	for(int i = 0; i<n; ++i)
		printf("%g,", x[i]);

        //double det = det_gauss(n, a);
        //double det = det_hausholder(n, a);
        //double det = det_rotation(n, a);
        //double det = det_square_root(n, a);
        double det = (*determinant[method])(n, a);
	printf("%s determinant: %12.2f\n",messages[method], det);
	printf("\n");
        fcomplex z1 = {1., 2.};
        fcomplex z2 = {1., 1.};
        fcomplex z3 = csum(z1, z2);
        printf("%f + i%f\n", z3.r, z3.i);
        z3 = cmult(z1, z2);
        printf("%f + i%f\n", z3.r, z3.i);
        z3 = cdiv(z1, z2);
        printf("%f + i%f\n", z3.r, z3.i);
        printf("%f\n", cabs(z1));
        printf("%f\n", cabs(z2));
	fcomplex a1[9] = {{1.,0.}, {0., 0.}, {3., 0.},
		          {0.,0.}, {4., 0.}, {0., 0.},
		          {3., 0.},{0., 0.}, {10., 0.}};

	fcomplex b1[3] = {{4., 0.}, {22., 0.}, {42.,0.}};
        fcomplex *x1 = cgauss(n, a1, b1);
	if ( x1 == NULL) 
		return -1;
	printf("%s complex solution:\n", messages[method]);
	for(int i = 0; i<n; ++i)
		printf("%g +i %g,", x1[i].r, x1[i].i);
	return 0;
}
