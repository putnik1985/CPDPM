      function average(n, x)
              implicit none
              integer n, i
              real x(n)
              real average

              average = 0.
                 do i=1,n
                    average = average + x(i)
                 enddo
                 average = average / n
      end function average

      !!! Eigen Values Ax-l*Bx=0 B is positive defined
      subroutine EigV(N,A,B,Eval,Evec)
      integer N, NL, i, j, p, r,iterations,ip,error,k,l
      real A(N,N),Eval(N),Evec(N,N),sum1,Maximum
      real B(N,N) 
      byte Sym, check, Ortogonality
      common /PREC/ TOL, MAX_NUM
      real TOL, MAX_NUM, ep,Det,Minimum

        integer Modes
        common /Tones/ Modes

      print*
      print*,' Solve (A-l*B)X = 0 Eigenvalue problem'
	  print*,' B is positive defined'
      print*



	  
      call Jacobi_Transformation(N,B,Eval,Evec)
      call Normirovka(N,Eval,Evec)

      do i=1,N
         do j =1,N
         B(i,j) =0.0
         do k=1,N
            do l=1,N
            B(i,j) = B(i,j) + Evec(k,i) * A(k,l) * Evec(l,j)
            enddo
         enddo
         enddo
      enddo
      call Eqval(N,B,A)

      call Jacobi_Transformation(N,A,Eval,B)

      do i=1,N
         do j =1,N
             A(i,j)=0.0
             do k = 1, N
             A(i,j) = A(i,j) + Evec(i,k)*B(k,j) 
             enddo      
         enddo
      enddo
      call Eqval(N,A,Evec)
      call Normirovka(N,Eval,Evec)


 
      end subroutine EigV

      subroutine Jacobi_Transformation(N,A,Eval,Evec)
      integer N, NL, i, j, p, r,iter,ip,MaxIter
      real A(N,N),Eval(N),Evec(N,N),sum1
      real epsilon1,teta,Maximum,Arctg,Maximum2
      real app, arr, apr,air,aip,x,y,s,c
        common /PREC/ TOL, MAX_NUM
        real TOL, MAX_NUM
      real PI
      Parameter (epsilon1=0.000000000001, PI=3.14159)
      byte check,Ortogonality

      call Matrix_E(N,Evec)


       MaxIter = N
       Maximum2 = 0.0
       iter = 0
       do while(.true.)

       call Max_Diagonal(N,A,p,r,Maximum)

       if (p.ge.r) then 
                   print*,'error#1 in the Jacoby algorithm'
                   stop
                   endif
       if (abs(Maximum).eq.0.0) then
                                goto 100
                                endif


        teta = 0.5*Arctg(2*A(p,r),A(r,r) - A(p,p))

        if (teta.gt.PI/4.0) then
                            teta = teta - 0.5*PI
                            endif


        if (teta.lt.-PI/4.0) then
                            teta = teta + 0.5*PI
                            endif

        x = abs(2*A(p,r))
        if (teta.lt.0) then 
                       x = -x
                       endif
        y = abs(A(r,r) - A(p,p)) 
        call Jacobi_Calculations(x, y, s, c)

        app = A(p,p)
        arr = A(r,r)       
        apr = A(p,r)

        A(p,p) = app*c**2-2*c*s*apr+arr*s**2
        A(r,r) = app*s**2+2*c*s*apr+arr*c**2

        A(p,r) = s*c*(app-arr)+apr*(c**2-s**2)
        A(r,p) = s*c*(app-arr)+apr*(c**2-s**2)

        A(p,r) = 0.0
        A(r,p) = A(p,r)

       
        do i=1,N

        if ((i.ne.p).and.(i.ne.r)) then

                                   aip = A(i,p)
                                   air = A(i,r)

                                   A(i,p) = c*aip - s*air
                                   A(i,r) = s*aip + c*air

                                   A(p,i) = A(i,p)
                                   A(r,i) = A(i,r)

                                   endif


        aip = Evec(i,p)
        air = Evec(i,r)

        Evec(i,p) = c*aip - s*air
        Evec(i,r) = s*aip + c*air

        enddo

      enddo

      !normirovka vectorov
100   do i=1,N
      Eval(i)=A(i,i) 
      enddo

      print*
      print*,' Jacobi Transformation:'
      print*,' Maximum off diagonal',Maximum
 
      end subroutine Jacobi_Transformation

        subroutine Matrix_E(n,m)
        integer n, i, j
        real m(n,n)

           do i=1,n
           do j=1,n
           m(i,j)=0.0
          enddo
           m(i,i) = 1.0
          enddo

        end subroutine Matrix_E


      subroutine Eqval(N,M,A)
      integer N,i,j, NL
      real M(N,N),A(N,N)

      do i=1,N
         do j =1,N
         A(i,j)=M(i,j)
         enddo
      enddo

      end subroutine
	  
      subroutine Normirovka(N,Eval,Evec)
      integer N, NL, i, j, Modes, RigidModes
      real Evec(N,N), Eval(N)
      common /PREC/ TOL, MAX_NUM
      real TOL, MAX_NUM
      RigidModes =0
      do i=1,N

        if (Eval(i).lt.0.0) then
                      RigidModes = 1
                            else
          do j=1,N
          Evec(j,i) = Evec(j,i)/sqrt(Eval(i))
          enddo
        
                            endif 
                           

      enddo
	  
      if(RigidModes.gt.0) then
      print*,' Normirovka:'
      print*,' Matrix is not positive defined'
                          endif

      print*,' Normirovka completed'
      end subroutine
	  
      subroutine Max_Diagonal(N,A,p,q,Maximum)
      integer N, i, j,p,q
      real A(N,N),Maximum
      p=1.0
      q=2.0
      Maximum = abs(A(1,2))
      do i=1,N
       do j =i+1,N
       if (abs(A(i,j)).gt.Maximum)  then
                                     p=i
                                     q=j
                                     Maximum = abs(A(i,j))
                                     endif
        enddo
       enddo
      end subroutine

      subroutine Jacobi_Calculations(x, y, s, c)
      real x, y, s, c
      integer k
      k = 1
      do while (4**(-k)*(x**2+y**2).ge.1)
      k = k + 1
      enddo

      x = x / (2**k)
      y = y / (2**k)
      c = sqrt(0.5*(1+y/sqrt(x**2+y**2)))
      s = 0.5*(x/sqrt(x**2+y**2))/c    

      end subroutine

      real function Arctg(y,x)
      real x, y, PI
      common /PREC/ TOL, MAX_NUM
      real TOL, MAX_NUM, epsilon1,ArctSeries
      parameter (PI=3.14159,epsilon1=0.000001)

      if (abs(x).lt.TOL) then

            if (y.gt.0) then
                        Arctg = PI/2.0
                        return
                        else
                        if(y.lt.0) then
                        Arctg = -PI/2.0
                        return
                                   else
                        Arctg = 0.0
                        return
                                   endif 
                        endif


                        else  

                        Arctg = ArctSeries(y/x)
                        return
                        
       
                 endif

      end function Arctg

      real function ArctSeries(x)

      real x, sum1,a
      real epsilon1
      integer n     
      parameter (epsilon1=1.e-32)
      real PI
      parameter (PI=3.14159)


      if (abs(x).le.1.0) then

      sum1=0.0
      n=0
      a = (-1)**n*(x**(2*n+1))/(2*n+1)

      do while (abs(a).gt.epsilon1)
      sum1 = sum1 + a
      n = n + 1
      a = (-1)**n*(x**(2*n+1))/(2*n+1)
      enddo     

      ArctSeries = sum1
      return
                        else

      sum1=0.0
      n=0
      a = (-1)**n /( (x**(2*n+1))*(2*n+1) )

      do while (abs(a).gt.epsilon1)
      sum1 = sum1 + a
      n = n + 1
      a = (-1)**n/( (x**(2*n+1))*(2*n+1) )
      enddo     

      ArctSeries = PI/2.0 - sum1
      return
                        endif


      end function ArctSeries
	  
