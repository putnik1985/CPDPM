real function K0(alpha, x)
        real alpha
        real x
        K0 = (1./2.) * (cosh(alpha*x) + cos(alpha*x))
        return
end function K0

real function K1(alpha, x)
        real alpha
        real x
        K1 = (1./(2.*alpha)) * (sinh(alpha*x) + sin(alpha*x))
        return
end function K1

real function K2(alpha, x)
        real alpha
        real x
        K2 = (1./(2.*alpha**2))* (cosh(alpha*x) - cos(alpha*x))
        return
end function K2

real function K3(alpha, x)
        real alpha
        real x
        K3 = (1./(2.*alpha**3)) * (sinh(alpha*x) - sin(alpha*x))
        return
end function K3
