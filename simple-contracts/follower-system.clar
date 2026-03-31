;; Follower System Contract
;; On-chain social following

(define-map following
    { follower: principal, following: principal }
    { since: uint }
)

(define-map follower-count principal uint)
(define-map following-count principal uint)

(define-read-only (is-following (follower principal) (target principal))
    (is-some (map-get? following { follower: follower, following: target }))
)

(define-read-only (get-follower-count (user principal))
    (default-to u0 (map-get? follower-count user))
)

(define-read-only (get-following-count (user principal))
    (default-to u0 (map-get? following-count user))
)

(define-public (follow (target principal))
    (begin
        (asserts! (not (is-eq tx-sender target)) (err u1))
        (asserts! (not (is-following tx-sender target)) (err u2))
        (map-set following 
            { follower: tx-sender, following: target }
            { since: block-height }
        )
        (map-set follower-count target (+ (get-follower-count target) u1))
        (map-set following-count tx-sender (+ (get-following-count tx-sender) u1))
        (ok true)
    )
)

(define-public (unfollow (target principal))
    (begin
        (asserts! (is-following tx-sender target) (err u3))
        (map-delete following { follower: tx-sender, following: target })
        (map-set follower-count target (- (get-follower-count target) u1))
        (map-set following-count tx-sender (- (get-following-count tx-sender) u1))
        (ok true)
    )
)
