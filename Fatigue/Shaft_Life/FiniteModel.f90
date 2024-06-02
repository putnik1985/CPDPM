
       SUBROUTINE form_ke(EJ,L,KE)

       implicit none
       double precision EJ, L 
       double precision KE(4,4)
       INTEGER I,J

       call mzero(4,KE)
       
       KE(1,1) = 12 * EJ / L**3
       KE(1,2) = 6 * EJ / L**2 
       KE(1,3) = -12 * EJ / L**3 
       KE(1,4) = 6 * EJ / L**2 

       KE(2,2) = 4 * EJ / L
       KE(2,3) = -6 * EJ / L**2
       KE(2,4) = 2 * EJ / L

       KE(3,3) = 12 * EJ /L**3
       KE(3,4) = -6 * EJ / L**2

       KE(4,4) = 4 * EJ / L
       
       DO I=1,4
          DO J=I,4
             KE(J,I)=KE(I,J)
          ENDDO ! DO J
       ENDDO !DO I
							 
       END SUBROUTINE form_ke 

       subroutine mzero(n,m)
        implicit none
        integer n, i, j
        real*8 m(n,n)
           do i=1,n
           do j=1,n
           m(i,j)=0.0
          enddo
          enddo
       end subroutine mzero

       subroutine vzero(n,m)
        implicit none
        integer n, i
        real*8 m(n)
           do i=1,n
           m(i)=0.0
          enddo
       end subroutine vzero

       subroutine append(i,j,KE,K,N)
        implicit none
        double precision KE(4,4)
        double precision K(N,N)
        integer r, c, N, i, j
        do r = 1,2 
         do c = 1,2 
         K(2*i-2+r,2*i-2+c) = K(2*i-2+r,2*i-2+c) + KE(r,c)
         K(2*i-2+r,2*j-2+c) = K(2*i-2+r,2*j-2+c) + KE(r,c+2)
         K(2*j-2+r,2*i-2+c) = K(2*j-2+r,2*i-2+c) + KE(r+2,c)
         K(2*j-2+r,2*j-2+c) = K(2*j-2+r,2*j-2+c) + KE(r+2,c+2)
         enddo
        enddo 

      end subroutine append

      subroutine apply_restraints(n, K, new_dimension)
        implicit none
        integer n, new_dimension
        double precision K(n,n)
        integer dof, i, j, constraints, global_dof
        integer, allocatable :: var_to_remove(:)
        integer, allocatable :: transform(:)

        open(unit = 12, file = "Restraints.dat")
        read(12,*) constraints
           allocate(var_to_remove(constraints))
            do i=1, constraints
               read(12,*) dof
               var_to_remove(i) = dof
            enddo
        close(12)

        allocate(transform(n)) 
        do i=1, n
           transform(i) = i
        enddo
        call sort(constraints, var_to_remove)

        do i=1, constraints
           global_dof = var_to_remove(i)
           dof = transform(global_dof)
           transform(global_dof) = 0
           call mshift(n, K, dof)
           do j=global_dof + 1, n
              transform(j) = transform(j) - 1
           enddo
        enddo

        deallocate(var_to_remove)
        deallocate(transform)
        new_dimension = n - constraints
     end subroutine apply_restraints

     subroutine sort(n, a)
       implicit none
       integer n
       integer a(n)
       integer temp, i, j
 
       do i = 1, n-1
          do j = i + 1, n
             if (a(i) >  a(j)) then
                 temp = a(i)
                 a(i) = a(j)
                 a(j) = temp
              endif
          enddo
       enddo
     end subroutine sort

     subroutine mshift(n, K, dof)
      implicit none
      double precision K(n,n)
      integer n, i, j, dof

          do i = dof, n - 1
                K(i,:) = K(i+1,:)
                K(:,i) = K(:,i+1)
          enddo

     end subroutine mshift

     subroutine vshift(n, v, dof)
      implicit none
      double precision v(n)
      integer n, i, j, dof
          do i = dof, n - 1
             v(i) = v(i+1)
          enddo
     end subroutine vshift

     subroutine mprint(n, K)
      implicit none
      integer n
      double precision K(n,n)
      integer i, j
       do i = 1, n
          write(*,*) K(i,:)
       enddo
     end subroutine mprint

     subroutine vprint(n, a)
      implicit none
      integer n
      double precision a(n)
      write(*,*) a(:)
     end subroutine vprint 

     subroutine create_K(n, K, funit, en)
       implicit none
       integer funit
       integer en, n, i, j
       double precision K(n,n)
       double precision ke(4,4)
       integer node
       double precision L,EJ

       call mzero(n, K)
       do i=1, en
        read(funit,*) node, L, EJ
        call form_ke(EJ, L, ke)
        call append(node, node + 1, ke, K, n)
       enddo

     end subroutine create_K

     subroutine create_P(n, P_mean, P_ampl)
       integer n, i, j 
       double precision P_mean(n), P_ampl(n)
       double precision mean, ampl
       integer records, dof
       open(unit = 12, file = "Loads.dat")
       read(12,*) records
       do i=1, records
        read(12,*) dof, mean, ampl
        P_mean(dof) = mean
        P_ampl(dof) = ampl
       enddo
    end subroutine create_P

      subroutine remove_dofs(n, P, new_dimension)
        implicit none
        integer n, new_dimension
        double precision P(n)
        integer dof, i, j, constraints, global_dof
        integer, allocatable :: var_to_remove(:)
        integer, allocatable :: transform(:)

        open(unit = 12, file = "Restraints.dat")
        read(12,*) constraints
           allocate(var_to_remove(constraints))
            do i=1, constraints
               read(12,*) dof
               var_to_remove(i) = dof
            enddo
        close(12)

        allocate(transform(n)) 
        do i=1, n
           transform(i) = i
        enddo
        call sort(constraints, var_to_remove)

        do i=1, constraints
           global_dof = var_to_remove(i)
           dof = transform(global_dof)
           transform(global_dof) = 0
           call vshift(n, P, dof)
           do j=global_dof + 1, n
              transform(j) = transform(j) - 1
           enddo
        enddo

        deallocate(var_to_remove)
        deallocate(transform)
        new_dimension = n - constraints
     end subroutine remove_dofs

      subroutine create_transform(n, transform)
        implicit none
        integer n, constraints, dof, i, j, global_dof
        integer transform(n)
        integer, allocatable :: var_to_remove(:)

        open(unit = 12, file = "Restraints.dat")
        read(12,*) constraints
           allocate(var_to_remove(constraints))
            do i=1, constraints
               read(12,*) dof
               var_to_remove(i) = dof
            enddo
        close(12)

        do i=1, n
           transform(i) = i
        enddo

        call sort(constraints, var_to_remove)

        do i=1, constraints
           global_dof = var_to_remove(i)
           dof = transform(global_dof)
           transform(global_dof) = 0
           do j = global_dof + 1, n
              transform(j) = transform(j) - 1
           enddo
        enddo

        deallocate(var_to_remove)
     end subroutine create_transform 

subroutine write_solution(n, u, filename, unit_num)
 implicit none
 integer nodes, node, unit_num
 double precision u(n)
 integer n
 double precision x
 integer i, j
 double precision, parameter :: conv_to_mm = 1000.
 integer filename

 if (filename .eq. 1) then
     open(unit = unit_num, file = "displacement_mean.out")
 else
     open(unit = unit_num, file = "displacement_ampl.out")
 endif

 open(unit = 12, file = "Nodes.dat")
 read(12,*) nodes

 do i=1, nodes
  read(12,*) node, x
  write(unit_num,'(3F12.4)') x, conv_to_mm * u(2 * node - 1), u(2 * node)
 enddo
 close(12)
 close(unit_num)
end subroutine write_solution

subroutine write_shaft_loads(n, u, filename, unit_num)
 implicit none
 integer n, i, j, k, element, nodes1, node, unit_num
 double precision ke(4,4), u(n), v(4), loads(4)
 double precision L, EJ, x
 double precision, allocatable ::  nodes(:)
 integer ne
 integer filename

 open(unit = 10, file = "Nodes.dat")
 read(10,*) nodes1
 allocate(nodes(nodes1))
 do i=1, nodes1
  read(10,*) node, x
  nodes(i) = x
 enddo
 close(10)

 open(unit = 12, file = "Elements.dat")
 read(12,*) ne

 if (filename .eq. 1) then
     open(unit = unit_num, file = "shaft_loads_mean.out")
 else
     open(unit = unit_num, file = "shaft_loads_ampl.out")
 endif
  
 do i=1, ne
  read(12,*) element, L, EJ
  call form_ke(EJ, L, ke)
   do j = 1, 2
    v(2*j-1) = u( 2 * (element + j - 1) - 1)
    v(2*j) = u( 2 * (element + j - 1) )
   enddo

   do j=1,4
    loads(j) = 0.
    do k=1, 4
     loads(j) = loads(j) + ke(j,k) * v(k)
    enddo
   enddo
  x = nodes(i)
  write(unit_num,'(3F12.2)') x, loads(1), loads(2)
 enddo
  x = nodes(ne+1)
  write(unit_num,'(3F12.2)') x, -loads(3), -loads(4)
  
 close(12)
 close(unit_num)
 deallocate(nodes)
end subroutine write_shaft_loads

subroutine create_moments(n, u, Moments)
 implicit none
 integer n, i, j, k, element, nodes1, node, unit_num
 double precision ke(4,4), u(n), v(4), loads(4), Moments(n/2)
 double precision L, EJ, x
 integer ne

 open(unit = 12, file = "Elements.dat")
 read(12,*) ne

 do i=1, ne
  read(12,*) element, L, EJ
  call form_ke(EJ, L, ke)
   do j = 1, 2
    v(2*j-1) = u( 2 * (element + j - 1) - 1)
    v(2*j) = u( 2 * (element + j - 1) )
   enddo

   do j=1,4
    loads(j) = 0.
    do k=1, 4
     loads(j) = loads(j) + ke(j,k) * v(k)
    enddo
   enddo
  Moments(i) = loads(2)
 enddo

 Moments(ne+1) = -loads(4)
 close(12)
end subroutine create_moments

subroutine create_stress(nodes, M, stress)
  implicit none
  integer nodes, i, j, ne, element
  double precision M(nodes)
  double precision stress(nodes)
  double precision R, Jz
  open(unit=12, file = "Geometry.dat")
  read(12,*) ne

  do i=1, ne
   read(12,*) element, R, Jz
   stress(i) = abs(M(i) * R / (2 * Jz))
  enddo
   stress(ne+1) = abs(M(ne+1) * R / (2 * Jz))
  close(12)
end subroutine create_stress

subroutine create_fillets_Kf(nodes, fillets, geometry)
 implicit none
 integer i, j, nodes, records, node
 double precision fillets(nodes)
 double precision geometry(nodes)

 double precision Kf, Kt, q, rad, R

 open(unit=12, file = "Fillets.dat")
 read(12,*) records

 do i=1, nodes
  fillets(i) = 1.
 enddo

 do i=1, records
  read(12,*) node, rad
  R = geometry(node)
  Kt = fillet_Kt(R, rad)
   q = notch_sensitivity(rad)
  Kf = 1. + q * (Kt - 1.)
  fillets(node) = Kf
 enddo

 close(12)
end subroutine create_fillets_Kf

subroutine create_holes(nodes, holes, geometry)
  implicit none
  double precision R, rad
  integer i, j, nodes, records, node
  double precision holes(nodes), geometry(nodes)
  double precision Kt, Kf, q
 
  open(unit=12, file="Holes.dat")
   read(12,*) records

  do i=1, nodes
   holes(i) = 1.
  enddo

  do i=1, records
   read(12,*) node, rad
   R = geometry(node)
   Kt = holes_Kt(R, rad)
    q = notch_sensitivity(rad)
   Kf = 1. + q * (Kt - 1.)

  enddo
  close(12)
end subroutine create_holes

subroutine include_Kt(nodes, stress, fillets, holes)
 implicit none
 integer i, j, nodes
 double precision stress(nodes), fillets(nodes), holes(nodes)

 do i=1, nodes
  stress(i) = stress(i) * holes(i) * fillets(i)
 enddo
end subroutine include_Kt

function max_stress_node(nodes, stress)
 implicit none
 integer i, j, nodes
 double precision stress(nodes)
 double precision max_stress
 integer max_stress_node

 max_stress = 0.
 do i=1, nodes
  if (stress(i) > max_stress ) then
      max_stress = stress(i)
      max_stress_node = i
  endif
 enddo
 return
end function max_stress_node

function equiv(s_mean, s_ampl, SU)
 implicit none
 double precision equiv, s_mean, s_ampl, SU

 equiv = s_ampl / (1. - (s_mean/SU)**2)
 return
end function equiv

function cycles(equiv, B, C)
 implicit none
 double precision equiv, B, C 
 double precision cycles

 cycles = C * equiv**(-B)
 return
end function cycles

subroutine create_geometry(nodes, geometry)
 implicit none 
 integer nodes, i, j, node, ne
 double precision geometry(nodes), rad, J
 open(unit = 12, file = "Geometry.dat")
 read(12,*) ne

 do i=1, ne
  read(12,*) node, rad, J
  geometry(i) = rad
 enddo
  geometry(nodes) = rad
 close(12)
end subroutine create_geometry

subroutine read_fatigue(B, C)
 implicit none
 double precision B, C
 open(unit = 12, file = "Wheller_B.dat")
 read(12,*) B
 close(12)

 open(unit = 12, file = "Wheller_C.dat")
 read(12,*) C 
 close(12)
end subroutine read_fatigue
