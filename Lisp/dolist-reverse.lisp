(defun dolist-reverse (l)
       (setf result nil)
       (dolist (element l result)
               (setf result (cons element result))))
