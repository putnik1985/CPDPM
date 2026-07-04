(defun user-defined-last (l)
       (if (endp (rest l)) l
           (user-defined-last (rest l))))
