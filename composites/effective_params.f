        program effective
         implicit none
         external dgetrf

         character*256 string
         double precision E1, E2, E3
         double precision G12, G23, G13
         double precision Nu12, Nu13, Nu23
         double precision a1, a2, a3
         integer layers, i, j
         double precision phi
         double precision h
         integer file_unit
         integer info, lwork
         integer, parameter :: dim = 6
         integer, parameter :: block_size = 512
         integer IPIV(dim)
         double precision D(dim, dim), work(dim)
         double precision INV_D(dim, dim)
         file_unit = 8

          read(*,*) string
          write(*,*) "input file: ",string 
          open(unit = file_unit, file = string)
          read(file_unit, *) string
          read(file_unit, *) E1, E2, E3
          read(file_unit, *) string
          read(file_unit, *) G12, G23, G13
          read(file_unit, *) string
          read(file_unit, *) Nu12, Nu13, Nu23
          read(file_unit, *) string
          read(file_unit, *) a1, a2, a3
          read(file_unit, *) string
          read(file_unit, *) phi, layers, h

10        FORMAT(A12,E12.2,A12,E12.2,A12,E12.2) 
20        FORMAT(A12,F12.2,A12,F12.2,A12,F12.2) 
30        FORMAT(A12,F12.2,A12,I12,A12,F12.4) 
          write(*,10) "E1:",E1, "E2:", E2, "E3:", E3 
          write(*,10) "G12:", G12, "G23:", G23, "G13:", G13
          write(*,20) "Nu12:", Nu12, "Nu13:", Nu13, "Nu23:", Nu23
          write(*,10) "a1:", a1,"a2:", a2, "a3:",  a3
          write(*,30) "phi:", phi, "layers:", layers, "thickness:", h
          close(file_unit)

          D(1,1) = 1./E1; D(1,2) = -Nu12/E2; D(1,3) = -Nu13/E3
          D(1,4) = 0.; D(1,5) = 0.; D(1,6) = 0.

          D(2,1) = -Nu12 / E1; D(2,2) = 1. / E2; D(2,3) = -Nu23 / E3
          D(2,4) = 0.;  D(2,5) = 0.; D(2,6) = 0.

          D(3,1) = -Nu13/E1; D(3,2) = -Nu23 / E2; D(3,3) = 1. / E3
          D(3,4) = 0.; D(3,5) = 0.; D(3,6) = 0.

          D(4,1) = 0.; D(4,2) = 0.; D(4,3) = 0.
          D(4,4) = 1. / (2*G12); D(4,5) = 0.; D(4,6) = 0.

          D(5,1) = 0.; D(5,2) = 0.; D(5,3) = 0.
          D(5,4) = 0.; D(5,5) = 1. / (2*G13); D(5,6) = 0. 
 
          D(6,1) = 0.; D(6,2) = 0.; D(6,3) = 0.
          D(6,4) = 0.; D(6,5) = 0.; D(6,6) = 1. / (2*G23)

          do i = 1, dim
           do j = 1, dim
              INV_D(i,j) = D(i,j)
           enddo
          enddo

          write(*,*)
          write(*,*)
          call print_matrix(dim, D)
          write(*,*)
          write(*,*)

          call dgetrf(dim, dim, INV_D, dim, IPIV, info)
          lwork = block_size 
          call dgetri(dim, INV_D, dim, IPIV, work, lwork, info)
cccc      matrix INV_D contains stiffnesses lambda for the effective characteristic calculations
          if (info .eq. 0) then  
              call print_matrix(dim, INV_D)
          else
              write(*,*) "can not invert matrix"
          end if

        end program effective


        subroutine print_matrix(n, a)
          implicit none
          integer n
          double precision a(n,n)
          integer i, j
          do i=1,n
           write(*,'(6E18.6)') a(i,:)
          enddo
        end subroutine
