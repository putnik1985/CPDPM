#ifndef MATRIX_H
#define MATRIX_H

#include "stl.h"
#include "nvector.h"

#define PRECISION 4
#define WIDTH 16

#define WRITE_PRECISION 10


template<typename T>
class Matrix{ // numberig starts from the 1
vector<T> v;
int dimension;


public:

	Matrix(int dim = 2);
	T& operator()(const int& i, const int& j);
	const T& operator()(const int& i, const int& j) const;
    int size() const;
    void set_dimension(const int& n); 
    T& get(const int& i, const int& j);
    const T& get(const int& i, const int& j) const;// must check validation of the indexes
    Matrix& operator=(const Matrix<T>& m);
    vector<T> column(const int i);
    vector<T> row(const int i);
    void transpose();
    Matrix& operator*=(double a);
	
};// Matrix class 


template<typename T>
Matrix<T>& operator+(const Matrix<T>& A, const Matrix<T>& B);
template<typename T>
Matrix<T>& operator-(const Matrix<T>& A, const Matrix<T>& B);
template<typename T>
Matrix<T>& operator*(const Matrix<T>& A, const Matrix<T>& B);
template<typename T>
Matrix<T>& operator*(const Matrix<T>& A, const T& b);
template<typename T>
Matrix<T>& operator*(const T& b, const Matrix<T>& A);
template<typename T>
nvector<T> operator*(const Matrix<T>& A, const nvector<T>& v);


template<typename T>
ostream& operator<<(ostream& os, const Matrix<T>& M);

#endif
