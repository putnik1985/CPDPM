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
    map<string, string>  path;

    while (getline(in, line)){
           ///cout << line << '\n';
           auto pos = line.find(",");
           auto key = line.substr(0, pos);
           ////cout << key << endl; 
           auto value = line.substr(pos+1);
           ////cout << stod(value) << endl;

           model[key] = stod(value);
            path[key] = value;
    }
    in.close();


    auto alpha = model["alpha"];
    auto  beta = model["beta"];
    auto input = path["modal_model"];

    cout << alpha << beta << input << endl; 
	 
    return 0;
}
