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

    if ( a != NULL) free(a);
    if ( v != NULL) free(v);
    if ( d != NULL) free(d);

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

    ofstream os;
    os.open("natural-frequencies.dat",ios_base::out);
    if (!os){
            cerr << "can not write to natural frequencies\n";
            return -1;
    }
    )os << "Natural Frequencies, Hz\n";
    for(int mode = 1; mode <= MAX_MODES; ++mode)
        os << frequencies(mode) << endl;
    os.close();

//    for(const auto& x: frequencies) 
//        cout << x << endl;

    os.open("natural-mode-shapes.dat",ios_base::out);
    char outputstr[MAXLINE];

    if (!os){
            cerr << "can not write to natural modes\n";
            return -1;
    }
    n = nodes.size();
    sprintf(outputstr, "%24s", "X,m"); 
    os << outputstr;
    for(int mode = 1; mode <= MAX_MODES; ++mode){
            char output1[MAXLINE];
            sprintf(output1,"mode#%dU(%.1fHz)",mode,frequencies(mode));
            sprintf(outputstr, "%24s", output1); 
            os << outputstr;
    }
    sprintf(outputstr, "\n");
    os << outputstr;

    for(int i=1; i<=n; ++i){
        sprintf(outputstr, "%24.6f",nodes(i));
        os << outputstr;
        for(int mode = 1; mode <= MAX_MODES; ++mode){
                sprintf(outputstr, "%24.6f",modes(i,mode)); 
                os << outputstr;
        }
        sprintf(outputstr,"\n");
        os << outputstr;
    }

    if (a != NULL) free(a);
    if (v != NULL) free(v);
    if (d != NULL) free(d);
    os.close();
                os.open("gnuplot-natural-mode-shapes.gpl",ios_base::out);
                os << "set title \"Machine \\n Mode Shapes\"" << endl;
                os << "set xlabel \"X\""<< endl;
                os << "set ylabel \"Deflections\" " << endl;
                sprintf(outputstr,"plot 'natural-mode-shapes.dat' using 1:2 title columnhead with lines,\\\n");
                os << outputstr;

                for(int i = 3; i < MAX_MODES; ++i){
                    sprintf(outputstr,"     'natural-mode-shapes.dat' using 1:%d title columnhead with lines,\\\n", i);
                    os << outputstr;
                }
                    sprintf(outputstr,"     'natural-mode-shapes.dat' using 1:%d title columnhead with lines\n", MAX_MODES);
                    os << outputstr;
                os.close();
                system("gnuplot -persist -e \"call 'gnuplot-natural-mode-shapes.gpl'\"");
    return 0;
}
