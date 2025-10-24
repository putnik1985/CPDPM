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
      read(12,*) delta, N, NF
      df = 1. / (2. * delta * NF)
      allocate(w(0:N), spec(0:NF), cov(0:N-1))
     
	  time_energy = 0.
      read(12,*) str
      do i = 0, N-1
         read(12,*) value
         cov(i) = value
	 time_energy = delta * value**2 + time_energy
      enddo
	     
      close(12)
      do k=0, N 
         w(k) = (1. - cos(2 * pi * k / (N - 1)))
      enddo

      open(unit = 12, file = "dft_output.dat")
      frequency_energy = 0.
      write(12,'(A12A16)') "Freq(Hz)", "R(f)"
      do I=0, NF 
         cossum = 0.
         sinsum = 0.
         do k=0, N-1 
            cossum = cossum + cov(k) * w(k) * cos(pi * k * i / NF)
            sinsum = sinsum - cov(k) * w(k) * sin(pi * k * i / NF)
         enddo
         ai = delta * cossum 
         bi = delta * sinsum  
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
