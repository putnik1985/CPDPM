!......................................................................!
      subroutine Create_FEM(ElementsFile, M, K, Coord, N, Nodes,Transf)
      integer Nodes
      
      character*256  ElementsFile, string
      character c
      real*8 M(6*N,6*N), K(6*N,6*N), ME(12,12), KE(12,12) 
      integer error, station1, station2, N
      real*8  x1, Ro1, Ri1, E1, Rho1, Nu1, Mass1, Ip1, Id1 
      real*8  x2, Ro2, Ri2, E2, Rho2, Nu2, Mass2, Ip2, Id2
      real*8 F, JD, JY, JZ, L, RO, E, G, PI, Coord(N)
      integer Transf(N),LocalNode
      Parameter (PI = 3.14159)
        real*8 Dens,Length,Modul
        common /sound/ Dens, Length,Modul


      print*, 'file of the part', ElementsFile
      open(unit =12,file=ElementsFile,iostat=error)
      if (error.gt.0) then
      print*,'error reading file ', ElementsFile 
      stop 
      else
      !@#!@#call Vector_Zero(N,Coord)
      LocalNode=0  
    
      print*,'start file reading'
      read(12,*,end=100) ! read first string of the title
      Dens = 0.0
      Length = 0.0 
      Modul = 0.0
!......................................................................!

      read(12,fmt='(I10,9G10)',iostat=error,end=100) station1,x1,Ro1,
     $Ri1, E1, Rho1, Nu1, Mass1, Ip1, Id1
      
      if (E1.gt.Modul) then 
                       Modul = E1
                       endif
      if (Rho1.gt.Dens) then 
                        Dens = Rho1
                        endif

      Nodes = Nodes + 1
      LocalNode = LocalNode+1
      Coord(Nodes) = x1 

      Transf(Nodes)=station1
      station1 = Nodes

      call Add_Lumped(station1,Mass1,Ip1,Id1,M,N)
    
      do while(.true.)
      read(12,fmt='(I10,9G10)',iostat=error,end=100) station2,x2,Ro2,
     $Ri2, E2, Rho2, Nu2, Mass2, Ip2, Id2
      Nodes = Nodes + 1
      LocalNode = LocalNode+1
      Coord(Nodes) = x2 

      !#!@##!@3write(*,*) station2,x2,Ro2,Ri2,E2,Rho2,Nu2,Mass2,Ip2,Id2
      !#!@#!@#read*


      Transf(Nodes)=station2
      station2 = Nodes


      L = abs(x2-x1)

      if (E2.gt.Modul) then 
                       Modul = E2
                       endif

      if (Rho2.gt.Dens) then 
                        Dens = Rho2
                        endif 

      if (L.gt.Length) then 
                       Length = L
                       endif



      JD = (PI/2) * (Ro1**4-Ri1**4)
      JY = JD / 2.0
      JZ = JD / 2.0
      F = PI * (Ro1**2-Ri1**2)
      G = E1 / (2*(1+Nu1))

      call FORM_LOCAL_KE_BEAM(F,JD,JY,JZ,L,E1,G,KE)
      call FORM_LOCAL_ME_BEAM(F,L,Rho1,JD,ME) 

      !@#!#!@#call Display(12,KE,12)
 
      ! No coosrdinate system transformation is required
      !@#@!#!@###!@#@# print*,'i',station1,'j',station2


      call Add_Global(station1,station2,KE,K,N)
      call Add_Global(station1,station2,ME,M,N)


      call Add_Lumped(station2,Mass2,Ip2,Id2,M,N)

      station1 = station2
      x1 = x2
      Ro1 = Ro2
      Ri1 = Ri2
      E1 = E2
      Rho1 = Rho2
      Nu1 = Nu2
      Mass1 = Mass2
      Ip1 = Ip2
      Id1 = Id2
    
      enddo !!!!! end of the file reading
100   close(12)

      !@#print*,' Part status'
      !@#call Inertia(N, M, K, Coord, Nodes)
      endif
      
      end subroutine Create_FEM

!......................................................................!
      subroutine Apply_BC(BCFile, M, K, Vect, N, Transf, LN,Nodes)
      character*256  BCFile
      real*8 M(6*N,6*N), K(6*N,6*N), value
      integer node, error, digit, Vect(6*N)
      integer dof, Nodes, k1, N, LN, node2,num
      integer Transf(N)

      
      LN = 6*Nodes
      print*, 'file of the Boundary Conditions ', BCFile
      open(unit =12,file=BCFile,iostat=error)
      if (error.gt.0) then
      print*,'error reading file ', BCFile 
      stop  
      else
      !! print*,'Nodes ', Nodes
      num = 0
      do node=1,Nodes
      do k1 = 1, 6
      Vect(6*node-6+k1)=6*node-6+k1  !!!! define the initial 
      enddo 
      enddo
      !@#$@$%^%*&^&(*&(^^%$^$#%$^&*&()*)*&^&%&
      !#!@#!#!#!#print*,' Dofs'
      !#!@#!#!#!#!#call DisplayV(6*N,Vect,6*Nodes)
      !!!!!!!!!!read*
      !@#$@$%^%*&^&(*&(^^%$^$#%$^&*&()*)*&^&%&

      print*,'start file reading'
      read(12,*,iostat=error,end=200) ! read first string of the title
      
      do while(.true.)
      !print*,' ready '
500   read(12,fmt='(2I8,G8)',iostat=error,end=200) node, dof, value

      !#!@#!#!@#!print*,'read node',node
      !@#!@#!@!@#!@#call DisplayV(N,Transf,Nodes)
      !#!@#!@#!@#!@#!#read*
      call ConvToNode(N,Transf,node,node2)

      if (node2.eq.0) then
!......................................................................!
                     print*,'there is no ',node,' station in the system'
                     goto 500
                     endif
                     
      !#!@#@##print*,'program node',node2
      node = node2

      !write(*,*) node, dof, value
      !read*
      !print*,'dofs are '

      do while (dof.ge.10)
      digit = mod(dof,10)
      !!!@#!@#print*, digit
      !@#!@#read* 
      ind = Vect(6*node-6+digit)
      !@#$@$%^%*&^&(*&(^^%$^$#%$^&*&()*)*&^&%&
      !#!#!@#!@print*,'remove ', 6*node-6+digit
      !#!@#!@#!##read*
      !#@$%@#$^$&%*&(&*^%^^&%&(*&(%$&^%$^^$
      call CutDof(6*N,M,ind,Nodes)
      call CutDof(6*N,K,ind,Nodes)
      call ChangeVec(6*N,Vect,6*node-6+digit,Nodes)
      LN = LN - 1
      num = num + 1
      !!!!!!!!!!!!!!!!!!#$##%^%$%^&^()*)_*%^$#%#@%!!!!!!!!1

      !!!!!!!!!!!!!@#$$&^*(^%$$@#$@^%*&%^$^!!!!!!!!!!!!!!!!!!!!
      dof = (dof - digit) / 10

      enddo

      !print*, dof
      ind = Vect(6*node-6+dof)
      !@#$@$%^%*&^&(*&(^^%$^$#%$^&*&()*)*&^&%&
      !!!!!!!!!!!!!print*,'remove ', 6*node-6+dof
      !#@$%@#$^$&%*&(&*^%^^&%&(*&(%$&^%$^^$
      !!!!!!!!!!!!!!!print*,'ind = ', ind
      call CutDof(6*N,M,ind,Nodes)
      call CutDof(6*N,K,ind,Nodes)
      call ChangeVec(6*N,Vect,6*node-6+dof,Nodes)
      LN = LN - 1
      num = num + 1

      !@##@#@#!$$!!@#$@$$$
      !#!@#!@#!call DisplayV(6*N,Vect,6*Nodes)
      !#!@#!@#!@read*
      !@$@#$@#$@#$#$@#$@#$@$@#$@$

      enddo
200   close(12)

      !#@$%@#$^$&%*&(&*^%^^&%&(*&(%$&^%$^^$
      !!#!@#@!#!@#!print*,' Dofs after reduction '
      !!#!@#!@#!@#call DisplayV(6*N,Vect,6*Nodes)
      !!#!@#!@#!@#!read*
      !#@$%@#$^$&%*&(&*^%^^&%&(*&(%$&^%$^^$
      print*,'-------------------------------------------------'
      print*,'number of the boundary conditions',num
      print*,'-------------------------------------------------'
      endif !!! case of the acceptable file reading

      end subroutine Apply_BC



!......................................................................!
      subroutine Create_Static_Force(LoadF, P, Vect, N,Transf,Nodes)
      character*256  LoadF
      real*8 P(6*N)
      integer node, error, digit, N, Vect(6*N)
      integer dof, Nodes, k1, ind,node2,num
      integer Transf(N)

      !!!!!print*,' Loads '
      call Vector_Zero(6*N,P)

      !@#$$$$$%#@$@#$#@$#@@#$@#$
      !print*,' Loads before apply'
      !call DisplayV_R(6*N,P,6*Nodes)
      !!!!!!!!!!!!!!!!!!!!!!!!!!!call DisplayV(6*N,Vect,6*Nodes)
      !!#@#!$#$^%#$%$#%#$@%#$%#

      print*, 'file of the Loads Conditions ', LoadF
      open(unit =12,file=LoadF,iostat=error)

      if (error.gt.0) then
      print*,'error reading file ', LoadF 
      stop 
      else
      num=0
      print*,'start file reading'
      read(12,*,iostat=error,end=300) ! read first string of the title
      
      do while(.true.)
      !print*,' ready '
500   read(12,fmt='(2I8,G8)',iostat=error,end=300) node, dof, value

      !!#!@#!@#!@#write(*,*) node, dof, value
      !!#!@#!@#!#read*

      call ConvToNode(N,Transf,node,node2)

      if (node2.eq.0) then
!......................................................................!
                     print*,'there is no ',node,' station in the system'
                     goto 500
                     endif

      node = node2

      !!#!@#!@#!@#!print*,'program node'
      !!#!@#!@#!@#!write(*,*) node, dof, value
      !!#!@#!@#!@#!@#!read*
      
      !print*,'dofs are '

      do while (dof.ge.10)

      digit = mod(dof,10)
      !!!print*, digit
      !!!print*, 6*node-6+digit
      ind = Vect(6*node-6+digit)
      if (ind.gt.0) then 
                    P(ind) = value
                    num = num + 1
                    endif
      dof = (dof - digit) / 10
      enddo

      ind = Vect(6*node-6+dof)
      if (ind.gt.0) then 
                    P(ind) = value
                    num = num + 1
                    endif

      enddo
300   close(12)

      !#@$%@#$^$&%*&(&*^%^^&%&(*&(%$&^%$^^$
      !@#!@#@!#!@print*,' Loads '
      !!#!@#!@#!@#call DisplayV_R(6*N,P,6*Nodes)
      !!@#!@#read*
      !#@$%@#$^$&%*&(&*^%^^&%&(*&(%$&^%$^^$

      print*,'-------------------------------------------------'
      print*,'number of the Loads conditions',num
      print*,'-------------------------------------------------'
      
      endif
      

      end subroutine Create_Static_Force

!......................................................................!
                  
      subroutine Create_Loading(ElementsFile, U, N,Vect,Transf,o1,o2,t)
      integer n1,n2,i
      real*8 t
      character*256  ElementsFile, output,output2,o1,o2,elements
      character c
      real*8 KE(12,12), Forces1(N,7),Forces2(N,7),V(12)
      integer error, station1, station2, N,EID, Vect(6*N),Transf(N)
      real*8  x1, Ro1, Ri1, E1, Rho1, Nu1, Mass1, Ip1, Id1 
      real*8  x2, Ro2, Ri2, E2, Rho2, Nu2, Mass2, Ip2, Id2
      real*8 F, JD, JY, JZ, L, RO, E, G, PI, U(6*N),F1(12)
      integer node1, node2, ind
      Parameter (PI = 3.14159)
  
 


      open(unit =12,file=ElementsFile,iostat=error)
      if (error.gt.0) then
      print*,'error reading file ', ElementsFile  
      else

      print*,'filename to write Share Forces'
      print*,o1

      open(unit =14,file=o1,iostat=error)
      if (error.gt.0) then
      print*,'error writing file '
      stop  
                      endif

      print*,'filename to write Bending Moments'
      print*,o2


      open(unit =16,file=o2,iostat=error)
      if (error.gt.0) then
      print*,'error writing file '
      stop  
                      endif

       !go to  the end of the Forces file
       do while (.true.)
       read(14,*,end=53) elements
       enddo
53     write(14,*) "time = ", t  

       !go to  the end of the Moments file
       do while (.true.)
       read(16,*,end=63) elements
       enddo
63     write(16,*) "time = ", t  



      print*,'Create Loads'
      call Vector_Zero(12,V)
      call Vector_Zero(12,F1)
      do n1=1,N
      do n2 =1,7
      Forces1(n1,n2) =0.0 
      Forces2(n1,n2) =0.0 
      enddo
      enddo
      EID = 0
      read(12,*) ! read first string of the title
      
!......................................................................!

      read(12,fmt='(I10,9G10)',iostat=error,end=100) station1,x1,Ro1,
     $Ri1, E1, Rho1, Nu1, Mass1, Ip1, Id1

      call ConvToNode(N,Transf,station1,node1)
      station1 = node1
      
    
      do while(.true.)
      read(12,fmt='(I10,9G10)',iostat=error,end=100) station2,x2,Ro2,
     $Ri2, E2, Rho2, Nu2, Mass2, Ip2, Id2

      call ConvToNode(N,Transf,station2,node2)
      station2 = node2


      !!!! write(*,*) station, x, Ro, Ri, E, Rho, Nu, Mass, Ip, Id
      EID = EID + 1     
      L = abs(x2-x1)

      JD = (PI/2) * (Ro1**4-Ri1**4)
      JY = JD / 2.0
      JZ = JD / 2.0
      F = PI * (Ro1**2-Ri1**2)
      G = E1 / (2*(1+Nu1))
     
      call FORM_LOCAL_KE_BEAM(F,JD,JY,JZ,L,E1,G,KE)
      !!!!!print*,'form vector'

      do n1 = 1, 6
      !print*, 6*station1-6+n1
      !print*, 6*station2-6+n1
      !print*, 6*Nodes
      !print*,V(n1)
      !print*,U(6*station1-6+n1)

      ind = Vect(6*station1-6+n1)
      if (ind.ne.0) then 
                    V(n1) = U(ind)
                    else
                    V(n1) = 0.0
                    endif
      
      ind = Vect(6*station2-6+n1)
      if (ind.ne.0) then 
                    V(n1+6) = U(ind)
                    else
                    V(n1+6) = 0.0
                    endif
      !#!##!#!@print*,V(n1)
      enddo
      !!!!!!!!!print*,'formed vector'

       do n2 = 1,12 
       F1(n2) = 0.0
       do n1 =1,12
       F1(n2) = F1(n2) + KE(n2,n1)*V(n1) 
       enddo
       enddo
      
      !@#$@@@@@%$#%#$%#$%#$%##$
      !print*,'Forces....'
      !  do n1 =1,12
      !  print*,F1(n1)
      !  enddo
      !read*

      do n1=1,4
      
      Forces1(EID,n1) = -F1(n1)
      Forces2(EID,n1) = -F1(n1)
    
      enddo

      Forces1(EID,5) = -F1(5)
      Forces2(EID,5) = -F1(5) - L*F1(3)


      Forces1(EID,6) = -F1(6)
      Forces2(EID,6) = -F1(6) + L*F1(2)
    

      Forces1(EID,7) = x1
      Forces2(EID,7) = x2

      !@#!@#@!#!@#!@#!@#print*,'Element',EID
      !!#!@#!@#!@#!@#!print*,Forces1(EID,2),Forces2(EID,2)
      !!#!@#!@#!@#!@#!@#!@!@#read*

      !print*,station2
      !print*,F1(6), F1(12)
      !@#$@#!$@#$@#$@#$@#$@#$@#$@#$@$@#read*
     
      ! No coosrdinate system transformation is required
      i = EID
      write(14,'(4G16.5)') Forces1(i,7), Forces1(i,1),Forces1(i,2),
     $Forces1(i,3)
      write(14,'(4G16.5)') Forces2(i,7),Forces2(i,1),Forces2(i,2),
     $Forces2(i,3)


      write(16,'(4G16.5)') Forces1(i,7), Forces1(i,4),Forces1(i,5),
     $Forces1(i,6)
      write(16,'(4G16.5)') Forces2(i,7),Forces2(i,4),Forces2(i,5),
     $Forces2(i,6)

 
      station1 = station2
      x1 = x2
      Ro1 = Ro2
      Ri1 = Ri2
      E1 = E2
      Rho1 = Rho2
      Nu1 = Nu2
      Mass1 = Mass2
      Ip1 = Ip2
      Id1 = Id2
    
      enddo !!!!! end of the file reading
100   close(12)
      close(14)
      close(16)

      endif

      !@#!@#!@#@#@#!@###!@# call DisplayForces(Forces1,Forces2,Nodes,EID)
      
      end subroutine Create_Loading


      subroutine Create_Coordinates(N,Coord,Nodes,ElementsFile)
      integer Nodes
      character*256  ElementsFile, string
      character c
      integer error, station1, station2, N
      real*8  x1, Ro1, Ri1, E1, Rho1, Nu1, Mass1, Ip1, Id1 
      real*8  x2, Ro2, Ri2, E2, Rho2, Nu2, Mass2, Ip2, Id2
      real*8 F, JD, JY, JZ, L, RO, E, G, PI, Coord(N)
      Parameter (PI = 3.14159)
  
      print*, 'file of the rotor', ElementsFile
      open(unit =12,file=ElementsFile,iostat=error)
      if (error.gt.0) then
      print*,'error reading file ', ElementsFile  
      else
      Nodes = 0
      call Vector_Zero(N,Coord)      
      print*,'start file reading'
      read(12,*,end=100) ! read first string of the title
      
!......................................................................!

      read(12,fmt='(I10,9G10)',iostat=error,end=100) station1,x1,Ro1,
     $Ri1, E1, Rho1, Nu1, Mass1, Ip1, Id1
      
      Nodes = Nodes + 1
      Coord(Nodes) = x1 

      do while(.true.)
      read(12,fmt='(I10,9G10)',iostat=error,end=100) station2,x2,Ro2,
     $Ri2, E2, Rho2, Nu2, Mass2, Ip2, Id2
      Nodes = Nodes + 1
      Coord(Nodes) = x2
      enddo !!!!! end of the file reading
100   close(12)

      call DisplayV_R(N,Coord,Nodes)
     
      endif
      
      end subroutine Create_Coordinates


      subroutine Create_DVector(N,U,Vect,Transf,Ufile,output)
      character*256 Ufile, output
      integer error, station1, station2, N
      real*8  x1, Ro1, Ri1, E1, Rho1, Nu1, Mass1, Ip1, Id1 
      real*8  x2, Ro2, Ri2, E2, Rho2, Nu2, Mass2, Ip2, Id2
      real*8 F, JD, JY, JZ, L, RO, E, G
      integer Transf(N), Vect(6*N),ind,dof,Nodes
      real*8 U(6*N),T(6)



      !@#@!#@!#@!#!@#!@#!@#!@#print*,'file of the part', Ufile
      open(unit =12,file=Ufile,iostat=error)
      if (error.gt.0) then
      print*,'error reading file ', Ufile  
      else
     
      print*,' filename to write displacements'
      print*,output
      
      !@##@#@#@#@#@#@#print*,'form displacements of the part'
      read(12,*) ! read first string of the title
      
!......................................................................!
      open(unit =14,file=output,iostat=error)
      if (error.gt.0) then
      print*,'error writing file '
      stop  
                      endif

      do while(.true.)
      read(12,fmt='(I10,9G10)',iostat=error,end=400) station2,x2,Ro2,
     $Ri2, E2, Rho2, Nu2, Mass2, Ip2, Id2

      call ConvToNode(N,Transf,station2,node)
      call  Vector_Zero(6,T)
     
      do dof = 1, 6
      ind = Vect(6*node-6+dof)
      if (ind.ne.0) then 
                   T(dof) = U(ind)
                   endif
     
      enddo 
  
      write(14,'(7G16.5)') x2,T(1),T(2),T(3),T(4),T(5),T(6)
    
      enddo !!!!! end of the file reading

400   close(12)
      close(14)

   
      endif
 

      end subroutine Create_DVector


      subroutine Apply_Couplings(BCFile, K, N, Transf)
      !this subroutine should be applied before Boundary conditions
      character*256  BCFile
      real*8 K(6*N,6*N), value
      integer node1, node2, error, digit
      integer dof, k1, N, ind1, ind2,num
      integer Transf(N),station1, station2

      
      print*, 'file of the Couplings ', BCFile
      open(unit =12,file=BCFile,iostat=error)
      if (error.gt.0) then
      print*,'error reading file ', BCFile 
      stop 
      else
      num = 0
      print*,'start file reading'
      read(12,*,iostat=error,end=200) ! read first string of the title
!......................................................................!      
      do while(.true.)
500   read(12,fmt='(3I10,G10)',iostat=error,end=200) station1, station2,
     $dof, value

                     
      !#!@#!@#@#write(*,*) station1, station2, dof, value
      !!#!@#!@#!@#!@#read*
      !print*,'dofs are '
      call ConvToNode(N,Transf,station1,node1)

      if (node1.eq.0) then
!......................................................................!
                print*,'there is no ',station1,' station in the system'
                     goto 500
                     endif

      call ConvToNode(N,Transf,station2,node2)

      if (node2.eq.0) then
!......................................................................!
                print*,'there is no ',station2,' station in the system'
                     goto 500
                     endif


      do while (dof.ge.10)
      digit = mod(dof,10)
      !!!@#!@#print*, digit
      !@#!@#read* 
      !@#$@$%^%*&^&(*&(^^%$^$#%$^&*&()*)*&^&%&
      !#!#!@#!@print*,'remove ', 6*node-6+digit
      !#!@#!@#!##read*
      !#@$%@#$^$&%*&(&*^%^^&%&(*&(%$&^%$^^$
      !!!!!!!!!!!!!!!!!!#$##%^%$%^&^()*)_*%^$#%#@%!!!!!!!!1
      ind1 = 6*node1-6+digit
      ind2 = 6*node2-6+digit
      K(ind1,ind1) = K(ind1,ind1) + value
      K(ind1,ind2) = K(ind1,ind2) - value
      K(ind2,ind1) = K(ind2,ind1) - value
      K(ind2,ind2) = K(ind2,ind2) + value
      !!!!!!!!!!!!!@#$$&^*(^%$$@#$@^%*&%^$^!!!!!!!!!!!!!!!!!!!!
      dof = (dof - digit) / 10
      num = num + 1
      enddo

      !print*, dof
      !@#$@$%^%*&^&(*&(^^%$^$#%$^&*&()*)*&^&%&
      !!!!!!!!!!!!!print*,'remove ', 6*node-6+dof
      !#@$%@#$^$&%*&(&*^%^^&%&(*&(%$&^%$^^$
      !!!!!!!!!!!!!!!print*,'ind = ', ind
      digit = dof
      ind1 = 6*node1-6+digit
      ind2 = 6*node2-6+digit
      K(ind1,ind1) = K(ind1,ind1) + value
      K(ind1,ind2) = K(ind1,ind2) - value
      K(ind2,ind1) = K(ind2,ind1) - value
      K(ind2,ind2) = K(ind2,ind2) + value
      num = num + 1
      !@##@#@#!$$!!@#$@$$$
      !#!@#!@#!call DisplayV(6*N,Vect,6*Nodes)
      !#!@#!@#!@read*
      !@$@#$@#$@#$#$@#$@#$@$@#$@$

      enddo
200   close(12)

      !#@$%@#$^$&%*&(&*^%^^&%&(*&(%$&^%$^^$
      !#!@##@#!@#print*,' Dofs after reduction '
      !#!@#@!#!@#call DisplayV(6*N,Vect,6*Nodes)
      !#@$%@#$^$&%*&(&*^%^^&%&(*&(%$&^%$^^$

      print*,'-------------------------------------------------'
      print*,'number of the Couplings',num
      print*,'-------------------------------------------------'
 
      endif !!! case of the acceptable file reading

      end subroutine Apply_Couplings


      subroutine Apply_Mounts(BCFile, K, N, Transf)
      !this subroutine should be applied before Boundary conditions
      character*256  BCFile
      real*8 K(6*N,6*N), value
      integer node1, node2, error, digit
      integer dof, k1, N, ind1, ind2,num
      integer Transf(N),station1, station2

      
      print*, 'file of the Mounts ', BCFile
      open(unit =12,file=BCFile,iostat=error)
      if (error.gt.0) then
      print*,'error reading file ', BCFile
      stop  
      else
      num = 0
      print*,'start file reading'
      read(12,*,iostat=error,end=200) ! read first string of the title
!......................................................................!      
      do while(.true.)
500   read(12,fmt='(2I10,G10)',iostat=error,end=200) station1,dof,value

                     
      !!#!@#!@!@#!#write(*,*) station1, dof, value
      !!#!@#!@#!@#!#!read*
      !print*,'dofs are '
      call ConvToNode(N,Transf,station1,node1)


      if (node1.eq.0) then
!......................................................................!
                print*,'there is no ',station1,' station in the system'
                     goto 500
                     endif


      do while (dof.ge.10)
      digit = mod(dof,10)
      !!!@#!@#print*, digit
      !@#!@#read* 
      !@#$@$%^%*&^&(*&(^^%$^$#%$^&*&()*)*&^&%&
      !#!#!@#!@print*,'remove ', 6*node-6+digit
      !#!@#!@#!##read*
      !#@$%@#$^$&%*&(&*^%^^&%&(*&(%$&^%$^^$
      !!!!!!!!!!!!!!!!!!#$##%^%$%^&^()*)_*%^$#%#@%!!!!!!!!1
      ind1 = 6*node1-6+digit
      K(ind1,ind1) = K(ind1,ind1) + value
      !!!!!!!!!!!!!@#$$&^*(^%$$@#$@^%*&%^$^!!!!!!!!!!!!!!!!!!!!
      dof = (dof - digit) / 10
      num = num + 1
      enddo

      !print*, dof
      !@#$@$%^%*&^&(*&(^^%$^$#%$^&*&()*)*&^&%&
      !!!!!!!!!!!!!print*,'remove ', 6*node-6+dof
      !#@$%@#$^$&%*&(&*^%^^&%&(*&(%$&^%$^^$
      !!!!!!!!!!!!!!!print*,'ind = ', ind

      digit = dof
      ind1 = 6*node1-6+digit
      K(ind1,ind1) = K(ind1,ind1) + value
      num = num + 1
      !@##@#@#!$$!!@#$@$$$
      !#!@#!@#!call DisplayV(6*N,Vect,6*Nodes)
      !#!@#!@#!@read*
      !@$@#$@#$@#$#$@#$@#$@$@#$@$

      enddo
200   close(12)

      !#@$%@#$^$&%*&(&*^%^^&%&(*&(%$&^%$^^$
      !#!@##@#!@#print*,' Dofs after reduction '
      !#!@#@!#!@#call DisplayV(6*N,Vect,6*Nodes)
      !#@$%@#$^$&%*&(&*^%^^&%&(*&(%$&^%$^^$

      print*,'-------------------------------------------------'
      print*,'number of the Mounts',num
      print*,'-------------------------------------------------'
 
      endif !!! case of the acceptable file reading

      end subroutine Apply_Mounts


!......................................................................!
      subroutine Create_Matrix(ElementsFile, M, K, N, Nodes,Transf)
      integer Nodes
      
      character*256  ElementsFile, string
      character c
      real*8 M(6*N,6*N), K(6*N,6*N), ME(12,12), KE(12,12) 
      integer error, station1, station2, N, dof,node1
      real*8  x1,Mass,Ip,Id,x2,xc,U 
      real*8 F,R(6),m1,m2,Jp1,Jp2,Jd1,Jd2, Jo
      integer Transf(N),i,j
      
  
      print*, 'file of the part', ElementsFile
      open(unit =12,file=ElementsFile,iostat=error)
      if (error.gt.0) then
      print*,'error reading file ', ElementsFile 
      stop 
      else
   
      print*,'start file reading'
      read(12,*,end=100) ! read first string of the title

!......................................................................!

      read(12,fmt='(I10,G10)',iostat=error,end=100) station1,x1
      !@#!@#@!#@!print*,'read ',station1,x1
      !!#!#!@##read*

      call ConvToNode(N,Transf,station1,node1)
      if (node1.eq.0) then
                      Nodes = Nodes + 1
                      Transf(Nodes)=station1
                      station1 = Nodes
                      else
                      station1 = node1
                      endif

      !!#!@#@!print*,'read ',station1,x1
      !#!#!#!#!read*
      

      read(12,fmt='(I10,G10)',iostat=error,end=100) station2,x2
      !!#!@#!@#print*,'read ',station2,x2
      !!###!#@#read*

      call ConvToNode(N,Transf,station2,node1)
      if (node1.eq.0) then
                      Nodes = Nodes + 1
                      Transf(Nodes)=station2
                      station2 = Nodes
                      else
                      station2 = node1
                      endif

      !!#!@#!@#print*,'read ',station2,x2
      !@#!@#!@#read*


      read(12,*) ! read comments
      read(12,fmt='(4G10)',iostat=error,end=100) Mass,Ip,Id,xc 

      !!#!@#!@print*,'read ',Mass,Ip,Id,xc
      !!#!@#!@#read*

      read(12,*) ! read comments
      read(12,*) ! read comments
      read(12,*) ! read comments
      read(12,*) ! read comments
      read(12,*) ! read title

      call Matrix_Zero(12,KE)
      call Matrix_Zero(12,ME)

      ! read reactions in the first station if force is applied in the 
      ! second section

      do i = 1,6
!......................................................................!
      read(12,fmt='(G10,I4,G16,6G8)',iostat=error,end=100) F,dof,U,
     $R(1),R(2),R(3),R(4),R(5),R(6)

      !!#!@#!#!@#print*,'read ',F,dof,U,R(1),R(2),R(3),R(4),R(5),R(6)
      !!#!#!#!#read*

      do j = 1,6
      if (U.ne.0.0) then 
                    KE(j,dof+6) = R(j)/U
                    endif
      enddo

      !%&^&%^&%%call FORM_LOCAL_KE_BEAM(F,JD,JY,JZ,L,E1,G,KE)
      !!@#!@#!@#!@#!@#!@#!@#call FORM_LOCAL_ME_BEAM(F,L,Rho1,ME) 

      enddo
 
      ! No coosrdinate system transformation is required
      !@#@!#!@###!@#@# print*,'i',station1,'j',station2
      read(12,*) ! read comments
      read(12,*) ! read title


      ! read reactions in the second station if force is applied in the 
      ! second section

      do i = 1,6
!......................................................................!
      read(12,fmt='(G10,I4,G16,6G8)',iostat=error,end=100) F,dof,U,
     $R(1),R(2),R(3),R(4),R(5),R(6)

      !!#!#!@##print*,'read ',F,dof,U,R(1),R(2),R(3),R(4),R(5),R(6)
      !!#!#!#!#@#!read*

      do j = 1,6
      if (U.ne.0.0) then 
                    KE(j+6,dof+6) = R(j)/U
                    endif


      !%&^&%^&%%call FORM_LOCAL_KE_BEAM(F,JD,JY,JZ,L,E1,G,KE)
      !!@#!@#!@#!@#!@#!@#!@#call FORM_LOCAL_ME_BEAM(F,L,Rho1,ME) 

      enddo
      enddo

      read(12,*) ! read comments
      read(12,*) ! read title


      ! read reactions in the first station if force is applied in the 
      ! first section

      do i = 1,6
!......................................................................!
      read(12,fmt='(G10,I4,G16,6G8)',iostat=error,end=100) F,dof,U,
     $R(1),R(2),R(3),R(4),R(5),R(6)

      !!#!#!@#print*,'read ',F,dof,U,R(1),R(2),R(3),R(4),R(5),R(6)
      !!#!@#!@#!@#read*

      do j = 1,6
      if (U.ne.0.0) then 
                    KE(j,dof) = R(j)/U
                    endif
      enddo

      !%&^&%^&%%call FORM_LOCAL_KE_BEAM(F,JD,JY,JZ,L,E1,G,KE)
      !!@#!@#!@#!@#!@#!@#!@#call FORM_LOCAL_ME_BEAM(F,L,Rho1,ME) 

      enddo

      do i = 1,12
         do j = i+1, 12
         KE(j,i) = KE(i,j)
         enddo
      enddo
 
      if (x1.ne.x2) then 
      m1 =  Mass * (xc-x2) / (x1-x2)
      m2 =  Mass - m1
                   else
      m1 = Mass / 2
      m2 = Mass / 2    
                   endif
  
      if (m1*m2.lt.0.0) then
                   print*,'it is impossible to distribute M', Mass
                   print*,'in the location', xc
                   print*,'between locations', x1, x2
                   stop
                        endif
  

      Jp1 = Ip * m1 / Mass
      Jp2 = Ip * m2 / Mass
      Jo = Id - m1*(xc-x1)**2-m2*(xc-x2)**2

      if ( Jo.ge.0.0) then 
                      if(m1.ne.0.0) then
                      alpha = m2/m1
                      Jd1 = Jo / (1+alpha)
                      Jd2 = alpha * Jd1
                                    else
                      alpha = m1/m2
                      Jd2 = Jo / (1+alpha)
                      Jd1 = alpha * Jd2

                                    endif
                      else
                 print*,'it is impossible to distribute Jd ', Jd
                 print*,'in the location', xc
                 print*,'between locations', x1, x2
                 print*,' Jd=0.0 for both locations' 
                 Jd1 = 0.0
                 Jd2 = 0.0
                      endif 
      
      
      ME(1,1) = m1
      ME(2,2) = m1
      ME(3,3) = m1
      ME(4,4) = Jp1
      ME(5,5) = Jd1
      ME(6,6) = Jd1

      ME(7,7) = m2
      ME(8,8) = m2
      ME(9,9) = m2
      ME(10,10) = Jp2
      ME(11,11) = Jd2
      ME(12,12) = Jd2


      !@#!@#print*,'stations',station1,station2
      !!#!@#!@#read*
      call Add_Global(station1,station2,KE,K,N)
      call Add_Global(station1,station2,ME,M,N)

      !!@#!@#call DisplayV(MaxN,Transf,Nodes)
      !!@#!@#!@#!@read*
      !!@#!@#!print*,' Stiffness Matrix'
      !!#!@#!@#call Display(12,KE,12)
      !!#!@#!@#read*

      !!#!@#!@#print*,' Mass Matrix'
      !@#!3call Display(12,ME,12)
      !@#!@#!@#read*


100   close(12)

      !!@#@$#%@#$%%#$%#$#%#$%# call Inertia(N, M, Coord, Nodes)
      endif
      
      end subroutine Create_Matrix

      subroutine Create_Matrix_Force(ElementsFile,U1,Vect,N,Transf,Out)
      integer Nodes
      
      character*256  ElementsFile, Out
      character c
      real*8 U1(6*N), ME(12,12), KE(12,12) 
      integer error, station1, station2, N, dof,node1,node2
      real*8  x1,Mass,Ip,Id,x2,xc,U 
      real*8 F,R(6),m1,m2,Jp1,Jp2,Jd1,Jd2, Jo,F1(12),V(12)
      integer Transf(N),i,j,Vect(6*N),n1,ind,n2
      
  
      print*, 'file of the part', ElementsFile
      open(unit =12,file=ElementsFile,iostat=error)
      if (error.gt.0) then
      print*,'error reading file ', ElementsFile 
      stop 
      else
   
      print*,'start file reading'
      read(12,*,end=100) ! read first string of the title

!......................................................................!

      read(12,fmt='(I10,G10)',iostat=error,end=100) station1,x1
      !@#!@#@!#@!print*,'read ',station1,x1
      !!#!#!@##read*

      call ConvToNode(N,Transf,station1,node1)
      if (node1.eq.0) then
                      print*,'there is no station',station1
                      stop 
                      else
                      station1=node1
                      endif

      !!#!@#@!print*,'read ',station1,x1
      !#!#!#!#!read*
      

      read(12,fmt='(I10,G10)',iostat=error,end=100) station2,x2
      !!#!@#!@#print*,'read ',station2,x2
      !!###!#@#read*

      call ConvToNode(N,Transf,station2,node2)
      if (node2.eq.0) then
                      print*,'there is no station',station2
                      stop 
                      else
                      station2=node2
                      endif

      !!#!@#!@#print*,'read ',station2,x2
      !@#!@#!@#read*


      read(12,*) ! read comments
      read(12,fmt='(4G10)',iostat=error,end=100) Mass,Ip,Id,xc 

      !!#!@#!@print*,'read ',Mass,Ip,Id,xc
      !!#!@#!@#read*

      read(12,*) ! read comments
      read(12,*) ! read comments
      read(12,*) ! read comments
      read(12,*) ! read comments
      read(12,*) ! read title

      call Matrix_Zero(12,KE)
      call Matrix_Zero(12,ME)

      ! read reactions in the first station if force is applied in the 
      ! second section

      do i = 1,6
!......................................................................!
      read(12,fmt='(G10,I4,G16,6G8)',iostat=error,end=100) F,dof,U,
     $R(1),R(2),R(3),R(4),R(5),R(6)

      !!#!@#!#!@#print*,'read ',F,dof,U,R(1),R(2),R(3),R(4),R(5),R(6)
      !!#!#!#!#read*

      do j = 1,6
      if (U.ne.0.0) then 
                    KE(j,dof+6) = R(j)/U
                    endif
      enddo

      !%&^&%^&%%call FORM_LOCAL_KE_BEAM(F,JD,JY,JZ,L,E1,G,KE)
      !!@#!@#!@#!@#!@#!@#!@#call FORM_LOCAL_ME_BEAM(F,L,Rho1,ME) 

      enddo
 
      ! No coosrdinate system transformation is required
      !@#@!#!@###!@#@# print*,'i',station1,'j',station2
      read(12,*) ! read comments
      read(12,*) ! read title


      ! read reactions in the second station if force is applied in the 
      ! second section

      do i = 1,6
!......................................................................!
      read(12,fmt='(G10,I4,G16,6G8)',iostat=error,end=100) F,dof,U,
     $R(1),R(2),R(3),R(4),R(5),R(6)

      !!#!#!@##print*,'read ',F,dof,U,R(1),R(2),R(3),R(4),R(5),R(6)
      !!#!#!#!#@#!read*

      do j = 1,6
      if (U.ne.0.0) then 
                    KE(j+6,dof+6) = R(j)/U
                    endif


      !%&^&%^&%%call FORM_LOCAL_KE_BEAM(F,JD,JY,JZ,L,E1,G,KE)
      !!@#!@#!@#!@#!@#!@#!@#call FORM_LOCAL_ME_BEAM(F,L,Rho1,ME) 

      enddo
      enddo

      read(12,*) ! read comments
      read(12,*) ! read title


      ! read reactions in the first station if force is applied in the 
      ! first section

      do i = 1,6
!......................................................................!
      read(12,fmt='(G10,I4,G16,6G8)',iostat=error,end=100) F,dof,U,
     $R(1),R(2),R(3),R(4),R(5),R(6)

      !!#!#!@#print*,'read ',F,dof,U,R(1),R(2),R(3),R(4),R(5),R(6)
      !!#!@#!@#!@#read*

      do j = 1,6
      if (U.ne.0.0) then 
                    KE(j,dof) = R(j)/U
                    endif
      enddo

      !%&^&%^&%%call FORM_LOCAL_KE_BEAM(F,JD,JY,JZ,L,E1,G,KE)
      !!@#!@#!@#!@#!@#!@#!@#call FORM_LOCAL_ME_BEAM(F,L,Rho1,ME) 

      enddo

      do i = 1,12
         do j = i+1, 12
         KE(j,i) = KE(i,j)
         enddo
      enddo


      do n1 = 1, 6
      !print*, 6*station1-6+n1
      !print*, 6*station2-6+n1
      !print*, 6*Nodes
      !print*,V(n1)
      !print*,U(6*station1-6+n1)

      ind = Vect(6*station1-6+n1)
      if (ind.ne.0) then 
                    V(n1) = U1(ind)
                    else
                    V(n1) = 0.0
                    endif
      
      ind = Vect(6*station2-6+n1)
      if (ind.ne.0) then 
                    V(n1+6) = U1(ind)
                    else
                    V(n1+6) = 0.0
                    endif
      !#!##!#!@print*,V(n1)
      enddo
      !!!!!!!!!print*,'formed vector'

      call Vector_Zero(12,F1)      
       do n2 = 1,12 
       F1(n2) = 0.0
       do n1 =1,12
       F1(n2) = F1(n2) + KE(n2,n1)*V(n1) 
       enddo
       enddo


      print*,' file for the forces output'
      print*,Out
      
      open(unit =14,file=Out,iostat=error)
      if (error.gt.0) then
      print*,'error writing file ',Out
      stop  
                      endif

!......................................................................!   

      !!@#!@#!#@print*,x1,x2
   
      write(14,'(G8.3,12G16.5)') x1,V(1),V(2),V(3),V(4),V(5),V(6),F1(1),
     $F1(2),F1(3),F1(4),F1(5),F1(6)

      write(14,'(G8.3,12G16.5)') x2,V(7),V(8),V(9),V(10),V(11),V(12),
     $F1(7),F1(8),F1(9),F1(10),F1(11),F1(12)

      !!@#!@#!print*,'displacements'
      !!@#!@#!@#call DisplayV_R(12,V,12)

      !!@#!@#!print*,'Forces'
      !!#!@#@!call DisplayV_R(12,F1,12)

100   close(12)
      close(14)

      !!@#@$#%@#$%%#$%#$#%#$%# call Inertia(N, M, Coord, Nodes)
      endif
      
      end subroutine Create_Matrix_Force


      subroutine Write_EigV(N,Eval,Evec,Vect,Transf,Ufile,NL,output)
      character*256 Ufile, output
      integer error, station1, station2, N, NL
      real*8  x1, Ro1, Ri1, E1, Rho1, Nu1, Mass1, Ip1, Id1 
      real*8  x2, Ro2, Ri2, E2, Rho2, Nu2, Mass2, Ip2, Id2
      real*8 F, JD, JY, JZ, L, RO, E, G
      integer Transf(N), Vect(6*N),ind,dof,Nodes,En
      real*8 Eval(6*N), Evec(6*N,6*N),T(6)
      real*8 MaxFreq
      common /speed/ MaxFreq
        integer Modes
        common /Tones/ Modes

      print*,'input filename to write Natural Modes'
      print*,output
      

      !@#!@#!@#!#!@# call Display(6*N,Evec,NL)
       
!......................................................................!
      open(unit =14,file=output,iostat=error)
      if (error.gt.0) then
      print*,'error writing file '
      stop  
                      endif

      !@#@!#@!#@!#!@#!@#!@#!@#print*,'file of the part', Ufile

      do En=1,NL

      if (abs(Eval(En)).le.(MaxFreq)) then

      write(14,'(F10.2)') Eval(En)
      open(unit =12,file=Ufile,iostat=error)
      if (error.gt.0) then
      print*,'error reading file ', Ufile  
      stop
      else
      !@##@#@#@#@#@#@#print*,'form displacements of the part'
      read(12,*) ! read first string of the title
      do while(.true.)
      read(12,fmt='(I10,9G10)',iostat=error,end=400) station2,x2,Ro2,
     $Ri2, E2, Rho2, Nu2, Mass2, Ip2, Id2

      call ConvToNode(N,Transf,station2,node)
      call  Vector_Zero(6,T)
     
      do dof = 1, 6
      ind = Vect(6*node-6+dof)
      if (ind.ne.0) then 
                   T(dof) = Evec(ind,En)
                   endif
     
      enddo 
  
      write(14,'(7G16.5)') x2,T(1),T(2),T(3),T(4),T(5),T(6)
    
      enddo !!!!! end of the file reading

      endif

400   close(12)


                                     endif !check for frequency


      enddo !cycle through all eigenvalues

      close(14)

      end subroutine Write_EigV


      subroutine Write_EigV_M(N,Eval,Evec,Vect,Transf,Ufile,NL,output)
      character*256 Ufile, output
      integer error, station1, station2, N, NL
      real*8 x1,x2
      integer Transf(N), Vect(6*N),ind,dof,Nodes,En,node
      real*8 Eval(6*N), Evec(6*N,6*N),T(6)
      real*8 MaxFreq
      common /speed/ MaxFreq
        integer Modes
        common /Tones/ Modes

      print*,'input filename to write Natural Modes'
      print*,output
      

      !@#!@#!@#!#!@# call Display(6*N,Evec,NL)
       
!......................................................................!
      open(unit =14,file=output,iostat=error)
      if (error.gt.0) then
      print*,'error writing file '
      stop  
                      endif

      !@#@!#@!#@!#!@#!@#!@#!@#print*,'file of the part', Ufile

      do En=1,NL

      if (abs(Eval(En)).le.(MaxFreq)) then

      write(14,'(F10.2)') Eval(En)
      open(unit =12,file=Ufile,iostat=error)
      if (error.gt.0) then
      print*,'error reading file ', Ufile  
      stop
      else
      !@##@#@#@#@#@#@#print*,'form displacements of the part'

      read(12,*,end=401) ! read first string of the title
      read(12,fmt='(I10,G10)',iostat=error,end=401) station1,x1
      read(12,fmt='(I10,G10)',iostat=error,end=401) station2,x2

      call ConvToNode(N,Transf,station1,node)
      call  Vector_Zero(6,T)
      do dof = 1, 6
      ind = Vect(6*node-6+dof)
      if (ind.ne.0) then 
                   T(dof) = Evec(ind,En)
                   endif
     
      enddo 
      write(14,'(7G16.5)') x1,T(1),T(2),T(3),T(4),T(5),T(6)
      call ConvToNode(N,Transf,station2,node)
      call  Vector_Zero(6,T)
      do dof = 1, 6
      ind = Vect(6*node-6+dof)
      if (ind.ne.0) then 
                   T(dof) = Evec(ind,En)
                   endif
     
      enddo 
      write(14,'(7G16.5)') x2,T(1),T(2),T(3),T(4),T(5),T(6)
    

      endif

401   close(12)


                                     endif !check for frequency


      enddo !cycle through all eigenvalues

      close(14)

      end subroutine Write_EigV_M



      subroutine Write_Whirl(N,Eval,Evec,Vect,Transf,Ufile,NL,MaxSpeed)
      character*256 Ufile, output
      integer error, station1, station2, N, NL, k1
      real*8  x1, Ro1, Ri1, E1, Rho1, Nu1, Mass1, Ip1, Id1 
      real*8  x2, Ro2, Ri2, E2, Rho2, Nu2, Mass2, Ip2, Id2
      real*8 F, JD, JY, JZ, L, RO, E, G
      integer Transf(N), Vect(6*N),ind,dof,Nodes,En,Nsteps
      real*8 Eval(6*N), Evec(6*N,6*N),T(6)
      real*8 MaxSpeed, Ann, Jpn,forw,reverse,w,sp,speed
        real*8 Acceleration
        common /Accel/ Acceleration

        real*8 PI
        parameter (PI=3.14159)


      print*,'input filename to write Whirl Map'
      read*,output

      print*,'Maximum speed for the rotor is', MaxSpeed
      print*,'Rotor is from the fle',Ufile
      print*,'input number of the speed steps'
      read*,Nsteps


      !@#!@#!@#!#!@# call Display(6*N,Evec,NL)
!......................................................................!
      open(unit =14,file=output,iostat=error)
      if (error.gt.0) then
      print*,'error writing file '
      stop  
                      endif

      !@#@!#@!#@!#!@#!@#!@#!@#print*,'file of the part', Ufile

      do En=1,NL
      if (Eval(En).le.(MaxSpeed/60.0)) then

      write(14,'(F10.2)') Eval(En)
      Ann=0.0
      Jpn =0.0

      open(unit =12,file=Ufile,iostat=error)
      if (error.gt.0) then
      print*,'error reading file ', Ufile  
      stop
      else
      !@##@#@#@#@#@#@#print*,'form displacements of the part'

      read(12,*) ! read first string of the title
      read(12,fmt='(I10,9G10)',iostat=error,end=400) station1,x1,Ro1,
     $Ri1, E1, Rho1, Nu1, Mass1, Ip1, Id1

      do while(.true.)
      read(12,fmt='(I10,9G10)',iostat=error,end=400) station2,x2,Ro2,
     $Ri2, E2, Rho2, Nu2, Mass2, Ip2, Id2

      L = x2 - x1
      JD = (PI/2) * (Ro1**4-Ri1**4)
      Jpn = Rho1*JD*L + Ip1 ! calculate inertia of the element

      !@#!@#@!#!@print*,'Jpn',Jpn
      

      call ConvToNode(N,Transf,station1,node)
      call  Vector_Zero(6,T)
     
      do dof = 1, 6
      ind = Vect(6*node-6+dof)
      if (ind.ne.0) then 
                   T(dof) = Evec(ind,En)
                   endif
     
      enddo 
  
      !@#!@#write(14,'(7G16.5)') x2,T(1),T(2),T(3),T(4),T(5),T(6)
      
      Ann = Ann + Jpn*(T(5)**2+T(6)**2)

      station1 = station2
      x1 = x2
      Ro1 = Ro2
      Ri1 = Ri2
      E1 = E2
      Rho1 = Rho2
      Nu1 = Nu2
      Mass1 = Mass2
      Ip1 = Ip2
      Id1 = Id2
    
      enddo !!!!! end of the file reading

      endif

400   close(12)

      !print*,'freq',Eval(En)
      !print*,'Ann',Ann
      
      sp = MaxSpeed/Nsteps
      !print*,'sp=',sp
      !read*

      Ann=Ann/Acceleration
      do k1=0,Nsteps
      
      w = 2*PI*sp*k1/60.0
      
      forw = (w*Ann+sqrt((w*Ann)**2+4*(Eval(En)*2*PI)**2))/2
      reverse = (-w*Ann+sqrt((w*Ann)**2+4*(Eval(En)*2*PI)**2))/2

      forw = forw / (2*PI)
      reverse = reverse / (2*PI)
      speed = sp*k1
      write(14,'(F12.0,2F12.2)') speed, reverse, forw
      enddo


                                     endif !check for frequency

      enddo !cycle through all eigenvalues

      close(14)

      end subroutine Write_Whirl

