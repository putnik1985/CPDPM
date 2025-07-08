program wheel
        implicit none
        real r, p, J, d, E
        integer n
        character*256 str

        real F, k, a, alpha, beta, Pi
        parameter (Pi = 3.14159)
        common alpha, beta
        real w1, w2
        write(*,*) "Wheel:"
        open(unit = 12, file = "wheel-input.dat")
        read(12,*) str, n
        read(12,*) str, r
        read(12,*) str, p
        read(12,*) str, J
        read(12,*) str, d
        read(12,*) str, E
        close(12)

        ! convert mm -> cm
        d = 0.1 * d
        F = Pi * d**2 / 4.
        k = E * F * n / (2. * Pi * r**2)
        a = sqrt(1. + r**4 * k / (E*J))
        alpha = sqrt((a - 1.) / 2.)
         beta = sqrt((a + 1.) / 2.)
        write(*,*) "Interstage calculations:" 
        write(*,'(A12,F12.2,A12,F12.4,A12,F12.4)') "a=",a, "alpha=", alpha, "beta=", beta
end program
