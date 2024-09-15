#include "Matrix.h"

    void Matrix::clear() { v.clear(); dimension = 0;}

    const double& Matrix::operator()(const int& i, const int& j) const 
        { 
           return v[ (i - 1) * dimension + (j-1)]; 
        } // must be sure that i <= dimension && j << dimension

    double& Matrix::operator()(const int& i, const int& j) 
        { 
           return v[ (i-1) * dimension + (j-1)]; 
        } // must be sure that i <= dimension && j << dimension

    int Matrix::size() const { return dimension; }

    void Matrix::set_dimension(const int& n) 
        { 
             vector<double> new_v(n*n);
             int dim = min(dimension,n);

             for(int i = 1; i <= dim; ++i)
               for(int j = 1; j <= dim; ++j)
                   new_v[ (i - 1) * n + (j-1)] = get(i,j);

             v.clear(); // clear current one
             dimension = n;
             v = new_v;
         }

    void Matrix::print() const
      {
           for(int i=1;i<=dimension;++i){
             for(int j=1;j<=dimension;++j)   
               cout << fixed << setprecision(WRITE_PRECISION) << this->operator()(i,j) << ";";
             cout << '\n';
           }
      } 

     Matrix& Matrix::operator=(const Matrix& m)
     {
                if(m.size()!=dimension) 
                   set_dimension(m.size());
        
                for(int i=1;i<=dimension;++i)
                    for(int j=1;j<=dimension;++j)
                        get(i,j) = m(i,j);

                return *this;
     }


     double& Matrix::get(const int& i, const int& j) { return this->operator()(i,j); } // must check validation of the indexes

     const double& Matrix::get(const int& i, const int& j) const { return this->operator()(i,j); } // must check validation of the indexes

  

     void Matrix::fill_row(const vector<double>& v, int i) 
     {// must be sure v.size == dimension  
         for(int k=1;k<=dimension;++k)
             get(i,k) = v[k-1];
     }

     void Matrix::fill_column(const vector<double>& v, int i) 
     {  // must be sure v.size == dimension 
          for(int k=1;k<=dimension;++k)
              get(k,i) = v[k-1];
     }

     vector<double> Matrix::column(const int i) 
     {
               vector<double> v(dimension);
               for(int k=1;k<=dimension;++k){
                   v[k-1] = get(k,i);
               }
               return v;
     }

     vector<double> Matrix::row(const int i) 
     {
               vector<double> v(dimension);
               for(int k=1;k<=dimension;++k)
                   v[k-1] = get(i,k);
               return v;
     }


     void Matrix::random()
     {
          for(int i=1;i<=dimension;++i)
              for(int j=i;j<=dimension;++j){
                  get(i,j) = rand();
                  get(j,i) = get(i,j);
              }
     }//random filling


     void Matrix::unit()
     {
          for(int i=1;i<=dimension;++i)
              get(i,i) = 1.0;
     }// unit filling


     bool Matrix::symmetric() const
     {
          for(int i=1;i<=dimension;++i)
              for(int j=i+1;j<=dimension;++j){
                  if (get(i,j)!=get(j,i)) {
                      cout << " i= " << i
                           << " j= " << j 
                           << " delta = " << get(i,j) - get(j,i) << '\n';
                           return false;
                  }
          }
          return true;
     }


     void Matrix::transpose()
     {
          for(int i=1;i<=dimension;++i)
              for(int j=i+1;j<=dimension;++j)
                  swap(get(i,j), get(j,i));
     }       


Matrix operator+(const Matrix& A, const Matrix& B){

     if( A.size() == B.size() ){
     Matrix C(A.size());
     int dim = A.size();
     for(int i=1;i<=dim;++i)
     for(int j=1;j<=dim;++j)
     C(i,j) = A(i,j) + B(i,j);
     return C;
     }
}

Matrix operator-(const Matrix& A, const Matrix& B){

     if( A.size() == B.size() ){
     Matrix C(A.size());
     int dim = A.size();
     for(int i=1;i<=dim;++i)
     for(int j=1;j<=dim;++j)
     C(i,j) = A(i,j) - B(i,j);
     return C;
     }
}

Matrix operator*(const Matrix& A, const Matrix& B){

     if( A.size() == B.size() ){
     int dim = A.size();
     Matrix C(dim);

     for(int i=1;i<=dim;++i)
     for(int j=1;j<=dim;++j)
       for(int k=1;k<=dim;++k)
       C(i,j) = C(i,j) + A(i,k) * B(k,j);
     return C;
     }
}


Matrix operator*(const Matrix& A, const double& b){

     int dim = A.size();
     Matrix C(dim);

     for(int i=1;i<=dim;++i)
     for(int j=1;j<=dim;++j)
       C(i,j) = A(i,j) * b;
     return C;
}

Matrix operator*(const double& b, const Matrix& A){

     int dim = A.size();
     Matrix C(dim);
     
     for(int i=1;i<=dim;++i)
     for(int j=1;j<=dim;++j)
        C(i,j) = A(i,j) * b;
     return C;
}

ostream& operator<<(ostream& os, const Matrix& M){
      int dimension = M.size();
      for(int i=1;i<=dimension;++i){
      for(int j=1;j<=dimension;++j)   
      os << M(i,j) << ";";
      os << '\n';
      }
return os;
}


vector<double> operator*(const Matrix& A, const vector<double>& v){

     int dim = A.size();
     vector<double> c;
     ////cout << "dimension: " << dim << '\n';
     for(int i=1;i<=dim;++i){
     double s =0;

         for(int j=1;j<=dim;++j)
           s+= A(i,j) * v[j-1];

     c.push_back(s);  
    }
     return c;
}


