#include "signal.h"

signal::signal(string filename){
 ifstream is;
 is.open(filename, ios_base::in);

 if (!is) 
    cerr << "can not open file: " << filename << '\n';

 step p;
 while (is >> p) 
  thistory.push_back(p);
 
 N = thistory.size();
 T = thistory[N-1].first;

 fs = N / T;
 df = fs / N;
}

int signal::fft(){
 vector<Complex> y;
 vector<Complex> y_fft;

 for(long int i=0; i<N; ++i){
  auto x = thistory[i].second;
  y.push_back(Complex( x*w(i), 0.));
 }

 y_fft = fft_transform(y);
 return 0;
}

vector<Complex> signal::fft_transform(const vector<Complex>& y) {

 double data[2*N]; 
 for(long int i = 0; i < N; ++i){
  REAL(data,i) = real(y[i]);
  IMAG(data,i) = 0.0;
 }

 gsl_complex_packed_array x = data;
 vector<Complex> result;
 gsl_fft_complex_radix2_forward(x, 1, N);

 for(long int i = 0; i < N/2; ++i){
  double a = 4 * REAL(x,i) / N;
  double b = 4 * IMAG(x,i) / N;
  result.push_back(Complex(a,b));  
  double mag = sqrt(a * a + b * b);
  double phase = atan2(a,b) * 180. / M_PI;
  double freq = i * df;
  printf("%12.4f%12g%12.2f\n",freq, mag, phase);
 }
 return result;

}
