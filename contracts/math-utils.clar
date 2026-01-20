;; title: math-utils
;; summary: Basic math utility functions for Clarity contracts.

(define-read-only (add (a uint) (b uint))
    (ok (+ a b))
)

(define-read-only (sub (a uint) (b uint))
    (if (>= a b)
        (ok (- a b))
        (err u400)
    )
)

(define-read-only (mul (a uint) (b uint))
    (ok (* a b))
)

(define-read-only (div (a uint) (b uint))
    (if (> b u0)
        (ok (/ a b))
        (err u400)
    )
)
