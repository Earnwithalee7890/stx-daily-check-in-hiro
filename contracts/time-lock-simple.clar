;; title: time-lock-simple
;; summary: Simple time-locking utility for builder funds.

(define-map locks principal uint)

(define-public (lock-until (height uint))
    (begin
        (map-set locks tx-sender height)
        (ok true)
    )
)

(define-read-only (get-lock-height (user principal))
    (default-to u0 (map-get? locks user))
)
