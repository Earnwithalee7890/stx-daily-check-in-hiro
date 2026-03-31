;; attendance-tracker contract

(define-map attendance { user: principal, day: uint } bool)
(define-map total-days principal uint)

(define-read-only (was-present (user principal) (day uint))
  (default-to false (map-get? attendance { user: user, day: day }))
)

(define-read-only (get-total-days (user principal))
  (default-to u0 (map-get? total-days user))
)

(define-public (mark-attendance (day uint))
  (begin
    (map-set attendance { user: tx-sender, day: day } true)
    (map-set total-days tx-sender (+ (get-total-days tx-sender) u1))
    (ok (get-total-days tx-sender))
  )
)
