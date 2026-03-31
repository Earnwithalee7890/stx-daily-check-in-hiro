;; permission-registry contract

(define-constant contract-owner tx-sender)

(define-map permissions { user: principal, permission: (string-ascii 32) } bool)

(define-read-only (has-permission (user principal) (permission (string-ascii 32)))
  (default-to false (map-get? permissions { user: user, permission: permission }))
)

(define-public (grant-permission (user principal) (permission (string-ascii 32)))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u1))
    (map-set permissions { user: user, permission: permission } true)
    (ok true)
  )
)

(define-public (revoke-permission (user principal) (permission (string-ascii 32)))
  (begin
    (asserts! (is-eq tx-sender contract-owner) (err u1))
    (map-delete permissions { user: user, permission: permission })
    (ok true)
  )
)
