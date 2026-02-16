#include "stl.h"
#include "MatrixLib.cpp"

int main(int argc, char** argv){
	int n = 2;
	Numeric_lib::Matrix<double,2> M(n,n);

	for(int i=0; i<n; ++i)
		for(int j=0; j<n; ++j){
			M(i,j) = i+j;
		}

	cout << "Integral Equation Solver:" << endl;
	for(int i=0; i<n; ++i){
		for(int j=0; j<n; ++j)
	           printf("%12.4f",M(i,j));
		printf("\n");
	}
	return 0;
}
