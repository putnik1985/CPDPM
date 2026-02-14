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

            if (analysis_type.compare("fra") == 0){
                auto max_freq = stod(csv.getfield(3));
                auto x0 = stod(csv.getfield(5));
                fcomplex imag = {0., 1.};
                double w_max = max_freq * 2 * M_PI;
                int n = machine2.K.size();

                Matrix<double> Eu(n);
                Matrix<double> Ef(n);
                for(int i=1; i<=n; ++i){ 
                    Eu(i,i) = 1.;
                    for(int j=1; j<=n; ++j){
                        Ef(i,j) = 0.;
                    }
                }
                Eu(1,1) = 0.; // dof of excitation
                Ef(1,1) = 1.; // dof of excitation
                
                //cout << Eu << Ef;
                //return -1;
                double w = 0.0;
                double dw = w_max / 100.;

                       char outputstr[MAXLINE];
                       ofstream os;
                       os.open("fra-transmissibility.dat",ios_base::out);
                       if (!os) {
                                cerr << "can not open fra-transmissibility.dat\n";
                                return -1;
                       }
                       sprintf(outputstr,"%12s","Frequency,Hz");
                       os << outputstr;
                       for(int i = 2; i <= n; ++i){
                           char output[MAXLINE];
                           sprintf(output,"point#%d",i);
                           sprintf(outputstr, "%12s", output);
                           os << outputstr;
                       }
                       sprintf(outputstr, "\n");
                       os << outputstr;

                while (w < w_max){
                       fcomplex* A = (-w * w * machine2.M + imag * w * machine2.D + machine2.K) * Eu - Ef; 
                       nvector<double> X0(n);
                       for(int i=1; i<=n; ++i)
                           X0(i) = 0.;

                       X0(1) = x0; //dof of excitation
                       fcomplex* b = ( w * w * machine2.M + imag * (-w) * machine2.D + (-1.) *  machine2.K) * X0;
                       fcomplex* x = cgauss(n, A, b);
                       double freq = w / (2 * M_PI);
                       sprintf(outputstr,"%12.2f",freq);
                       os << outputstr;
                       for(int i = 2; i <= n; ++i){
                           sprintf(outputstr, "%12.4f",cabs(x[i-1])/x0);
                           os << outputstr;
                       }
                       sprintf(outputstr, "\n");
                       os << outputstr;
                       w += dw;
                }
                os.close();

                os.open("gnuplot-fra-transmissibility.dat",ios_base::out);
                os << "set title \"Machine System \\n FRA(Transmissibility)\"" << endl;
                os << "set logscale" << endl;
                os << "set grid" << endl;
                os << "set xlabel \"Frequency, Hz\""<< endl;
                os << "set ylabel \"Q\" " << endl;
                sprintf(outputstr,"plot 'fra-transmissibility.dat' using 1:2 title columnhead with lines,\\\n");
                os << outputstr;
                for(int i = 3; i < n; ++i){
                    sprintf(outputstr,"     'fra-transmissibility.dat' using 1:%d title columnhead with lines,\\\n", i);
                    os << outputstr;
                }
                    sprintf(outputstr,"     'fra-transmissibility.dat' using 1:%d title columnhead with lines\n", n);
                    os << outputstr;
                os.close();

                system("gnuplot -persist -e \"call 'gnuplot-fra-transmissibility.dat'\"");
                cout << "Frequency Response Analysis Completed\n";
            }
        }

		
    } // end of the cycle over the commands
    ///////////////////cout << machine2.K << machine2.M;
    return 0;
}
