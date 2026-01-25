
;; Contract 10: Like Button
(define-data-var likes uint u0)

(define-public (like)
    (ok (var-set likes (+ (var-get likes) u1)))
)

(define-read-only (get-likes)
    (ok (var-get likes))
)
