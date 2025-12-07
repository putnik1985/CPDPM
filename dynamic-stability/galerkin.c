#include <stdio.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

int a(int n){
   return M_PI / 2. * (2. * n - 1.);
}

double K0(double x,int n){ 
       return 1./(2.)*(cosh(a(n)*x) + cos(a(n)*x));
}

double K1(double x,int n){
       return 1./(2.*a(n))*(sinh(a(n)*x) + sin(a(n)*x));
}

double K2(double x,int n){
       return 1./(2.*pow(a(n),2))*(cosh(a(n)*x) - cos(a(n)*x));
}

double K3(double x,int n){
       return 1./(2.*pow(a(n),3))*(sinh(a(n)*x) - sin(a(n)*x));
}

double u(double x,int n){
       return K2(x,n) - a(n) * (cosh(a(n)) + cos(a(n)))/(sinh(a(n))+sin(a(n))) * K3(x,n);
}

double v(double x,int n){
       return K0(x,n) - a(n) * (cosh(a(n)) + cos(a(n)))/(sinh(a(n))+sin(a(n))) * K1(x,n);
}

int main(int argc, char** argv){

       return 0;
}
