#! /usr/bin/scheme --program

(import (chezscheme))
(import (os net))

(define (logMsg tag msg)
    (define d (current-date))
    (printf "~a:~a:~a [~a] ~a\n"
            (date-hour d) (date-minute d) (date-second d)
            tag msg))

(define tag "server")
(logMsg tag "work begin")

(define s (net_listen 8080))

(logMsg tag (format "socket=~a" s))

(define cl (net_accept s))
(logMsg tag (format "accept socket=~a" cl))

(define buf_in (make-bytevector 1024 0))
(define len (net_read cl buf_in (bytevector-length buf_in)))

(define req (make-bytevector len))
(bytevector-copy! buf_in 0 req 0 len)

(set! req (utf8->string req))

(logMsg tag (format "req=~a" req))

(define res (format "req=[~a], res=~a" req (string-length req)))

(define buf_out (string->utf8 res))
(net_write cl buf_out (bytevector-length buf_out))

(logMsg tag "end net_write")
(sleep (make-time 'time-duration 0 5))

(logMsg tag "work done.")

(net_close cl)
(net_close s)
