;; title: access-guard
;; summary: Basic role-based access control guard.

(define-map roles principal (string-ascii 10))

(define-public (assign-role (user principal) (role (string-ascii 10)))
    (begin
        (map-set roles user role)
        (ok true)
    )
)

(define-read-only (has-role (user principal) (role (string-ascii 10)))
    (ok (is-eq (default-to "" (map-get? roles user)) role))
)
