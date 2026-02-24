#include "stl.h"
ostream& operator<<(ostream& os, const Numeric_lib::Matrix<double, 2>& m);
ostream& operator<<(ostream& os, const Numeric_lib::Matrix<double, 1>& m);

namespace Numeric_lib {
	
/* square_root: solve linear system of n equations Ax=b using symmetry if the Numeric_lib::Matrix A*/
template<class T>
Matrix<T,1> square_root(const Matrix<T,2>& A, const Matrix<T,1>& b)
{
    int n = A.dim1();
	Matrix<T,2> s(n,n);

	s(0,0) = sqrt(A(0,0));
	for(int j = 0; j < n; ++j)
		s(0,j) = A(0,j) / s(0,0);


	for(int i = 1; i < n; ++i){
		T sum = 0.;
		
		for(int k = 0; k < i; ++k)
			sum += s(k,i) * s(k,i);
		
		s(i,i) = sqrt(A(i,i) - sum);
		
	    for(int j = i+1; j < n; ++j){
			T sum = 0.;
			for(int k = 0; k < i; ++k)
				sum += s(k,i) * s(k,j);

			s(i,j) = (A(i,j) - sum)/s(i,i);
		}
	}



        for(int j = 0; j < n; ++j)
		    for(int i = j + 1; i < n; ++i)
			    s(i,j) = 0.;

/*********************************
    cout << "S:\n";
	cout << s;

    cout << "Transpose S:\n";
	cout << transpose(s);
	
    cout << "S'S:\n";
	cout << transpose(s) * s;
************************************/	
	
	Matrix<T,1> z(n);

	for(int i = 0; i < n; ++i){
		T sum = 0.;
		for(int k = 0; k < i; ++k)
			sum += s(k,i) * z(k);
		z[i] = (b[i] - sum)/s(i,i);
	}

	Matrix<T,1> x(n);
	for(int k = n - 1; k >= 0; --k){
		T sum = 0.;
		for(int i = k + 1; i < n; ++i)
			sum += s(k,i) * x(i);
		x(k) = (z(k) - sum) / s(k,k);
	}
	//cout << "Solution:\n";
	//cout << x;
	
	return x;
}

/* gauss: solve linear system of n equations Ax=b */
template<class T>
Matrix<T,1> gauss(const Matrix<T,2>& A1, const Matrix<T,1>& b1)
{ 
        //cout << A;
		//cout << b;
		auto A = A1;
		auto b = b1;
        auto n = A.dim1();
        for(int i = 0; i < n - 1; ++i)
		for(int j = i + 1; j < n; ++j){
			T factor = A(j,i) / A(i,i);
			for(int k = i; k < n; ++k)
				A(j,k) -= factor * A(i,k);

			b(j) -= factor * b(i);
		}

    //cout << "Gauss Eliminarion\n";
    //cout << A;
	//cout << b;
	Matrix<T,1> x(n);

	for(int k = n - 1; k >= 0; --k){
	    T s = 0.;
		for(int j = k + 1; j < n; ++j)
			s += A(k,j) * x(j);
		x(k) = (b(k) - s) / A(k,k);
	}
	//cout << "Solution:\n";
	//cout << x;
	return x;
}

/* hausholder: solve linear system of n equations Ax=b using reflection matrix*/
template<class T>
Matrix<T,1> hausholder(const Matrix<T,2>& A1, const Matrix<T,1>& b1)
{
		auto R = A1;
        int n = R.dim1();
		auto Q = QR(R);
		
/************************************		
		//cout << A;

        int n = 3;
		Matrix<T,2> R(n,n);
		Matrix<T,2> Q(n,n);
		
		R(0,0) = 12.; R(0,1) = -51.; R(0,2) = 4.;
		R(1,0) = 6.; R(1,1) = 167.; R(1,2) = -68.;
		R(2,0) = -4.; R(2,1) = 24.; R(2,2) = -41.;
		
		Matrix<T,2> I(n,n);
		for(int i=0; i<n; ++i)
			I(i,i) = 1.;
		
	    Matrix<T,2> Q = I;
		
    // cout << endl;	
    for(int i=0; i<n-1; ++i){
		Matrix<T,1> x(n), e(n);
		for(int j=i; j<n; ++j)
			x(j) = R(j,i);
		e(i) = 1.;
		
		T alpha = vnorm(x);
		Matrix<T,1> u = x - e * alpha;
		
		u /= vnorm(u);
		Q = Q * (I - (u * u) * 2.);
		//cout << Q << endl;
		R = (I - (u * u) * 2.) * R;
		//cout << R << endl;
	}	
	
	//cout << Q * R;
*********************************************/
    	

	Matrix<T,1> x(n);
	Matrix<T,1> b = transpose(Q) * b1;
	
	for(int k = n - 1; k >= 0; --k){
		T s = 0.;
		for(int j = k + 1; j < n; ++j)
			s += R(k,j) * x(j);
		
		x(k) = (b(k) - s) / R(k,k);
	}
	return x;
}

template<class T>
Matrix<T,2> QR(Matrix<T,2>& A)
{
        int n = A.dim1();
		Matrix<T,2> I(n,n);

		for(int i=0; i<n; ++i)
			I(i,i) = 1.;
		
	    Matrix<T,2> Q = I;
		
    for(int i=0; i<n-1; ++i){
		Matrix<T,1> x(n);
		Matrix<T,1> e(n);
        
		e(i) = 1.;
		for(int j=i; j<n; ++j)
			x(j) = A(j,i);

		
		
		T alpha = vnorm(x);
		Matrix<T,1> u = x - e * alpha;
		
		u /= vnorm(u);
		Q = Q * (I - (u * u) * 2.);
		//cout << Q << endl;
		A = (I - (u * u) * 2.) * A;
		//cout << R << endl;
	}
	return Q;
}


template<class T>
Matrix<T,2> reflection_matrix(const Matrix<T,1>& x, int i)
{
        int n = x.dim1();
		Matrix<T,2> I(n,n);

        Matrix<T,1> e(n);
		e(i) = 1.; //where to convert
		
		for(int i=0; i<n; ++i)
			I(i,i) = 1.;
		
		T alpha = vnorm(x);
		Matrix<T,1> u = x - e * alpha;	
		u /= vnorm(u);
		
		return (I - (u * u) * 2.);
}

} //Numeric_lib
