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
	 (age int)))

(define getInfo (foreign-procedure "getInfo" ((* info)) int))

(define ti (make-ftype-pointer info (foreign-alloc (ftype-sizeof info))))

(define strdup (foreign-procedure "strdup" (string) (* char)))
(ftype-set! info (name) ti (strdup "helen"))

(getInfo ti)

(printf "info/ age=~d\n"  (ftype-ref info (age) ti))
