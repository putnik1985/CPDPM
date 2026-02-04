
#include "machine.h"

int machine::append(const component& cmp){

    if (nodes == 0) {
        nodes = 2;
        M = Matrix<double>( nodes);
        K = Matrix<double>( nodes);
        D = Matrix<double>( nodes);
        G = Matrix<double>( nodes);
    }

    M.set_dimension(nodes + 1);
    K.set_dimension(nodes + 1);
    D.set_dimension(nodes + 1);

    unsigned int dofs = 2;
    for(int i = 1; i <= dofs; ++i)
        for(int j = 1; j <= dofs; ++j){
            M(nodes - 1 + i, nodes + j) += cmp.M(i,j);
            K(nodes - 1 + i, nodes + j) += cmp.K(i,j);
            D(nodes - 1 + i, nodes + j) += cmp.D(i,j);
        } 
    return 0;
}

int machine::append(const lumped_mass& d){

    if (nodes = 0) {
        nodes = 1;
        M = Matrix<double>( nodes);
        K = Matrix<double>( nodes);
        D = Matrix<double>( nodes);
    }

    M(nodes,nodes) = d.M(1,1);
    return 0;
}

