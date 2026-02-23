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
		auto A = A1;
		auto b = b1;
        int n = A.dim1();
		
        T w[n];
	T e[n];
	T S[n];

	for(int i = 0; i < n; ++i){
		e[i] = 0.;
		S[i] = 0.;
		w[i] = 0.;
	}
	for(int step = 0; step < n - 1; ++step){
		e[step] = 1.;
		for(int k = step; k < n; ++k)
			S[k] = A(k,step);

		T alpha = 0.;
		for(int k = step; k < n; ++k)
			alpha += S[k] * S[k];
		alpha = sqrt(alpha);

		T rho;
		for(int k = step; k < n; ++k)
			rho += (S[k] - alpha * e[k]) * (S[k] - alpha * e[k]);
		rho = sqrt(rho);

		for(int k = step; k < n; ++k)
			w[k] = (S[k] - alpha * e[k])/rho;

		for(int col = step; col < n; ++col){
			T dot_product_a = 0.;
			T dot_product_b= 0.;
			for(int i = step; i < n; ++i){
				dot_product_a += w[i] * A(i,col);
				dot_product_b += w[i] * b(i);
			}

			for(int row = step; row < n; ++row){
				A(row,col) -= 2. * dot_product_a* w[row];
				b(row) -= 2. * dot_product_b * w[row];
			}
		}
	}

	Matrix<T,1> x(n);

	for(int k = n - 1; k >= 0; --k){
		double s = 0.;
		for(int j = k + 1; j < n; ++j)
			s += A(k,j) * x(j);
		x(k) = (b(k) - s) / A(k,k);
	}
	return x;
}

} //Numeric_lib
