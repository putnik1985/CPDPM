(defun do-factorial (n)
   (do ((count n (- count 1))
         (result 1 (* result count)))
        ((zerop count) result)))
