; common utils in shell

; cd, ls, pwd, mkdir, rmdir
(current-directory)
(directory-list path)
(current-directory path)
(make-directory path)
(make-directory* path)
(delete-directory path)
(delete-file path)

; cp, rm, mv
(copy-directory/files src dst)
(copy-file src dest)
(delete-directory/files path)
(rename-file-or-directory old new)

; test file or dir
(file-exists? path)
(directory-exists? path)
(link-exists? path)
(file-size path)

; path operation basename, dirname, suffix
(require racket/path)
(file-name-from-path path)
(filename-extension path)
(path-only path)

; read and write file: cat, echo
(with-output-to-file "test.log"
    (lambda () (printf "hello world\n")))

(with-input-from-file "test.log"
    (lambda ()
        (let t ((line (read-line)))
            (when (not (eof-object? line))
                (display line)
                (newline)
                (t (read-line))))))

(read-char in)

; command line arguments
(current-command-line-arguments)

; environment vars
(getenv "path")
(putenv name value)
(environment-variables-names (current-environment-variables))

; time and date
(require racket/date)
(current-date)
(date-month (current-date))
(current-milliseconds)
(current-seconds)
(time body)
(sleep 3)

; execute external cmds
(require racket/system)
(system "ipconfig /all")

; performance test
(define (make-random-input)
    (define len (+ 1 (* 2 (random 1000000))))
    (define input (make-vector len))
    (let loop ((i 0))
        (when (< i len)
            (vector-set! input i (random 100000))
            (loop (+ i 1))))
    input)
