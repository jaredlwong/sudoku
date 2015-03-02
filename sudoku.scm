(set! load/suppress-loading-message? #t)

(define sudoku
  '#(#(8 0 1 3 4 0 0 0 0)
     #(4 3 0 8 0 0 1 0 7)
     #(0 0 0 0 6 0 0 0 3)
     #(2 0 8 0 5 0 0 0 9)
     #(0 0 9 0 0 0 7 0 0)
     #(6 0 0 0 7 0 8 0 4)
     #(3 0 0 0 1 0 0 0 0)
     #(1 0 5 0 0 6 0 4 2)
     #(0 0 0 0 2 4 3 0 8)))

(define (flatmap func lst)
  (fold-left (lambda (lst e) (append lst e)) '() (map func lst)))

(define (@ sudoku row col)
  (vector-ref (vector-ref sudoku row) col))

(define sudoku-row-coors
  (map (lambda (i) (map (lambda (j) (cons i j)) (iota 9))) (iota 9)))

(define sudoku-col-coors
  (map (lambda (i) (map (lambda (j) (cons j i)) (iota 9))) (iota 9)))

(define ((translate r c) coor)
  (cons (+ (car coor) r)
	(+ (cdr coor) c)))

(define (cross-product lst1 lst2)
  (flatmap (lambda (i) (map (lambda (j) (cons i j)) lst1)) lst2))

(define sudoku-sqr-coors-basic
  (cross-product (iota 3) (iota 3)))

(define sudoku-sqr-coors
  (flatmap (lambda (i)
	     (map (lambda (j)
		    (map (translate (* i 3) (* j 3))
			 sudoku-sqr-coors-basic))
		  (iota 3)))
	   (iota 3)))

(define (sudoku-get-coors sudoku coors-list)
  (map (lambda (coors)
	 (map (lambda (coor)
		(let ((row (car coor))
		      (col (cdr coor)))
		  (@ sudoku row col)))
	      coors))
       coors-list))

(define (sudoku-rows sudoku)
  (sudoku-get-coors sudoku sudoku-row-coors))

(define (sudoku-cols sudoku)
  (sudoku-get-coors sudoku sudoku-col-coors))

(define (sudoku-sqrs sudoku)
  (sudoku-get-coors sudoku sudoku-sqr-coors))

(define (row-col-sqr-okay rcs)
  (let ((seen (make-vector 10 0)))
       (let lp ((i 0)
		(lst rcs))
	 (let ((e (car lst)))
	   (vector-set! seen e (+ (vector-ref seen e) 1))
	   (cond ((and (> e 0) (> (vector-ref seen e) 1)) #f)
		 ((null? (cdr lst)) #t)
		 (else (lp (+ i 1) (cdr lst))))))))

(define (sudoku-possible sudoku)
  (for-all? (map row-col-sqr-okay (append (sudoku-rows sudoku)
					  (sudoku-cols sudoku)
					  (sudoku-sqrs sudoku)))
	    (lambda (x) x)))

(define (sudoku-complete sudoku)
  (let lp ((coors (cross-product (iota 9) (iota 9))))
    (let ((row (car (car coors)))
	  (col (cdr (car coors)))
	  (rest (cdr coors)))
      (cond ((= (@ sudoku row col) 0) #f)
	    ((null? rest) #t)
	    (else (lp rest))))))

(define (sudoku-next-empty sudoku)
  (let lp ((coors (cross-product (iota 9) (iota 9))))
    (let ((row (car (car coors)))
	  (col (cdr (car coors)))
	  (rest (cdr coors)))
      (cond ((= (@ sudoku row col) 0) (cons row col))
	    ((null? rest) #f)
	    (else (lp rest))))))

(define (sudoku-copy sudoku)
  (vector-map vector-copy sudoku))

(define (sudoku-set! sudoku row col val)
  (vector-set! (vector-ref sudoku row) col val))

(define (sudoku-gen-next sudoku)
  (let* ((coors (sudoku-next-empty sudoku))
	 (row (car coors))
	 (col (cdr coors)))
    (map (lambda (i)
	   (let ((next-sudoku (sudoku-copy sudoku)))
	     (sudoku-set! next-sudoku row col i)
	     next-sudoku))
	 (cdr (iota 10)))))

(define (sudoku-solve sudoku)
  (let lp ((queue (list sudoku)))
    (if (null? queue)
	#f
	(let ((sudoku (car queue))
	      (rest (cdr queue)))
	  (cond ((not (sudoku-possible sudoku)) (lp rest))
		((sudoku-complete sudoku) sudoku)
		(else (lp (append rest (sudoku-gen-next sudoku)))))))))

;(sudoku-solve sudoku)
(define (sudoku-print sudoku)
  (let ((l (vector->list (vector-map vector->list sudoku))))
    (map (lambda (row) (apply string-append (map number->string row))) l)))

(display (sudoku-print sudoku))
(display (sudoku-print (sudoku-solve sudoku)))
