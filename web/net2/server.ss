; (import (chezscheme))
(import (net))

; (define cl (command-line))

; (if (not (= 2 (length-on cl)))
;     (begin
;       (printf "usage: server.ss <port> <dir>")
;       (exit 1)))

; (define p (string->number (car cl)))
; (define dir (cadr cl))

(define (listen-on p)
  (define soc (nsocket 2 1 0))
  
  (define serv_addr
    (make-ftype-pointer sockaddr_in 
        (foreign-alloc (ftype-sizeof sockaddr_in))))
  
  (ftype-set! sockaddr_in (sin_family) 
              serv_addr 2)
  
  (ftype-set! sockaddr_in (sin_addr s_addr)
              serv_addr (htonl 0))
  
  (ftype-set! sockaddr_in (sin_port)
              serv_addr (htons p))
  
  (nbind soc serv_addr (ftype-sizeof sockaddr_in))
  
  (nlisten soc 64)
  
  soc)

(define (get-req q)
  (define cli_addr
    (make-ftype-pointer sockaddr_in 
        (foreign-alloc (ftype-sizeof sockaddr_in))))
  
  (define len (make-bytevector 8 0))
  
  (define c (naccept q cli_addr len))
  (define buf (make-bytevector 8192 0)) 
  
  (define rpy (string->utf8 "HTTP/1.1 200 OK\nContent-Length: 14\nConnection: close\nContent-Type: text/plain\n\nAccess Success"))
  
  
  (nread c buf 8192)
  (printf "http-req:\n~a\n" (utf8->string buf))
  
  (nwrite c rpy (bytevector-length rpy))
  (nsleep 1)
  (nclose c)
  )





; (loop
;     (define s (get-req q))
;     (define head-line (get-head-line s))
;     (define parameters (get-parameters s))
;     (define body (get-body s))

;     (define action (get-action head-line))
;     (define url (get-url head-line))
;     (define http-ver (get-http-version head-line))

;     (define loc (get-location url))
;     (define args (get-args url body))


;     (define res (handle-req loc args))

;     (reply s res)

;     )
