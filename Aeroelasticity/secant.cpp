#include <iostream>
#include <numeric>
#include <string>
#include <cmath>
#include <complex>

#include <cstring>
#include <cstdio>

using namespace std;

struct equation {
       virtual double operator()(double) = 0;

       protected:
       double R;
};


struct cantelivered: public equation{
        public:
        cantelivered(double R1){ R = R1; };
        double operator()(double x){ 
                          return (R*x*(1.+cosh(x)*cos(x)) + sinh(x) * cos(x) + sin(x) * cosh(x)) / cosh(x);
        }
};

struct joint: public equation{
        joint(double R1){ R = R1; };
        double operator()(double x){ 
                          return (R*x*(sinh(x) * cos(x) - sin(x) * cosh(x)) + 1. - cosh(x) * cos(x)) / cosh(x);
        }
};

double root(equation& eq, double x1, double x2, double err);
int main(int argc, char** argv){

    double R = 1.; 
    double x0 = 0.;
    double dx = 0.;
    double err = 0.00001;
    bool jnt = false;


    for(int i=0; i<argc; ++i){
        if (strcmp(argv[i], "-R") == 0)   R = stod(argv[i+1]);  
        if (strcmp(argv[i], "-x") == 0)  x0 = stod(argv[i+1]);  
        if (strcmp(argv[i], "-dx") == 0) dx = stod(argv[i+1]);  
        if (strcmp(argv[i], "-e") == 0) err = stod(argv[i+1]);  
        if (strcmp(argv[i], "-joint") == 0) jnt = true;  
    }

    double x1 = x0 - dx;
    double x2 = x0 + dx;

    cantelivered f(R);
    joint g(R);
    double x = 0.;          

    if (jnt) {
              x = root(g, x1, x2, err);          
    } else {
              x = root(f, x1, x2, err);
    }
    printf("%12.4f\n", x);

    return 0;
}

double root(equation& eq, double x1, double x2, double err){
   int maxiter = 64;
   int iter  = 0;
   double x0, error;

   if (eq(x1) * eq(x2) > 0.) {
       fprintf(stderr, "there is no root within %.3f,%.3f\n", x1, x2);
       exit(1);
   }
 
   while (iter < maxiter){
          x0 = (x1 + x2) / 2.;
          error = abs(x2 - x1);

          if (error < err) {
              return x0;
          }

          if (eq(x1) * eq(x0) < 0) x2 = x0;
          else x1 = x0;
          ++iter;
   }
          
   fprintf(stderr, "Too many iterations\n");
   exit(1);
}
