#ifndef SIGNAL_H
#define SIGNAL_H

#include <vector>
#include <iostream>
#include <fstream>
#include <sstream>
#include <iomanip>
#include <string>
#include <utility>
#include <complex>

#include <math.h>

#include <gsl/gsl_fft_complex.h>
#define REAL(z,i) ((z)[2*(i)])
#define IMAG(z,i) ((z)[2*(i)+1])

using namespace std;
using step = pair<double, double>;
using Complex = complex<double>;

class signal {
 public:
 signal(string filename);
 int fft();
 friend ostream& operator<<(ostream&, const signal&);

 private:
 vector<step> thistory;
 long int N;
 double fs;
 double df;
 double T;

 double w(long int n) {
   return pow(sin(M_PI * n / N), 2);
 }
 vector<Complex> fft_transform(const vector<Complex>& y);
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

inline ostream& operator<<(ostream& os, const vector<Complex>& v){
 long int N = v.size();
 for(long int i = 0; i < N; ++i)
  os << v[i] << endl;
 return os;
}
#endif
