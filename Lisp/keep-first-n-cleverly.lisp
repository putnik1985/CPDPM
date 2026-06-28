(defun keep-first-n-cleverly
       (n l)
       (keep-first-n-cleverly-aux n l nil))

(defun keep-first-n-cleverly-aux 
           (n l result)
           (if (zerop n) (reverse result)
                         (keep-first-n-cleverly-aux (- n 1) (rest l) (cons (first l) result))))
