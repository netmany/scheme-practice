(library (some utility log)
	(export slog print-stack-trace)
    (import (chezscheme))

	(define (slog tag msg)
		(define d (current-date))
		(printf "~a: ~a(~a): ~a\n"
			(format "~2,'0d-~2,'0d ~2,'0d:~2,'0d:~2,'0d.~3,'0d"
			         (date-month d) (date-day d)
				 (date-hour d) (date-minute d) (date-second d) (div (date-nanosecond d) 1000000))
			tag (get-process-id) msg))

    (define (source-info func file line)
        (format "\tat ~a (~a:~a)"
            (if func func "--main--")
            file
            line))

	(define (print-stack-trace tag obj max-depth)
		(call/cc (lambda (k)
			(slog tag (format "backtrace of [~a] as following:" obj))
			(let loop ((cur (inspect/object k)) (i 0))
			     (if (and (> (cur 'depth) 1) (< i max-depth))
			         (begin
				        (call-with-values
				    	    (lambda () (cur 'source-path))
					        (case-lambda
						        ((file line char) (slog tag (source-info ((cur 'code) 'name) file line)))
						        ((file line) (slog tag (source-info ((cur 'code) 'name) file line)))
						        (else (k)))) 
				        (loop (cur 'link) (+ i 1))))))))

)

