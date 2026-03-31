;; subscription-manager contract

(define-map subscriptions principal { tier: uint, active: bool })

(define-read-only (get-subscription (user principal))
  (map-get? subscriptions user)
)

(define-read-only (is-subscribed (user principal))
  (default-to false (get active (map-get? subscriptions user)))
)

(define-public (subscribe (tier uint))
  (begin
    (map-set subscriptions tx-sender { tier: tier, active: true })
    (ok tier)
  )
)

(define-public (cancel-subscription)
  (begin
    (map-delete subscriptions tx-sender)
    (ok true)
  )
)
