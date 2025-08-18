#include "receptance.h"

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


    auto ksi = model["ksi"];
    auto eta = model["eta"];
    auto k = model["k"];
    auto g = model["g"];
    auto f = model["f"];
    auto fmax = model["fmax"];
	

    
	if ((k <= 0.) || (g <= 0.) || (f <= 0.) || (fmax <= 0.)) {
		fprintf(stderr, "k, g, f, fmax - all should be defined into the input file:%s\n", filename.c_str());
		cout << "ksi = " << ksi << " k = " << k << " g = " << g << " f = " << f << " fmax = " << fmax << endl;
		return -1;
	}
	
    int N = int(fmax);
    auto m = k * g / (4 * M_PI * M_PI * f * f );
    //cout << "mass(kgs/g) = " << m/g << endl;

    auto c = ksi * 2. * sqrt(m * k / g );
    viscous_damping alpha(m/g, k, c);
	
    auto h = eta * k;
    structural_damping beta(m/g, k, h);
	
    string format_string;
    //create format string for titles of 5 names
    for(auto i = 0; i<5; ++i)
	    format_string += "%12s";

    ////cout << format_string << endl; 
    printf("\n\nReceptance Viscous Damping Model (ksi = %.2f)\n", ksi); 
    printf(format_string.c_str(),"Frequency", "Mag(Visc)", "Real(Visc)", "Imag(Visc)", "Phase(Visc)"); 
    printf("\n");
    mobility_plot mb1(alpha, fmax, N);
    cout << mb1;

    printf("\n\nReceptance Structural Damping Model (eta = %.2f)\n", eta); 
    printf(format_string.c_str(),"Frequency", "Mag(Str)", "Real(Str)", "Imag(Str)", "Phase(Str)"); 
    printf("\n");
    mobility_plot mb2(beta, fmax, N);
    cout << mb2;
	 
    return 0;
}
