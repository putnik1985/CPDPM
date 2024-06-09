#ifndef SIGNAL_H
#define SIGNAL_H

#include <vector>
#include <iostream>
#include <fstream>
#include <sstream>
#include <iomanip>
#include <string>
#include <utility>

using namespace std;

class signal {
 public:
 signal(string filename);
 friend ostream& operator<<(ostream&, const signal&);

 private:
 vector< pair<double, double> > thistory;
};

inline istream& operator>>(istream& is, pair<double, double>& p){
 double time, speed, value;
 char c;

 is >> time >> speed >> value;
 p.first = time;
 p.second = value;
 ///cout << time << "  " << speed << " " << value << endl;
 ///is.setstate(ios_base::failbit);
 return is;
} 

inline ostream& operator<<(ostream& os, const signal& s){
 auto v = s.thistory;
 for(int i = 0; i < v.size(); ++i){
  auto p = v[i];
  os << p.first << "," << p.second << '\n';
 }
 return os;
}

#endif
