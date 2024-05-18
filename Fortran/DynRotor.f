        program DynRotor
        implicit none
        character*256 elements, BCFile, LoadF, Ufile,Coupl,Mount
        character*256 EngineInp, EngineOut, Rotor, SysF,Inp,EngineM
        character*256 EngineOutM, output,outputf,outputm,RotorF
        character*256 TransientF, UnbLoad, TransientOut, LogDecF

        integer MaxN, Nodes,i,FreqSteps, Dofs, node, digit,j,ind
        integer OutNode,comp1, comp2,step
        character c
        Parameter (MaxN = 1000)
        real*8 M(6*MaxN,6*MaxN), K(6*MaxN,6*MaxN), P(6*MaxN), U(6*MaxN)
        real*8 Eval(6*MaxN), Evec(6*MaxN,6*MaxN),Coord(MaxN), VU(6*MaxN)
        real*8 InvK(6*MaxN,6*MaxN),response,Dfreq,Mtime,tstep,time
        integer Vect(6*MaxN), NL, error, Transf(MaxN),Nsteps,station
        real*8 PI, eps,m0,k0,w,System_F, freq, wmin,wmax, Mag, Phase
        real*8 damp, kn, tetai, ai, AiCos,AiSin, Pin, pn, tetan,wn
        real*8 Magnitude, Phase2, Exc_Disp, Exc_Vel, C1, C2, l1,l2
        real*8 Disp(6),logmin,logmax, LogDec,Aw2,Bw,Cw0
        real*8 k1,k2,k3,k4, timeout
        real*8 cost, sint, ampl
        parameter (PI=3.14159,eps=0.00000000001)

        common /PREC/ TOL, MAX_NUM
        real*8 TOL, MAX_NUM

        real*8 MaxFreq, MaxSpeed
        common /speed/ MaxFreq

        real*8 Acceleration
        common /Accel/ Acceleration
        
        integer Modes
        common /Tones/ Modes

        real*8 MainFreq2, Max_Elem
        common /values/ MainFreq2

        real*8 Kdet
        common /determinant/ Kdet

        real*8 Dens,Length,Modul
        common /sound/ Dens, Length,Modul
!......................................................................!
        TOL=1.e-40
        MAX_NUM=1.e+40


        call Matrix_Zero(6*MaxN,K)
        call Matrix_Zero(6*MaxN,M)
        call Vector_ZeroI(MaxN,Transf)
        call Vector_Zero(MaxN,Coord)
        call Vector_Zero(6*MaxN,U)
        Nodes=0


        print*,'Input file for the Analysis'
        read*, Inp
        open(unit =24,file=Inp,iostat=error)
        if (error.gt.0) then
        print*,'error reading file ', Inp
        stop  
                        endif

        read(24,fmt=*,iostat=error,end=640) elements 
        read(24,fmt=*,iostat=error,end=640) EngineInp
        read(24,fmt=*,iostat=error,end=640) elements

        read(24,fmt=*,iostat=error,end=640) elements 
        read(24,fmt=*,iostat=error,end=640) EngineM
        read(24,fmt=*,iostat=error,end=640) elements

        read(24,fmt=*,iostat=error,end=640) elements 
        read(24,fmt=*,iostat=error,end=640) Coupl
        read(24,fmt=*,iostat=error,end=640) elements

        read(24,fmt=*,iostat=error,end=640) elements 
        read(24,fmt=*,iostat=error,end=640) Mount
        read(24,fmt=*,iostat=error,end=640) elements

        read(24,fmt=*,iostat=error,end=640) elements 
        read(24,fmt=*,iostat=error,end=640) BCFile
        read(24,fmt=*,iostat=error,end=640) elements


        read(24,fmt=*,iostat=error,end=640) elements 
        read(24,fmt=*,iostat=error,end=640) Acceleration
        read(24,fmt=*,iostat=error,end=640) elements


        read(24,fmt=*,iostat=error,end=640) elements 
        read(24,fmt=*,iostat=error,end=640) LoadF
        read(24,fmt=*,iostat=error,end=640) elements


        read(24,fmt=*,iostat=error,end=640) elements 
        read(24,fmt=*,iostat=error,end=640) RotorF
        read(24,fmt=*,iostat=error,end=640) elements

        read(24,fmt=*,iostat=error,end=640) elements 
        read(24,fmt=*,iostat=error,end=640) TransientF
        read(24,fmt=*,iostat=error,end=640) elements


        read(24,fmt=*,iostat=error,end=640) elements 
        read(24,fmt=*,iostat=error,end=640) EngineOut
        read(24,fmt=*,iostat=error,end=640) elements

        read(24,fmt=*,iostat=error,end=640) elements 
        read(24,fmt=*,iostat=error,end=640) EngineOutM
        read(24,fmt=*,iostat=error,end=640) elements



640     close(24)
        

        print*
        print*,'Create Engine parts (beam elements)'
        !print*, EngineInp
        open(unit =16,file=EngineInp,iostat=error)
        if (error.gt.0) then
        print*,'error reading file ', EngineInp
        stop  
                        endif

        do while (.true.)

        read(16,fmt=*,iostat=error,end=100) elements 
        print*
        print*,'input file of the part', elements
        !!#!@#!@#!@#!@#!@#read*
        call Create_FEM(elements, M, K, Coord, MaxN, Nodes,Transf)

        enddo
100     close(16)
        
        print*
        print*,'Create Engine parts (Matrix elements)'
        print*, EngineM
        open(unit =16,file=EngineM,iostat=error)
        if (error.gt.0) then
        print*,'error reading file ', EngineInp
        stop  
                        endif

        do while (.true.)

        read(16,fmt=*,iostat=error,end=400) elements 
        print*
        print*,'input file of the part', elements
        !!#!@#!@#!@#!@#!@#read*
        call Create_Matrix(elements,M,K,MaxN,Nodes,Transf)
        enddo
400     close(16)

       

        print*,'-------------------------------------------------'
        print*, 'Nodes number ',Nodes 
        print*,'-------------------------------------------------'


        !#!@#!@!@#!@ stop
        !!!print*,'Mass Matrix'
        !!!!call Display_NonZero(6*MaxN,M,6*Nodes)
        !@#!@#@!print*,'??????????????'
        !@#!@#@read*
                        
        !@#@!#call DisplayV(MaxN,Transf,Nodes)
        !#!@#stop
        print*
        print*,'Apply Couplings'
        !print*,Coupl
        call Apply_Couplings(Coupl, K, MaxN, Transf)

        print*
        print*,'Apply Mounts'
        !print*,Mount
        call Apply_Mounts(Mount, K, MaxN, Transf)

        print*,'Acceleration for the technical units'
        print*,Acceleration
        print*
        print*,'System Status (beam elements)'
        call Inertia(MaxN, M, K, Coord, Nodes)

        print*
        print*,'Apply Boundary Conditions'
        print*,BCFile
        call Apply_BC(BCFile,M,K,Vect,MaxN,Transf,NL,Nodes)

        !#$%^&*^&$%#%$#^%&*&^%$@#$@!#%#%!@#$@#!$@#$@#@#$@!$
        print*,'Global number of the DOFs', NL

        !!#!@#call Display(6*MaxN,K,NL)
        !@#print*,'Mass Matrix BC'
        !@#!@#call Display_NonZero(6*MaxN,M,NL)
        !@#!@#print*,'??????????????'
        !@#!@#!@read*


        !#!@#!#stop
        !@#!@#print*,' Transform '
        !@#!@#@!call DisplayV(6*MaxN,Vect,6*Nodes)
        !@#!@#print*,'??????????????'
        !@#!@#!@#read*

       !m0 = Max_Elem(6*MaxN,NL,M)
       !k0 = Max_Elem(6*MaxN,NL,K)


       !print*,'m0=',m0
       !print*,'k0=',k0
       !stop
       !MainFreq2 = k0/m0
!......................................................................!

       print*
       print*,'------------------------------------------------------'
       print*,' Engine Dynamics Analysis'
       print*,' 5 - Natural Modes'
       print*,' 6 - Periodic Excitation'
       print*,' 7 - Static Excitation'
       print*,'------------------------------------------------------'
       print*,' 8 - Exit'
       print*,'------------------------------------------------------'
       read*,c
       print*


        if (c.eq.'5') then 
                      goto 800
                      endif

        if (c.eq.'6') then 
                      goto 800
                      endif

        if (c.eq.'7') then 
                      goto 700
                      endif

        if (c.eq.'8') then 
                      goto 1000
                      endif

        print*
700     print*,'Apply Load Conditions'
        !print*,LoadF
        call Create_Static_Force(LoadF,P,Vect,MaxN,Transf,Nodes)
        !@#$%^$^@#$@$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
        !#!@#!@#print*,'Loads in Main'
        !!@#@!#!@call DisplayV_R(6*MaxN,P,NL)

        !!@#@!print*,'M'
        !@#!@#call Display(MaxN,M,NL)
        !#!@#!@print*,'K'
        !#!@#@!call Display(MaxN,K,NL)
        !#!@#@!print*,'?????'
        !#!@#!@#read*

        !call Inverse(6*MaxN,K,InvK,NL,error)         
        !if (error.eq.1) then 
        !           print*, 'Stiffness Matrix is singular'
        !           stop
        !                endif
        !call MulMatVec(6*MaxN,InvK,P,U,NL)

        !@#############################################
        call Gauss(6*MaxN,K,P,U,NL,error)

        if (error.eq.1) then 
                   print*, 'Stiffness Matrix is singular'
                   stop
                   endif
                   !$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
                   !!!!!call DisplayV_R(6*MaxN,U,NL)
!......................................................................!

        
        print*
        print*,'Engine parts(beams)for the output'
        print*, EngineOut
        open(unit =18,file=EngineOut,iostat=error)
        if (error.gt.0) then
        print*,'error reading file ', EngineOut
        stop  
                        endif

        do while (.true.)

        read(18,fmt=*,iostat=error,end=200) Ufile,output,outputf,outputm
        print*
        print*,'file of the part', Ufile
        !!#!@#!@#!@#!#read*
           
           !!!!!!!@#!@#!@#!@#!@#!@#!@#@ call Create_Coordinates(6*MaxN,Coord,Nodes,Ufile) !!! Nodes are calculated for the current part
           call Create_DVector(MaxN,U,Vect,Transf,Ufile,output)
           !#!@#!@#!##!#@#call Displacements(6*MaxN,U,Vect,Nodes,Transf,Coord)
      time=0.0
      call Create_Loading(Ufile,U,MaxN,Vect,Transf,outputf,outputm,time) 

       enddo

200    close(18)   
!......................................................................!
        print*,'Engine parts(Matrix)for the output'
        print*, EngineOutM

        open(unit =18,file=EngineOutM,iostat=error)
        if (error.gt.0) then
        print*,'error reading file ', EngineOutM
        stop  
                        endif

        do while (.true.)

        read(18,fmt=*,iostat=error,end=600) Ufile,output 
        print*
        print*,'file of the part', Ufile
        call Create_Matrix_Force(Ufile,U,Vect,MaxN,Transf,output) 

        enddo

600    close(18)
            !@#!@#!@#!@#!@#!#       endif !if the static solution exists

       print*
       print*,' Static Solution is completed'
       goto 1000

       
       !800    print*,'input Maximium Engine Frequency'
       !read*,MaxFreq
       
800    call DivideMatrix(6*MaxN,M,Acceleration)

       !call MulMat(6*MaxN,InvK,M,Evec,NL)
        !print*,'Vectors'
        !call Display(6*MaxN,Evec,NL)
        !read*

       !#!!#!call EigV_Reley(6*MaxN,K,M,Eval,Evec,NL)       
       !call EigV_Reley(6*MaxN,K,M,Eval,InvK,NL)       
       !call Eqval_Reduce(6*MaxN,InvK,Evec,NL,Modes)

         call EigV(6*MaxN,M,K,Eval,Evec,NL)   

         do i=1,NL
         if (Eval(i).ge.0.0) then
         Eval(i) = (1/(2*PI))/ sqrt(Eval(i)) 
         
                else
                !print*,'not positive eigenvalue'
                Eval(i) = (-1/(2*PI))/ sqrt(abs(Eval(i)))       
                endif
         !if (Eval(i).ge.0.0) then
         !print*,i,Eval(i)
         !!endif
         enddo

        call Reduce_Vectors(Eval,Evec,6*MaxN,NL)

         print*
         print*,'Calculated Engine Frequencies, Hz'
         do i=1,Modes
         print*,i,Eval(i)
         enddo


        !@#!@#call DisplayV_R(6*MaxN,Eval,NL)

        !call DivideMatrix(6*MaxN,M,m0)
        !call DivideMatrix(6*MaxN,K,k0)


        !print*,'Input number of the steps'
        !read*,FreqSteps
        !print*,'Input file to write System Function'
        !read*,SysF
        !open(unit =18,file=SysF,iostat=error)
        !if (error.gt.0) then
        !print*,'error reading file ', SysF
        !stop  
        !                endif

        !Dfreq = MaxFreq/FreqSteps
        !do i = 1, FreqSteps
        !freq = (i-1)*Dfreq
        !w = 2*PI*freq !* sqrt(m0/k0)

        !response = System_F(w,Evec,6*MaxN,NL) 
   
        !write(18,'(F8.2,F16.4)') freq, response
        !enddo

        !print*,'writing completed'
        !stop
        print*
        print*,'Engine parts(beams)for the output'
        print*, EngineOut
        open(unit =18,file=EngineOut,iostat=error)
        if (error.gt.0) then
        print*,'error reading file ', EngineOut
        stop  
                        endif

1999    do while (.true.)
!......................................................................!
        read(18,fmt=*,iostat=error,end=226) Ufile,output,outputf,outputm 
        print*
        print*,'file of the part', Ufile
        !print*,'Modes - ', output
        !print*,'Moments - ', outputf
        !print*,'Forces - ', outputm

        call Write_EigV(MaxN,Eval,Evec,Vect,Transf,Ufile,NL,output)

        open(38,file=outputf,iostat=error)
        if(error.gt.0) then 
        print*,'error open file: ',outputf
                       endif                  
        write(38,*) ' Shear forces for the ', Ufile
        close(38)
           
        open(38,file=outputm,iostat=error)
        if(error.gt.0) then 
        print*,'error open file: ',outputm
                       endif
        write(38,*) ' Bending moments for the ', Ufile
        close(38)

        enddo

226     close(18)

        print*
        print*,'Engine parts(Matrix)for the output'
        print*, EngineOutM
        open(unit =18,file=EngineOutM,iostat=error)
        if (error.gt.0) then
        print*,'error reading file ', EngineOutM
        stop  
                        endif

3999    do while (.true.)

        read(18,fmt=*,iostat=error,end=4000) Ufile, output 
        print*
        print*,'file of the part', Ufile
        call Write_EigV_M(MaxN,Eval,Evec,Vect,Transf,Ufile,NL,output)
        enddo

4000    close(18)
       print*
       print*,' Natural Frequencies Analysis is completed'
       print*
      
                      if (c.eq.'6') then
                                    goto 20
                                    else
                                    goto 1000
                                    endif


20     print*,' Transient analysis is started'
       !it is supposed that the initial conditions are zero
        !print*,' Input Data for the transient ',TransientF 
        open(unit =18,file=TransientF,iostat=error)
        if (error.gt.0) then
        print*,'error reading file ', TransientF
        stop  
                        endif

        read(18,*,iostat=error,end=21) elements 
        read(18,*,iostat=error,end=21) Mtime,Nsteps
        print*,' Maximim time ', Mtime
        print*,' Time steps ',Nsteps
        tstep = Mtime/Nsteps
        !tstep = 1.0 / (2*MaxFreq)
        print*,' Time step ',tstep
        
        read(18,*,iostat=error,end=21) elements 
        read(18,*,iostat=error,end=21) UnbLoad
        !print*,'Periodic Loads are in the:'
        !print*,UnbLoad


        read(18,*,iostat=error,end=21) elements 
        read(18,*,iostat=error,end=21) LogDecF
        !print*,'Log Dec is in the:'
        !print*,LogDecF



        read(18,*,iostat=error,end=21) elements 
        read(18,*,iostat=error,end=21) TransientOut
        print*,'Output for Transient:'
        print*,TransientOut

 
21      close(18)
       
        !!!!!!!!stop


        open(unit =28,file=TransientOut,iostat=error)
        if (error.gt.0) then
        print*,'error reading file ', TransientOut
        stop 
                        endif
      
       read(28,*,iostat=error,end=23) elements

       do while(.true.)

       read(28,fmt=*,iostat=error,end=23) station,Ufile
       open(unit =38,file=Ufile,iostat=error)
       if (error.gt.0) then
       print*,'error reading file ', Ufile
       stop 
                       endif
       write(38,*) 'Displacements for the station',station
       call ConvToNode(MaxN,Transf,station,OutNode)
       !!!!!print*,' node for the output', station, OutNode
       close(38)

       enddo

23     close(28)


       print*,' Output files created'
       print*
       !!!!stop 

        open(unit =28,file=LogDecF,iostat=error)
        if (error.gt.0) then
        print*,'error reading file ', LogDecF
        stop 
                        endif
      
       read(28,*,iostat=error,end=26) elements
       read(28,*) logmin,logmax
       !####print*,'min & max',logmin, logmax

26     close(28)

       time = 0.0
       step = 0
       do while (time.lt.MTime)
       
       LogDec = logmin + time*(logmax-logmin)/MTime
       !----------------------------------
       !#######print*,'time = ', time
       !----------------------------------
        do j = 1, Modes
        if (Eval(j).lt.0.0) then
                            continue
                            endif

        
        damp = LogDec * Eval(j) ! it is assumed 0.01 log deg for each time
                              ! for each element
        wn = 2*PI*Eval(j)
        !#######kn, tetai, ai, 

        U(j) = 0.0
        VU(j) = 0.0

        open(unit =18,file=UnbLoad,iostat=error)
        if (error.gt.0) then
        print*,'error reading file ', UnbLoad
        stop 
                        endif
       read(18,*,iostat=error,end=22) elements 

        do while (.true.)
      read(18,fmt='(I10,I8,2G10,G16,G10,3G6)',iostat=error,end=22) 
     $station,Dofs,wmin,wmax,Mag,Phase,Aw2,Bw,Cw0
!......................................................................!     
         wmin = 2*PI*wmin
         wmax = 2*PI*wmax
         
        !##################################33
        !!!!!print*,station, Dofs, Wmin, Wmax, Mag, Phase
        !######################################

        call ConvToNode(MaxN,Transf,station,node)
        !!!print*,'node',node
        ! node is a global number in the system
        w  = wmin + ((wmax - wmin)/Mtime) * time
        !w  = wmin + ((wmax - wmin)/Nsteps) * step
        !step = step + 1
        !########## print*,'w= ', w
        Phase = Phase * PI / 180.
        Mag = Mag * (Aw2*w**2+Bw*w+Cw0)

        do while (Dofs.ge.10)
        digit = mod(Dofs,10)
        Dofs = (Dofs - digit) / 10
        !########print*,'Dof ', digit
        ind = Vect(6*node-6+digit)
        if (ind.gt.0) then
                      Pin = Evec(ind,j) * Mag 
                      else                        
                      Pin = 0.0
                      endif 


        !pn = Magnitude(Pin,w,Phase,damp,wn,time)
        !tetan = Phase2(Pin,w,Phase,damp,wn,time)

        !U(j) = U(j)+pn*cos(w*time+Phase+tetan)
        !VU(j) = VU(j) - w*pn*sin(w*time+Phase+tetan)

        call Transfer1(w,damp,wn,ampl,cost,sint)
        pn = Pin*ampl
!......................................................................!        
        U(j) = U(j)+pn*(cos(w*time+Phase)*cost-sin(w*time+Phase)*sint)
        VU(j)=VU(j)-w*pn*(sin(w*time+Phase)*cost+cos(w*time+Phase)*sint)

        enddo
        ind = Vect(6*node-6+Dofs)
        if (ind.gt.0) then
                      Pin = Evec(ind,j) * Mag 
                      else                        
                      Pin = 0.0
                      endif 

        !pn = Magnitude(Pin,w,Phase,damp,wn,time)
        !tetan = Phase2(Pin,w,Phase,damp,wn,time)

        !U(j) = U(j)+pn*cos(w*time+Phase+tetan)
        !VU(j) = VU(j) - w*pn*sin(w*time+Phase+tetan)

        call Transfer1(w,damp,wn,ampl,cost,sint)
        pn = Pin*ampl
!......................................................................!        
        U(j) = U(j)+pn*(cos(w*time+Phase)*cost-sin(w*time+Phase)*sint)
        VU(j)=VU(j)-w*pn*(sin(w*time+Phase)*cost+cos(w*time+Phase)*sint)


        !print*,'Mag=',Mag
        !print*,'U = ',Evec(ind,j)
        !print*,'pn=',pn
        !read*
        
        !!!!!!!print*,'Velocity=',VU(j)

        enddo !cycle for loads
!......................................................................!

22     close(18) ! Close file with the Unbalance Loads


       enddo !cycle over the modes 

       !######################################
       ! Define the displacements
       !#######################################
       do comp1 = 1, NL 
       P(comp1) =0.0
       do comp2 = 1, Modes
       P(comp1) = P(comp1)+Evec(comp1,comp2)*U(comp2) 
       enddo
       enddo 
        
        open(unit =28,file=TransientOut,iostat=error)
        if (error.gt.0) then
        print*,'error reading file ', TransientOut
        stop 
                        endif
       read(28,*,iostat=error,end=43) elements
       do while(.true.)
       read(28,fmt=*,iostat=error,end=43) station,Ufile
       open(unit =38,file=Ufile,status='OLD',iostat=error)
       if (error.gt.0) then
       print*,'error reading file ', Ufile
       stop 
                       endif

       call ConvToNode(MaxN,Transf,station,OutNode)

       if (OutNode.gt.0) then

       do comp1 =1,6
       ind = Vect(6*OutNode-6+comp1)
       !print*,'Node = ',OutNode
       !print*,'comp = ',comp1
       !print*,ind
       if (ind.gt.0.0) then
       Disp(comp1) = P(ind)
                       else
       Disp(comp1) = 0.0
                       endif
       !!!print*,P(comp1)
       enddo

       do while (.true.)
       read(38,*,end=50) elements
       enddo
50    write(38,'(7f8.4)') time,Disp(1),Disp(2),Disp(3),Disp(4),Disp(5),
     $Disp(6)  
       close(38)

      endif !if node exist
       enddo ! complete read files for the output
43     close(28)
       !!!!print*, " No loads are written"
       !!!!!continue;

!!!!!!!! Now we are writing loads to the files for each time point

        open(unit =28,file=EngineOut,iostat=error)
        if (error.gt.0) then
        print*,'error reading file ', EngineOut
        stop 
                        endif
!......................................................................!
       do while(.true.)
       read(28,fmt=*,iostat=error,end=73) Ufile,output,outputf,outputm
      call Create_Loading(Ufile,P,MaxN,Vect,Transf,outputf,outputm,time)
       enddo ! complete read files for the output

73     close(28)



!!!!!!!! loads to the files for each time point completed
       time = time + tstep    
       enddo !cycle over the time

       print*,' Transient analysis completed'
       print*
       goto 1000

1000   print*,' Program Excecution Completed'

        end program DynRotor
