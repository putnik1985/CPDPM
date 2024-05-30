program shaft
 implicit none
 double precision, allocatable::K(:,:), K_reduced(:,:)
 double precision, allocatable::P_mean(:), P_ampl(:)
 double precision, allocatable::P_mean_reduced(:), P_ampl_reduced(:)
 integer n, ne, new_dim, i, j
 double precision, allocatable::u_mean(:), u_ampl(:)
 integer, allocatable :: transform(:)

 open(unit = 12, file = "Elements.dat")
 read(12,*) ne
 n = 2 * (ne+1)
 allocate(K(n,n), P_mean(n), P_ampl(n), u_mean(n), u_ampl(n))
 call create_K(n, K, 12, ne)
!!!!!!!!!!!!!!!!!!!!!!!!!!!! call mprint(n, K)
 close(12)

 call create_P(n, P_mean, P_ampl)
!!!!!!!!!!!!!!! call vprint(n, P_mean)
 write(*,*) 
!!!!!!!!!!!!!!!!! call vprint(n, P_ampl)
 allocate(transform(n))
 call create_transform(n, transform)

      do i=1, n
       write(*,*) i," --->> ", transform(i)
      enddo
 write(*,*)

 call apply_restraints(n, K, new_dim)
 call remove_dofs(n, P_mean, new_dim)
 call remove_dofs(n, P_ampl, new_dim)

 allocate(K_reduced(new_dim, new_dim))
 allocate(P_mean_reduced(new_dim), P_ampl_reduced(new_dim))

  do i=1, new_dim
   do j=1, new_dim
    K_reduced(i,j) = K(i,j)
   enddo
    P_mean_reduced(i) = P_mean(i)
    P_ampl_reduced(i) = P_ampl(i)
  enddo 

 call mprint(new_dim, K_reduced)
 write(*,*)
 call vprint(new_dim, P_mean_reduced)
 call vprint(new_dim, P_ampl_reduced)

 deallocate(K, P_mean, P_ampl)
 deallocate(K_reduced)
 deallocate(P_mean_reduced, P_ampl_reduced)
 deallocate(transform)
end program shaft
