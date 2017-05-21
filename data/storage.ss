; read/write object from/to structured file (cat file)
(define f (open-output-file "~/explore/jobs/data_structured" '(truncate)))
(write (list 134 3.453-4i 234.63 #\k "some wrong" #f (list "inner info" 34 -45.25 #t 23423.23462)) f)
(close-port f)

(define f (open-input-file "~/explore/jobs/data_structured"))
(define t (read f))
(eof-object? t)
(list-ref (list-ref t 5) 2)
(close-port f)

; read/write line from/to unstructured file (cat file)
(define f (open-output-file "jobs/data_unstructured" '(truncate)))
(fprintf f "first line of work.\n")
(fprintf f "second line\t: name=~a.\n" "jeffry")
(close-port f)

(define f (open-input-file "jobs/data_unstructured"))
(define cur (get-line f))
(string-length cur)
(string-ref cur 0)
(substring cur 2 4)
(set! cur (get-line f))
(close-port f)

; read/write line from/to binary file (xxd binary_file)
(define f (open-file-output-port "~/explore/jobs/data_binary"))
(define buf (make-bytevector 10))
(bytevector-u8-set! buf 0 #x1c)
(bytevector-u8-set! buf 1 #x0d)
(bytevector-u8-set! buf 4 #xfd)
(bytevector-u8-set! buf 8 #xac)
(put-bytevector f buf 0 4)
(put-bytevector f buf)
(put-bytevector f buf)
(put-bytevector f buf)
(close-port f)

(define f (open-file-input-port "~/explore/jobs/data_binary"))
(define len (get-bytevector-n! f  buf 0 (bytevector-length buf)))
(set! len (get-bytevector-n! f  buf 0 (bytevector-length buf)))
(close-port f)

; ascii char to/from number
(char->integer c)
(integer->char i)

; command line i/o
(command-line)
(standard-input-port)
(standard-output-port)
(standard-error-port)
; current-input-port current-output-port current-error-port

