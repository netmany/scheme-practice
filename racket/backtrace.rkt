#lang racket

; print stack trace
; Racket.exe -l errortrace -t F:/devs/lisp/test.rkt

(require errortrace)

(define (fn1 x y)
    (+ x (fn2 y)))

(define (fn2 y)
    (begin
        (print-error-trace
            (current-output-port)
            (make-exn
                "fn2-test"
                (current-continuation-marks)))
        (* 3 y)))

(fn1 2 5)
(printf "print stack trace end!\n")
