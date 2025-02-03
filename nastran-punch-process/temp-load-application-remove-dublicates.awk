BEGIN {FS=",";}
{ 
  dublicate[$3]++; 
  if (dublicate[$3] == 1) print $0;
}