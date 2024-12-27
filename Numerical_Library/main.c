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
        printf("%f + i%f\n", z3.re, z3.i);
        z3 = cmult(z1, z2);
        printf("%f + i%f\n", z3.re, z3.i);
        z3 = cdiv(z1, z2);
        printf("%f + i%f\n", z3.re, z3.i);
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
		printf("%g +i %g,", x1[i].re, x1[i].i);
	return 0;
}
