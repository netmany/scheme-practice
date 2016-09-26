#lang racket

(define (serve port-no)
    (define listener (tcp-listen port-no 5 #t))
    (define (loop)
        (accept-and-handle listener)
        (loop))
    (define t (thread loop))
    (lambda ()
        (kill-thread t)
        (tcp-close listener)))

(define (accept-and-handle listener)
    (define-values (in out) (tcp-accept listener))
    (handle in out)
    (close-input-port in)
    (close-output-port out))

(define (handle in out)
    (display "HTTP/1.1 200 OK\r\n" out)
    (display "Server: myServer\r\n" out)
    (display "Content-Type: text/html\r\n" out)
    (display "\r\n" out)
    
    (display "</html>" out)
    (display "<form action=\"blah.php\" method=\"post\">\r\n" out)
    (display "<input type=\"text\" name=\"data\" value=\"mydata\" />\r\n" out)
    (display "<input type=\"submit\" />\r\n" out)
    (display "</form>\r\n" out)
    (display "<br />req=BEGIN<br />" out)

    (let t ((p (read-line in 'return-linefeed)))
        (printf "~a\n" p)
        (when (not (string=? "" p))
            (fprintf out "~a<br />" p)
            (t (read-line in 'return-linefeed))))
    
    (display "<br />END</html>" out))

(define stop (serve 8080))
(display "end server? ")
(read-line)
(stop)
