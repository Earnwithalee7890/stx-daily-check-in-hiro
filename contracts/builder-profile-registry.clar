;; title: builder-profile-registry
;; summary: Registry for builder profiles and metadata.

(define-map profiles principal { name: (string-ascii 24), bio: (string-ascii 100) })

(define-public (set-profile (name (string-ascii 24)) (bio (string-ascii 100)))
    (begin
        (map-set profiles tx-sender { name: name, bio: bio })
        (ok true)
    )
)

(define-read-only (get-profile (user principal))
    (map-get? profiles user)
)
