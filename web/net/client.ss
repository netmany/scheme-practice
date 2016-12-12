#! /usr/bin/scheme --program

(import (chezscheme))
(import (os net))

(define (logMsg tag msg)     
       (define d (current-date))   
       (printf "~a:~a:~a [~a] ~a\n"
                (date-hour d) (date-minute d) (date-second d) 
                tag msg))

(define tag "client")
(logMsg tag "work begin")

(define s (net_connect "127.0.0.1" 8080))

(logMsg tag (format "socket=~a" s))

(logMsg tag "net_write begin")
(define buf_out (string->utf8 "sum 100 23 23523 57"))
(net_write s buf_out (bytevector-length buf_out))

(logMsg tag "net_write end")

(define buf_in (make-bytevector 1024 0))
(define len (net_read s buf_in (bytevector-length buf_in)))

(define res (make-bytevector len))
(bytevector-copy! buf_in 0 res 0 len)

(logMsg tag "net_read end")

(logMsg tag (format "from server, res=~a" (utf8->string res)))

(sleep (make-time 'time-duration 0 5))

(logMsg tag "work done.")

(net_close s)

