real function w1(phi)
        real phi
        real a, b
        common a, b
        w1 = cosh(a*phi) * cos(b*phi)
end function

real function w2(phi)
        real phi
        real a, b
        common a, b
        w2 = sinh(a*phi) * sin(b*phi)
end function
