;; wishlist-manager contract

(define-map wishlist { user: principal, item-id: uint } { name: (string-utf8 100), added: bool })

(define-read-only (is-in-wishlist (user principal) (item-id uint))
  (default-to false (get added (map-get? wishlist { user: user, item-id: item-id })))
)

(define-public (add-to-wishlist (item-id uint) (name (string-utf8 100)))
  (begin
    (map-set wishlist { user: tx-sender, item-id: item-id } { name: name, added: true })
    (ok true)
  )
)

(define-public (remove-from-wishlist (item-id uint))
  (begin
    (map-delete wishlist { user: tx-sender, item-id: item-id })
    (ok true)
  )
)
