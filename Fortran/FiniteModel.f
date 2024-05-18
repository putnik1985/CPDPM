        !*****************************************************************************************
        !PROCEDURE TO FORM LOCAL MATRIX OF MASS AND STIFNESS FOR THE BEAM ELEMENT
        !*****************************************************************************************
        !F,JD,JY,JZ,L - SQUARE, INERTIA MOMENT OF X, Y, Z AND THE LENGTH OF THE BEAM
        !RO,E,G - DENSITY, YOUNG MODULUS, SHARE MODULUS OF THE BEAM
        !KE, ME - RESULT LOCAL MATRIXES OF THE STIFNESS AND MASS OF THE BEAM
        !*****************************************************************************************
!......................................................................!      
       SUBROUTINE FORM_LOCAL_KE_BEAM(F,JD,JY,JZ,L,E,G,KE)

       ! BEGIN DESCRIPTION OF THE VARAIBLES

       real*8 F,JD,JY,JZ,L,RO,E,G
       real*8 KE(12,12)
       INTEGER I,J

       ! END DESCRIPTION OF THE VARAIBLES

       call Matrix_Zero(12,KE)

       KE(1,1) = E * F / L ; KE(1,7) = - E * F / L

       KE(2,2) = 12 * E * JZ / L**3
       KE(2,6) = 6 * E * JZ / L**2 
       KE(2,8) = -12 * E * JZ / L**3 
       KE(2,12) = 6 * E * JZ / L**2 
	
       KE(3,3) = 12 * E * JY / L**3
       KE(3,5) = -6 * E * JY / L**2
       KE(3,9) = -12 * E * JY / L**3
       KE(3,11) = -6 * E * JY / L**2
	
       KE(4,4) = G * JD / L
       KE(4,10) = - G * JD / L

       KE(5,5) = 4 * E * JY / L
       KE(5,9) = 6 * E * JY / L**2
       KE(5,11) = 2 * E * JY / L

       KE(6,6) = 4 * E * JZ / L
       KE(6,8) = -6 * E * JZ / L**2
       KE(6,12) = 2 * E * JZ / L

       KE(7,7) = E * F / L

       KE(8,8) = 12 * E * JZ /L**3
       KE(8,12) = -6 * E * JZ / L**2

       KE(9,9) = 12 * E * JY / L**3
       KE(9,11) = 6 * E * JY / L**2

       KE(10,10) = G * JD / L
       
       KE(11,11) = 4 * E * JY / L
       KE(12,12) = 4 * E * JZ / L
 
       DO I=1,12
       DO J=I,12
       KE(J,I)=KE(I,J)
       ENDDO ! DO J
       ENDDO !DO I
							 
       END SUBROUTINE FORM_LOCAL_KE_BEAM


       SUBROUTINE FORM_LOCAL_ME_BEAM(F,L,RO,JD,ME)
       ! BEGIN DESCRIPTION OF THE VARAIBLES

       real*8 F,L,RO,JD
       real*8 ME(12,12)
       INTEGER I,J

       ! END DESCRIPTION OF THE VARAIBLES
        call Matrix_Zero(12,ME)
       ME(1,1) = F * L * RO / 3
       ME(1,7) = F * L * RO / 6

	ME(2,2) = 13 * F * L * RO / 35  
        ME(2,6) = 11 * F * (L**2) * RO / 210 
        ME(2,8) = 9 * F * L * RO / 70 
	ME(2,12) = -13 * RO * F * (L**2) / 420 
	
	ME(3,3) = 13 * F * L * RO / 35 
        ME(3,5) = -11 * F * (L**2) * RO / 210 
	ME(3,9) = 9 * F * L * RO / 70 
        ME(3,11) = 13 * F * (L**2) * RO / 420 

        ME(4,4) = JD*RO*L*0.5 
        
	ME(5,5) = F * (L**3) * RO / 105 
        ME(5,9) = -13 * F * (L**2) * RO /420 
	ME(5,11) = -F * (L**3) * RO / 140 

	ME(6,6) = F * (L**3) * RO / 105 
        ME(6,8) = 13 * F * (L**2) * RO / 420
	ME(6,12) = -F * (L**3) * RO / 140 

	ME(7,7) = F * L * RO / 3 ;

	ME(8,8) = 13 * F * L * RO / 35 
        ME(8,12) = -11 * F * (L**2) * RO / 210 

	ME(9,9) = 13 * F * L * RO / 35 
        ME(9,11) = 11 * F * (L**2) * RO / 210 

        ME(10,10) = JD*RO*L*0.5
 
	ME(11,11) = F * (L**3) * RO / 105 
	ME(12,12) = F * (L**3) * RO / 105 

	DO I=1,12
        DO J=I,12
        ME(J,I)=ME(I,J)
        ENDDO ! DO J
        ENDDO !DO I
	END SUBROUTINE FORM_LOCAL_ME_BEAM

        subroutine Matrix_Zero(n,m)
        integer n, i, j
        real*8 m(n,n)

           do i=1,n
           do j=1,n
           m(i,j)=0.0
          enddo
          enddo

        end subroutine Matrix_Zero

        subroutine Vector_Zero(n,m)
        integer n, i
        real*8 m(n)

           do i=1,n
           m(i)=0.0
          enddo

        end subroutine Vector_Zero

        subroutine Vector_ZeroI(n,m)
        integer n, i
        integer m(n)

           do i=1,n
           m(i)=0.0
          enddo

        end subroutine Vector_ZeroI


      subroutine Add_Global(i,j,KE,K,N)
      real*8 KE(12,12)
      real*8 K(6*N,6*N)
      integer r, c, N
      do r = 1, 6
         do c = 1, 6
         
         K(6*i-6+r,6*i-6+c) = K(6*i-6+r,6*i-6+c) + KE(r,c)
         K(6*i-6+r,6*j-6+c) = K(6*i-6+r,6*j-6+c) + KE(r,c+6)
         K(6*j-6+r,6*i-6+c) = K(6*j-6+r,6*i-6+c) + KE(r+6,c)
         K(6*j-6+r,6*j-6+c) = K(6*j-6+r,6*j-6+c) + KE(r+6,c+6)
         
         enddo
      enddo 
     
      end subroutine Add_Global

      subroutine Add_Lumped(i,Mi,Jpi,Jdi,K,N)
      real*8 Mi,Jpi,Jdi
      real*8 K(6*N,6*N)
      integer r, c, N, i
      !@print*,'station',i

      !add lumped masses
      do r = 1, 3
         K(6*i-6+r,6*i-6+r) = K(6*i-6+r,6*i-6+r) + Mi
         !@#!print*,'dof Mass',6*i-6+r, Mi
      enddo 

         K(6*i-2,6*i-2) = K(6*i-2,6*i-2) + Jpi

      do r = 5, 6
         K(6*i-6+r,6*i-6+r) = K(6*i-6+r,6*i-6+r) + Jdi
         !@#!@#print*,'dof Jd',6*i-6+r, Jdi      
      enddo 

      !@#!@#read*
      end subroutine Add_Lumped

      subroutine Inertia(N, M, K, Coord, Nodes)
      integer N, Nodes
      real*8 K(6*N,6*N), kx, ky, kz, krx, kry, krz
      real*8 M(6*N,6*N), massx, massy, massz, Jp, Coord(N), Jdy
      real*8 Jdz, xz, xy, My, Mz,fx,fy,fz,PI,frx,fry,frz
      integer i, j
      Parameter (PI = 3.14159)

        real*8 Acceleration
        common /Accel/ Acceleration
      
      mass = 0.0
      Jp = 0.0
      Jdy = 0.0
      Jdz = 0.0
      My = 0.0
      Mz = 0.0
!......................................................................!

      !do j=1,Nodes
      !print*,Coord(j)
      !enddo
      massx = 0.0
      massy = 0.0
      massz = 0.0

      do i=1,N
      do j=1,N
      massx = massx + M(6*i-5,6*j-5)
      massy = massy + M(6*i-4,6*j-4)
      massz = massz + M(6*i-3,6*j-3)

      kx = kx + K(6*i-5,6*j-5)
      ky = ky + K(6*i-4,6*j-4)
      kz = kz + K(6*i-3,6*j-3)



      Jp = Jp + M(6*i-2,6*j-2)
      krx = krx + K(6*i-2,6*j-2)
      
      My = My + M(6*i-3,6*j-3)*Coord(j) - M(6*i-3,6*j-1)

      Jdy = Jdy + Coord(i)*(M(6*i-3,6*j-3)*Coord(j) - M(6*i-3,6*j-1))
      Jdy = Jdy - M(6*i-1,6*j-3)*Coord(j) + M(6*i-1,6*j-1)

      kry = kry + Coord(i)*(K(6*i-3,6*j-3)*Coord(j) - K(6*i-3,6*j-1))
      kry = kry - K(6*i-1,6*j-3)*Coord(j) + K(6*i-1,6*j-1)



      !print*, Coord(j)
      !read*
      Mz = Mz + M(6*i-4,6*j-4)*Coord(j) + M(6*i-4,6*j)

      Jdz = Jdz + Coord(i)*(M(6*i-4,6*j-4)*Coord(j) + M(6*i-4,6*j))
      Jdz = Jdz + M(6*i,6*j-4)*Coord(j) + M(6*i,6*j)

      krz = krz + Coord(i)*(K(6*i-4,6*j-4)*Coord(j) + K(6*i-4,6*j))
      krz = krz + K(6*i,6*j-4)*Coord(j) + K(6*i,6*j)


      !!!!print*, M(6*i-4,6*j-4)
      !read*
      enddo
      enddo

      xy = My / massy
      xz = Mz / massz


      print*,'Mass of the system'
      print*, 'X direction ', massx
      print*, 'Y direction ', massy
      print*, 'Z direction ', massz

      print*, 'Centre of the gtavity '
      print*, 'Y direction X= ', xy
      print*, 'Z direction X= ', xz

      print*,'Inertia of the system (wrt CG)'
      print*, 'X direction ', Jp
      print*, 'Y direction ', Jdy - massy * xy**2
      print*, 'Z direction ', Jdz - massz * xz**2



      if (kx.gt.0.0) then
      fx = (1/(2*PI))*sqrt(kx/(massx/Acceleration))
                     else
      fx=0.0
                     endif        

      if (ky.gt.0.0) then 
      fy = (1/(2*PI))*sqrt(ky/(massy/Acceleration))
                     else
      fy=0.0
                     endif        

      if (kz.gt.0.0) then
      fz = (1/(2*PI))*sqrt(kz/(massz/Acceleration))
                     else
      fz=0.0
                     endif        

      if (krx.gt.0.0)  then
      frx = (1/(2*PI))*sqrt(krx/(Jp/Acceleration))
                     else
      frx=0.0
                     endif        

      if (kry.gt.0.0) then 
      fry = (1/(2*PI))*sqrt(kry/(Jdy/Acceleration))
                     else
      fry=0.0
                     endif        

      if (krz.gt.0.0) then
      frz = (1/(2*PI))*sqrt(krz/(Jdz/Acceleration))
                     else
      frz=0.0
                     endif        

      print*,' Frequencies, Hz'
      print*, 'X direction ', fx
      print*, 'Y direction ', fy
      print*, 'Z direction ', fz

      print*, 'Rx direction ', frx
      print*, 'Ry direction ', fry
      print*, 'Rz direction ', frz


      !@print*, ' coordinates'

      !do j=1,Nodes
      !print*,Coord(j)
      !enddo
    

      end subroutine

!......................................................................!
      subroutine CutDof(N,M,dof,Nodes)
      real*8 M(N,N)
      integer dof, N, Nodes, i, j      
      !!!print*, 'reduce matrix'
      !print*,' N = ', N
      !print*,' dof = ', dof
      !print*,' Nodes = ', Nodes

  
      !! reduce the rows
      do i=dof,6*Nodes-1,1
       do j=1,6*Nodes
        M(i,j) = M(i+1,j)   
       enddo 
      enddo  

      !! reduce the columns
      do j=dof,6*Nodes-1,1
       do i=1,6*Nodes
        M(i,j) = M(i,j+1)   
       enddo 
      enddo 

      end subroutine CutDof

      subroutine ChangeVec(N,Vect,ind,Nodes)
      integer N, ind, Vect(N), Nodes, i
      !print*, 'change vector'
      
      Vect(ind)=0
      do i=ind+1,6*Nodes
      if (Vect(i).gt.0) then 
                        Vect(i)=Vect(i)-1
                        endif
      enddo

      end subroutine ChangeVec



!......................................................................!
      
      subroutine Displacements(N,U,Vect,Nodes,Coord)
      integer N
      real*8 U(N), T(N), Coord(N)
      integer Vect(N), Nodes, NL,node, dof, ind, error

      print*,'Wirte Dispalcements'
      call Vector_Zero(N,T)

      do node=1,Nodes
     
      do dof = 1, 6
      ind = Vect(6*node-6+dof)

      if (ind.ne.0) then 
                    T(6*node-6+dof)=U(ind)
                    endif
      enddo 

      enddo 


      open(unit =12,file='Displacements.dat',iostat=error)
      if (error.gt.0) then
      print*,'error writing file '  
      else

      do i = 1, Nodes
         do j = 1,6
         U(6*i-6+j) = T(6*i-6+j)
         enddo
!......................................................................!
      write(12,'(7G16.5)') Coord(i),T(6*i-5),T(6*i-4),T(6*i-3),T(6*i-2),
     $T(6*i-1),T(6*i)
      enddo

      close(12)
      endif

      end subroutine Displacements

      subroutine DisplayForces(Forces1,Forces2,Nodes, EID)
      integer Nodes, node, error, EID
      real*8 Forces1(Nodes,7),Forces2(Nodes,7)

      open(unit =12,file='ShareForces.dat',iostat=error)
      if (error.gt.0) then
      print*,'error writing Forces file '  
      else
      
      !!@#!@!@$#$@#$@#$@#$@#$@#$@#$@#$@#$$@
      print*,'Element number',EID

      do i = 1, EID
!......................................................................!
      write(12,'(4G16.5)') Forces1(i,7), Forces1(i,1),Forces1(i,2),
     $Forces1(i,3)
      write(12,'(4G16.5)') Forces2(i,7),Forces2(i,1),Forces2(i,2),
     $Forces2(i,3)

      enddo

      close(12)
      endif
      
      open(unit =12,file='BendingMoments.dat',iostat=error)
      if (error.gt.0) then
      print*,'error writing Moments file '  
      else
      do i = 1, EID
!......................................................................!
      write(12,'(4G16.5)') Forces1(i,7),Forces1(i,4),Forces1(i,5),
     $Forces1(i,6)
      write(12,'(4G16.5)') Forces2(i,7),Forces2(i,4),Forces2(i,5),
     $Forces2(i,6)
      enddo

      close(12)
      endif

      
      end subroutine DisplayForces


      subroutine ConvToNode(N,Transf,station,node)
      integer N, station, node
      integer Transf(N)
      
      node=1
      do while ( (Transf(node).ne.station).and.(node.le.N) )
      node = node + 1
      enddo
      if (node.gt.N) then 
                     node = 0
                     endif

      end subroutine ConvToNode
