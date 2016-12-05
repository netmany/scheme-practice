(library (some utility work)
	(export fn1 fn2)
    (import (chezscheme)
    	(some utility log))
    
    (define tag "mywork")

    (define (fn1 x)
      (slog tag (format "fn1/ x=~a" x))
      (fn2 x)
      (slog tag "fn1/ end"))

    (define (fn2 x)
      (slog tag (format "fn2/ x=~a" x))
      (fn3 x)
      (slog tag "fn2/ end"))

    (define (fn3 x)
      (slog tag (format "fn3/ x=~a" x))
      (print-stack-trace tag "some-wrong" 10)
      (slog tag "fn3/ end"))

)
