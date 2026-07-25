(defun fetch-from-file (fragment file)
       (with-open-file (line-stream file :direction :input)
             (do ( (line (read line-stream nil)
                         (read line-stream nil))
                 ) ;; line parameter
                 ((not line) (format t "%No such entry!"))
                 (when (search fragment line :test #'char-equal) 
                       (format t "~%~a" line)
                       (return t)
                 ) ;; when
             ) ;; end do
       ) ; end of with-open-file
) ;; end of defun
