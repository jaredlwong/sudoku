;;;; Simple stack&queue Abstraction

(declare (usual-integrations))

(define-record-type <stack&queue>
  (%make-stack&queue front back)
  stack&queue?
  (front stack&queue-front set-stack&queue-front!)
  (back stack&queue-back set-stack&queue-back!))


(define (make-stack&queue)
  (%make-stack&queue '() '()))

(define (stack&queue-empty? stq)
  (not (pair? (stack&queue-front stq))))

(define (stack&queued? stq item)
  (memq item (stack&queue-front stq)))

(define (push! stq object)
  (if (pair? (stack&queue-front stq))
      (set-stack&queue-front! stq
			      (cons object (stack&queue-front stq)))
      (begin
	(set-stack&queue-front! stq
				(cons object (stack&queue-front
					      stq)))
	(set-stack&queue-back! stq
			       (stack&queue-front stq))))
  unspecific)

(define (add-to-end! stq object)
  (let ((new (cons object '())))
    (if (pair? (stack&queue-back stq))
	(set-cdr! (stack&queue-back stq) new)
	(set-stack&queue-front! stq new))
    (set-stack&queue-back! stq new)
    unspecific))

(define (pop! stq)
  (let ((next (stack&queue-front stq)))
    (if (not (pair? next))
	(error "Empty stack&queue -- POP"))
    (if (pair? (cdr next))
	(set-stack&queue-front! stq (cdr next))
	(begin
	  (set-stack&queue-front! stq '())
	  (set-stack&queue-back! stq '())))
    (car next)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-syntax amb
  (sc-macro-transformer
   (lambda (form uenv)
     `(amb-list
       (list ,@(map (lambda (arg)
		      `(lambda ()
			 ,(close-syntax arg uenv)))
		    (cdr form)))))))

(define *number-of-calls-to-fail* 0)	;for metering.

(define (amb-list alternatives)
  (if (null? alternatives)
      (set! *number-of-calls-to-fail*
	    (+ *number-of-calls-to-fail* 1)))
  (call-with-current-continuation
   (lambda (k)
     (add-to-search-schedule
      (map (lambda (alternative)
             (lambda ()
               (within-continuation k alternative)))
           alternatives))
     (yield))))


;;; amb-set! is an assignment operator
;;;  that gets undone on backtracking.

(define-syntax amb-set!
  (sc-macro-transformer
   (lambda (form uenv)
     (compile-amb-set (cadr form) (caddr form) uenv))))

(define (compile-amb-set var val-expr uenv)
  (let ((var (close-syntax var uenv))
        (val (close-syntax val-expr uenv)))
    `(let ((old-value ,var))
       (effect-wrapper
        (lambda ()
          (set! ,var ,val))
        (lambda ()
          (set! ,var old-value))))))


;;; A general wrapper for undoable effects

(define (effect-wrapper doer undoer)
  (force-next
   (lambda () (undoer) (yield)))
  (doer))

;;; Alternative search strategy wrappers

(define (with-depth-first-schedule thunk)
  (call-with-current-continuation
   (lambda (k)
     (fluid-let ((add-to-search-schedule
		  add-to-depth-first-search-schedule)
		 (*search-schedule* (empty-search-schedule))
		 (*top-level* k))
       (thunk)))))

(define (with-breadth-first-schedule thunk)
  (call-with-current-continuation
   (lambda (k)
     (fluid-let ((add-to-search-schedule
		  add-to-breadth-first-search-schedule)
		 (*search-schedule* (empty-search-schedule))
		 (*top-level* k))
       (thunk)))))


;;; Representation of the search schedule

(define *search-schedule*)

(define (empty-search-schedule)
  (make-stack&queue))

(define (yield)
  (if (stack&queue-empty? *search-schedule*)
      (*top-level* #f)
      ((pop! *search-schedule*))))

(define (force-next thunk)
  (push! *search-schedule* thunk))

;;; Alternative search strategies

(define (add-to-depth-first-search-schedule alternatives)
  (for-each (lambda (alternative)
	      (push! *search-schedule* alternative))
	    (reverse alternatives)))

(define (add-to-breadth-first-search-schedule alternatives)
  (for-each (lambda (alternative)
	      (add-to-end! *search-schedule* alternative))
	    alternatives))

;;; For incremental interactive experiments from REPL.

(define (init-amb)
  (set! *search-schedule* (empty-search-schedule))
  (set! *number-of-calls-to-fail* 0)
  'done)

(define add-to-search-schedule ;; Default is depth 1st
  add-to-depth-first-search-schedule)

(define *top-level*
  (lambda (ignore)
    (display ";No more alternatives\n")
    (abort->top-level unspecific)))



(define (require p)
  (if (not p) (amb)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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


(vector-for-each
 (lambda (row)
   (for-each
    (lambda (i)
      (let ((e (vector-ref row i)))
	(if (= e 0)
	    (vector-set! row i (amb 1 2 3 4 5 6 7 8 9))
    (iota 9)) sudoku)))))

(

(with-depth-first-schedule
  (lambda ()
    (sudoku)

;(let ((r1c1 (amb 1 2 3 4 5 6 7 8 9)))
;  (let ((r1c2 (amb 1 2 3 4 5 6 7 8 9)))
;    (let ((r1c3 (amb 1 2 3 4 5 6 7 8 9)))
;      (let ((r1c4 (amb 1 2 3 4 5 6 7 8 9)))
;        (let ((r1c5 (amb 1 2 3 4 5 6 7 8 9)))
;          (let ((r1c6 (amb 1 2 3 4 5 6 7 8 9)))
;            (let ((r1c7 (amb 1 2 3 4 5 6 7 8 9)))
;              (let ((r1c8 (amb 1 2 3 4 5 6 7 8 9)))
;                (let ((r1c9 (amb 1 2 3 4 5 6 7 8 9)))
;(let ((r2c1 (amb 1 2 3 4 5 6 7 8 9)))
;  (let ((r2c2 (amb 1 2 3 4 5 6 7 8 9)))
;    (let ((r2c3 (amb 1 2 3 4 5 6 7 8 9)))
;      (let ((r2c4 (amb 1 2 3 4 5 6 7 8 9)))
;        (let ((r2c5 (amb 1 2 3 4 5 6 7 8 9)))
;          (let ((r2c6 (amb 1 2 3 4 5 6 7 8 9)))
;            (let ((r2c7 (amb 1 2 3 4 5 6 7 8 9)))
;              (let ((r2c8 (amb 1 2 3 4 5 6 7 8 9)))
;                (let ((r2c9 (amb 1 2 3 4 5 6 7 8 9)))
;(let ((r3c1 (amb 1 2 3 4 5 6 7 8 9)))
;  (let ((r3c2 (amb 1 2 3 4 5 6 7 8 9)))
;    (let ((r3c3 (amb 1 2 3 4 5 6 7 8 9)))
;      (let ((r3c4 (amb 1 2 3 4 5 6 7 8 9)))
;        (let ((r3c5 (amb 1 2 3 4 5 6 7 8 9)))
;          (let ((r3c6 (amb 1 2 3 4 5 6 7 8 9)))
;            (let ((r3c7 (amb 1 2 3 4 5 6 7 8 9)))
;              (let ((r3c8 (amb 1 2 3 4 5 6 7 8 9)))
;                (let ((r3c9 (amb 1 2 3 4 5 6 7 8 9)))
;(let ((r4c1 (amb 1 2 3 4 5 6 7 8 9)))
;  (let ((r4c2 (amb 1 2 3 4 5 6 7 8 9)))
;    (let ((r4c3 (amb 1 2 3 4 5 6 7 8 9)))
;      (let ((r4c4 (amb 1 2 3 4 5 6 7 8 9)))
;        (let ((r4c5 (amb 1 2 3 4 5 6 7 8 9)))
;          (let ((r4c6 (amb 1 2 3 4 5 6 7 8 9)))
;            (let ((r4c7 (amb 1 2 3 4 5 6 7 8 9)))
;              (let ((r4c8 (amb 1 2 3 4 5 6 7 8 9)))
;                (let ((r4c9 (amb 1 2 3 4 5 6 7 8 9)))
;(let ((r5c1 (amb 1 2 3 4 5 6 7 8 9)))
;  (let ((r5c2 (amb 1 2 3 4 5 6 7 8 9)))
;    (let ((r5c3 (amb 1 2 3 4 5 6 7 8 9)))
;      (let ((r5c4 (amb 1 2 3 4 5 6 7 8 9)))
;        (let ((r5c5 (amb 1 2 3 4 5 6 7 8 9)))
;          (let ((r5c6 (amb 1 2 3 4 5 6 7 8 9)))
;            (let ((r5c7 (amb 1 2 3 4 5 6 7 8 9)))
;              (let ((r5c8 (amb 1 2 3 4 5 6 7 8 9)))
;                (let ((r5c9 (amb 1 2 3 4 5 6 7 8 9)))
;(let ((r6c1 (amb 1 2 3 4 5 6 7 8 9)))
;  (let ((r6c2 (amb 1 2 3 4 5 6 7 8 9)))
;    (let ((r6c3 (amb 1 2 3 4 5 6 7 8 9)))
;      (let ((r6c4 (amb 1 2 3 4 5 6 7 8 9)))
;        (let ((r6c5 (amb 1 2 3 4 5 6 7 8 9)))
;          (let ((r6c6 (amb 1 2 3 4 5 6 7 8 9)))
;            (let ((r6c7 (amb 1 2 3 4 5 6 7 8 9)))
;              (let ((r6c8 (amb 1 2 3 4 5 6 7 8 9)))
;                (let ((r6c9 (amb 1 2 3 4 5 6 7 8 9)))
;(let ((r7c1 (amb 1 2 3 4 5 6 7 8 9)))
;  (let ((r7c2 (amb 1 2 3 4 5 6 7 8 9)))
;    (let ((r7c3 (amb 1 2 3 4 5 6 7 8 9)))
;      (let ((r7c4 (amb 1 2 3 4 5 6 7 8 9)))
;        (let ((r7c5 (amb 1 2 3 4 5 6 7 8 9)))
;          (let ((r7c6 (amb 1 2 3 4 5 6 7 8 9)))
;            (let ((r7c7 (amb 1 2 3 4 5 6 7 8 9)))
;              (let ((r7c8 (amb 1 2 3 4 5 6 7 8 9)))
;                (let ((r7c9 (amb 1 2 3 4 5 6 7 8 9)))
;(let ((r8c1 (amb 1 2 3 4 5 6 7 8 9)))
;  (let ((r8c2 (amb 1 2 3 4 5 6 7 8 9)))
;    (let ((r8c3 (amb 1 2 3 4 5 6 7 8 9)))
;      (let ((r8c4 (amb 1 2 3 4 5 6 7 8 9)))
;        (let ((r8c5 (amb 1 2 3 4 5 6 7 8 9)))
;          (let ((r8c6 (amb 1 2 3 4 5 6 7 8 9)))
;            (let ((r8c7 (amb 1 2 3 4 5 6 7 8 9)))
;              (let ((r8c8 (amb 1 2 3 4 5 6 7 8 9)))
;                (let ((r8c9 (amb 1 2 3 4 5 6 7 8 9)))
;(let ((r9c1 (amb 1 2 3 4 5 6 7 8 9)))
;  (let ((r9c2 (amb 1 2 3 4 5 6 7 8 9)))
;    (let ((r9c3 (amb 1 2 3 4 5 6 7 8 9)))
;      (let ((r9c4 (amb 1 2 3 4 5 6 7 8 9)))
;        (let ((r9c5 (amb 1 2 3 4 5 6 7 8 9)))
;          (let ((r9c6 (amb 1 2 3 4 5 6 7 8 9)))
;            (let ((r9c7 (amb 1 2 3 4 5 6 7 8 9)))
;              (let ((r9c8 (amb 1 2 3 4 5 6 7 8 9)))
;                (let ((r9c9 (amb 1 2 3 4 5 6 7 8 9)))



