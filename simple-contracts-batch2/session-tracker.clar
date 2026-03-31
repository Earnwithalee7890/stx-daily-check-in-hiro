;; session-tracker contract

(define-map sessions principal { session-count: uint, last-session: uint })

(define-read-only (get-session-info (user principal))
  (map-get? sessions user)
)

(define-public (start-session (session-id uint))
  (let ((current (map-get? sessions tx-sender)))
    (match current
      existing (map-set sessions tx-sender 
        { session-count: (+ (get session-count existing) u1), last-session: session-id })
      (map-set sessions tx-sender { session-count: u1, last-session: session-id })
    )
    (ok session-id)
  )
)
