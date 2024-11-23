#include "csv.h"
#include <cstring>

#include "linear_bearing.h"
#include "disk.h"
#include "uniform_shaft.h"
#include "rotor.h"
#include "nvector.h"
#include "nvector.cpp"

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
  
        if (csv.getfield(0).compare("_analysis") == 0 ){
            auto analysis_type = csv.getfield(1);
            if (analysis_type.compare("maneuver") == 0){
                auto speed = stod(csv.getfield(3));
                auto ang_vel = stod(csv.getfield(5));
                auto dofs = csv.getfield(7);
                //cout << speed << "," << ang_vel << "," << dofs << "\n"; 
                nvector<double> v(R.G.size());
                auto nodes = v.size() / 4;
                //cout << nodes << "\n";
                   for(int i = 0; i < dofs.size(); ++i){
                        auto dof = dofs.c_str()[i] - '0';
                        for( int i = 1; i <= nodes; ++i)
                             v(4 * i - 4 + dof) = ang_vel;
                   }

                //cout << "force:\n";
                nvector<double> force = R.G * v;
                //for(int i = 1; i <= force.size(); ++i)
                //    cout << force(i) << '\n';
                auto n = force.size();
                double a[n * n];
                double b[n];
                for(int i = 0; i < n; ++i){
                    for(int j = 0; j < n; ++j)
                        a[n*i + j] = R.K(i+1,j+1);
                    b[i] = force(i+1);
                }
	        double* x;
	        x = gauss(n,a,b);
                cout << "gauss solution:\n";
                for(int i=0; i < n; ++i)
                    cout << x[i] << ",";
                cout << "\n";
            }
        }
    } // end of the cycle over the commands
    return 0;
}
