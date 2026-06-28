(defun add
       (a b)
       (if (zerop b) a
                     (add (1+ a) (1- b))))
