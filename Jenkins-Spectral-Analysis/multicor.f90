program multicor

        implicit none
        integer NS, N, MAXM
        real average, delta

        real, allocatable, dimension(:) :: xm
        real, allocatable, dimension(:,:) :: x
        real, allocatable, dimension(:,:,:) :: cov, dcov, cor, dcor
        character*8, allocatable, dimension(:) :: ident 
        character*256 filename, titles
        integer i, j, k, L

        common /data/ delta

        print*
 !!       print*, "Input filename with series"
        print*, "Input delta"
        read*, delta
        print*, "Input filename with series"
        print*
        read*, filename

        open(unit = 12, file = filename)
        read(12,*) titles
        read(12,*) NS, N
        MAXM = N - 1 

        allocate(ident(NS), x(N,NS), xm(NS))
        allocate(cov(0:MAXM+1,NS,NS), dcov(0:MAXM, NS, NS))
        allocate(cor(0:MAXM,NS,NS), dcor(0:MAXM, NS, NS))

        read(12,*) ident(:)
        do i=1,N
           read(12,*) x(i,:)
        enddo
        close(12)

        call output_vector(8, N, NS, x, ident, "series.dat")  

        do j=1,NS
           xm(j) = average(N, x(:,j))
           print*, xm(j)
        enddo

        do j=1,NS
           do i=1, N
              x(i,j) = x(i,j) - xm(j)
           enddo
        enddo


        call output_vector(9, N, NS, x, ident, "norm-series.dat")  

        do j=1,NS
           do L=1,NS
              do k=0,MAXM+1
                 cov(k,j,L) = 0.
                 do i=1,N-k
                    cov(k,j,L) = cov(k,j,L) + x(i,j) * x(i+k,L)
                 enddo
                 cov(k,j,L) = cov(k,j,L) / N
              enddo
            enddo
        enddo
              
        do j=1,NS
           do L=1,NS
              do k=0,MAXM
                 dcov(k,j,L) = -cov(k-1, j,L) + 2*cov(k,j,L)-cov(k+1,J,L)
              enddo
            enddo
        enddo

        do j=1,NS
           do L=1,NS
              do k=0,MAXM
                 cor(k,j,L) = cov(k,j,L) / sqrt(cov(0,j,j) * cov(0,L,L)) 
                 dcor(k,j,L) = dcov(k,j,L) / sqrt(dcov(0,j,j) * dcov(0,L,L)) 
              enddo
            enddo
        enddo

        call output(12, MAXM+1, NS, cov, "covariance.dat")
        call output(14, MAXM, NS, dcov, "diff-covariance.dat")
        call output(16, MAXM, NS, cor, "correlation.dat")
        call output(24, MAXM, NS, dcor, "diff-correlation.dat")

        deallocate(x, ident, xm, cov, dcov, cor, dcor)
end program

subroutine output(unit1, MAXM, NS, cov, filename)
        integer MAXM, NS, j, L, unit1
        character*256 filename
        real, dimension(0:MAXM, NS, NS) :: cov
        real delta
        common /data/ delta

        open(unit = unit1, file = filename)
        write(unit1,"(A15)") "Delta"
        write(unit1,'(F15.6)') delta
        write(unit1,"(A15)") "N"
        write(unit1,'(I15)') MAXM+1

        do j=1,NS
           do L=1,NS
              write(unit1,"(A12I1I1A1)", advance = "no") "COV(",j,L,")"
           enddo
        enddo
        write(unit1,*) 
              do k=0,MAXM
                 do j=1,NS
                    do L=1,NS
                       write(unit1,'(F15.2)', advance = "no") cov(k,j,L)
                    enddo
                 enddo   
                 write(unit1,*) 
              enddo
        close(unit1)

end subroutine

subroutine output_vector(unit, N, NS, x, ident, filename)
         implicit none
         integer i, N, unit, j, NS
         real, dimension(N, NS) :: x
         character*8, dimension(NS) :: ident
         character*256 filename
   
          
         open(unit = unit, file = filename)
         write(unit, '(A12)', advance="no") "Lug"
         do j=1, NS
           write(unit, '(A12)', advance = "no") ident(j)
         enddo
         write(unit,*)

         do i=1, N
           write(unit,'(I12)', advance = "no") i
           do j=1,NS
              write(unit,'(F12.2)', advance = "no") x(i,j)
           enddo
           write(unit,*)
        enddo

end subroutine
