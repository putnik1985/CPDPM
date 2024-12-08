#include "numeric_c.h" 
#include <string.h>

int main(int argc, char** argv)
{
	int n = 3;
	double a[9] = {1., 0., 3.,
		       0., 4., 0.,
		       3., 0., 10.};

	double b[3] = {4.,22.,42.};

	double* x;

        double (*(*functions[])(int, double* ,double*))  = {gauss, rotation, hausholder, square_root};
        double (*determinant[])(int, double*)  = {det_gauss, det_rotation, det_hausholder, det_square_root};
        char* messages[] = {"gauss", "rotation", "hausholder", "square_root"};

        int method = 0; /* gauss by default */
	for(int i = 0; i < argc; ++i){
		if (strcmp("-g",argv[i]) == 0) method = 0;
		if (strcmp("-r",argv[i]) == 0) method = 1;
		if (strcmp("-h",argv[i]) == 0) method = 2;
		if (strcmp("-s",argv[i]) == 0) method = 3;
	}
/*
        switch (method){
		case 1:
			func = gauss;
			break;
		case 2:
			func = rotation;
			break;
		case 3: 
			func = hausholder;
			break;
		case 4:
			func = square_root;
			break;
		default:
			func = gauss;
	}
*/
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
