#include "signal.h"

signal::signal(string filename){
 ifstream is;
 is.open(filename, ios_base::in);

 if (!is) 
    cerr << "can not open file: " << filename << '\n';

 step p;
 while (is >> p) 
  thistory.push_back(p);
 

}

