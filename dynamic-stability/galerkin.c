#include <stdio.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

typedef struct { double x; double w; } pair;
double p(int n, double x);
double dp(int n, double x);
pair* gausspoints(int n);


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
       int np = 16; //input from console
	   pair* points = gausspoints(np);
	   ///return 0;
	   /*
	   double x0 = 0.;
       while (x0<=1.){
              printf("%12f%12f\n",x0,u(x0,1));
              x0 += 0.001;
	   }
	   */
	   int N = 3, K = N;
	   printf("UkUn:\n");
       	   for(int k=1; k<=K; ++k){
			   for(int n=1; n<=N; ++n){
				   double a = 0.; // limits from the problem
				   double b = 1.;
				   double sum = 0.; // integral sum
	               for(int i=0; i<np; ++i){
				       double mu = points[i].x;
				       double  w = points[i].w;
					   double x = (b-a)/2. * mu + (b+a)/2.;
					   sum += w * u(x,k) * u(x,n);
				       //printf("%12.6f%12.6f\n",x,w);
			       }
				   sum *= (b-a)/2.;
				   printf("%12.4f",sum);
			   }
			   printf("\n");
		   }


	   printf("UkVn:\n");
       	   for(int k=1; k<=K; ++k){
			   for(int n=1; n<=N; ++n){
				   double a = 0.; // limits from the problem
				   double b = 1.;
				   double sum = 0.; // integral sum
	               for(int i=0; i<np; ++i){
				       double mu = points[i].x;
				       double  w = points[i].w;
					   double x = (b-a)/2. * mu + (b+a)/2.;
					   sum += w * u(x,k) * v(x,n);
				       //printf("%12.6f%12.6f\n",x,w);
			       }
				   sum *= (b-a)/2.;
				   printf("%12.4f",sum);
			   }
			   printf("\n");
		   }
				   
	   if (points) free(points);
       return 0;
}

double p(int n, double x) {

	if (n>1) {
		return (2.*n-1.)/n * x * p(n-1,x) - (n-1.)/n * p(n-2,x);
	} else if ( n == 1) {
		return x;
	} else {
		return 1;
	}
}

double dp(int n, double x){
       return 1./(1.-x*x) * ( -n*x*p(n,x) + n*p(n-1,x) );
}


pair* gausspoints(int n){
    pair* points = calloc(n, sizeof(pair));
	
        for(int m=1; m<=n; ++m){
            double teta = (4. * m - 1.) / (4. * n + 2.) * M_PI + 1./(8.*n*n) * 1. / tan(M_PI * (4.*m-1)/(4.*n+2));
	        double x = cos(teta);
            double a = 2./( (1.-x*x)*dp(n,x)*dp(n,x) );
			
			points[m-1].x = x;
			points[m-1].w = a;
			//printf("%f,%f,%d\n",points[m-1].x,points[m-1].w,n);
        }
		
	return points;
}
