BEGIN{
      file1 = ARGV[1]
      file2 = ARGV[2]
      print "calculate " file1 " \ " file2

      while (getline < file1 > 0){
             set1[++record1] = $1
      }

      while (getline < file2 > 0){
             set2[++record2] = $1
      }
      print file1 " records " record1
      print file2 " records " record2
      ###### calculate set1 \ set2
      for (i=1; i<=record1; ++i){
           e1 = set1[i]
           for(j=1; j<=record2; ++j){
               e2 = set2[j]
               if (e1 == e2) break
           }
           if (j>record2)
               print e1
      }
}
