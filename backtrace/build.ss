; disable optimization for calling code line number tracing

(parameterize ([optimize-level 0]
               [compile-imported-libraries #t]
               [run-cp0 (lambda (cp0 x) x)])
      (compile-program "./bt.ss" "./bt.so"))
