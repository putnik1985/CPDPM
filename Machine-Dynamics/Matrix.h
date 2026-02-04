#ifndef MATRIX_H
#define MATRIX_H

#include "stl.h"
#include "nvector.h"

#define PRECISION 4
#define WIDTH 16

#define WRITE_PRECISION 10

extern "C"{
#include "../Numerical_Library/numeric_c.h"
}

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
    Matrix(T* a, int n);
    T* c_matrix();
	
};// Matrix class 


template<typename T>
Matrix<T> operator+(const Matrix<T>& A, const Matrix<T>& B);
template<typename T>
Matrix<T> operator-(const Matrix<T>& A, const Matrix<T>& B);
template<typename T>
Matrix<T> operator*(const Matrix<T>& A, const Matrix<T>& B);
template<typename T>
Matrix<T> operator*(const Matrix<T>& A, const T& b);
template<typename T>
Matrix<T> operator*(const T& b, const Matrix<T>& A);
template<typename T>
nvector<T> operator*(const Matrix<T>& A, const nvector<T>& v);

template<typename T>
fcomplex* operator*(const fcomplex b, const Matrix<T>& A);
template<typename T>
fcomplex operator*(const fcomplex a, const T b);
template<typename T>
fcomplex operator*(const T b, const fcomplex a);
template<typename T>
fcomplex operator+(const fcomplex a, const T b);
template<typename T>
fcomplex* operator+(const Matrix<T>& A, fcomplex* B);
template<typename T>
fcomplex* operator+(fcomplex* B, const Matrix<T>& A);


template<typename T>
ostream& operator<<(ostream& os, const Matrix<T>& M);

template<typename T>
Matrix<T> inverse(const Matrix<T>& A);

template<typename T>
nvector<T> sqrt(const nvector<T>& v);

template<typename T>
nvector<T> operator/(const nvector<T>& v, T a);

template<typename T>
Matrix<T> transpose(const Matrix<T>& A);

template<typename T>
Matrix<T> sqrt(const Matrix<T>& A);

#endif
