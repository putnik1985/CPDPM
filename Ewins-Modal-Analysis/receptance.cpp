#include "receptance.h"

receptance::receptance(double m1, double k1):
m(m1), k(k1)
{
       cout << "receptance constructor:\n";	 
       w0 = sqrt(k/m);
}

complex<double> viscous_damping::operator()(double w){
                return 1. / ( k - w*w * m + 1.i * w * c);
}

viscous_damping::viscous_damping(double m1, double k1, double c1):
receptance(m1,k1), c(c1) 
{
	cout << "viscous constructor:\n"; 
}

structural_damping::structural_damping(double m1, double k1, double h1):
receptance(m1,k1), h(h1) 
{
	cout << "structural constructor:\n"; 
}

complex<double> structural_damping::operator()(double w){
                return 1. / ( k - w*w * m + 1.i * h);
}

mobility_plot::mobility_plot(receptance& rc, double f1, int n1):
fmax(f1), N(n1)
{
     double df = fmax / N; 
     for(auto i = 1.; i <= N; ++i)
		 data.push_back(rc(2. * M_PI * df * i));
	 
};

ostream& operator<<(ostream& os, const mobility_plot& mb) {
     int N = mb.N;
     double df = mb.fmax / mb.N; 
     for(auto i = 1.; i <= N; ++i){
              auto value = mb.data[i-1];	          
	          os << setw(12) << fixed << setprecision(4) << df * i
                 << setw(12) << fixed << setprecision(4) << abs(value)
                 << setw(12) << fixed << setprecision(4) << real(value)
                 << setw(12) << fixed << setprecision(4) << imag(value)
                 << setw(12) << fixed << setprecision(4) << arg(value) * 180. / M_PI
                 << endl;
	 }			 
              return os;
}
