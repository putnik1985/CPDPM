#include "nvector.h"
#include "nvector.cpp"

int main(){
    nvector<double> v(2);
    v(1) = 2;
    v(2) = 45.33242;
    for(int i = 1; i <= v.size(); ++i){
    cout << v(i) << ",";
    }
    cout << "\n";
    return 0;
}
