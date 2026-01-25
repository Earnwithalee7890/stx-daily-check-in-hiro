
;; Contract 12: Simple Constants
(define-constant err-custom (err u404))

(define-public (trigger-error)
    err-custom
)

(define-read-only (is-ok)
    (ok true)
)
