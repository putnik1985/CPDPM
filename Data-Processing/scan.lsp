(setf data '())
(with-open-file (istream "input.dat"
                 :direction :input)

(do ((number (read istream nil) (read istream nil))) ((not number) data)
    (setf data (append data (list number)))))

(print data)
