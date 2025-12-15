;; Badge Contract
;; Simple achievement badges

(define-map badges principal bool)
(define-data-var badge-count uint u0)

(define-public (claim-badge)
  (begin
    (map-set badges tx-sender true)
    (var-set badge-count (+ (var-get badge-count) u1))
    (ok true)
  )
)

(define-read-only (has-badge (user principal))
  (ok (default-to false (map-get? badges user)))
)
