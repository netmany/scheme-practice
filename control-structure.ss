; while loop with break statement
(define (test x)
    (let while ((i 0))
      (call/cc (lambda (break)
                 (printf "cur/ i=~d\n" i)
                 (if (= x (+ 1 (* 2 i)))
                     (begin (printf "break on i=~d\n" i)
                            (break)))
                 (printf "cur/ end i=~d\n" i)
                 (while (+ 1 i))))))

; function with return statement
(define (query x)
    (call/cc (lambda (return)
               (if (= 0 x) (return 'zero))
               (if (= 0 (mod x 3)) (return 'threes))
               (if (= 0 (mod x 10)) (return 'tens))
               (return 'nothing))))

; function with long jump statement
(define (ex-handler x c)
    (if (> x 10) (c))
    (printf "safe to print x=~d\n" x))
    
(define (test-jmp x)
    (printf "test-jmp/ x=~d\n" x)
    (call/cc (lambda (c)
               (ex-handler x c)
               (printf "we can run longer!\n"))))
               
               
