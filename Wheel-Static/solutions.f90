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


real function d1w1(phi)
        real phi
        real a, b
        common a, b
        d1w1 = a * sinh(a*phi) * cos(b*phi) - b * cosh(a*phi) * sin(b*phi)
end function

real function d2w1(phi)
        real phi, w1, w2
        real a, b
        common a, b
        d2w1 = (a**2 + b**2) * w1(phi) - 2*a*b*w2(phi)
end function

real function d3w1(phi)
        real phi, d1w1, d1w2
        real a, b
        common a, b
        d3w1 = (a**2 + b**2) * d1w1(phi) - 2*a*b*d1w2(phi)
end function

real function d4w1(phi)
        real phi, d1w1, d1w2
        real a, b
        common a, b
        d4w1 = (a**2 + b**2) * d2w1(phi) - 2*a*b*d2w2(phi)
end function

real function d1w2(phi)
        real phi
        real a, b
        common a, b
        d1w2 = a * cosh(a*phi) * sin(b*phi) + b * sinh(a*phi) * cos(b*phi)
end function

real function d2w2(phi)
        real phi, w1, w2
        real a, b
        common a, b
        d2w2 = (a**2 - b**2) * w2(phi) + 2*a*b*w1(phi)
end function

real function d3w2(phi)
        real phi, d1w1, d1w2
        real a, b
        common a, b
        d3w2 = (a**2 - b**2) * d1w2(phi) + 2*a*b*d1w1(phi)
end function

real function d4w2(phi)
        real phi, d2w1, d2w2
        real a, b
        common a, b
        d4w2 = (a**2 - b**2) * d2w2(phi) + 2*a*b*d2w1(phi)
end function

