;; inventory-system contract

(define-map inventory { user: principal, item-id: uint } uint)

(define-read-only (get-quantity (user principal) (item-id uint))
  (default-to u0 (map-get? inventory { user: user, item-id: item-id }))
)

(define-public (add-item (item-id uint) (quantity uint))
  (begin
    (map-set inventory { user: tx-sender, item-id: item-id } 
      (+ (get-quantity tx-sender item-id) quantity))
    (ok (get-quantity tx-sender item-id))
  )
)

(define-public (remove-item (item-id uint) (quantity uint))
  (let ((current (get-quantity tx-sender item-id)))
    (asserts! (>= current quantity) (err u1))
    (map-set inventory { user: tx-sender, item-id: item-id } (- current quantity))
    (ok (get-quantity tx-sender item-id))
  )
)
