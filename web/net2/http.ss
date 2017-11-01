(define (trim s)
   (let p ((first -1) (last -1) (i 0))
     (if (< i (string-length s))
         (if (char-whitespace? (string-ref s i))
             (p first last (+ 1 i))
             (p (if (< first 0) i first) i (+ 1 i)))
         (if (< -1 first last)
             (substring s first (+ 1 last))
             ""))))

(define (split s)
  (define len (string-length s))
  (if (= len 0)
      '()
       (if (char=? #\space (string-ref s 0))
           (split (substring s 1 len))
           (let p ((i 1))
             (if (= i len)
                 (list s)
                 (if (char=? #\space (string-ref s i))
                     (cons (substring s 0 i) (split (substring s i len)))
                     (p (+ 1 i))))))))

(define (get-line f max-len)
    (let p ((i 0)
            (ln '()))
        (let ((c (get-u8 f)))
           (if (< i max-len)
               (if (or (eof-object? c) (char=? #\newline (integer->char c)))
                   ln
                   (p (+ 1 i) (append ln (list c))))
               'too-long))))

(define (read-line f max-len)
    (define res (get-line f max-len))
    (if (symbol? res)
      res
      (list->string (map integer->char res))))
(define-syntax try
   (syntax-rules ()
    ((_ expr handler)
     (call/cc
      (lambda (k)
        (with-exception-handler
          (lambda (e) (k (handler e)))
          (lambda () expr)))))))

(define (split-field s)
  (define len (string-length s))
  (try 
    (let p ((i 0))
        (if (char=? #\: (string-ref s i))
            (list (substring s 0 i)
                  (substring s (+ 1 i) len))
            (p (+ 1 i))))
    (lambda (e)
        e)))

(define (parse-field s)
  (define kv (split-field s))
  (if (list? kv)
      (let ((key (trim (car kv)))
            (val (trim (cadr kv))))
        (if (or (string=? "" key)
                (string=? "" val))
            'bad-field
            (list key val)))
      'bad-field))

(define (read-fields f m)
    (let p ((fields '())
            (z m))
        (let ((cl (read-line f z)))
          (if (symbol? cl)
              cl
              (if (string=? "" cl)
                  fields
                  (let ((cur-max (- z (+ 1 (string-length cl))))
                        (kv (parse-field cl)))
                    (if (list? kv)
                        (p (append fields (list kv))
                           cur-max)
                        'bad-field)))))))

(define f (open-file-input-port "http.p"))

(define max-header (* 8 1024))
(define header-line (read-line f max-header))
(define start-line (split header-line))
(define header-fields (read-fields f (- max-header (+ 1 (string-length header-line)))))
(define message-body (utf8->string (get-bytevector-all f)))

(printf "http parse result: \nstart-line:\n~a \nheader-fields:\n~a \nmessage-body:\n~a\n"
        start-line header-fields message-body)

(close-port f)
