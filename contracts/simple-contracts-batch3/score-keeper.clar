
;; Contract 8: Score Keeper
(define-map scores principal uint)

(define-public (set-score (score uint))
    (ok (map-set scores tx-sender score))
)

(define-read-only (get-my-score)
    (ok (default-to u0 (map-get? scores tx-sender)))
)
