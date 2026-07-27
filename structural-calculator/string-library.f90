integer function length(line)
  implicit none
  character(*) line
  length = index(line, '  ') - 1
  return
end function length

subroutine remove_leading_spaces(line)
        implicit none
        character(*) line
        line = adjustl(line)
end 

subroutine remove_trailing_spaces(line)
        implicit none
        character(*) line
        line = trim(line)
end 
