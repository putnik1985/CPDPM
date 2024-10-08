#include "Matrix.h"

template<typename T>
Matrix<T>::Matrix(int dim):dimension(dim){v.resize(dim*dim);}

template<typename T>	
T& Matrix<T>::operator()(const int& i, const int& j) 
	{ 
           return v[ (i-1) * dimension + (j-1)]; 
    } // must be sure that i <= dimension && j << dimension

template<typename T>
const T& Matrix<T>::operator()(const int& i, const int& j) const
	{ 
           return v[ (i-1) * dimension + (j-1)]; 
    } // must be sure that i <= dimension && j << dimension

template<typename T>	
int Matrix<T>::size() const { return dimension; }

template<typename T>
void Matrix<T>::set_dimension(const int& n) 
		{ 
             vector<T> new_v(n*n);
             //cout << " new dimension " << n << '\n';
             int dim = min(dimension,n);

             for(int i = 1; i <= dim; ++i)
             for(int j = 1; j <= dim; ++j)
             new_v[ (i - 1) * n + (j-1)] = (*this)(i,j);

             v.clear(); // clear current one
             dimension = n;
             v = new_v;
            
        }

template<typename T>
T& Matrix<T>::get(const int& i, const int& j) { return this->operator()(i,j); } // must check validation of the indexes

template<typename T>
const T& Matrix<T>::get(const int& i, const int& j) const { return this->operator()(i,j); } // must check validation of the indexes


template<typename T>	 
Matrix<T>& Matrix<T>::operator=(const Matrix<T>& m)
	 {
     if(m.size()!=dimension) 
        set_dimension(m.size());
        for(int i=1;i<=dimension;++i)
         for(int j=1;j<=dimension;++j)
             (*this)(i,j) = m(i,j);
     return *this;
     }


template<typename T>
vector<T> Matrix<T>::column(const int i) 
	 {
     vector<T> v(dimension);
       for(int k=1;k<=dimension;++k){
        v[k-1] = (*this)(k,i);
        // cout << "column: " << v[k-1] << '\n'; 
        }
     return v;
     }

template<typename T>
vector<T> Matrix<T>::row(const int i) 
	 {
     vector<T> v(dimension);
       for(int k=1;k<=dimension;++k)
        v[k-1] = (*this)(i,k);
     return v;
     }

template<typename T>
void Matrix<T>::transpose()
	 {
     for(int i=1;i<=dimension;++i)
      for(int j=i+1;j<=dimension;++j)
      swap((*this)(i,j), (*this)(j,i));
     }       

template<typename T>
Matrix<T>& Matrix<T>::operator*=(double a){
           for(int i = 0; i < v.size(); ++i)
               v[i]*=a;
           return *this;
    }


template<typename T>
Matrix<T>& operator+(const Matrix<T>& A, const Matrix<T>& B){

     if( A.size() == B.size() ){
     Matrix<T> C(A.size());
     int dim = A.size();
     for(int i=1;i<=dim;++i)
     for(int j=1;j<=dim;++j)
     C(i,j) = A(i,j) + B(i,j);
     return C;
     }
}

template<typename T>
Matrix<T>& operator-(const Matrix<T>& A, const Matrix<T>& B){

     if( A.size() == B.size() ){
     Matrix<T> C(A.size());
     int dim = A.size();
     for(int i=1;i<=dim;++i)
     for(int j=1;j<=dim;++j)
     C(i,j) = A(i,j) - B(i,j);
     return C;
     }
}

template<typename T>
Matrix<T>& operator*(const Matrix<T>& A, const Matrix<T>& B){

     if( A.size() == B.size() ){
     int dim = A.size();
     Matrix<T> C(dim);

     for(int i=1;i<=dim;++i)
     for(int j=1;j<=dim;++j)
       for(int k=1;k<=dim;++k)
       C(i,j) = C(i,j) + A(i,k) * B(k,j);
     return C;
     }
}


template<typename T>
Matrix<T>& operator*(const Matrix<T>& A, const T& b){

     int dim = A.size();
     Matrix<T> C(dim);

     for(int i=1;i<=dim;++i)
     for(int j=1;j<=dim;++j)
       C(i,j) = A(i,j) * b;
     return C;
}

template<typename T>
Matrix<T>& operator*(const T& b, const Matrix<T>& A){

     int dim = A.size();
     Matrix<T> C(dim);
     
     for(int i=1;i<=dim;++i)
     for(int j=1;j<=dim;++j)
        C(i,j) = A(i,j) * b;
     return C;
}

template<typename T>
vector<T>& operator*(const Matrix<T>& A, const vector<T>& v){

     int dim = A.size();
     vector<T> c;
     ////cout << "dimension: " << dim << '\n';
     for(int i=1;i<=dim;++i){
     double s =0;

         for(int j=1;j<=dim;++j)
           s+= A(i,j) * v[j-1];

     c.push_back(s);  
    }
     return c;
}

template<typename T>
ostream& operator<<(ostream& os, const Matrix<T>& M){
      int dimension = M.size();
      for(int i=1;i<=dimension;++i){
      for(int j=1;j<=dimension;++j)   
      os << M(i,j) << ";";
      os << '\n';
      }
return os;
}