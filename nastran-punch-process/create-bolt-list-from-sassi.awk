BEGIN {FS=",";}
{ 
      min = $1
      max = $2
      for(i=min; i<=max; ++i){
          print i
      }
}
