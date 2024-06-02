program shaft
 implicit none
 double precision, allocatable::K(:,:), K_reduced(:,:)
 double precision, allocatable::P_mean(:), P_ampl(:)
 double precision, allocatable::P_mean_reduced(:), P_ampl_reduced(:)
 integer n, ne, new_dim, i, j
 double precision, allocatable::u_mean(:), u_ampl(:)
 double precision, allocatable::B(:,:)
 integer lda, ldb, info, nrhs
 integer, allocatable :: transform(:)
 double precision u, v

 open(unit = 12, file = "Elements.dat")
 read(12,*) ne
 n = 2 * (ne+1)
 allocate(K(n,n), P_mean(n), P_ampl(n), u_mean(n), u_ampl(n))
 call create_K(n, K, 12, ne)
 close(12)

 call create_P(n, P_mean, P_ampl)
 allocate(transform(n))
 call create_transform(n, transform)

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

 allocate(B(new_dim, 2))

       B(:,1) = P_mean_reduced 
       B(:,2) = P_ampl_reduced
       nrhs = 2
       lda  = new_dim
       ldb  = new_dim
       call dposv('U', new_dim, nrhs, K_reduced, lda, B, ldb, info) 
       call vzero(n, u_mean)
       call vzero(n, u_ampl)

       do i = 1, new_dim
        u = B(i,1)
        v = B(i,2)
          j = 1
          do while (transform(j) .ne. i)
            j = j + 1
          enddo
          u_mean(j) = u 
          u_ampl(j) = v
       enddo

 call write_solution(n, u_mean, 1, 6)
 call write_solution(n, u_ampl, 2, 7)
 call write_shaft_loads(n, u_mean, 1, 8)
 call write_shaft_loads(n, u_ampl, 2, 9)


 call create_geometry(nodes, geometry)
 allocate(M_mean(nodes), M_ampl(nodes))
 allocate(stress_mean(nodes), stress_ampl(nodes))

 call create_stress(nodes, M_mean, stress_mean)
 call create_stress(node, M_ampl, stress_ampl)
 call create_fillets(nodes, fillets, geometry)
 call creat_holes(nodes, holes, geometry)
 call include_Kt(nodes, stress_ampl, fillets, holes)
 
 node = max_stress_node(nodes,stress_ampl)
 write(*,*) "Max stress amplitude at node: ", node, stress_ampl(node)
 s_mean = stress_mean(node)
 s_ampl = stress_ampl(node)

 equiv_stress = equiv(s_mean, s_ampl, SU)
 call read_fatigue(B, C)

 write(*,*) "cycles: ", cycles(equiv_stress, B, C)

 deallocate(K, P_mean, P_ampl)
 deallocate(K_reduced)
 deallocate(P_mean_reduced, P_ampl_reduced)
 deallocate(transform)
 deallocate(B)
end program shaft
