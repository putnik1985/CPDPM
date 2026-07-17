(defun make-book (title author classification)
       (list (list 'title title)
             (list 'author author)
             (list 'classification classification)))

;; create a database of the books
(setf books
      (list 
       (make-book '(artificial intelligence)
                 '(patric henry winston)
                 '(technical ai))
       (make-book '(common lisp)
                  '(guy L steele)
                  '(technical lisp))
       (make-book '(moby dick)
                  '(herman melville)
                  '(fiction))
       (make-book '(tom sawyer)
                  '(mark twain)
                  '(fiction))
       (make-book '(the black orchid)
                  '(rex stout)
                  '(fiction mystery))))

;;filter authors
(defun list-authors (books)
       (if (endp books) nil
           (cons (book-author (first books))
                 (list-authors (rest books)))))

;;define author of the book
(defun book-author (book)
       (second (assoc 'author book)))    

;; define fiction predicate
(defun fictionp (book)
       (member 'fiction (book-classification book)))

;; define book classification
(defun book-classification (book)
   (second (assoc 'classification book)))

;; define book title
(defun book-title (book)
       (second (assoc 'title book)))

;; list of fiction
(defun list-fiction-books (books)
       (cond ((endp books) nil)
             ((fictionp (first books))
              (cons (first books)
                    (list-fiction-books (rest books))))
             (t (list-fiction-books (rest books)))))

;;count fiction books
(defun count-fiction-books (books)
       (cond ((endp books) 0)
             ((fictionp (first books))
              (+ 1 (count-fiction-books (rest books))))
             (t (count-fiction-books (rest books))))) 
