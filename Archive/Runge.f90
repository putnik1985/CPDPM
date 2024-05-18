!  Runge.f90 
!
!  FUNCTIONS:
!	Runge      - Entry point of console application.
!
!	Example of displaying 'Hello World' at execution time.
!

!****************************************************************************
!
!  PROGRAM: Runge
!
!  PURPOSE:  Entry point for 'Hello World' sample console application.
!
!****************************************************************************

	program Runge

	integer n, i, nt, comp;
	real*4,allocatable::x0(:);
	real*4 dt;

	

	print*,'input a dimension of the result vector'
	read*,n
	allocate(x0(n));

	print*,' input vector of the initial condition' 

	do i = 1, n

	print*,'input x(',i,')'
	read*,x0(i)


	enddo

	print*,' please input time step'
	read*,dt

	print*,' please input number of steps'
	read*, nt

	print*,' please input component to extract'
	read*,comp

	call Runge1(dt,nt,n,x0,comp,12)

	deallocate(x0);

	end program Runge

