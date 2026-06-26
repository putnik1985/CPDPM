(defun skip-first-n
       (n l)
       (if (= n 0) l (skip-first (- n 1) (rest l))))	   