(setf data '())
(with-open-file (istream "input.dat"
                 :direction :input)

(do ((number (read istream nil) (read istream nil))) ((not number) data)
    (setf data (append data (list number)))))

;(print data)
(setf n (length data))
(setf sum 0)
(setf sqsum 0)

(dolist (element data sum)
        (setf sum (+ sum element))
		(setf sqsum (+ sqsum (* element element)))
)  
		
(print (list "    sum:" sum))
(print (list " amount:" n))
(print (list "average:" (/ sum n)))

(setf mat (/ sum n))
(setf D (* (- (/ sqsum n) (* mat mat)) (/ n (- n 1)))
)

(print (list "    D:" D))
(print (list "sigma:" (sqrt (/ D n))))
(setf sigma (sqrt (/ D n)))

(print "please input Tbeta (agreement interval)")
(setf tb (read))
(print tb)

(setf eps (* tb sigma))
(print "Agreement interval:")
(print (list (- mat eps) (+ mat eps)))