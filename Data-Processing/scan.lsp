(with-open-file (istream "input.dat"
                 :direction :input)

(setf data '(1 2))
(do ((number (read istream nil) (read istream nil))) ((not number) data)
    (append data (list number))))

(print data)
