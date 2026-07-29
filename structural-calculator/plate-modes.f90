program modes
   implicit none

   integer MAX_RECORDS, i, n, L, MAX_WORD, m
   integer m1

   parameter (MAX_RECORDS = 1000, MAX_WORD = 128)
   
   integer length
   character(len=MAX_WORD) filename
   character(len=MAX_WORD) line
   character(len=12) condition

   real shape_x, shape_y
   real string_to_real

   character direction
   real real_number
   real E, nu, h

   print*, "Please input filename"
   read*, filename

   !!!!print*, filename  
   open(unit = 12, file = filename)

   n = 0
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
          else
                  write(*,*) "Y direction", real_number
          endif

      else 
          write(*,'(A)') line(:L)
          real_number = string_to_real(line(m1+1:))
          write(*,*) line(:m1-1), real_number
      endif

   enddo

100 write(*,fmt=200) filename(:length(filename)), n 
200 format('file: ', A, ' number records read:',I4)
    close(12)
end program

