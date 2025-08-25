program multicor

        implicit none
        integer NS, N, MAXM
        real average

        real, allocatable, dimension(:) :: xm
        real, allocatable, dimension(:,:) :: x
        real, allocatable, dimension(:,:,:) :: cov, dcov, cor, dcor
        character*8, allocatable, dimension(:) :: ident 
        character*256 filename
        integer i, j, k, L

        print*
 !!       print*, "Input filename with series"
        print*, "Input filename with series"
        print*
        read*, filename

        open(unit = 12, file = filename)
        read(12,*) NS, N
        MAXM = N - 1 

        allocate(ident(NS), x(N,NS), xm(NS))
        allocate(cov(0:MAXM,NS,NS))

        read(12,*) ident(:)
        do i=1,N
           read(12,*) x(i,:)
        enddo
        close(12)

         do i=1, N
           write(*,*) x(i,:)
        enddo
        
        print*
        do j=1,NS
           xm(j) = average(N, x(:,j))
           write(*,*) "Serie: ", ident(j), "Average: ", xm(j)
        enddo

        do j=1,NS
           do i=1, N
              x(i,j) = x(i,j) - xm(j)
           enddo
        enddo

        print*
        print*,"Normalized series:"
        do i=1, N
           write(*,*) x(i,:)
        enddo

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
              
        print*
        print*,"Covariance:"
        do k=0,MAXM+1
           write(*,*) k, cov(k,1,:)
        enddo

        deallocate(x, ident, xm, cov)
end program

