
;; Contract 18: Math Adder
(define-read-only (add (a uint) (b uint))
    (ok (+ a b))
)

(define-read-only (double (a uint))
    (ok (* a u2))
)
