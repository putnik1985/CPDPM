#include "csv.h"
#include <cstring>

#include "linear_bearing.h"
#include "disk.h"
#include "uniform_shaft.h"
#include "rotor.h"
#include "nvector.h"
#include "nvector.cpp"
#include "analysis.h"
#include "analysis.cpp"


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
    double global_mass = 0.;
    nvector<double> global_nodes;
    vector<pair<int, complex<double> > > unbalances;
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
             //////cout << R.D;
        }

        if ( csv.getfield(0).compare("_disk") == 0 ){
             double m = stod(csv.getfield(1)); 
             double Jp = stod(csv.getfield(2)); 
             double Jd = stod(csv.getfield(3)); 
             double unb = stod(csv.getfield(4)); 
             double phase = stod(csv.getfield(5)); 
             phase *= M_PI / 180.;
             disk d(m, Jp, Jd);
             R.append(d);
             int node = R.K.size() / 4;
             //cout << node << '\n';
             complex<double> imbalance(unb * cos(phase), unb * sin(phase));
             //cout << imbalance << '\n';
             unbalances.push_back(make_pair(node, imbalance));
             global_mass += m;
        }

        if ( csv.getfield(0).compare("_uniform_shaft") == 0 ){
             auto L = stod(csv.getfield(1)); 
             auto rho = stod(csv.getfield(2));
             auto E = stod(csv.getfield(3)); 
             auto Ri = stod(csv.getfield(4)); 
             auto Ro = stod(csv.getfield(5)); 
             auto  n = stod(csv.getfield(6)); // number of the elements
             global_mass += M_PI * (Ro * Ro - Ri * Ri) * L * rho;

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
            if (analysis_type.compare("natural_modes") == 0){
                natural_modes(R.M, R.K, global_nodes);
            }
            if (analysis_type.compare("unbalance") == 0){
                auto max_speed = stod(csv.getfield(3));
                fcomplex imag = {0., 1.};
                double w_max = max_speed * 2 * M_PI / 60.;
                int n = R.K.size();
                fcomplex unb[n];
                    for(int i = 0; i < n; ++i)
                        unb[i] = {0., 0.};

                for(auto& imb : unbalances){
                    /////cout << imb.first << " " << imb.second << '\n';
                    int node = imb.first;
                    complex<double> val = imb.second;
                    unb[4 * node - 3 - 1] = {val.real(), val.imag()};
                    unb[4 * node - 2 - 1] = {val.imag(),-val.real()};
                }
                /******************************
                    for(int i = 0; i < n; ++i)
                     cout << unb[i].re << " " << unb[i].i << '\n';
                *****************************/

                nvector<double> v(n);
                nvector<double> u(n);
                for(int i = 1; i <= n/4; ++i){
                    v(4*i-3) = 1.;
                    u(4*i-2) = 1.;
                }

                //////  cout << "global mass: " << global_mass << endl;
                double mass_y = 0.;
                  for(int i = 1; i <=n; ++i)
                      for(int j = 1; j <= n; ++j)
                          mass_y += v(i) * R.M(i,j) * v(j);
                //////  cout << "mass y: " << mass_y << endl;
                double mass_z = 0.;
                  for(int i = 1; i <=n; ++i)
                      for(int j = 1; j <= n; ++j)
                          mass_z += u(i) * R.M(i,j) * u(j);
                  ////cout << "mass z: " << mass_z << endl;
                //return -1;
                double w = 0.0;
                double dw = w_max / 100.;
             /***************************************
                cout << R.D;
                return -1;
             ***************************************/
                       char outputstr[MAXLINE];
                       ofstream os;
                       os.open("unbalance-displacement.dat",ios_base::out);
                       if (!os) {
                                cerr << "can not open unbalance-displacement.dat\n";
                                return -1;
                       }
                       printf("%12s","Frequency,Hz");
                       sprintf(outputstr,"%12s","Frequency,Hz");
                       os << outputstr;
                       for(int i = 1; i <= n / 4; ++i){
                           char outputy[MAXLINE];
                           char outputz[MAXLINE];
                           sprintf(outputy,"point#%d-y",i);
                           sprintf(outputz,"point#%d-z",i);
                           printf("%12s%12s", outputy, outputz);
                           sprintf(outputstr, "%12s%12s", outputy, outputz);
                           os << outputstr;
                       }
                       printf("\n");
                       sprintf(outputstr, "\n");
                       os << outputstr;

                while (w < w_max){
                       fcomplex* F = -w * w * R.M + imag * w * (R.D + w * R.G) + R.K; 
                       fcomplex b[n];
                                 for(int i =0; i < n; ++i)
                                     b[i] = {w * w * unb[i].re, w * w * unb[i].i};
                          /***************
                                 for(int i = 0; i < n; ++i)
                                     printf("(%g,%g)\n", b[i].re, b[i].i);
                          ***************/
                       fcomplex* x = cgauss(n, F,b);
                       double freq = w / (2 * M_PI);
                       printf("%12.2f",freq);
                       sprintf(outputstr,"%12.2f",freq);
                       os << outputstr;
                       for(int i = 1; i <= n / 4; ++i){
                           printf("%12.4f%12.4f",cabs(x[4 * i - 3 - 1]), cabs(x[4 * i - 2 - 1]));
                           sprintf(outputstr, "%12.4f%12.4f",cabs(x[4 * i - 3 - 1]), cabs(x[4 * i - 2 - 1]));
                           os << outputstr;
                       }
                       printf("\n");
                       sprintf(outputstr, "\n");
                       os << outputstr;
                       w += dw;
                }
                os.close();

                os.open("gnuplot-unbalance-displacement.dat",ios_base::out);
                os << "set title \"Rotor System \\n Unbalance response\"" << endl;
                os << "set xlabel \"Frequency, Hz\""<< endl;
                os << "set ylabel \"Deflections\" " << endl;
                sprintf(outputstr,"plot 'unbalance-displacement.dat' using 1:2 title columnhead with lines,\\\n");
                os << outputstr;
                sprintf(outputstr,"     'unbalance-displacement.dat' using 1:3 title columnhead with lines,\\\n");
                os << outputstr;

                for(int i = 2; i < n/4; ++i){
                    sprintf(outputstr,"     'unbalance-displacement.dat' using 1:%d title columnhead with lines,\\\n", 2*i);
                    os << outputstr;
                    sprintf(outputstr,"     'unbalance-displacement.dat' using 1:%d title columnhead with lines,\\\n", 2*i+1);
                    os << outputstr;
                }
                    sprintf(outputstr,"     'unbalance-displacement.dat' using 1:%d title columnhead with lines,\\\n", 2*(n/4));
                    os << outputstr;
                    sprintf(outputstr,"     'unbalance-displacement.dat' using 1:%d title columnhead with lines\n", 2*(n/4)+1);
                    os << outputstr;
                os.close();
                system("gnuplot -persist -e \"call 'gnuplot-unbalance-displacement.dat'\"");
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
                os.open("gnuplot-maneuver-displacement.dat",ios_base::out);
                if (!os) {
                         cerr << "can not open gnuplot-maneuver-displacement.dat\n";
                         return -1;
                }
                os << "set title \"Rotor System \\n Rotor Deflections under Maneuver\"" << endl;
                os << "set xlabel \"X\""<< endl;
                os << "set ylabel \"Deflections\" " << endl;
                sprintf(outputstr,"plot 'maneuver-displacement.dat' using 1:2 title columnhead with lines,\\\n");
                os << outputstr;
                sprintf(outputstr,"     'maneuver-displacement.dat' using 1:3 title columnhead with lines,\\\n");
                os << outputstr;
                os.close();
                system("gnuplot -persist -e \"call 'gnuplot-maneuver-displacement.dat'\""); 
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
