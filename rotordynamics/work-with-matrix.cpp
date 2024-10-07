#include "Matrix_library.h"

#include <iostream>
using namespace std;


int main(int argc, char** argv){

    Numeric_lib::Matrix<double, 2> m(2,2);
    for(int i = 0; i < m.dim1(); ++i){
		for(int j = 0; j< m.dim2(); ++j)
			 cout << m(i,j) << ",";
		 cout << '\n';
    }	 
    
    return 0;
}
