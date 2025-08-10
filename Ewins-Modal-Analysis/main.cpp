#include <iostream>
#include <string>
#include <complex>
#include <map>
#include <fstream>

using namespace std;

int main(int argc, char** argv){

    map<string, string> data;
    for(auto i = 1; i < argc; ++i){
        string s = argv[i];
        cout << s << '\n'; 
        auto pos = s.find("=");

        if (pos > 0) {
            auto key = s.substr(0, pos);
            auto value = s.substr(pos+1, s.size());
            cout << key <<  " " << value << '\n';
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
    while (getline(in, line)){
           cout << line << '\n';
    }
    return 0;
}
