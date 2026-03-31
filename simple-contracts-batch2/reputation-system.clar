;; reputation-system contract

(define-map reputation principal uint)

(define-read-only (get-reputation (user principal))
  (default-to u0 (map-get? reputation user))
)

(define-public (add-reputation (user principal) (points uint))
  (begin
    (map-set reputation user (+ (get-reputation user) points))
    (ok (get-reputation user))
  )
)

(define-public (subtract-reputation (user principal) (points uint))
  (let ((current (get-reputation user)))
    (if (>= current points)
      (begin
        (map-set reputation user (- current points))
        (ok (get-reputation user))
      )
      (err u1)
    )
  )
)
