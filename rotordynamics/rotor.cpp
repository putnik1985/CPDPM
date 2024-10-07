
#include "rotor.h"

int rotor::append(const linear_bearing& lbr){

    if (nodes == 0) {
        nodes = 1;
        M = Matrix<double>( 4 * nodes);
        K = Matrix<double>( 4 * nodes);
        G = Matrix<double>( 4 * nodes);
    }

    unsigned int dofs = 2;
    for(int i = 1; i <= dofs; ++i)
        for(int j = 1; j <= dofs; ++j){
            M(4*(nodes - 1) + i, 4*(nodes - 1) + j) += lbr.M(i,j);
            K(4*(nodes - 1) + i, 4*(nodes - 1) + j) += lbr.K(i,j);
        } 
    return 0;
}

int rotor::append(const disk& d){

    if (nodes == 0) {
        nodes = 1;
        M = Matrix<double>( 4 * nodes);
        K = Matrix<double>( 4 * nodes);
        G = Matrix<double>( 4 * nodes);
    }

    unsigned int dofs = 4;
    for(int i = 1; i <= dofs; ++i)
        for(int j = 1; j <= dofs; ++j){
            M(4*(nodes - 1) + i, 4*(nodes - 1) + j) += d.M(i,j);
            K(4*(nodes - 1) + i, 4*(nodes - 1) + j) += d.K(i,j);
            G(4*(nodes - 1) + i, 4*(nodes - 1) + j) += d.G(i,j);
        } 
    return 0;
}

int rotor::append(const uniform_shaft& us){

    if (nodes == 0) {
        nodes = 1;
        M = Matrix<double>(4 * nodes);
        K = Matrix<double>(4 * nodes);
        G = Matrix<double>(4 * nodes);
    }

    M.set_dimension(4 * nodes + 4); // additional nodes has 4 dofs
    K.set_dimension(4 * nodes + 4); // additional nodes has 4 dofs
    G.set_dimension(4 * nodes + 4); // additional nodes has 4 dofs

    unsigned int n1 = nodes;
    unsigned int n2 = ++nodes;

    unsigned int dofs = 8;
    vector<unsigned int> transform;

    for(int i = 1; i <= 4; ++i){
        transform.push_back(4*(n1 - 1) + i);
    }

    for(int i = 1; i <= 4; ++i){
        transform.push_back(4*(n2 - 1) + i);
    }
 
    for(int i = 1; i <= dofs; ++i)
        for(int j = 1; j <= dofs; ++j){
            unsigned int gi = transform[i-1];
            unsigned int gj = transform[j-1];
            M(gi, gj) += us.M(i,j);
            K(gi, gj) += us.K(i,j);
            G(gi, gj) += us.G(i,j);
        }
    return 0;
}
