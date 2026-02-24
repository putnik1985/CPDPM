program integration
        real f, sum, a, b
        real, dimension(6) :: weight
        real, dimension(6) :: point

        integer n, i
        parameter (n=6)
        ! number of integration point in Gauss

        weight(1) = 0.1713244924
        weight(2) = 0.1713244924

        weight(3) = 0.3607615730
        weight(4) = 0.3607615730

        weight(5) = 0.4679139346
        weight(6) = 0.4679139346

         point(1) = -0.9324695142
         point(2) =  0.9324695142

         point(3) = -0.6612093865
         point(4) =  0.6612093865

         point(5) = -0.2386191861
         point(6) =  0.2386191861

         print*, "Please input integration limits"
         read*, a, b

         do i=1,n
            sum = sum + weight(i) * f((b-a)/2. * point(i) + (a+b)/2.) * (b-a)/2.
         enddo
         
         write(*,'(A24)') "Integration Limits:"
         write(*,'(F12.4,F12.4)') a, b
         !!!!print*, a,b
         print*
         write(*,'(A24)') "Integral Value:"
         write(*,'(F24.4)') sum
end program
