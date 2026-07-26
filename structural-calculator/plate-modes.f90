program modes
   implicit none

   integer MAX_RECORDS, i, n, L, MAX_WORD, m
   parameter (MAX_RECORDS = 1000, MAX_WORD = 128)
   
   integer length
   character(len=MAX_WORD) filename
   character(len=MAX_WORD) line

   print*, "Please input filename"
   read*, filename

   !!!!print*, filename  
   open(unit = 12, file = filename)

   n = 0
   do i=1,MAX_RECORDS
      read(12,'(A)',end=100) line
      L = length(line)
      !!!!L = LEN(line) defines actual length during the definition
      n = n + 1
      m = index(line, ',')
      if (m .gt. 0) then
          write(*,'(A)') line(:m-1)
      else 
          write(*,'(A)') line(:L)
      endif

   enddo

100 write(*,fmt=200) filename(:length(filename)), n 
200 format('file: ', A, ' number records read:',I4)
    close(12)
end program

