
(define TAG "hung-test")

(define (slog tag msg)
    (define d (current-date))
    (printf "~a\t~a\t~a\t~a: ~a\n"
        (format "~2,'0d-~2,'0d ~2,'0d:~2,'0d:~2,'0d.~3,'0d"
            (date-month d) (date-day d)
            (date-hour d) (date-minute d)
            (date-second d) (div (date-nanosecond d) 1000000))
        (get-process-id) (get-thread-id) tag msg))

(define (make-exception s)
  (condition
   (make-message-condition s)
   (make-continuation-condition
    (call/cc (lambda (k) k)))))

(define (print-stack-trace e)
    (slog TAG (condition-message e))
    (let loop ([t (inspect/object (condition-continuation e))])
      (slog TAG
        (format "\tat ~a\t~a" (or ((t 'code) 'name) "???")
            (call-with-values
             (lambda () (t 'source-path))
             (case-lambda
              [(file line column)
              (format "(~a:~a,~a)" file line column)]
              [(file pos) (format "(~a:~a)" file pos)]
              [() "???"]))))
      (when (> (t 'depth) 1)
        (loop (t 'link)))))

(define MAX_THREAD_NUM 32)
(define thread-dump? (make-vector MAX_THREAD_NUM #f))

(register-signal-handler 10
  (lambda (sig)
     (print-stack-trace (make-exception "on signal"))
     (vector-fill! thread-dump? #t)))

(define (my-fork-thread work)
  (fork-thread (lambda ()
      (timer-interrupt-handler
          (lambda ()
            (if (vector-ref thread-dump? (get-thread-id))
                (begin
                  (vector-set! thread-dump? (get-thread-id) #f)
                  (print-stack-trace (make-exception "on timer"))))
            (set-timer 1000)))
      (set-timer 1000)
      (work))))


(define (f1 x)
   (+ 1 (f2 x)))

(define (f2 x)
   (* 2 (f3_type1 x)))

(define (f3_type1 x)
   (let p () (p))
   (+ 3 x))

(define (f3_type2 x)
   (sleep (make-time 'time-duration 0 5))
   (+ 3 x))

(define (hung-task)
    (f1 20))

(my-fork-thread hung-task)
(my-fork-thread hung-task)
(my-fork-thread hung-task)

(hung-task)

(let p ()
  (sleep (make-time 'time-duration 0 1))
  (p))

(printf "exit tid=~a\n" (get-thread-id))

