program dft

   implicit none

   integer n, maxm, nf
   real delta, cossum, sinsum, pi
   integer k, M, I
   real freq, df, value, B, D, ai, bi
   character*64 str, filename
   real time_energy, frequency_energy

   parameter (pi = 3.14159)

   real, allocatable :: w(:), cov(:), spec(:)
      print*, "input signal filename"
      read*,filename
	  
      open(unit = 12, file = filename)

      read(12,*) str
      read(12,*) delta, N
      df = 1. / (2. * delta * N)
      allocate(w(0:N), spec(0:N), cov(0:N-1))
     
	  time_energy = 0.
      read(12,*) str
      do i = 0, N-1
         read(12,*) value
         cov(i) = value
		 time_energy = delta * value**2 + time_energy
      enddo
	     
      close(12)
      do k=0, N 
         w(k) = 0.5 * (1. + cos(pi * k / N))
      enddo

      open(unit = 12, file = "dft_output.dat")
	  frequency_energy = 0.
      write(12,'(A12A16)') "Freq(Hz)", "R(f)"
      do I=0, N 
         cossum = 0.
         sinsum = 0.
         do k=1, N 
            cossum = cossum + cov(k) * w(k) * cos(pi * k * i / N)
            sinsum = sinsum + cov(k) * w(k) * sin(pi * k * i / N)
         enddo
         ai = 2. * delta * (cov(0) + 2. * cossum) 
         bi = 2. * delta * 2. * sinsum  
         write(12,'(F12.4F16.8)') i*df, sqrt(ai**2 + bi**2) 
         frequency_energy = frequency_energy + (ai**2 + bi**2) * df
      enddo
	  close(12)

      deallocate(w, spec, cov)
	  print*
      write(*,*) "Parseval Equality:"
	  write(*,*) "Time Domain"
	  write(*,'(F12.4)') time_energy
	  write(*,*) "Freq Domain"
	  write(*,'(F12.4)') frequency_energy

end program
