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
using step = pair<double, double>;

class signal {
 public:
 signal(string filename);
 friend ostream& operator<<(ostream&, const signal&);

 private:
 vector<step> thistory;
};

inline istream& operator>>(istream& is, step& p){
 double time, speed, value;
 char c;
 is >> time >> c >> speed >> c >> value >> c;
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
