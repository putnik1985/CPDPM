      program Matrix 

      integer error,i
      character*256 Inp
      integer Nmax,n
      Parameter (Nmax=100)
      real*8 A(Nmax,Nmax),Eval(Nmax),Evec(Nmax,Nmax),B(Nmax,Nmax),x
      real*8 arc, ArctSeries, PI, Det,s
      parameter(PI=3.14159)
      character c

!......................................................................!
        print*,'input the matix size (<500)'
        read*,n

        do j=1,n
           do i=1,n
           print*,'A(',i,',',j,')='
           read*,A(i,j)
           enddo
        enddo 

        !@#!@#!@#call Jacobi_Transformation(Nmax,A,Eval,Evec,n)


        print*,'1 - EigenValues'
        print*,'2 - Inverse Matrix'
        print*,'3 - Arctangence'
        print*,'4 - Determinant'

     
        read*,c

        if (c.eq.'1') then 
                      goto 1000
                      endif

        if (c.eq.'2') then 
                      goto 2000
                      endif


        if (c.eq.'3') then 
                      goto 3000
                      endif


        if (c.eq.'4') then 
                      goto 4000
                      endif


1000    call Jacobi_Transformation_Opt(Nmax,A,Eval,Evec,n)
        print*,'Eigen Values'
        call DisplayV_R(Nmax,Eval,n)

        print*,'Eigen Vectors'
        call Display(Nmax,Evec,n)
        stop

2000    print*,'Calculate Inverse Matrix'   
        call Inverse(Nmax,A,B,n,error)
        if (error.eq.1) then
                        print*,'Matrix is singular'
                        stop
                        else
                        print*,'Inversed Matrix'
                        call Display(Nmax,B,n)
                        endif
       stop

3000   print*,'input x'
       read*,x
       arc = ArctSeries(x)
       print*,'angle = ',arc*180/PI
       stop

4000   s = Det(A,Nmax,n)
       print*,'Detreminant = ',s
       stop
         
      end program Matrix 

      subroutine Jacobi_Transformation(N,A,Eval,Evec,NL)
      integer N, NL, i, j, p, r,iterations,ip
      real*8 A(N,N),Eval(N),Evec(N,N),sum1
      real*8 P1(N,N),C1(N,N)
      real*8 Matrix_Out_Diagonal,epsilon1,teta

      Parameter (epsilon1=0.0000001)
      

      !#@#!@#!#!sum1 = Matrix_Out_Diagonal(N,A,NL)    
      !@!#!@#!@#!@#!#!print*,'sum is', sum1

      !#!@#!@#!# CHECK THE SYMMETRY OF THE MATRIX
      call Matrix_E(N,Evec)

      iterations = 0
      !sum1 = Matrix_Out_Diagonal(N,A,NL)
      print*,'NL=',NL
      !#print*,'sum1 = ',sum1
      !#print*,'epsilon ',epsilon1
      !!#!#print*,'iterations',iterations

      !#!@#!#!#read*

      do iterations=1,NL
      !#@!@do while (iterations.le.NL)
     
      do p = 1,NL
        do r= p+1,NL

        teta = 0.5*ATAN2(2*A(p,r),A(r,r) - A(p,p))       

        c = cos(teta)
        s = sin(teta)

        call Matrix_E(N,P1)
        !!#!@#print*,'p=',p
        !!#!@#!@print*,'r=',r

        !!#!@#print*,'p=',p
        !!#!@#print*,'r=',r
        P1(p,p) = c
        P1(r,r) = c
        P1(p,r) = s
        P1(r,p) = -s
        !@call Display(N,P1,NL)
        !@read*
        call Mul2(N,A,P1,C1,NL)
        call Eqval(N,C1,A,NL)
        call MulMat(N,Evec,P1,C1,NL)
        call Eqval(N,C1,Evec,NL)

        !!@#!@#!call Display(N,A,NL)
        !!#!@#!@read*

       enddo    
      enddo

      sum1 = Matrix_Out_Diagonal(N,A,NL)
      !#!@@!#print*,'out diagonal sum',sum1
      !#!@#!#!read*

      enddo

      do i=1,NL
      Eval(i)=A(i,i) 
      enddo

      print*,'Jacobi Transformation completed'
      sum1 = Matrix_Out_Diagonal(N,A,NL)
      print*,'out diagonal sum',sum1
      print*,'iteration is',iterations
 
      end subroutine Jacobi_Transformation

      real*8 function Matrix_Out_Diagonal(N,A,NL)
      integer N, NL,i,j
      real*8 A(N,N),summ
      summ = 0.0

      do i=1,NL
         do j=i+1,NL
         summ = summ + A(i,j) + A(j,i)
        enddo
      enddo

      !@#!@#!!@#print*,summ 

      Matrix_Out_Diagonal = summ;

      end function

      subroutine MulMat(N,A,B,C,NL)
      integer N, NL, i, j, k
      real*8 A(N,N),B(N,N),C(N,N)

      do i=1,NL
         do j =1,NL
         C(i,j)=0.0
         enddo
      enddo


      do i=1,NL
         do j =1,NL
             do k = 1, NL
             C(i,j) = C(i,j) + A(i,k)*B(k,j) 
             enddo      
         enddo
      enddo

      end subroutine

      subroutine Display(N,M,NL)
      integer N,i,j, NL
      real*8 M(N,N)
      
      do i=1,NL
       do j=1,NL 
       write(*,*) 'M(',i,',',j,')=',M(i,j)
       enddo
      enddo

      end subroutine Display


      subroutine Mul2(N,M,A,C,NL)
      integer N,i,j, NL,k,l
      real*8 M(N,N),C(N,N),A(N,N)


      do i=1,NL
         do j =1,NL
         C(i,j)=0.0
         enddo
      enddo

!......................................................................!

      do i=1,NL
         do j =1,NL
         do k=1,NL
            do l=1,NL

            C(i,j) = C(i,j) + A(k,i) * M(k,l) * A(l,j)
            
            enddo
         enddo
         enddo
      enddo

      end subroutine


        subroutine Matrix_E(n,m)
        integer n, i, j
        real*8 m(n,n)

           do i=1,n
           do j=1,n
           m(i,j)=0.0
          enddo
           m(i,i) = 1.0
          enddo

        end subroutine Matrix_E


      subroutine Eqval(N,M,A,NL)
      integer N,i,j, NL
      real*8 M(N,N),A(N,N)


      do i=1,NL
         do j =1,NL
         A(i,j)=M(i,j)
         enddo
      enddo


      end subroutine

      subroutine DisplayV_R(N,V,NL)
      integer N,i,j,NL
      real*8 V(N)
      
      do i=1,NL
      write(*,*) V(i)
      enddo

      end subroutine DisplayV_R


      subroutine Jacobi_Transformation_Opt(N,A,Eval,Evec,NL)
      integer N, NL, i, j, p, r,iterations,ip
      real*8 A(N,N),Eval(N),Evec(N,N),sum1
      real*8 epsilon1,teta,Maximum
      real*8 app, arr, apr,air,aip

      Parameter (epsilon1=0.0001)
      print*,'Optimum'
      !!#!@#!@#stop
      !#@#!@#!#!sum1 = Matrix_Out_Diagonal(N,A,NL)    
      !@!#!@#!@#!@#!#!print*,'sum is', sum1

      !#!@#!@#!# CHECK THE SYMMETRY OF THE MATRIX
      call Matrix_E(N,Evec)

      iterations = 0
      !sum1 = Matrix_Out_Diagonal(N,A,NL)
      print*,'NL=',NL
      !#print*,'sum1 = ',sum1
      !#print*,'epsilon ',epsilon1
      !!#!#print*,'iterations',iterations

      !#!@#!#!#read*
      
       do while(.true.)

       call Max_Diagonal(N,NL,A,p,r,Maximum)

       if (Maximum.eq.0.0) then
                                goto 100
                                endif

        teta = 0.5*ATAN2(2*A(p,r),A(r,r) - A(p,p))       

        c = cos(teta)
        s = sin(teta)

        app = A(p,p)
        arr = A(r,r)       
        apr = A(p,r)
               
        A(p,p) = app*c**2-2*c*s*apr+arr*s**2
        A(r,r) = app*s**2+2*c*s*apr+arr*c**2
        A(p,r) = 0.0
        A(r,p) = 0.0

        do i=1,NL
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

100   do i=1,NL
      Eval(i)=A(i,i) 
      enddo

 
      end subroutine Jacobi_Transformation_Opt

!......................................................................!
      subroutine Max_Diagonal(N,NL,A,p,q,Maximum)
      integer N, NL, i, j,p,q
      real*8 A(N,N),Maximum

      p=1.0
      q=2.0
      Maximum = abs(A(1,2))

      do i=1,NL
       do j =i+1,NL

       if (abs(A(i,j)).gt.Maximum)  then
                                     p=i
                                     q=j
                                     Maximum = abs(A(i,j))
                                     endif
        enddo
       enddo

      end subroutine


      subroutine Inverse(N,K,U,NL,error)
      real*8 K(N,N), P(N,N), U(N,N), eps, c, h
      
      integer N, NL, error, i, j, k1,i1,j1
      Parameter(eps=0.0000000001)
      print*, 'Start Inverse Matrix'


      call Matrix_E(N,P)

      do i=1,N
      do j=1,N
      U(i,j)=0.0
      enddo 
      enddo

         !##########################################@
         !print*,' matric before exclusion'
         !call Display(N,K,NL)
         !read*
        !################################################
      
      do k1=1,NL

         i=k1

         do while( (abs(K(i,k1))<eps ).and.(i.le.NL) )
         i = i + 1
         enddo
         !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
         !!print*, 'exclude', i
         !!!read*
         !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
         if (i.gt.NL) then
                      error = 1 !!!!!!!no such varaible, determinant is 0
                      return
                      else
                      
                      if (i.ne.k1) then
                      
                      do j=k1, NL
                      !!!!!!!!!!@###########$%^&&&&&&&&&&&&&&*************(((((((((((()
                      !print*,K(i,j), ' switch with', K(k1,j)
                      !read*
                      h = K(i,j)
                      K(i,j) =K(k1,j)
                      K(k1,j) = h
                      !!!!!!!!!!@###########$%^&&&&&&&&&&&&&&*************(((((((((((()
                      !print*,K(i,j), ' switched with', K(k1,j)
                      !read*

                      enddo

                      do j = 1,NL
                      h = P(i,j)
                      P(i,j) = P(k1,j)
                      P(k1,j) = h
                      enddo

          
                      endif

                      do i1 = k1+1,NL
                           c = - (K(i1,k1)/K(k1,k1))
                           do j=k1,NL
                           K(i1,j) = K(i1,j) + c * K(k1,j)
                           enddo  

                           do j=1,NL
                           P(i1,j) = P(i1,j) + c * P(k1,j)
                           enddo  


                      enddo
      !##########################################@
      !!!!print*,' matric after exclusion'
      !!!!call Display(N,K,NL)
      !################################################
                      endif
              
      enddo

         !@#print*,' matric after exclusion'
         !@#call Display(N,K,NL)
         !@#read*

         !@#print*,' matric after exclusion'
         !@#call Display(N,P,NL)
         !@#read*



      do j1=1,NL

      U(NL,j1) = P(NL,j1) / K(NL,NL)

      do k1=NL-1,1,-1
         do j = k1 + 1, NL   
         U(k1,j1) = U(k1,j1) + K(k1,j)*U(j,j1)
         enddo 
      U(k1,j1) = (P(k1,j1) - U(k1,j1))/K(k1,k1)
      enddo

      enddo


      end subroutine Inverse


      real*8 function ArctSeries(x)

      real*8 x, sum1,a
      real*8 epsilon1
      integer n     
      parameter (epsilon1=0.000001)
      real*8 PI
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


      real*8 function Det(A,N,NL)
      integer N, NL, error,i
      real*8 A(N,N),s

      !print*,'Matrix'
      !call Display(N,A,NL)
      
      call GaussExclusion(N,A,NL,error)

      !print*,'Matrix'
      !call Display(N,A,NL)

      if (error.eq.1) then
                      Det = 0.0
                      return
                      else
                      s = 1.0
                      do i=1,NL
                      s = s * A(i,i)
                      enddo
                      Det = s
                      return
                      endif 

      end function Det


      subroutine GaussExclusion(N,K,NL,error)
      real*8 K(N,N), eps, c, h
      
      integer N, NL, error, i, j, k1,i1
      Parameter(eps=0.0000000001)
      print*, 'Start Gauss Exclusion'

      do k1=1,NL

         i=k1
         !@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
         !print*,'i=', i
         !print*,'k1=', k1
         !print*, K(1,1),K(i,k1),K(2,2)
         !read*
         !##########################################@
         !!!!!print*,' matric before exclusion'
         !!!!!call Display(N,K,NL)
        !################################################
         do while( (abs(K(i,k1))<eps ).and.(i.le.NL) )
         i = i + 1
         enddo
         !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
         !!print*, 'exclude', i
         !!!read*
         !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
         if (i.gt.NL) then
                      error = 1 !!!!!!!no such varaible, determinant is 0
                      return
                      else
                      
                      if (i.ne.k1) then
                      
                      do j=k1, NL
                      !!!!!!!!!!@###########$%^&&&&&&&&&&&&&&*************(((((((((((()
                      !print*,K(i,j), ' switch with', K(k1,j)
                      !read*
                      h = K(i,j)
                      K(i,j) =K(k1,j)
                      K(k1,j) = h
                      !!!!!!!!!!@###########$%^&&&&&&&&&&&&&&*************(((((((((((()
                      !print*,K(i,j), ' switched with', K(k1,j)
                      !read*
                      enddo
          
                      endif

                      do i1 = k1+1,NL
                           c = - (K(i1,k1)/K(k1,k1))
                           do j=k1,NL
                           K(i1,j) = K(i1,j) + c * K(k1,j)
                           enddo  
                      enddo
      !##########################################@
      !!!!print*,' matric after exclusion'
      !!!!call Display(N,K,NL)
      !################################################
                      endif
              
      enddo

      end subroutine GaussExclusion

