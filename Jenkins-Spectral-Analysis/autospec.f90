program dft

   implicit none

   integer n, maxm, nf
   real delta, sum, pi
   integer k, M, I
   real freq, df, value, B, D
   character*64 str

   parameter (pi = 3.14159)

   real, allocatable :: w(:), cov(:), spec(:)
      
      open(unit = 12, file = 'covariance.dat')

      read(12,*) str
      read(12,*) delta, M, NF
      read(12,*) str
      read(12,*) n
      maxm = n - 1

      B = 4. / (3.*M*delta)
      D = (8. * N) / (3. * M)
      df = 1. / (2. * delta * NF)

      allocate(w(0:maxm), spec(0:NF), cov(0:maxm))

      read(12,*) str
      do i = 0, maxm
         read(12,*) value
         cov(i) = value
      enddo
      close(12)
      do k=0,maxm 
         w(k) = 0.5 * (1. + cos(pi * k / maxm))
      enddo

         write(*,'(A12A16)') "Freq(Hz)", "R(f)"
      do I=0, NF
         sum = 0.
         do k=1, M-1
            sum = sum + cov(k) * w(k) * cos(pi * k * i / nf)
         enddo
         spec(i) = 2. * delta * (cov(0) + 2. * sum) / cov(0)
         write(*,'(F12.4F16.8)') i*df, spec(i)
      enddo

      deallocate(w, spec, cov)

end program
