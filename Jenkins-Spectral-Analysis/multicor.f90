program multicor

        implicit none
        integer NS, N, MAXM
        real average

        real, allocatable, dimension(:) :: xm
        real, allocatable, dimension(:,:) :: x
        real, allocatable, dimension(:,:,:) :: cov, dcov
        character*8, allocatable, dimension(:) :: ident 
        character*256 filename
        integer i, j, k, L

        print*
        print*, "Input filename with series"
        print*
        read*, filename

        open(unit = 12, file = filename)
        read(12,*) NS, N, MAXM
        allocate(ident(NS), x(N,NS), xm(NS))

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
        deallocate(x, ident, xm)

end program

