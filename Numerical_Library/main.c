#include "numeric_c.h" 

int main()
{
	int n = 3;
	double a[3][3] = {{2.,-1.,-1.},
		          {3.,4.,-2.},
			  {3.,-2.,4.}};

	double b[3] = {4.,11.,11.};

	double* x;
	x = gauss(n,a,b);

	if ( x == NULL) 
		return -1;
	printf("gauss:\n");
	for(int i = 0; i<n; ++i)
		printf("%g,", x[i]);
	printf("\n");

	x = rotation(n,a,b);
	if ( x == NULL) 
		return -1;
	printf("rotations:\n");
	for(int i = 0; i<n; ++i)
		printf("%g,", x[i]);
	printf("\n");
	return 0;
}
