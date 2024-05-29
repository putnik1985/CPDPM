program shaft
 implicit none
 double precision, allocatable::K(:,:)
 double precision, allocatable::P_mean(:), P_ampl(:)
 integer n, ne
 double precision, allocatable::u_mean(:), u_ampl(:)

 open(unit = 12, file = "Elements.dat")
 read(12,*) ne
 n = 2 * (ne+1)
 allocate(K(n,n), P_mean(n), P_ampl(n), u_mean(n), u_ampl(n))
 call create_K(n, K, 12, ne)
 close(12)

 call create_P(n, P_mean, P_ampl)
 call vprint(n, P_mean)
 write(*,*) 
 call vprint(n, P_ampl)
 deallocate(K, P_mean, P_ampl)

end program shaft
