;; Vault V2 Contract
;; Simple locked vault

(define-data-var locked bool false)
(define-data-var balance uint u0)

(define-public (deposit (amt uint))
  (begin
    (try! (stx-transfer? amt tx-sender (as-contract tx-sender)))
    (var-set balance (+ (var-get balance) amt))
    (ok amt)
  )
)

(define-public (lock)
  (ok (var-set locked true))
)

(define-read-only (get-vault)
  (ok {locked: (var-get locked), balance: (var-get balance)})
)
