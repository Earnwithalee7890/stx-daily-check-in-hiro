
;; Contract 14: Milestone Tracker
(define-data-var milestone uint u0)

(define-public (reach-milestone)
    (begin
        (var-set milestone (+ (var-get milestone) u1))
        (ok (var-get milestone))
    )
)
