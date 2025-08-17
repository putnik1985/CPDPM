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
    cout << "Hysteretic proportional damping:" << endl;
    cout << "EigenValues:" << endl;
    for(int i = 0; i < eigenvalues.size(); ++i)
        cout << eigenvalues[i] * ( 1. + 1.i * (beta + alpha / eigenvalues[i]))<< endl;

    cout << "Vectors" << endl;
    for(int i = 0; i < eigenvectors.size(); ++i){
        for(int j = 0; j < eigenvectors[i].size(); ++j)
            cout << eigenvectors[i][j] << ",";
        cout << endl;
    }
    is.close();
    return 0;
}
