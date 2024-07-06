program rectangular_beam
  implicit none
  character*256 string
  double precision E1, E2, E3
  double precision G12, G23, G13
  double precision Nu12, Nu13, Nu23
  integer layers
  integer file_unit
  double precision params(9)
  double precision, allocatable::A(:,:)

  double precision, allocatable::K(:,:), K_reduced(:,:)
  double precision, allocatable::P(:)
  double precision, allocatable::P_reduced(:)
  integer n, ne, new_dim, i, j
  double precision, allocatable::u(:)
  double precision u1
  integer lda, ldb, info, nrhs
  integer, allocatable :: transform(:)
  integer nodes, node


         file_unit = 8

          read(*,*) string
          write(*,*) "input file: ",string 
          open(unit = file_unit, file = string)
          read(file_unit, *) string
          read(file_unit, *) layers
          allocate(A(layers, 5))
          
          do i = 1, layers
             read(file_unit, *) string
             read(file_unit, *) E1, E2, E3, Nu12, Nu13, Nu23, G12, G13, G23
             params(1) = E1
             params(2) = E2
             params(3) = E3
             params(4) = Nu12
             params(5) = Nu13
             params(6) = Nu23
             params(7) = G12
             params(8) = G13
             params(9) = G23
             call create_layers(layers, A, params, i)
          enddo


         open(unit = 12, file = "Elements.dat")
         read(12,*) ne
         n = 2 * (ne+1)
         allocate(K(n,n), P(n), u(n))
         call create_composite_K(n, K, 12, layers, A, ne)
         close(12)

         call create_P_composite(n, P)
         allocate(transform(n))
         call create_transform(n, transform)

         call apply_restraints(n, K, new_dim)
         call remove_dofs(n, P, new_dim)

         allocate(K_reduced(new_dim, new_dim))
         allocate(P_reduced(new_dim))

  do i=1, new_dim
   do j=1, new_dim
    K_reduced(i,j) = K(i,j)
   enddo
    P_reduced(i) = P(i)
  enddo 
       call print_matrix(new_dim, K_reduced)
       nrhs = 1
       lda  = new_dim
       ldb  = new_dim
       call dposv('U', new_dim, nrhs, K_reduced, lda, P_reduced, ldb, info) 
       call vzero(n, u)

       do i = 1, new_dim
        u1 = P_reduced(i)
          j = 1
          do while (transform(j) .ne. i)
            j = j + 1
          enddo
          u(j) = u1 
       enddo
      call write_solution_composite(n, u, 6)
      call write_shaft_loads_composite(n, u, 8, layers, A)

 deallocate(K, P)
 deallocate(K_reduced)
 deallocate(P_reduced)
 deallocate(transform)
 deallocate(A)

end program rectangular_beam

subroutine create_layers(n, A, params, layer)

  implicit none
  double precision E1, E2, E3
  double precision G12, G23, G13
  double precision Nu12, Nu13, Nu23
  double precision Nu21, Nu31, Nu32
  integer layers, i, j, n, layer
  integer info, lwork
  integer, parameter :: dim = 6
  integer, parameter :: block_size = 512
  integer IPIV(dim)
  double precision D(dim, dim), work(dim)
  double precision C(dim, dim)
  double precision A(n,5)
  double precision params(9)
  double precision A11, A15, A51, A55, A66

  double precision l1111, l1122, l1133, l1112, l1123, l1131
  double precision l2211, l2222, l2233, l2212, l2223, l2231
  double precision l3311, l3322, l3333, l3312, l3323, l3331
  double precision l1211, l1222, l1233, l1212, l1223, l1231
  double precision l2311, l2322, l2333, l2312, l2323, l2331
  double precision l3111, l3122, l3133, l3112, l3123, l3131


          E1 = params(1)
          E2 = params(2)
          E3 = params(3)
          Nu12 = params(4)
          Nu13 = params(5)
          Nu23 = params(6)
           G12 = params(7)
           G13 = params(8)
           G23 = params(9)

          Nu21 = Nu12 * E1 / E2
          Nu31 = Nu13 * E1 / E3
          Nu32 = Nu23 * E2 / E3

          D(1,1) = 1./E1; D(1,2) = -Nu12/E2; D(1,3) = -Nu13/E3
          D(1,4) = 0.; D(1,5) = 0.; D(1,6) = 0.

          D(2,1) = -Nu21 / E1; D(2,2) = 1. / E2; D(2,3) = -Nu23 / E3
          D(2,4) = 0.;  D(2,5) = 0.; D(2,6) = 0.

          D(3,1) = -Nu31/E1; D(3,2) = -Nu32 / E2; D(3,3) = 1. / E3
          D(3,4) = 0.; D(3,5) = 0.; D(3,6) = 0.

          D(4,1) = 0.; D(4,2) = 0.; D(4,3) = 0.
          D(4,4) = 1. / (2*G12); D(4,5) = 0.; D(4,6) = 0.

          D(5,1) = 0.; D(5,2) = 0.; D(5,3) = 0.
          D(5,4) = 0.; D(5,5) = 1. / (2*G23); D(5,6) = 0. 
 
          D(6,1) = 0.; D(6,2) = 0.; D(6,3) = 0.
          D(6,4) = 0.; D(6,5) = 0.; D(6,6) = 1. / (2*G13)

          do i = 1, dim
           do j = 1, dim
              C(i,j) = D(i,j)
           enddo
          enddo

          call dgetrf(dim, dim, C, dim, IPIV, info)
          lwork = block_size 
          call dgetri(dim, C, dim, IPIV, work, lwork, info)


          l1111 = C(1,1)
          l1122 = C(1,2)
          l1133 = C(1,3)
          l1112 = C(1,4)
          l1123 = C(1,5)
          l1131 = C(1,6)

          l2211 = C(2,1)
          l2222 = C(2,2)
          l2233 = C(2,3)
          l2212 = C(2,4)
          l2223 = C(2,5)
          l2231 = C(2,6)

          l3311 = C(3,1)
          l3322 = C(3,2)
          l3333 = C(3,3)
          l3312 = C(3,4)
          l3323 = C(3,5)
          l3331 = C(3,6)

          l1211 = C(4,1)
          l1222 = C(4,2)
          l1233 = C(4,3)
          l1212 = C(4,4)
          l1223 = C(4,5)
          l1231 = C(4,6)

          l2311 = C(5,1)
          l2322 = C(5,2)
          l2333 = C(5,3)
          l2312 = C(5,4)
          l2323 = C(5,5)
          l2331 = C(5,6)

          l3111 = C(6,1)
          l3122 = C(6,2)
          l3133 = C(6,3)
          l3112 = C(6,4)
          l3123 = C(6,5)
          l3131 = C(6,6)

          A11 = l1111 + l1122 * (l2233 * l3311 - l3333 * l2211) / (l2222 * l3333 - l2233**2) +& 
                l1133 * (l3322 * l2211 - l2222 * l3311) / (l2222 * l3333 - l2233**2)
          A15 = l1131 + l1122 * (l2233 * l3331 - l3333 * l2231) / (l2222 * l3333 - l2233**2) +&
                l1133 * (l3322 * l2231 - l2222 * l3331) / (l2222 * l3333 - l2233**2)
          A51 = A15
          A55 = l3131 + l3122 * (l2233 * l3331 - l3333 * l2231) / (l2222 * l3333 - l2233**2) +&
                l3133 * (l3322 * l2231 - l2222 * l3331) / (l2222 * l3333 - l2233**2)
          A66 = (l1212 * l2323 - l1223**2) / l2323  

          A(layer,1) = A11
          A(layer,2) = A15
          A(layer,3) = A51
          A(layer,4) = A55
          A(layer,5) = A66


end subroutine create_layers


subroutine print_matrix(n, a)
  implicit none
  integer n
  double precision a(n,n)
  integer i, j
    do i=1,n
     write(*,'(6E18.6)') a(i,:)
    enddo
end subroutine
