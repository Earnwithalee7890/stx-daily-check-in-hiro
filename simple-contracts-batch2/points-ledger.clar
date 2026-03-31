;; points-ledger contract

(define-map points principal uint)
(define-map point-history { user: principal, tx-id: uint } { amount: uint, action: (string-ascii 32) })
(define-map user-tx-count principal uint)

(define-read-only (get-points (user principal))
  (default-to u0 (map-get? points user))
)

(define-public (add-points (amount uint) (action (string-ascii 32)))
  (let ((tx-id (+ (default-to u0 (map-get? user-tx-count tx-sender)) u1)))
    (map-set points tx-sender (+ (get-points tx-sender) amount))
    (map-set point-history { user: tx-sender, tx-id: tx-id } { amount: amount, action: action })
    (map-set user-tx-count tx-sender tx-id)
    (ok (get-points tx-sender))
  )
)

(define-public (spend-points (amount uint))
  (let ((current (get-points tx-sender)))
    (asserts! (>= current amount) (err u1))
    (map-set points tx-sender (- current amount))
    (ok (get-points tx-sender))
  )
)
