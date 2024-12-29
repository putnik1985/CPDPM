#include "analysis.h"

extern "C"{
#include "../Numerical_Library/numeric_c.h"
}

template<typename T>
int natural_modes(Matrix<T> M, Matrix<T> K, const nvector<T>& nodes){
    int n = M.size();
    T *a = M.c_matrix();
    T *v = (T*)calloc(n*n, sizeof(T));
    T *d = (T*)calloc(n  , sizeof(T));
    if (!a || !v || !d) {
        cerr << "allocation failure in natural modes analysis\n";
        return -1;
    }
    jacobi(a, n, d, v);

    Matrix<T> D(n);
    for(int i=1; i<=n; ++i)
     D(i,i) = d[i-1];

    Matrix<T> Q(v, n);
    Matrix<T> P = Q * inverse(sqrt(D)); 
    Matrix<T> A = transpose(P) * K * P;

    free(a);
    free(v);
    free(d);

    a = A.c_matrix();
    v = (T*)calloc(n*n, sizeof(T));
    d = (T*)calloc(n  , sizeof(T));

    if (!a || !v || !d) {
        cerr << "second allocation failure in natural modes\n"; 
        return -1;
    }
    jacobi(a, n, d, v);

    Matrix<T> Z(v, n);
    nvector<T> omega2(n);
    for(int i = 0; i<n;++i)
        omega2[i] = d[i];

    nvector<T> frequencies = sqrt(omega2) / (2 * M_PI);
    Matrix<T> modes = P * Z;

    vector<int>shapes;

    cout << "Natural Frequencies, Hz\n";
    for(const auto& x: frequencies) 
        cout << x << endl;
/****************************    
    n = nodes.size();
    for(int i=1; i<=n; ++i){
        printf("%12.6f",nodes(i));
        for(const auto& num:shapes){
           printf("%12.6f%12.6f",modes(4*i-3,num), modes(4*i-2,num)); 
        }
        printf("\n");
    }
*****************************/
    free(a);
    free(v);
    free(d);
    return 0;
}
