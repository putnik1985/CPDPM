program modes
   implicit none

   integer MAX_RECORDS, i, n, L, MAX_WORD, m
   integer m1

   parameter (MAX_RECORDS = 1000, MAX_WORD = 128)
   
   integer length, current_to_add_x, current_to_add_y
   character(len=MAX_WORD) filename
   character(len=MAX_WORD) line
   character(len=12) condition, x_condition(2), y_condition(2), property

   real shape_x, shape_y
   real string_to_real

   character direction
   real real_number
   real E, nu, h
   real x_boundary(2), y_boundary(2)



   print*, "Please input filename"
   read*, filename

   !!!!print*, filename  
   open(unit = 12, file = filename)

   n = 0
   current_to_add_x = 1
   current_to_add_y = 1

   do i=1,MAX_RECORDS
      read(12,'(A)',end=100) line
      L = length(line)
      n = n + 1
       m = index(line, ',')
      m1 = index(line, '=')

      if (m .gt. 0) then
          condition = line(m+1:)
          
          write(*,'(A)') line(:m-1)
          write(*,'(A)') condition
          call remove_leading_spaces(condition)
          call remove_trailing_spaces(condition)
          if (condition .eq. "supported") then
                  write(*,*) "Found supported"
          else if (condition .eq. "clamped") then
                  write(*,*) "Found clamped"
          endif
          write(*,'(A,I16)') condition, length(condition)
          direction = line(:m1-1)
          real_number = string_to_real(line(m1+1:m-1))

          if (direction .eq. 'x') then
                  write(*,*) "X direction", real_number
                  x_boundary(current_to_add_x) = real_number
                  x_condition(current_to_add_x) = condition
                  current_to_add_x = current_to_add_x + 1
          else
                  write(*,*) "Y direction", real_number
                  y_boundary(current_to_add_y) = real_number
                  y_condition(current_to_add_y) = condition
                  current_to_add_y = current_to_add_y + 1
          endif

      else 
          write(*,'(A)') line(:L)
          real_number = string_to_real(line(m1+1:))
          write(*,*) line(:m1-1), real_number
          property = line(:m1-1)
          if (property .eq. 'E') then
                  E = real_number
          else if (property .eq. 'h') then
                  h = real_number
          else if (property .eq. 'nu') then
                  nu = real_number
          endif

      endif

   enddo


100 write(*,fmt=200) filename(:length(filename)), n 
200 format('file: ', A, ' number records read:',I4)
    close(12)

   print*, "------------------------------------------------------------------"
   print*, "Boundaries:"
   print*, "x0 = ", x_boundary(1), x_condition(1), " x1 = ", x_boundary(2), x_condition(2)
   print*, "y0 = ", y_boundary(1), y_condition(1), " y1 = ", y_boundary(2), y_condition(2)
   print*, "E = ", E, " nu = ", nu, " h= ", h
end program

