#include "csv.h"
#include <cstring>

#include "linear_bearing.h"
#include "disk.h"

#include "functions.h"

int main(int argc, char** argv){
    string line;
    string filename;


    for( int i = 0; i < argc; ++i)
     if (strcmp(argv[i], "-f") == 0) filename = argv[i+1]; // need to check if it exists will crash otherwise

    cout << filename << "\n";
    ifstream ifs(filename.c_str());
    if (!ifs){
       cerr << "can not open file: " << filename << "\n";
       return -1;
    }

    Csv csv(ifs);
    while (csv.getline(line) != 0) {
        cout << "line = '" << line << "'\n";
        for (int i = 0; i < csv.getnfield(); i++)
            cout << "field[" << i << "] = "
                 << csv.getfield(i) << "\n";

        if ( csv.getfield(0).compare("_linear_bearing") == 0 ){
             double k = stod(csv.getfield(1)); 
             linear_bearing lbr(k);
             Matrix mat = lbr.K();
             cout << mat;
        }

        if ( csv.getfield(0).compare("_disk") == 0 ){
             double m = stod(csv.getfield(1)); 
             double Jp = stod(csv.getfield(2)); 
             double Jd = stod(csv.getfield(3)); 
             disk d(m, Jp, Jd); 
        }
    }
    return 0;
}
