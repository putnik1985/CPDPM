program modal
        implicit none
        character*256 string
        character*256 mass_file, stiff_file
        integer N
        integer I, J

        real, allocatable, dimension(:,:) :: M, K
        real, allocatable, dimension(:,:) :: Evec
		real, allocatable, dimension(:) :: Eval

        real PI 
        parameter (PI=3.14159)
		
        mass_file = "mass.txt"
        stiff_file = "stiffness.txt"

      print*,' ------------------------------------------------------------------------ '
	  print*,' Input Data'
      print*,' ------------------------------------------------------------------------ '
      print*
        write(*,*) "mass = ", mass_file
        write(*,*) "stif = ", stiff_file
		
        open(unit = 12, file = mass_file)
        read(12,*) string 
        read(12,*) N

        allocate(M(N,N))
           DO I = 1, N
              read(12, *) M(I,:)
           ENDDO
        close(12)

        open(unit = 12, file = stiff_file)
        read(12,*) string 
        read(12,*) N

        allocate(K(N,N))
           DO I = 1, N
              read(12, *) K(I,:)
           ENDDO
        close(12)

      print*
      print*,' ------------------------------------------------------------------------ '
	  print*,' Spatial Model'
      print*,' ------------------------------------------------------------------------ '
      print*

        print*, "Mass Matrix:"
           DO I = 1, N
              write(*, *) M(I,:)
           ENDDO
        print*,""
		
        print*, "Stiffness Matrix:"
           DO I = 1, N
              write(*, *) K(I,:)
           ENDDO

        allocate(Eval(N), Evec(N,N))
		
      print*
      print*,' ------------------------------------------------------------------------ '
	  print*,' Calculations'
      print*,' ------------------------------------------------------------------------ '
      print*		
      call EigV(N, M, K, Eval, Evec)
      print*
  
      print*
      print*,' ------------------------------------------------------------------------ '
	  print*,' Modal Model'
      print*,' ------------------------------------------------------------------------ '
      print*

		print*
		print*,"Frequencies: ", N
        Do I = 1, N
		   print*, sqrt(1. / Eval(i)) / ( 2. * PI);
		ENDDO

		print*
		print*,"Eigenvectors:", N
        Do I = 1, N
		   print*, Evec(i,:)
		ENDDO

        deallocate(M, K)
        deallocate(Eval, Evec)

end program
