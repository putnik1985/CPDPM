(defun rotate-list
       (l &key direction (distance 1))
       (if (eq direction 'left)
           (rotate-list-left l distance)
           (rotate-list-right l distance )))

(defun rotate-list-right
       (l n)
       (if (zerop n) l
           (rotate-list-right (append (last l) (butlast l)) (- n 1))))

(defun rotate-list-left (l n)
       (if (zerop n) l
           (rotate-list-left (append (rest l) (list (first l))) (- n 1))))
