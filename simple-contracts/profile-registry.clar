;; Profile Registry Contract
;; Store user profiles on-chain

(define-map profiles
    principal
    { 
        name: (string-ascii 50), 
        bio: (string-utf8 160), 
        created-at: uint 
    }
)

(define-map username-to-principal
    (string-ascii 50)
    principal
)

(define-read-only (get-profile (user principal))
    (map-get? profiles user)
)

(define-read-only (get-user-by-name (name (string-ascii 50)))
    (map-get? username-to-principal name)
)

(define-read-only (has-profile (user principal))
    (is-some (map-get? profiles user))
)

(define-public (create-profile (name (string-ascii 50)) (bio (string-utf8 160)))
    (begin
        (asserts! (is-none (map-get? profiles tx-sender)) (err u1))
        (asserts! (is-none (map-get? username-to-principal name)) (err u2))
        (map-set profiles tx-sender { 
            name: name, 
            bio: bio, 
            created-at: block-height 
        })
        (map-set username-to-principal name tx-sender)
        (ok true)
    )
)

(define-public (update-bio (bio (string-utf8 160)))
    (match (map-get? profiles tx-sender)
        profile (begin
            (map-set profiles tx-sender (merge profile { bio: bio }))
            (ok true)
        )
        (err u3)
    )
)
