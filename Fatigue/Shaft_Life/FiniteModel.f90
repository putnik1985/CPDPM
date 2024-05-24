       SUBROUTINE FORM_LOCAL_KE_BEAM(EJ,L,K)

       ! BEGIN DESCRIPTION OF THE VARAIBLES

       implicit none
       real*8 EJ, L 
       real*8 K(4,4)
       INTEGER I,J

       call Matrix_Zero(4,K)

       KE(2,2) = 12 * E * JZ / L**3
       KE(2,6) = 6 * E * JZ / L**2 
       KE(2,8) = -12 * E * JZ / L**3 
       KE(2,12) = 6 * E * JZ / L**2 

       KE(6,6) = 4 * E * JZ / L
       KE(6,8) = -6 * E * JZ / L**2
       KE(6,12) = 2 * E * JZ / L

       KE(8,8) = 12 * E * JZ /L**3
       KE(8,12) = -6 * E * JZ / L**2
       
       DO I=1,4
       DO J=I,4
       K(J,I)=K(I,J)
       ENDDO ! DO J
       ENDDO !DO I
							 
       END SUBROUTINE FORM_LOCAL_KE_BEAM

       subroutine Matrix_Zero(n,m)
        implicit none
        integer n, i, j
        real*8 m(n,n)
           do i=1,n
           do j=1,n
           m(i,j)=0.0
          enddo
          enddo
       end subroutine Matrix_Zero

       subroutine Vector_Zero(n,m)
        implicit none
        integer n, i
        real*8 m(n)
           do i=1,n
           m(i)=0.0
          enddo
       end subroutine Vector_Zero

       subroutine Add_Global(i,j,KE,K,N)
        implicit none
        real*8 KE(4,4)
        real*8 K(2*N,2*N)
        integer r, c, N
        do r = 1,2 
         do c = 1,2 
         K(6*i-6+r,6*i-6+c) = K(6*i-6+r,6*i-6+c) + KE(r,c)
         K(6*i-6+r,6*j-6+c) = K(6*i-6+r,6*j-6+c) + KE(r,c+6)
         K(6*j-6+r,6*i-6+c) = K(6*j-6+r,6*i-6+c) + KE(r+6,c)
         K(6*j-6+r,6*j-6+c) = K(6*j-6+r,6*j-6+c) + KE(r+6,c+6)
         enddo
        enddo 
      end subroutine Add_Global
