#include "Matrix.h"

template<typename T>
Matrix<T> transpose(const Matrix<T>& A){
  int n = A.size();
  Matrix<T> M(n);
  for(int i=1; i<=n; ++i)
      for(int j=1; j<=n; ++j)
          M(i,j) = A(j,i);

  return M;
}

template<typename T>
Matrix<T> inverse(const Matrix<T>& A){
  int n = A.size();
  Matrix<T> M(n);
  for(int i=1; i<=n; ++i)
      M(i,i) = 1. / A(i,i);

  return M;
}

template<typename T>
nvector<T> sqrt(const nvector<T>& v){
  int n = v.size();
  nvector<T> vec(n);
  for(int i=1; i<=n; ++i)
      vec(i) = sqrt(v(i));

  return vec;
}

template<typename T>
Matrix<T> sqrt(const Matrix<T>& A){
  int n = A.size();
  Matrix<T> M(n);
  for(int i=1; i<=n; ++i)
      for(int j=1; j<=n; ++j)
          M(i,j) = sqrt(A(i,j));

  return M;
}

template<typename T>
nvector<T> operator/(const nvector<T>& v, T a){
  int n = v.size();
  nvector<T> vec(n);

  for(int i=1; i<=n; ++i)
      vec(i) = v(i) / a;

  return vec;
}

template<typename T>
T* Matrix<T>::c_matrix(){
   int n = this->size();
   T* a = (T*)calloc(n*n, sizeof(T));
   for(int i = 0; i < n; ++i)
       for(int j = 0; j<n; ++j)
           a[i*n+j] = (*this)(i+1, j+1);

   return a;
}

template<typename T>
Matrix<T>::Matrix(T* a, int dim):
dimension(dim)
{
v.resize(dim*dim);
  for(int i = 0; i < dim; ++i)
      for(int j = 0; j < dim; ++j)
          v[i*dim+j] = a[i*dim+j];
}

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
Matrix<T> operator+(const Matrix<T>& A, const Matrix<T>& B){

     Matrix<T> C(A.size());
     int dim = A.size();
     for(int i=1;i<=dim;++i)
     for(int j=1;j<=dim;++j)
     C(i,j) = A(i,j) + B(i,j);
     return C;
}

template<typename T>
Matrix<T> operator-(const Matrix<T>& A, const Matrix<T>& B){

     Matrix<T> C(A.size());
     int dim = A.size();
     for(int i=1;i<=dim;++i)
     for(int j=1;j<=dim;++j)
     C(i,j) = A(i,j) - B(i,j);
     return C;
}

template<typename T>
Matrix<T> operator*(const Matrix<T>& A, const Matrix<T>& B){

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
Matrix<T> operator*(const Matrix<T>& A, const T& b){

     int dim = A.size();
     Matrix<T> C(dim);

     for(int i=1;i<=dim;++i)
     for(int j=1;j<=dim;++j)
       C(i,j) = A(i,j) * b;
     return C;
}

template<typename T>
Matrix<T> operator*(const T& b, const Matrix<T>& A){

     int dim = A.size();
     Matrix<T> C(dim);
     
     for(int i=1;i<=dim;++i)
     for(int j=1;j<=dim;++j)
        C(i,j) = A(i,j) * b;
     return C;
}

template<typename T>
nvector<T> operator*(const Matrix<T>& A, const nvector<T>& v){

     int dim = A.size();
     nvector<T> c;
     ////cout << "dimension: " << dim << '\n';
     for(int i=1;i<=dim;++i){
     double s =0;

         for(int j=1;j<=dim;++j)
           s+= A(i,j) * v(j);

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

template<typename T>
fcomplex* operator*(const fcomplex b, const Matrix<T>& A){
  int n = A.size();
  fcomplex* out = (fcomplex*)calloc(n*n, sizeof(fcomplex));
  for(int i=0; i<n; ++i)
      for(int j=0; j<n; ++j)
          out[n*i+j] = {b.r * A(i+1, j+1), b.i * A(i+1, j+1)};
  return out;
}

template<typename T>
fcomplex operator*(const fcomplex a, const T b){
  return {a.r * b, a.i * b};
}

template<typename T>
fcomplex operator*(const T b, const fcomplex a){
  return {a.r * b, a.i * b};
}

template<typename T>
fcomplex operator+(const fcomplex a, const T b){
  return {a.r + b, a.i };
}

template<typename T>
fcomplex* operator+(const Matrix<T>& A, fcomplex* B){
  int n = A.size();
  fcomplex* out = (fcomplex*)calloc(n*n, sizeof(fcomplex));
  for(int i = 0; i<n; ++i)
      for(int j = 0; j < n; ++j)
          out[n*i +j] = B[n*i+j] + A(i+1, j+1);
  return out;
}

template<typename T>
fcomplex* operator+(fcomplex* B, const Matrix<T>& A){
  return A + B;
}
/******************************************************
template<typename T>
int natural_modes(Matrix<T> M, Matrix<T> K){
    int n = M.size();
    T* a = (T*)calloc(n*n, sizeof(T));
    T* v = (T*)calloc(n*n, sizeof(T));
    T* d = (T*)calloc(n  , sizeof(T));

    if (!a) {
            cerr << "allocation failure a matrix\n";
            return -1;
    }

    if (!v) {
            cerr << "allocation failure v matrix\n";
            return -1;
    }

    if (!d) {
            cerr << "allocation failure d vector\n";
            return -1;
    }

    return 0;
}
********************************************************/
