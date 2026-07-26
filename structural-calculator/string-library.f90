integer function length(line)
  implicit none
  character(*) line
  length = index(line, '  ') - 1
  return
end function length


