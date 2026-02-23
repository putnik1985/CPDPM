#include "stl.h"
#include "Operator.h"
#include "MatrixLib.cpp"
#include "linear-algebra.cpp"

ostream& operator<<(ostream& os, const Numeric_lib::Matrix<double, 2>& m){
 int n = m.dim1(); 
         for(int i=0; i<n; ++i){
             for(int j=0; j<n; ++j)
                 printf("%12.4f", m(i,j));
             os << '\n';
         }
 return os;
}

ostream& operator<<(ostream& os, const Numeric_lib::Matrix<double, 1>& m){
 int n = m.dim1(); 
         for(int i=0; i<n; ++i)
                 printf("%12.4f", m(i));
         os << '\n';
 return os;
}

int main(int argc, char** argv){
	
	int nx = 32, ns = 32;
	double a = 0., b = M_PI, c = 0. , d = M_PI;
	double p = 4.;
	
    double alpha = 1.; // initial value for alpha
	
        for(int i=0; i< argc; ++i){
		if (strcmp(argv[i], "-nx")==0) nx = atoi(argv[i+1]);
		if (strcmp(argv[i], "-ns")==0) ns = atoi(argv[i+1]);
		if (strcmp(argv[i], "-a")==0) a = atof(argv[i+1]);
		if (strcmp(argv[i], "-b")==0) b = atof(argv[i+1]);
		if (strcmp(argv[i], "-c")==0) c = atof(argv[i+1]);
		if (strcmp(argv[i], "-d")==0) d = atof(argv[i+1]);
		if (strcmp(argv[i], "-p")==0) p = atof(argv[i+1]);
		if (strcmp(argv[i], "-alpha")==0) alpha = atof(argv[i+1]);
		
	}
	//printf("nx=%d, ns=%d, a=%.4f, b=%.4f, c=%.4f, d=%.4f\n", nx, ns, a, b, c, d);

	image<double>  u;
	kernel<double> K;
        integral_operator<kernel<double>, double> iop(K, a, b, c, d, nx, ns); // define integral operator with the kernel k	
	Numeric_lib::Matrix<double,1> g  = iop(u); // g(s) is an image of the u from the action of K must be double func(double)
	Numeric_lib::Matrix<double,2> K_ = iop(K); // K_(s,t)

        
	Numeric_lib::Matrix<double,2> B(ns,ns);
	Numeric_lib::Matrix<double,2> C(ns,ns);
	Numeric_lib::Matrix<double,1> y(ns);
//********************************************

//************************************************/
		
	double h = (b-a) / ns;
        for(int i=0; i<ns; ++i){
		double s = a + 0.5 * h + i * h;
		for (int j=0; j<ns; ++j){
			 double t = a + 0.5 * h + j * h;
			 B(i,j) = K_(i,j) * h;
			 C(i,j) = 0.;
		}
		y(i) = g(i);
	}

	for(int i=0; i<ns; ++i)
		C(i,i) = (1. + 2. * p / (h*h));

	for(int i=1; i<ns; ++i)
		C(i,i-1) = (-alpha * p / (h*h));

	for(int i=0; i<ns-1; ++i)
		C(i,i+1) = (-alpha * p / (h*h));

	C(0,0) = C(ns-1,ns-1) = 1. + p / (h*h);

/******************************************
        printf("h:\n");
		printf("%12.4f\n",h);

        cout << "g\n";
        cout << g ;

        cout << "K\n";
        cout << K_;
		
        cout << "B\n";
        cout << B;

        cout << "C\n";
        cout << C;
********************************************/
		
	Numeric_lib::Matrix<double,2> A = B + C * alpha;
	
/*********************************************************
        cout << "A\n";
        cout << A;
        cout << "y\n";
        cout << y ;
**********************************************************/


	//cout << "\nGauss\n" << A << "\n" << y;	
	Numeric_lib::Matrix<double,1> z1 = gauss(A,y);
	
	//cout << "\nSquare Root\n" << A << "\n" << y;
	Numeric_lib::Matrix<double,1> z2 = square_root(A,y);

	//cout << "\nHausholder\n" << A << "\n" << y;
	Numeric_lib::Matrix<double,1> z3 = hausholder(A,y);	
	//cout << "Integral Equation Solution:" << endl;
	printf("\n%12s%12s%12s%12s%12s\n", "s", "Gauss", "Square", "Hausholder", "Exact");



	for(int i=0; i<ns; ++i){
		double s = a + 0.5 * h + i * h;
		printf("%12.6f%12.6f%12.6f%12.6f%12.6f\n", s, z1(i), z2(i), z3(i), sin(s));
		//printf("%12.6f%12.6f%12.6f%12.6f%12.6f\n", s, z1(i), z2(i), z3(i), 1.);		
    }
	    Numeric_lib::Matrix<double,1> yexact(z1.dim1());
	    for(int i=0; i<z1.dim1(); ++i){
			
			double s = a + 0.5 * h + i * h;
			//yexact(i) = 1.;
			yexact(i) = sin(s);
        }
       
		printf("\n%12s%12.6f%12.6f%12.6f%12.6f\n", "Residuals:", vnorm(A*z1-y), vnorm(A*z2-y), vnorm(A*z3-y), vnorm(A*yexact - y));

	return 0;
}
