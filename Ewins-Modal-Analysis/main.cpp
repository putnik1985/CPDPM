#include <iostream>
#include <string>
#include <complex>
#include <map>
#include <fstream>
#include <cmath>
#include <iomanip>

const double M_PI = 3.14159;

using namespace std;

class receptance {
  public:
  virtual complex<double> operator()(double w) = 0;
  receptance(double m1, double k1);

  protected:
  double m;
  double k;
  double w0;
};

class viscous_damping: protected receptance {
  public:
  complex<double> operator()(double w);
  viscous_damping(double m1, double k1, double c1);
  using receptance::receptance;

  private:
  double c;
};

class structural_damping: protected receptance {
  public:
  complex<double> operator()(double w);
  structural_damping(double m1, double k1, double h1);
  using receptance::receptance;

  private:
  double h;
};

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

int main(int argc, char** argv){

    map<string, string> data;
    for(auto i = 1; i < argc; ++i){
        string s = argv[i];
        ///cout << s << '\n'; 
        auto pos = s.find("=");

        if (pos > 0) {
            auto key = s.substr(0, pos);
            auto value = s.substr(pos+1, s.size());
            //cout << key <<  " " << value << '\n';
            data[key] = value;
        }
    }
    string filename;
    if (data.size() > 0 ) {
        filename = data["file"];
    }
    //cout << filename;
    ifstream in(filename, ios_base::in);
    if (!in) {
             cerr << "can not open file: " << filename << '\n';
             return 1;
    }

    string line;
    map<string, double> model;

    while (getline(in, line)){
           ///cout << line << '\n';
           auto pos = line.find(",");
           auto key = line.substr(0, pos);
           ////cout << key << endl; 
           auto value = line.substr(pos+1);
           ////cout << stod(value) << endl;
           model[key] = stod(value);
    }
    in.close();
    for( auto& record : model){
         ///cout << record.first << record.second << endl; 
    }
    auto ksi = model["ksi"];
    auto eta = model["eta"];
    auto k = model["k"];
    auto g = model["g"];
    auto f = model["f"];
    auto fmax = model["fmax"];
    ////cout << ksi << k << g << f << fmax << endl;
    int N = int(fmax);
    auto m = k * g / (4 * M_PI * M_PI * f * f );
    //cout << "mass(kgs/g) = " << m/g << endl;
    auto c = ksi * 2. * sqrt(m * k / g );
    viscous_damping alpha(m/g, k, c);
    string format_string;
    //create format string for titles
    for(auto i = 0; i<7; ++i)
	    format_string += "%12s";

    ////cout << format_string << endl; 
    printf(format_string.c_str(),"Frequency", "Mag(Visc)", "Real(Visc)", "Imag(Visc)", "Phase(Visc)", "1/k", "1./(wwm)"); 
    printf("\n");
    double df = fmax / N;
        for(auto i = 1.; i <= N; ++i){
            double w = 2 * M_PI * df * i;
            auto value = alpha(w);
            cout << setw(12) << fixed << setprecision(4) << df * i
                 << setw(12) << fixed << setprecision(4) << abs(value)
                 << setw(12) << fixed << setprecision(4) << real(value)
                 << setw(12) << fixed << setprecision(4) << imag(value)
                 << setw(12) << fixed << setprecision(4) << arg(value) * 180. / M_PI
                 << setw(12) << fixed << setprecision(4) << 1. / k 
                 << setw(12) << fixed << setprecision(4) << 1. / (w*w*m/g)
                 << endl;
        } 
    return 0;
}
