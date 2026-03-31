;; identity-verifier contract

(define-constant contract-owner tx-sender)

(define-map verified-users principal { verified: bool, verifier: principal })

(define-read-only (is-verified (user principal))
  (default-to false (get verified (map-get? verified-users user)))
)

(define-public (verify-user (user principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u1))
    (map-set verified-users user { verified: true, verifier: tx-sender })
    (ok true)
  )
)

(define-public (revoke-verification (user principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u1))
    (map-delete verified-users user)
    (ok true)
  )
)
