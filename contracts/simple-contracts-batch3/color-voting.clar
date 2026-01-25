
;; Contract 7: Color Vote
(define-map votes (string-ascii 10) uint)

(define-public (vote-color (color (string-ascii 10)))
    (let ((current-votes (default-to u0 (map-get? votes color))))
        (ok (map-set votes color (+ current-votes u1)))
    )
)

(define-read-only (get-votes (color (string-ascii 10)))
    (ok (default-to u0 (map-get? votes color)))
)
