;; certification-registry contract

(define-constant contract-owner tx-sender)

(define-map certifications { user: principal, cert-id: (string-ascii 32) } { issued: bool, issuer: principal })

(define-read-only (is-certified (user principal) (cert-id (string-ascii 32)))
  (default-to false (get issued (map-get? certifications { user: user, cert-id: cert-id })))
)

(define-public (issue-certificate (user principal) (cert-id (string-ascii 32)))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u1))
    (map-set certifications { user: user, cert-id: cert-id } { issued: true, issuer: tx-sender })
    (ok true)
  )
)

(define-public (revoke-certificate (user principal) (cert-id (string-ascii 32)))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u1))
    (map-delete certifications { user: user, cert-id: cert-id })
    (ok true)
  )
)
