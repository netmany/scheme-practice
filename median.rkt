#lang racket

(define (median v)
    (define (findk v start end k)
        
        (define (swap v i j)
            (when (not (= i j))
                (let ((t (vector-ref v i)))
                    (vector-set! v i (vector-ref v j))
                    (vector-set! v j t))))
        
        (define (partition v s e)
            (define p (+ s (random (- e s))))
            (swap v s p)
            (set! p (+ s 1))
            (let loop ((i p))
                (when (< i e)
                    (when (< (vector-ref v i) (vector-ref v s))
                        (swap v i p)
                        (set! p (+ p 1)))
                    (loop (+ i 1))))
            (swap v s (- p 1))
            (- p 1))
        
        (let ((p (partition v start end)))
            (cond
                ((= p (+ k start)) (vector-ref v p))
                ((> p (+ k start)) (findk v start p k))
                (else (findk v (+ p 1) end (- k (- (+ p 1) start)))))))
    
    (define len (vector-length v))
    (findk v 0 len (quotient len 2)))

; make median test in random sequence data



(define v (make-random-input))
(printf "len is ~a\n" (vector-length v))
(time (median v))
(time (list-ref (sort (vector->list v) <) (quotient (vector-length v) 2)))

; correctness test

; (let loop ((i 0)
;            (v (make-random-input)))
;     (when (< i 1000)
;         (let ((a (median v))
;               (b (list-ref (sort (vector->list v) <) (quotient (vector-length v) 2))))
;             (when (not (= a b))
;                 (printf "median is wrong: v=~a\n" v)))
;         (loop (+ i 1) (make-random-input))))
    
