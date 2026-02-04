#include "csv.h"
#include <cstring>

#include "component.h"
#include "lumped_mass.h"
#include "analysis.h"
#include "analysis.cpp"
#include "machine.h"

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
/*
*        cout << "line = '" << line << "'\n";
*        for (int i = 0; i < csv.getnfield(); i++)
*            cout << "field[" << i << "] = "
*                 << csv.getfield(i) << "\n";
*/
        if ( csv.getfield(0).compare("_component") == 0 ){
             double k = stod(csv.getfield(1)); 
             double c = stod(csv.getfield(2)); 
             component comp(k,c);
             machine2.append(comp);
             //////cout << machine2.D;
        }

        if ( csv.getfield(0).compare("_mass") == 0 ){
             double m = stod(csv.getfield(1)); 
             lumped_mass lmass(m);
             machine2.append(lmass);
        }

        if (csv.getfield(0).compare("_analysis") == 0 ){

            auto analysis_type = csv.getfield(1);
            if (analysis_type.compare("natural_modes") == 0){
                natural_modes(machine2.M, machine2.K, global_nodes);
                cout << "Natural Modes Analysis Completed\n";
            }

        }
    } // end of the cycle over the commands
    return 0;
}
