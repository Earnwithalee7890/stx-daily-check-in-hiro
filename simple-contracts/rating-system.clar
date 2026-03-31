;; Rating System Contract
;; Rate and review on-chain

(define-map ratings
    { rater: principal, target: principal }
    { score: uint, comment: (string-utf8 200), rated-at: uint }
)

(define-map rating-stats
    principal
    { total-score: uint, count: uint }
)

(define-read-only (get-rating (rater principal) (target principal))
    (map-get? ratings { rater: rater, target: target })
)

(define-read-only (get-stats (target principal))
    (default-to { total-score: u0, count: u0 } (map-get? rating-stats target))
)

(define-read-only (get-average (target principal))
    (let (
        (stats (get-stats target))
    )
        (if (> (get count stats) u0)
            (/ (get total-score stats) (get count stats))
            u0
        )
    )
)

(define-public (rate (target principal) (score uint) (comment (string-utf8 200)))
    (let (
        (stats (get-stats target))
        (existing (map-get? ratings { rater: tx-sender, target: target }))
    )
        (asserts! (not (is-eq tx-sender target)) (err u1))
        (asserts! (and (>= score u1) (<= score u5)) (err u2))
        (map-set ratings
            { rater: tx-sender, target: target }
            { score: score, comment: comment, rated-at: block-height }
        )
        (match existing
            prev-rating 
                (map-set rating-stats target {
                    total-score: (+ (- (get total-score stats) (get score prev-rating)) score),
                    count: (get count stats)
                })
            (map-set rating-stats target {
                total-score: (+ (get total-score stats) score),
                count: (+ (get count stats) u1)
            })
        )
        (ok true)
    )
)

(define-public (delete-rating (target principal))
    (match (map-get? ratings { rater: tx-sender, target: target })
        rating (let (
            (stats (get-stats target))
        )
            (map-delete ratings { rater: tx-sender, target: target })
            (map-set rating-stats target {
                total-score: (- (get total-score stats) (get score rating)),
                count: (- (get count stats) u1)
            })
            (ok true)
        )
        (err u3)
    )
)
