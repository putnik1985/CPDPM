      subroutine Gauss(N,K,P,U,NL,error)
      real*8 K(N,N), P(N), U(N), eps, c, h
      
      integer N, NL, error, i, j, k1,i1
      Parameter(eps=0.0000000001)
      print*, 'Start Gauss Solution'

      call Vector_Zero(N,U)

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

                      h = P(i)
                      P(i) = P(k1)
                      P(k1) = h 
          
                      endif

                      do i1 = k1+1,NL
                           c = - (K(i1,k1)/K(k1,k1))
                           do j=k1,NL
                           K(i1,j) = K(i1,j) + c * K(k1,j)
                           enddo  
                           P(i1) = P(i1) + c * P(k1)    
                      enddo
      !##########################################@
      !!!!print*,' matric after exclusion'
      !!!!call Display(N,K,NL)
      !################################################
                      endif
              
      enddo

      U(NL) = P(NL) / K(NL,NL)

      do k1=NL-1,1,-1
         do j = k1 + 1, NL   
         U(k1) = U(k1) + K(k1,j)*U(j)
         enddo 
      U(k1) = (P(k1) - U(k1))/K(k1,k1)
      enddo

      end subroutine Gauss

      subroutine Jacobi_Transformation(N,A,Eval,Evec,NL)
      integer N, NL, i, j, p, r,iter,ip,MaxIter
      real*8 A(N,N),Eval(N),Evec(N,N),sum1
      real*8 epsilon1,teta,Maximum,Arctg,Maximum2
      real*8 app, arr, apr,air,aip,x,y,s,c
        common /PREC/ TOL, MAX_NUM
        real*8 TOL, MAX_NUM
      real*8 PI
      Parameter (epsilon1=0.000000000001, PI=3.14159)
      byte check,Ortogonality

      !@#!@#!@#!#print*,'Optimum'
      !!#!@#!@#stop
      !#@#!@#!#!sum1 = Matrix_Out_Diagonal(N,A,NL)    
      !@!#!@#!@#!@#!#!print*,'sum is', sum1

      !#!@#!@#!# CHECK THE SYMMETRY OF THE MATRIX
      call Matrix_E(N,Evec)


      !call Max_Diagonal(N,NL,Evec,p,r,Maximum)
      !print*,'Jacobi Transformation:'
      !print*,'initial transfor matrix'
      !print*,'Maximum off diagonal',Maximum

      MaxIter = N
      !print*,'Max allowable Iterations are',MaxIter

        !!@#@#@print*,'A'
        !#!@#!@#call Display(N,A,NL)
        !#!@#!@print*,'?????'
        !#@!#@#read*

      !sum1 = Matrix_Out_Diagonal(N,A,NL)
      !!@#!@#@!print*,'NL=',NL
      !#print*,'sum1 = ',sum1
      !#print*,'epsilon ',epsilon1
      !!#!#print*,'iterations',iterations

      !#!@#!#!#read*
       Maximum2 = 0.0
       iter = 0
       do while(.true.)

       call Max_Diagonal(N,NL,A,p,r,Maximum)

       if (p.ge.r) then 
                   print*,'error#1 in the Jacoby algorithm'
                   stop
                   endif
       !print*,'Maximum = ',Maximum
       if (abs(Maximum).eq.0.0) then
                                goto 100
                                endif


        !!#!#!#############################################
        teta = 0.5*Arctg(2*A(p,r),A(r,r) - A(p,p))

        !teta = 0.5*Atan(2*A(p,r),A(r,r) - A(p,p))

        if (teta.gt.PI/4.0) then
                            teta = teta - 0.5*PI
                            endif


        if (teta.lt.-PI/4.0) then
                            teta = teta + 0.5*PI
                            endif

        !print*,'teta',teta*180/PI
        !print*,'A(',p,',',r,')=',A(p,r)
        !print*,'A(',p,',',p,')=',A(p,p) 
        !print*,'A(',r,',',r,')=',A(r,r)

        
        !c = cos(teta)
        !s = sin(teta)
        !!@!!!!!!!!!!!!##############################################
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


        !A(p,r) = A(p,r) / 2.0
        !A(r,p) = A(r,p) / 2.0

        A(p,r) = 0.0
        A(r,p) = A(p,r)

       
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

        !print*,'Evec(',i,',',p,')',Evec(i,p)
        !print*,'Evec(',i,',',r,')',Evec(i,r)

        Evec(i,p) = c*aip - s*air
        Evec(i,r) = s*aip + c*air

        !print*,'After:'
        !print*,'Evec(',i,',',p,')',Evec(i,p)
        !print*,'Evec(',i,',',r,')',Evec(i,r)

        
        !if (abs(Evec(i,p)).lt.epsilon1) then 
        !                                Evec(i,p) = 0.0
        !                                endif 

        !if (abs(Evec(i,r)).lt.epsilon1) then 
        !                                Evec(i,r) = 0.0
        !                                endif 

        !iter = iter + 1
        !if (iter.gt.MaxIter) then
        !                    endif

        !A(p,r) = A(p,r) / 2.0
        !A(r,p) = A(r,p) / 2.0

        enddo
      
      !print*,' teta = ',teta*180/PI 
      !   print*,' cos',c
      !  print*,' sin',s


      !check = Ortogonality(N,Evec,NL)
      !print*,' p & r',p,r
      !read*

      enddo



      !normirovka vectorov
100   do i=1,NL
      Eval(i)=A(i,i) 
      enddo

      print*
      print*,' Jacobi Transformation:'
      print*,' Maximum off diagonal',Maximum
 
      end subroutine Jacobi_Transformation

      real*8 function Matrix_Out_Diagonal(N,A,NL)
      integer N, NL,i,j
      real*8 A(N,N),summ
      summ = 0.0

      do i=1,NL
         do j=i+1,NL
         summ = summ + abs(A(i,j)) + abs(A(j,i))
        enddo
      enddo

      !@#!@#!!@#print*,summ 

      Matrix_Out_Diagonal = summ;

      end function

      subroutine MulMat(N,A,B,NL)
      integer N, NL, i, j, k
      real*8 A(N,N),B(N,N),C(N,N)

      print*,'MulMat:'
      print*,'Matrix Maltiplication'

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

      call Eqval(N,C,B,NL)

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


      subroutine Mul2(N,M,A,NL)
      integer N,i,j, NL,k,l
      real*8 M(N,N),C(N,N),A(N,N)

!......................................................................!

      do i=1,NL
         do j =1,NL

         C(i,j) =0.0

         do k=1,NL
            do l=1,NL

            C(i,j) = C(i,j) + A(k,i) * M(k,l) * A(l,j)
            
            enddo
         enddo

         enddo
      enddo

      call Eqval(N,C,M,NL)

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

      subroutine DisplayV(N,V,NL)
      integer N,i,j,NL
      integer V(N)
      
      do i=1,NL
      write(*,*) 'V(',i,')=',V(i)
      enddo

      end subroutine DisplayV

      subroutine DisplayV_R(N,V,NL)
      integer N,i,j,NL
      real*8 V(N)
      
      do i=1,NL
      write(*,*) V(i)
      enddo

      end subroutine DisplayV_R

      !!! Eigen Values Ax-l*Bx=0 B is positive defined
      subroutine EigV(N,A,B,Eval,Evec,NL)
      integer N, NL, i, j, p, r,iterations,ip,error,k,l
      real*8 A(N,N),Eval(N),Evec(N,N),sum1,Maximum
      real*8 B(N,N) 
      byte Sym, check, Ortogonality
      common /PREC/ TOL, MAX_NUM
      real*8 TOL, MAX_NUM, ep,Det,Minimum

        integer Modes
        common /Tones/ Modes


      !@#!@#print*,' B Matrix'
      !@#!@#@!call Display_NonZero(N,B,NL)
      !@#!@#!@print*,'?????'
      !#!@#!@#read*

      !print*,' A Matrix'
      !call Display_NonZero(N,A,NL)
      !@#print*,'?????'
      !@#!@read*

      !print*,' B Matrix'
      !call Display_NonZero(N,B,NL)
      !@#print*,'?????'
      !@#read*

      !@#!@############################
      !!!!!call Eqval(N,B,C1,NL)
      !!@################################
      
      print*,' Solve (A-l*B)X = 0 Eigenvalue problem'
      print*
      print*,' Jacoby Transformation for the Matrix B'
      call Jacobi_Transformation(N,B,Eval,Evec,NL)


      !@#do i = 1, Modes
      !@#print*,'Eval',Eval1(i)
      !@#enddo
      !print*,' B Matrix after Transformation'
      !call Display_NonZero(N,B,NL)
      !print*,'?????'
      !read*
     

       !print*,' B Matrix Vectors before Norm'
       !call Display_NonZero(N,Evec1,NL)
       !print*,'?????'
       !read*

      !for debugging !#!@#$%#^%$!#$%^&*@#!#

      !call Mul2(N,B,Evec1,C1,NL)
      !call Max_Diagonal(N,NL,C1,p,r,Maximum)
      !print*
      !print*,' Maximum off diagonal UtKU(',p,',',r,')=', Maximum
      !call MinMaxDiag(N,C1,NL,Maximum,Minimum)
      !print*,' Minimum & Maximum diagonal', Minimum, Maximum
      !call MinMaxVector(N,Eval,NL,Maximum,Minimum)
      !print*,' Minimum & Maximum Eigenvalues', Minimum, Maximum

      !print*,' EigenVectors:'
      !check =  Ortogonality(N,Evec1,NL)

      !Maximum = Det(Evec1,N,NL)
      !print*,'Transform Matrix determinant',Maximum
      !stop

      !!@#!@!@#!@#!@#!@#!@#!@#$@#$@%#$%#$^&*(*&^%$#@

      call Normirovka(N,NL,Eval,Evec)
      !call Mul2(N,A,Evec,NL)

      do i=1,NL
         do j =1,NL
         B(i,j) =0.0
         do k=1,NL
            do l=1,NL
            B(i,j) = B(i,j) + Evec(k,i) * A(k,l) * Evec(l,j)
            enddo
         enddo
         enddo
      enddo

      call Eqval(N,B,A,NL)

      !print*,' A Matrix After Multiplication'
      !call Display(N,C1,NL)
      !print*,'?????'
      !read*

       !print*,' B Matrix Vectors'
       !call Display_NonZero(N,Evec1,NL)
       !print*,'?????'
       !read*

      !check =  Ortogonality(N,Evec,NL)


      !@#!@#print*,' B Matrix Vectors'
      !call Display(N,Evec,NL)
      !print*,'?????'
      !read*

      !@#!@3print*,' A Matrix After Multiplication'
      !call Display(N,C1,NL)
      !print*,'?????'
      !read*

      !print*,' Jacoby Transformation for the Matrix A'
      !check=Sym(N,A,NL)

      !if (check.eq.1) then
      !                print*,' transformed A nonsymmetric'
      !                print*,' proceed?????'
      !                read*
      !                else
      !                print*,' transformed A symmetric'
      !                endif
      !@#!@#!@#!@#!@#!@

      !#!@#!@#!@#!@#!@#!@#
      !call Max_Diagonal(N,NL,C1,p,r,Maximum)
      !print*
      !print*,'Maximum off diagonal',Maximum
      print*
      print*,' Jacoby Transformation for the Matrix A'
      call Jacobi_Transformation(N,A,Eval,B,NL)

      !@#!@#print*,' A Vectors before Norm'
      !@#!@call Display(N,Evec1,NL)
      !@#!@#print*,'?????'
      !@#!#read*

      !print*,' A Matrix after Jacobi'
      !call Display_NonZero(N,C1,NL)
      !print*,'?????'
      !read*


      !call Normirovka(N,NL,Eval,Evec1)
      !print*,' Mass Matrix Vectors'
      !call Display(N,Evec1,NL)
      !print*,'?????'
      !read*
      
      !print*,' Transformed Result Matrix'
      !call Display(N,C1,NL)
      !print*,'?????'
      !read*

      
      do i=1,NL
         do j =1,NL
             A(i,j)=0.0
             do k = 1, NL
             A(i,j) = A(i,j) + Evec(i,k)*B(k,j) 
             enddo      
         enddo
      enddo


      call Eqval(N,A,Evec,NL)
      call Normirovka(N,NL,Eval,Evec)

      !for debugging !#!@#$%#^%$!#$%^&*@#!#
      !call Mul2(N,A,Evec,C1,NL)
      
      !call Max_Diagonal(N,NL,C1,p,r,Maximum)
      !print*
      !print*,' Maximum off diagonal UtMU(',p,',',r,')=', Maximum
      !call MinMaxDiag(N,C1,NL,Maximum,Minimum)
      !print*,' Minimum & Maximum diagonal', Minimum, Maximum
      
      !for debugging !#!@#$%#^%$!#$%^&*@#!#

      !print*,'?????'
      !read*
 
      end subroutine EigV


      subroutine DivideMatrix(N,A,Acceleration)
      integer N, i, j
      real*8 A(N,N),Acceleration

      if (Acceleration.ne.0.0) then
      do i=1,N
      do j=1,N
      A(i,j) = A(i,j)/Acceleration
      enddo
      enddo
                      else
              print*,' Acceleration is set 1.0'  
                      Acceleartion =1.0
                      endif


      end subroutine DivideMatrix

      subroutine Max_Diagonal(N,NL,A,p,q,Maximum)
      integer N, NL, i, j,p,q
      real*8 A(N,N),Maximum

      p=1
      q=2
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

      byte function Sym(N,A,NL)
      integer N, NL, i, j
      real*8 A(N,N),eps
      parameter (eps=0.0001)

      Sym = 0

      do i = 1, NL
         do j = i+1, NL
         if (abs(A(i,j)-A(j,i)).gt.eps) then
                               print*,'A(',i,',',j,')',A(i,j)
                               print*,'A(',j,',',i,')',A(j,i)
                               Sym =1
                               return  
                               endif
                               
         enddo
      enddo

      end function

      subroutine Display_NonZero(N,M,NL)
      integer N,i,j, NL
      real*8 M(N,N)
      real*8 eps
      parameter (eps=0.00001)
        common /PREC/ TOL, MAX_NUM
        real*8 TOL, MAX_NUM      
      do i=1,NL
       do j=1,NL 
       if (abs(M(i,j)).gt.TOL) then
       write(*,*) 'M(',i,',',j,')=',M(i,j) 
                               endif
       enddo
      enddo

      end subroutine Display_NonZero


      byte function Ortogonality(N,A,NL)
      integer N, NL, i, j, k, l,p,r
      real*8 A(N,N), sum1, C(N,N),Maximum, Det
      real*8 Minimum

      print*,' Check Matrix Ortogonality'
      do i=1,NL
      do j=1,NL
      C(i,j)=0.0
          do k=1,NL
          C(i,j)=C(i,j)+A(k,i)*A(k,j)
          enddo      
      enddo
      enddo

      call Max_Diagonal(N,NL,C,p,r,Maximum)
      print*,' Ortogonality:'
      print*,' Maximum off diagonal',Maximum

      print*,' Minimum Maximum on diagonal:' 
      call MinMaxDiag(N,C,NL,Maximum,Minimum)
      print*,Maximum,Minimum

      !print*,'?????'

      end function


      subroutine MinMaxDiag(N,A,NL,Maximum,Minimum)
      integer N, NL, i
      real*8 A(N,N), Maximum, Minimum
      Minimum = A(1,1)
      Maximum = A(1,1)

      do i=2,NL

      if ( A(i,i).lt.Minimum ) then
                    Minimum = A(i,i)
                                    endif 

      if ( A(i,i).gt.Maximum ) then
                    Maximum = A(i,i)
                                    endif 

      enddo
       
      end subroutine


      subroutine MinMaxVector(N,A,NL,Maximum,Minimum)
      integer N, NL, i
      real*8 A(N), Maximum, Minimum
      Minimum = A(1)
      Maximum = A(1)

      do i=2,NL

      if ( A(i).lt.Minimum ) then
                    Minimum = A(i)
                             endif 

      if ( A(i).gt.Maximum ) then
                    Maximum = A(i)
                             endif 

      enddo
       
      end subroutine


      subroutine Normirovka(N,NL,Eval,Evec)
      integer N, NL, i, j, Modes, RigidModes
      real*8 Evec(N,N), Eval(N)
      common /PREC/ TOL, MAX_NUM
      real*8 TOL, MAX_NUM
      RigidModes =0
      do i=1,NL

        if (Eval(i).lt.0.0) then
                      RigidModes = 1
                            else
          do j=1,NL
          Evec(j,i) = Evec(j,i)/sqrt(Eval(i))
          enddo
        
                            endif 
                           

      enddo
      if(RigidModes.gt.0) then
      print*,' Normirovka:'
      print*,' Matrix is not positive defined'
                          endif

      print*
      print*,' Normirovka completed'
      end subroutine


      subroutine Mul_Reduce(N,M,A,C,NL,Modes)
      integer N,i,j, NL,k,l, Modes
      real*8 M(N,N),C(N,N),A(N,N)


      do i=1,NL
         do j =1,NL
         C(i,j)=0.0
         enddo
      enddo

!......................................................................!
      print*,' Matrix Multiplication....'
      do i=1,Modes
         do j =1,Modes

         do k=1,NL
            do l=1,NL

            C(i,j) = C(i,j) + A(k,i) * M(k,l) * A(l,j)
            
            enddo
         enddo

         enddo
      enddo

      end subroutine


      real*8 function ArctSeries(x)

      real*8 x, sum1,a
      real*8 epsilon1
      integer n     
      parameter (epsilon1=1.e-32)
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


      real*8 function Arctg(y,x)
      real*8 x, y, PI
      common /PREC/ TOL, MAX_NUM
      real*8 TOL, MAX_NUM, epsilon1,ArctSeries
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


      real*8 function Max_Elem(N,NL,A)
      integer N, NL, i, j
      real*8 A(N,N),Maximum

      
      Maximum = 0.0

      do i=1,NL
       do j =1,NL

       if (abs(A(i,j)).gt.Maximum)  then
                                     Maximum = abs(A(i,j))
                                    endif
        enddo
       enddo

      Max_Elem = Maximum

      end function


      subroutine MulMatVec(N,A,b,c,NL)
      integer N,i,j,NL
      real*8 A(N,N),b(N),c(N)

      do i=1,NL
      c(i) = 0.0
      do j=1,NL
      c(i) = c(i) + A(i,j)*b(j)
      enddo
      enddo

      end subroutine


      subroutine EigV_Reley(N,K,M,Eval,Evec,NL)
      integer N, NL, i, j, p, r,iterations,ip
      real*8 K(N,N),Eval(N),Evec(N,N),sum1
      real*8 M(N,N), mass, stif
      byte Sym, check, Ortogonality
      common /PREC/ TOL, MAX_NUM
      real*8 TOL, MAX_NUM, ep
      real*8 PI
      parameter (PI=3.14159)

      integer Modes
      common /Tones/ Modes

      Modes=0
      call Vector_Zero(N,Eval) 

      !print*,'Mass'
      !call Display_NonZero(N,M,N)


      !print*,'Vector'
      !call Display_NonZero(N,Evec,N)

!......................................................................!      
      do i=1,NL

         mass = 0
         do j=1,NL
         do p=1,NL
         mass = mass + Evec(j,i)*M(j,p)*Evec(p,i)
         enddo
         enddo
       !print*,'mass=',mass

      if (mass.gt.TOL) then

         stif = 0
         do j=1,NL
         do p=1,NL
         stif = stif + Evec(j,i)*K(j,p)*Evec(p,i)
         enddo
         enddo

      !print*,'stif',stif
      if (stif.lt.(-TOL)) then
                          print*,'error defining stiffness'
                          stop
                          endif
      Modes = Modes + 1
      Eval(Modes) = (1/(2*PI))*sqrt(stif/mass)   
        
      do j=1,NL
      Evec(j,Modes) = Evec(j,i) / sqrt(mass)
      enddo
                     endif
                       
      enddo     
  
      end subroutine


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
      !@!print*, 'Start Gauss Exclusion'

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

      real*8 function System_F(w,K,N,NL)
      real*8 w, res, Det
      integer N, NL, i, j
      real*8 K(N,N), K1(N,N)
      real*8 Kdet
      common /determinant/ Kdet

      !print*,N,NL

      !print*,'Mass'
      !call Display_NonZero(N,M,NL)

      !print*,'Stiffness'
      !call Display_NonZero(N,K,NL)

      do i =1,NL
         do j =1,NL
         K1(i,j) = (w**2)*K(i,j)
         enddo
       K1(i,i) = (w**2)*K(i,i) - 1
      enddo

      !print*,'Stiffness second'
      !call Display_NonZero(N,K1,NL)
      !read*
      res = Det(K1,N,NL)

      !if (w.eq.0) then
      !            Kdet = res
      !            endif

      if (res.eq.0.0) then 
              System_F = 0.0
              return
                     endif
      System_F = res

      end function System_F


      subroutine SqrtMatr(N,A,NL)
      integer i, j, N, NL
      real*8 A(N,N)
      common /PREC/ TOL, MAX_NUM
      real*8 TOL, MAX_NUM
      
      do i=1,NL
         do j=1,NL
         if (A(i,j).gt.TOL) then
                        A(i,j) = sqrt(A(i,j))
                            else
                        print*,'SqrtMatr:'
                        print*,'negative element',A(i,j)
                            endif
         enddo
      enddo

      end subroutine SqrtMatr


      subroutine Jacobi_Calculations(x, y, s, c)
      real*8 x, y, s, c
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



      subroutine Reduce_Vectors(Eval,Evec,N,NL)
        integer Modes
        common /Tones/ Modes
       real*8 Evec(N,N), Eval(N), h
       integer N, NL, j,i,k
        real*8 Dens,Length,Modul
        common /sound/ Dens, Length,Modul
        real*8 Velocity, Maximum
        real*8 MaxFreq
        common /speed/ MaxFreq

       print*,' Vectors Reduction:'
       print*,' Density = ',Dens
       print*,' Module = ',Modul
       print*,' Length = ',Length
       
       if (Dens.gt.0.0) then 
                   Velocity = sqrt(Modul/Dens)      
                   MaxFreq = sqrt(Modul/Dens)/Length
                         else
                         Velocity = 5000
                         MaxFreq = 500000.0
                         endif

       print*,' Sound Speed (m/sec) = ', Velocity
 
       Maximum = 0.0
       Modes = 0
       j = 1

       do i = 1, NL
       !print*,'i = ',i
       !print*,'Freq = ', Eval(i)

       if ((Eval(i).gt.0).and.(Eval(i).le.MaxFreq)) then
       h = Eval(i)
       Eval(i) = Eval(j)
       Eval(j) = h
       do k=1,NL
       h = Evec(k,i)
       Evec(k,i)=Evec(k,j)
       Evec(k,j)=h
       enddo
       if (Eval(j).gt.Maximum) then
                               Maximum = Eval(j)
                               endif
       j = j + 1
       Modes = Modes + 1
       !print*,' Switched' 
                                                 endif       
       enddo

       print*,' Number of Modes', Modes
       MaxFreq = Maximum
       print*,' Maximum System Frequency = ', MaxFreq

      end subroutine


      real*8 function Magnitude(p,w,phase,n,wn,t)
      real*8 p,w,phase,n,wn,t,teta,a

      a=p/(wn**2*sqrt((1-(w/wn)**2)**2+4*(n/wn)**2*(w/wn)**2))
      !!!!Magnitude = abs(a)
      Magnitude = a
      end function


      real*8 function Phase2(p,w,phase,n,wn,t)
      real*8 p,w,phase,n,wn,t,teta,a
      real*8 Arctg

      Phase2 = Arctg(-2.0*n*w,wn**2-w**2)

      end function

!......................................................................! 

      subroutine Transfer1(w,n,wn,a,cost,sint)
      real*8 w,n,wn,a,cost,sint

      a=1/(wn**2*sqrt((1-(w/wn)**2)**2+4*(n/wn)**2*(w/wn)**2))
      cost = (wn**2-w**2)*a
      sint = -2.0*n*w*a

      end subroutine


