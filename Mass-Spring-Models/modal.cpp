#include "csv.h"
#include <cstring>

/****************************************
extern "C"{
#include "../Numerical_Library/numeric_c.h"
}
****************************************/

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

    Csv csv(ifs);
    while (csv.getline(line) != 0) {
        cout << "line = '" << line << "'\n";
        for (int i = 0; i < csv.getnfield(); i++)
            cout << "field[" << i << "] = "
                 << csv.getfield(i) << "\n";
        }

return 0;
}
