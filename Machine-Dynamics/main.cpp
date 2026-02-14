#include "csv.h"
#include <cstring>

#include "component.h"
#include "lumped_mass.h"
#include "analysis.h"
#include "analysis.cpp"
#include "machine.h"
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

    double global_mass = 0.;
    nvector<double> global_nodes;
    double x0{0.0};
    machine machine2;

    Csv csv(ifs);
    while (csv.getline(line) != 0) {
/*****************************************************
        cout << "line = '" << line << "'\n";
        for (int i = 0; i < csv.getnfield(); i++)
            cout << "field[" << i << "] = "
                 << csv.getfield(i) << "\n";
*****************************************************/

        if ( csv.getfield(0).compare("_component") == 0 ){
             double k = stod(csv.getfield(1)); 
             double c = stod(csv.getfield(2)); 
             component comp(k,c);
             machine2.append(comp);
        }

        if ( csv.getfield(0).compare("_mass") == 0 ){
             double m = stod(csv.getfield(1)); 
             lumped_mass lmass(m);
             machine2.append(lmass);
             global_nodes.push_back(x0+=1.);
        }
        if (csv.getfield(0).compare("_analysis") == 0 ){

            auto analysis_type = csv.getfield(1);
			
            if (analysis_type.compare("natural_modes") == 0){
                machine2.K(1,1) += 0.00000001;
                natural_modes(machine2.M, machine2.K, global_nodes);
                cout << "Natural Modes Analysis Completed\n";
            }

        }

            if (analysis_type.compare("fra") == 0){
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
                       ///printf("%12s","Frequency,Hz");
                       sprintf(outputstr,"%12s","Frequency,Hz");
                       os << outputstr;
                       for(int i = 1; i <= n / 4; ++i){
                           char outputy[MAXLINE];
                           char outputz[MAXLINE];
                           sprintf(outputy,"point#%d-y",i);
                           sprintf(outputz,"point#%d-z",i);
                           ////printf("%12s%12s", outputy, outputz);
                           sprintf(outputstr, "%12s%12s", outputy, outputz);
                           os << outputstr;
                       }
                       ////printf("\n");
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
                       ////printf("%12.2f",freq);
                       sprintf(outputstr,"%12.2f",freq);
                       os << outputstr;
                       for(int i = 1; i <= n / 4; ++i){
                           ///printf("%12.4f%12.4f",cabs(x[4 * i - 3 - 1]), cabs(x[4 * i - 2 - 1]));
                           sprintf(outputstr, "%12.4f%12.4f",cabs(x[4 * i - 3 - 1]), cabs(x[4 * i - 2 - 1]));
                           os << outputstr;
                       }
                       ///printf("\n");
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
                cout << "Unbalance Response Analysis Completed\n";
            }
		
    } // end of the cycle over the commands
    ///////////////////cout << machine2.K << machine2.M;
    return 0;
}
