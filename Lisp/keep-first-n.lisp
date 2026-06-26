(defun keep-first-n
       (n l)
       (if (= n 0) nil (cons (first l) (keep-first-n (- n 1) (rest l)))))	   