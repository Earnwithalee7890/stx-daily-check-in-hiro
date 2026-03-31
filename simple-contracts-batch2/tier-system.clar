;; tier-system contract

(define-map user-tiers principal uint)

(define-read-only (get-tier (user principal))
  (default-to u1 (map-get? user-tiers user))
)

(define-public (upgrade-tier)
  (let ((current-tier (get-tier tx-sender)))
    (map-set user-tiers tx-sender (+ current-tier u1))
    (ok (get-tier tx-sender))
  )
)

(define-public (set-tier (tier uint))
  (begin
    (asserts! (<= tier u10) (err u1))
    (map-set user-tiers tx-sender tier)
    (ok tier)
  )
)
