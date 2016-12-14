; file ffi.ss
(load-shared-object "./libffi.so")

(define-ftype PASSVAL_T (function (int (* int) string u8* int) int))

(define passVal (ftype-ref PASSVAL_T () (make-ftype-pointer PASSVAL_T "passVal")))

(define srcInt 100)
(define dstInt (make-ftype-pointer int (foreign-alloc (ftype-sizeof int))))
(ftype-set! int ()  dstInt 200)

(define srcStr "some test string")
(define dstStrLen 8)
(define dstStr (make-bytevector (+ 1 dstStrLen) 0)) 

(printf"before passVal/ srcInt=~a, dstInt=~a, srcStr=~a, dstStr=~a\n" 
        srcInt (ftype-ref int ()  dstInt) srcStr (utf8->string dstStr))

(passVal srcInt dstInt srcStr dstStr dstStrLen)

(printf"after passVal/ srcInt=~a, dstInt=~a, srcStr=~a, dstStr=~a\n"
	srcInt (ftype-ref int () dstInt) srcStr (utf8->string dstStr))

(define-ftype info
    (struct
      (name (* char))
      (ostype (array 128 char))
      (addr (array 4 long))
      (cb long)
      (age int)))

(define getInfo (foreign-procedure "getInfo" ((* info)) int))

(define ti (make-ftype-pointer info (foreign-alloc (ftype-sizeof info))))

(define strdup (foreign-procedure "strdup" (string) (* char)))

(define (char*->string fptr)
  (utf8->string
   (apply bytevector
      (reverse
       (let loop ([i 0] [acc '()])
         (let ([c (char->integer (ftype-ref char () fptr i))])
           (if (zero? c)
	       acc
	       (loop (+ i 1) (cons c acc)))))))))

(define (charArr->string ti)
  (utf8->string
   (apply bytevector
      (reverse
       (let loop ([i 0] [acc '()])
         (let ([c (char->integer (ftype-ref info (ostype i) ti))])
           (if (zero? c)
	       acc
	       (loop (+ i 1) (cons c acc)))))))))

(define (string->charArr str ti)
    (define len (string-length str))
    (let loop ((i 0))
        (if (< i len)
            (begin (ftype-set! info (ostype i) ti (string-ref str i))
                (loop (+ 1 i)))))
    (ftype-set! info (ostype len) ti #\nul))

(define x 12)
(define my-cb (lambda (x)
               (printf "my-cb/ x=~a\n" x)))

(ftype-set! info (name) ti (strdup "helen"))
(ftype-set! info (age) ti 18)
(string->charArr "windows" ti)

(ftype-set! info (addr 0) ti 13)
(ftype-set! info (addr 1) ti 77)
(ftype-set! info (addr 2) ti 133)
(ftype-set! info (addr 3) ti 87)

(define callback
   (lambda (p)
        (let ([code (foreign-callable p (int) void)])
               (lock-object code)
               (foreign-callable-entry-point code))))

(ftype-set! info (cb) ti (callback  my-cb))

(getInfo ti)

(printf "info/ name=~a, ostype=~a, addr=[~a,~a,~a,~a] age=~d\n"
        (char*->string (ftype-ref info (name) ti))
	(charArr->string ti)
        (ftype-ref info (addr 0) ti) (ftype-ref info (addr 1) ti) (ftype-ref info (addr 2) ti) (ftype-ref info (addr 3) ti)
        (ftype-ref info (age) ti))

