;; title: builder-profile-registry
;; summary: Registry for builder profiles and metadata.

(define-constant version "1.1.0")
(define-constant contract-owner tx-sender)

(define-map profiles principal { 
    name: (string-ascii 24), 
    bio: (string-ascii 100),
    updated-at: uint 
})

(define-public (set-profile (name (string-ascii 24)) (bio (string-ascii 100)))
    (begin
        (map-set profiles tx-sender { 
            name: name, 
            bio: bio, 
            updated-at: stacks-block-height 
        })
        (print { event: "profile-update", user: tx-sender, name: name })
        (ok true)
    )
)

(define-read-only (get-profile (user principal))
    (map-get? profiles user)
)

(define-read-only (get-version)
    (ok version)
)

(define-read-only (get-contract-metadata)
    (ok {
        name: "Builder Profile Registry",
        version: version,
        description: "Official registry for Stacks Builder Profiles",
        author: contract-owner
    })
)
