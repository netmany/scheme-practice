#lang racket

(define (browse ip port)
    (define-values (in out) (tcp-connect ip port))
    (handle in out (format "~a:~a" ip port))
    (close-input-port in)
    (close-output-port out))

(define testHead
"GET / HTTP/1.1\r\n\
Host: ~a\r\n\
Connection: keep-alive\r\n\
Upgrade-Insecure-Requests: 1\r\n\
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/51.0.2704.103 Safari/537.36\r\n\
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8\r\n\
Accept-Encoding: gzip, deflate, sdch\r\n\
Accept-Language: zh-CN,zh;q=0.8\r\n\r\n"
)

(define (handle in out address)
    (display (format testHead address) out)
    (flush-output out)
    (let t ((p (read-line in 'return-linefeed)))
        (when (not (string=? "" p))
            (printf "~a\n" p)
            (t (read-line in 'return-linefeed)))))


(define args (current-command-line-arguments))

(define ip "")
(define port 80)

(case (vector-length args)
    ((1) (set! ip (vector-ref args 0)))
    ((2) (set! ip (vector-ref args 0))
         (set! port (string->number (vector-ref args 1))))
    (else (exit)))

(browse ip port)
