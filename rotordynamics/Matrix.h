#ifndef MATRIX_H
#define MATRIX_H

#include "stl.h"

#define PRECISION 4
#define WIDTH 16
#define WRITE_PRECISION 10

class Matrix{ // numbering starts from the 1

private:
vector<double> v;
int dimension;

public:
        void clear();
	Matrix(int dim = 2):
        dimension(dim) {v.resize(dim*dim);}
	const double& operator()(const int& i, const int& j) const; 
	double& operator()(const int& i, const int& j); 
        int size() const;
        void set_dimension(const int& n); 
        void print() const;
        Matrix& operator=(const Matrix& m);
        double& get(const int& i, const int& j);
        const double& get(const int& i, const int& j) const;
        void fill_row(const vector<double>& v, int i); 
        void fill_column(const vector<double>& v, int i); 
        vector<double> column(const int i); 
        vector<double> row(const int i); 
        void random();
        void unit();
        bool symmetric() const;
        void transpose();
};

#endif
