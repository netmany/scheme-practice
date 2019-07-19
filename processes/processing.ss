
;scheme --debug-on-exception --program foo.scm
;echo '(parameterize ([run-cp0 (lambda (cp0 x) x)]) (load-program "foo.ss"))' | scheme -q


; binary ports
(define-values (p0 p1 p2 p3)
      (open-process-ports "scheme -q" 'line (native-transcoder)))
(fprintf p0 "(* 64.3 4.2)\n")
(get-line p1)
(system (format "kill ~a" p3))

;textual ports
(define res (process "scheme -q"))
(fprintf (cadr res) "(* 64.3 4.2)\n")
(get-line (car res))
(system (format "kill ~a" (caddr res)))

(load-shared-object "libc.so.6")

(define-ftype KILL_T (function (int int) int))
(define kill (ftype-ref KILL_T () (make-ftype-pointer KILL_T "kill")))
(kill (caddr res) 9)

(define-ftype WAITPID_T (function (int (* int) int) int))
(define waitpid (ftype-ref WAITPID_T () (make-ftype-pointer WAITPID_T "waitpid")))
(define stat (make-ftype-pointer int (foreign-alloc (ftype-sizeof int))))

(waitpid p3 stat 0) 

(ftype-ref int () stat)
(foreign-free (ftype-pointer-address stat))

(set! k 20)
(fprintf (current-output-port) "~a\n"
    `(let p ((i 1)
             (sum 0))
       (if (< i ,k)
           (p (+ 1 i) (+ i sum))
           sum)))

(get-line p1)
