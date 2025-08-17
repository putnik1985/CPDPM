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
    ifstream in(filename, ios_base::in);
    if (!in) {
             cerr << "can not open file: " << filename << '\n';
             return 1;
    }

    string line;
    map<string, double> model;
    map<string, string>  path;

    while (getline(in, line)){
           auto pos = line.find(",");
           auto key = line.substr(0, pos);
           auto value = line.substr(pos+1);

          if (isdigit(value[0])) { 
              model[key] = stod(value);
          } else {
              path[key] = value;
          }
    }
    in.close();


    auto fmax = model["fmax"];
    auto alpha = model["alpha"];
    auto  beta = model["beta"];
    auto input = path["modal_model"];
    
    vector <double> eigenvalues;
    vector < vector<double> > eigenvectors; // matrix of eigenvectors 
                                            // column - eigenvector
    ifstream is(input);
      while(getline(is, line)){

            if (auto pos = line.find("Eigenvalues") != string::npos){ 
                istringstream iss(line); 
                string   str;
                   int     n;
                double value;
                iss >> str >> n;

                for(int i = 0; i < n; ++i){
                    is >> value;
                    eigenvalues.push_back(value);
                } 
            }

            if (auto pos = line.find("Eigenvectors") != string::npos){ 
                istringstream iss(line); 
                string   str;
                   int     n;
                double value;
                iss >> str >> n;

                for(int i = 0; i < n; ++i){
                    getline(is, line);
                    istringstream iss(line); 
                    vector<double> mode;
                           double value;

                    while (iss >> value)
                           mode.push_back(value);
                    
                    eigenvectors.push_back(mode);
                } 
            }
            
      }

             for(int s = 0; s < eigenvalues.size(); ++s){
                 for(int k = 0; k < eigenvalues.size(); ++k){
                     printf("%12s    Mag(%d,%d)  Phase(%d,%d)", "Freq(Hz)", s,k, s,k); 
                 }
             }
             cout << endl;

    auto N = int(fmax);
    auto df = fmax / N;

         for(int i = 1; i<=N; ++i){
             auto w = 2 * M_PI * df * i;
             for(int s = 0; s < eigenvalues.size(); ++s){
                 for(int k = 0; k < eigenvalues.size(); ++k){
                     complex<double> value;
                     for(int mode = 0; mode < eigenvalues.size(); ++mode) {
                         value += eigenvectors[k][mode] * eigenvectors[s][mode] / ( eigenvalues[mode] - w*w + 1.i * (beta + alpha / eigenvalues[mode]));
                     }
                     printf("%12.2f%12.4f%12.2f", df * i, abs(1.i * w * value), arg(1.i * w * value) * 180. / M_PI); 
                 }
             }
                 cout << endl; 
         }

    is.close();
    cout << endl;
    cout << "Natural Frequencies:" << endl;
    for(int i = 0; i < eigenvalues.size(); ++i)
        cout << sqrt(eigenvalues[i]) / (2. * M_PI) << endl;

    cout << endl;
    cout << "Hysteretic proportional damping:" << endl;
    cout << "Frequencies:" << endl;
    for(int i = 0; i < eigenvalues.size(); ++i)
        cout << sqrt(eigenvalues[i] * ( 1. + 1.i * (beta + alpha / eigenvalues[i]))) / (2. * M_PI)<< endl;
    return 0;
}
