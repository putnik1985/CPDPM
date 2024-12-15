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

    nvector<double> global_nodes;
    vector<pair<int, double> > unbalances;
    double x0{0.0};
    rotor R;
    nvector<uniform_shaft> shaft_matrices;

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
             double d = stod(csv.getfield(2)); 
             linear_bearing lbr(k,d);
             R.append(lbr);
             ///cout << R.D;
        }

        if ( csv.getfield(0).compare("_disk") == 0 ){
             double m = stod(csv.getfield(1)); 
             double Jp = stod(csv.getfield(2)); 
             double Jd = stod(csv.getfield(3)); 
             double unb = stod(csv.getfield(4)); 
             disk d(m, Jp, Jd);
             R.append(d);
             int node = R.K.size() / 4;
             cout << node << '\n';
             unbalances.push_back(make_pair(node, unb));
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
                 global_nodes.push_back(x0); 
                 uniform_shaft us = uniform_shaft(elem_L, rho, E, Ri, Ro);
                 shaft_matrices.push_back(us);
                 R.append(us);
                 x0 += elem_L;
             }
        }
  
        if (csv.getfield(0).compare("_analysis") == 0 ){
            auto analysis_type = csv.getfield(1);
            if (analysis_type.compare("unbalance") == 0){
                auto max_speed = stod(csv.getfield(3));
                fcomplex imag = {0., 1.};
                double w = max_speed * 2 * M_PI / 60.;
              
                fcomplex* F = -w*w * R.M + imag*w * (R.D + w * R.G) + R.K; 
             /*
                int n = R.K.size();
                for(int i=0; i<n; ++i){
                    for(int j=0; j<n; ++j)
                        printf("(%f,%f);",F[n*i+j].re, F[n*i+j].i);
                    printf("\n");
                }
             */
            }
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
                             v(4 * i - 4 + dof) = speed * 2 * M_PI / 60. * ang_vel;
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
                //cout << "gauss solution:\n";
                //for(int i=0; i < n; ++i)
                //    cout << x[i] << ",";
                //cout << "\n";

                ofstream os;
                os.open("maneuver-displacement.dat",ios_base::out);
                if (!os) {
                         cerr << "can not open file: maneuver-displacement.dat\n";
                         return -1;
                }
                printf("Maneuver %.2f rad/sec at %.2f, rpm\n", ang_vel, speed); 
                printf("\n%12s%12s%12s\n", "X,m", "Y,m", "Z,m"); 
                char outputstr[MAXLINE];
                sprintf(outputstr, "%12s%12s%12s\n", "X,m", "Y,m", "Z,m"); 
                os << outputstr;

                global_nodes.push_back(x0);
                for(int i=1; i <= global_nodes.size(); ++i){
                    printf("%12.4f%12.4f%12.4f\n",global_nodes(i), x[4 * i - 3 - 1], x[4 * i - 2 - 1]);
                    sprintf(outputstr, "%12.4f%12.4f%12.4f\n",global_nodes(i), x[4 * i - 3 - 1], x[4 * i - 2 - 1]);
                    os << outputstr;
                }
                    os.close();
                cout << "\n";
                printf("Bending Moments and Shear Forces:\n"); 
                os.open("maneuver-shear-bending.dat",ios_base::out);
                if (!os) {
                         cerr << "can not open file: maneuver-displacement.dat\n";
                         return -1;
                }
                printf("\n%12s%12s%12s%12s%12s\n","X,m", "Qy,kgs", "Qz,kgs", "My,kgs.m", "Mz,kgs.m");
                sprintf(outputstr, "%12s%12s%12s%12s%12s\n","X,m", "Qy,kgs", "Qz,kgs", "My,kgs.m", "Mz,kgs.m");
                os << outputstr;
                auto elem = shaft_matrices.size();
                nvector<double> load;
                for(int i = 1; i <= elem; ++i){
                    uniform_shaft us = shaft_matrices(i);
                    nvector<double> u(8);
                            for(int dof = 1; dof <= 4; ++dof){
                                u(dof) = x[4 * i - 4 + dof - 1];
                                u(dof + 4) = x[4 * (i+1) - 4 + dof - 1];
                            }

                    load = us.K * u;
                    printf("%12.4f%12.1f%12.1f%12.1f%12.1f\n", global_nodes(i), load(1), load(2), load(3), load(4));
                    sprintf(outputstr,"%12.4f%12.1f%12.1f%12.1f%12.1f\n", global_nodes(i), load(1), load(2), load(3), load(4));
                    os << outputstr;
                    sprintf(outputstr,"%12.4f%12.1f%12.1f%12.1f%12.1f\n", global_nodes(i+1), load(1), load(2), load(3), load(4));
                    os << outputstr;
                }
                    printf("%12.4f%12.1f%12.1f%12.1f%12.1f\n", global_nodes(elem+1), load(5), load(6), load(7), load(8));
                    sprintf(outputstr,"%12.4f%12.1f%12.1f%12.1f%12.1f\n", global_nodes(elem+1), load(5), load(6), load(7), load(8));
                    os << outputstr;
                    os.close();
            }
        }
    } // end of the cycle over the commands
    return 0;
}
