       SUBROUTINE FORM_LOCAL_KE_BEAM(EJ,L,K)

       implicit none
       real*8 EJ, L 
       real*8 K(4,4)
       INTEGER I,J

       call Matrix_Zero(4,K)

       KE(1,1) = 12 * EJ / L**3
       KE(1,2) = 6 * EJ / L**2 
       KE(1,3) = -12 * EJ / L**3 
       KE(1,4) = 6 * EJ / L**2 

       KE(2,2) = 4 * EJ / L
       KE(2,3) = -6 * EJ / L**2
       KE(2,4) = 2 * EJ / L

       KE(3,3) = 12 * EJ /L**3
       KE(3,4) = -6 * EJ / L**2
       
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
        real*8 K(N,N)
        integer r, c, N
        do r = 1,2 
         do c = 1,2 
         K(2*i-2+r,2*i-2+c) = K(2*i-2+r,2*i-2+c) + KE(r,c)
         K(2*i-2+r,2*j-2+c) = K(2*i-2+r,2*j-2+c) + KE(r,c+2)
         K(2*j-2+r,2*i-2+c) = K(2*j-2+r,2*i-2+c) + KE(r+2,c)
         K(2*j-2+r,2*j-2+c) = K(2*j-2+r,2*j-2+c) + KE(r+2,c+2)
         enddo
        enddo 
      end subroutine Add_Global
