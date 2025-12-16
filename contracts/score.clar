;; Score Contract
;; Simple score tracker

(define-map scores principal uint)

(define-public (add-score (points uint))
  (ok (map-set scores tx-sender (+ (get-score tx-sender) points)))
)

(define-read-only (get-score (user principal))
  (default-to u0 (map-get? scores user))
)
