#include "signal.h"

int main(int argc, char** argv){
 string filename = argv[1];
 cout << "file: " << filename << endl;
 signal s(filename);
 cout << s;  
 return 0;
}
