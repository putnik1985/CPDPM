#include "csv.h"
#include <cstring>

#include "linear_bearing.h"
#include "disk.h"
#include "uniform_shaft.h"
#include "rotor.h"

extern "C"{
#include "../Numerical_Library/numeric_c.h"
}

int main(int argc, char** argv){
    string line;
    string filename;


    for( int i = 0; i < argc; ++i)
     if (strcmp(argv[i], "-f") == 0) filename = argv[i+1]; // need to check if it exists will crash otherwise

    ifstream ifs(filename.c_str());
    if (!ifs){
       cerr << "can not open file: " << filename << "\n";
       return -1;
    }

    rotor R;
    Csv csv(ifs);
    while (csv.getline(line) != 0) {
/*
*        cout << "line = '" << line << "'\n";
*        for (int i = 0; i < csv.getnfield(); i++)
*            cout << "field[" << i << "] = "
*                 << csv.getfield(i) << "\n";
*/
        if ( csv.getfield(0).compare("_linear_bearing") == 0 ){
             double k = stod(csv.getfield(1)); 
             linear_bearing lbr(k);
             R.append(lbr);
        }

        if ( csv.getfield(0).compare("_disk") == 0 ){
             double m = stod(csv.getfield(1)); 
             double Jp = stod(csv.getfield(2)); 
             double Jd = stod(csv.getfield(3)); 
             disk d(m, Jp, Jd);
             R.append(d);
        }

        if ( csv.getfield(0).compare("_uniform_shaft") == 0 ){
             auto L = stod(csv.getfield(1)); 
             auto rho = stod(csv.getfield(2));
             auto E = stod(csv.getfield(3)); 
             auto Ri = stod(csv.getfield(4)); 
             auto Ro = stod(csv.getfield(5)); 
             auto  n = stod(csv.getfield(6)); // number of the elements

             double elem_L = L / n;
             for(int i = 0; i < n; ++i){
                 uniform_shaft us = uniform_shaft(elem_L, rho, E, Ri, Ro);
                 R.append(us);
             }
        }
    } // end of the cycle over the commands

    // lets start to solve the equations 
	cout << R.K;

	int n = 3;
	double a[3][3] = {{2.,-1.,-1.},
		          {3.,4.,-2.},
			  {3.,-2.,4.}};

	double b[3] = {4.,11.,11.};

	double* x;
	x = gauss(n,a,b);

    return 0;
}
