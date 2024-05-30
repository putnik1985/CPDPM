       SUBROUTINE form_ke(EJ,L,KE)

       implicit none
       double precision EJ, L 
       double precision KE(4,4)
       INTEGER I,J

       call mzero(4,KE)
       
       KE(1,1) = 12 * EJ / L**3
       KE(1,2) = 6 * EJ / L**2 
       KE(1,3) = -12 * EJ / L**3 
       KE(1,4) = 6 * EJ / L**2 

       KE(2,2) = 4 * EJ / L
       KE(2,3) = -6 * EJ / L**2
       KE(2,4) = 2 * EJ / L

       KE(3,3) = 12 * EJ /L**3
       KE(3,4) = -6 * EJ / L**2

       KE(4,4) = 4 * EJ / L
       
       DO I=1,4
          DO J=I,4
             KE(J,I)=KE(I,J)
          ENDDO ! DO J
       ENDDO !DO I
							 
       END SUBROUTINE form_ke 

       subroutine mzero(n,m)
        implicit none
        integer n, i, j
        real*8 m(n,n)
           do i=1,n
           do j=1,n
           m(i,j)=0.0
          enddo
          enddo
       end subroutine mzero

       subroutine vzero(n,m)
        implicit none
        integer n, i
        real*8 m(n)
           do i=1,n
           m(i)=0.0
          enddo
       end subroutine vzero

       subroutine append(i,j,KE,K,N)
        implicit none
        double precision KE(4,4)
        double precision K(N,N)
        integer r, c, N, i, j
        do r = 1,2 
         do c = 1,2 
         K(2*i-2+r,2*i-2+c) = K(2*i-2+r,2*i-2+c) + KE(r,c)
         K(2*i-2+r,2*j-2+c) = K(2*i-2+r,2*j-2+c) + KE(r,c+2)
         K(2*j-2+r,2*i-2+c) = K(2*j-2+r,2*i-2+c) + KE(r+2,c)
         K(2*j-2+r,2*j-2+c) = K(2*j-2+r,2*j-2+c) + KE(r+2,c+2)
         enddo
        enddo 

      end subroutine append

      subroutine apply_restraints(n, K, new_dimension)
        implicit none
        integer n, new_dimension
        double precision K(n,n)
        integer dof, i, j, constraints
        integer, allocatable :: var_to_remove(:)
        integer, allocatable :: transform(:)

        open(unit = 12, file = "Restraints.dat")
        read(12,*) constraints
           allocate(var_to_remove(constraints))
            do i=1, constraints
               read(12,*) dof
               var_to_remove(i) = dof
            enddo
        close(12)

        allocate(transform(n)) 
        do i=1, n
           transform(i) = i
        enddo
        call sort(constraints, var_to_remove)

        do i=1, constraints
           dof = transform(var_to_remove(i))
           call mshift(n, K, dof)
           transform(dof) = 0
           do j=dof + 1, n
              transform(j) = transform(j) - 1
           enddo
        enddo

        deallocate(var_to_remove)
        deallocate(transform)
        new_dimension = n - constraints
     end subroutine apply_restraints

     subroutine sort(n, a)
       implicit none
       integer n
       integer a(n)
       integer temp, i, j
 
       do i = 1, n-1
          do j = i + 1, n
             if (a(i) >  a(j)) then
                 temp = a(i)
                 a(i) = a(j)
                 a(j) = temp
              endif
          enddo
       enddo
     end subroutine sort

     subroutine mshift(n, K, dof)
      implicit none
      double precision K(n,n)
      integer n, i, j, dof

          do i = dof, n - 1
                K(i,:) = K(i+1,:)
                K(:,i) = K(:,i+1)
          enddo

     end subroutine mshift

     subroutine vshift(n, v, dof)
      implicit none
      double precision v(n)
      integer n, i, j, dof
          do i = dof, n - 1
             v(i) = v(i+1)
          enddo
     end subroutine vshift

     subroutine mprint(n, K)
      implicit none
      integer n
      double precision K(n,n)
      integer i, j
       do i = 1, n
          write(*,*) K(i,:)
       enddo
     end subroutine mprint

     subroutine vprint(n, a)
      implicit none
      integer n
      double precision a(n)
      write(*,*) a(:)
     end subroutine vprint 

     subroutine create_K(n, K, funit, en)
       implicit none
       integer funit
       integer en, n, i, j
       double precision K(n,n)
       double precision ke(4,4)
       integer node
       double precision L,EJ

       call mzero(n, K)
       do i=1, en
        read(funit,*) node, L, EJ
        call form_ke(EJ, L, ke)
        call append(node, node + 1, ke, K, n)
       enddo

     end subroutine create_K

     subroutine create_P(n, P_mean, P_ampl)
       integer n, i, j 
       double precision P_mean(n), P_ampl(n)
       double precision mean, ampl
       integer records, dof
       open(unit = 12, file = "Loads.dat")
       read(12,*) records
       do i=1, records
        read(12,*) dof, mean, ampl
        P_mean(dof) = mean
        P_ampl(dof) = ampl
       enddo
    end subroutine create_P

      subroutine remove_dofs(n, P, new_dimension)
        implicit none
        integer n, new_dimension
        double precision P(n)
        integer dof, i, j, constraints
        integer, allocatable :: var_to_remove(:)
        integer, allocatable :: transform(:)

        open(unit = 12, file = "Restraints.dat")
        read(12,*) constraints
           allocate(var_to_remove(constraints))
            do i=1, constraints
               read(12,*) dof
               var_to_remove(i) = dof
            enddo
        close(12)

        allocate(transform(n)) 
        do i=1, n
           transform(i) = i
        enddo
        call sort(constraints, var_to_remove)

        do i=1, constraints
           dof = transform(var_to_remove(i))
           call vshift(n, P, dof)
           transform(dof) = 0
           do j=dof + 1, n
              transform(j) = transform(j) - 1
           enddo
        enddo

        deallocate(var_to_remove)
        deallocate(transform)
        new_dimension = n - constraints
     end subroutine remove_dofs

      subroutine create_transform(n, transform)
        implicit none
        integer n, constraints, dof, i, j, global_dof
        integer transform(n)
        integer, allocatable :: var_to_remove(:)

        open(unit = 12, file = "Restraints.dat")
        read(12,*) constraints
           allocate(var_to_remove(constraints))
            do i=1, constraints
               read(12,*) dof
               var_to_remove(i) = dof
            enddo
        close(12)

        do i=1, n
           transform(i) = i
        enddo

        call sort(constraints, var_to_remove)

        do i=1, constraints
           global_dof = var_to_remove(i)
           dof = transform(global_dof)
           transform(global_dof) = 0
           do j = global_dof + 1, n
              transform(j) = transform(j) - 1
           enddo
        enddo

        deallocate(var_to_remove)
     end subroutine create_transform 
