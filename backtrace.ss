#! /usr/bin/scheme --program

(import (chezscheme))
(import (some utility work))
(import (some utility log))

(define tag "mytest")

(slog tag "main/ begin")
(fn1 100)
(fn1 50)
(slog tag "main/ end")
