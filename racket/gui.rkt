 #lang racket
 
(require racket/gui/base)
 
; ; Make a frame by instantiating the frame% class
; (define frame (new frame% [label "Example"]))
 
; ; Make a static text message in the frame
; (define msg (new message% [parent frame]
;                           [label "No events so far..."]))
 
; ; Make a button in the frame
; (new button% [parent frame]
;              [label "Click Me"]
;              ; Callback procedure for a button click:
;              [callback (lambda (button event)
;                          (send msg set-label "Button click"))])
 
; ; Show the frame by calling its show method
; (send frame show #t)

; (define frame (new frame%
;                    [label "Example"]
;                    [width 300]
;                    [height 300]))
; (new canvas% [parent frame]
;              [paint-callback
;               (lambda (canvas dc)
;                 (send dc set-scale 3 3)
;                 (send dc set-text-foreground "blue")
;                 (send dc draw-text "Don't Panic!" 0 0))])
; (send frame show #t)

; Create a dialog
(define dialog (instantiate dialog% ("Example")))
 
; Add a text field to the dialog
(new text-field% [parent dialog] [label "Your name"])
 
; Add a horizontal panel to the dialog, with centering for buttons
(define panel (new horizontal-panel% [parent dialog]
                                     [alignment '(center center)]))
 
; Add Cancel and Ok buttons to the horizontal panel
(new button% [parent panel] [label "Cancel"])
(new button% [parent panel] [label "Ok"])
(when (system-position-ok-before-cancel?)
  (send panel change-children reverse))
 
; Show the dialog
(send dialog show #t)
