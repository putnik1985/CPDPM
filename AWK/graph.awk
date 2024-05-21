BEGIN { current = 1; }
{
  if ($1 == "title") {
                      for(i = 2; i <= NF; ++i)
                          title = title " " $i
  }
  if ($1 == "plot")   {
                      file[current] = $2
                      x[current] = $3
                      y[current] = $4
                      name[current] = $5
                      for(i = 6; i <= NF; ++i)
                          name[current] = name[current] " " $i
                      current++
  }
  if ($1 == "xlabel") {
                      for(i = 2; i <= NF; ++i)
                          xlabel = xlabel " " $i
  }
  if ($1 == "ylabel") {
                      for(i = 2; i <= NF; ++i)
                          ylabel = ylabel " " $i
  }
  if ($1 == "yrange") {
                          ymin = $2
                          ymax = $3
  }
  if ($1 == "xrange") {
                          xmin = $2
                          xmax = $3
  }
}
END {
     print "set title" " " "\"" title "\""
     print "set xlabel" " " "\"" xlabel "\""
     print "set ylabel" " " "\"" ylabel "\""
     print "set xrange" " " "[" xmin ":" xmax "]"
     print "set yrange" " " "[" ymin ":" ymax "]"
     print "set grid"

     plots = 1
     print "plot" " \"<awk 'NR>=2 {print $$" x[plots] "," "$$" y[plots] "}'" " " file[plots]"\"" " title " "\"" name[plots] "\"" " with lines,\\"
     for(plots = 2; plots < current - 1; plots++){
         print "     \"<awk 'NR>=2 {print $$" x[plots] "," "$$" y[plots] "}'" " " file[plots]"\"" " title " "\"" name[plots] "\"" " with lines,\\"
     }
         print "     \"<awk 'NR>=2 {print $$" x[plots] "," "$$" y[plots] "}'" " " file[plots]"\"" " title " "\"" name[plots] "\"" " with lines"
}
