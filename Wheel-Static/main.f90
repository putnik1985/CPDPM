program wheel
        implicit none
        real r, p, J, d, E
        integer n
        character*256 str

        real F, k, a, alpha, beta, Pi
        parameter (Pi = 3.14159)
        common alpha, beta
        real w1, w2, d1w1, d1w2, d2w1, d2w2, d3w1, d3w2
        real C0, C1, C2
        real Q, M
        real, allocatable:: T(:,:)
        real, allocatable:: b(:)

        integer i, sectors
        real phi

        !write(*,*) "Wheel:"
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
        !!!write(*,*) "Interstage calculations:" 
        !!!!write(*,'(A12,F12.2,A12,F12.4,A12,F12.4)') "a=",a, "alpha=", alpha, "beta=", beta
        write(*,'(A12,A12,A12,A12,A12)') "Angle,deg", "Disp, cm", "Rotat, rad", "Q, kgs", "M, kgs.cm"
        C2 = ( p * R**3 / (E*J) ) / (d3w2(Pi) + d1w2(Pi) - d1w2(Pi) / d1w1(Pi) * (d3w1(Pi) + d1w1(Pi)))
        C1 = -C2 * d1w2(Pi) / d1w1(Pi)
        C0 = -C1 * w1(Pi) - C2 * w2(Pi)
        sectors = 60
        do i = 0, sectors
           phi = -Pi + i * 2 * Pi / sectors
           Q = E*J/R**3 * (C1 * (d3w1(phi) + d1w1(phi)) + C2 * (d3w2(phi) + d1w2(phi)))
           M = - E*J/R**2 * (C1 * (d2w1(phi) + w1(phi)) + C2 * (d2w2(phi) + w2(phi)))
           write(*, 100) (phi + Pi) * 180 / Pi, C0 + C1 * w1(phi) + C2 * w2(phi), C1 * d1w1(phi) + C2 * d1w2(phi), Q, M
        enddo   
100     Format(F12.2,F12.3,F12.6,F12.2,F12.2)
end program
