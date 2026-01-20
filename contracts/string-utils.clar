;; title: string-utils
;; summary: Basic string utility placeholders and helpers.

(define-read-only (is-valid-name (name (string-ascii 24)))
    (ok (> (len name) u0))
)

(define-read-only (concat-example (a (string-ascii 10)) (b (string-ascii 10)))
    (ok a) ;; Clarity 2+ would use string-concat, placeholder for now
)
