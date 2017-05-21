; number? boolean? char? string? symbol?
(number? 12.3)

; + - * / div mod floor ceiling max min
; flonum->fixnum fixnum->flonum
; cos sin tan exp log expt
; = > < char=? char>? char<? string>? string<? string=? symbol=?
; and or not boolean=?
; char->integer integer->char
; string->number number->string symbol->string string->symbol format
; string-ref string-set! string-length string-append string substring

; pair? list? vector? hashtable?
; cons car cdr set-car! set-cdr! 
; length list-ref list append 
; vector make-vector vector-ref vector-set! vector-length
; make-eq-hashtable hashtable-set! hashtable-ref hashtable-delete! hashtable-keys
; list->vector vector->list

; procedure?
; lambda if let let* letrec begin case cond define set!
; apply map call/cc values call-with-values eval exit

; directory-list current-directory 
; file-exist? file-size file-regular?
; delete-file delete-directory mkdir rename-file chmod get-mode
; path-first path-rest

; system time load getenv
; get-thread-id fork-thread thread? 
; process get-process-id
; sleep current-time time<? current-date

; library import export
