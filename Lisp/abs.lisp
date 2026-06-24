(defun absolute
       (x)
       (if (> x 0) (first (list x)) (first (list (- x)))))
