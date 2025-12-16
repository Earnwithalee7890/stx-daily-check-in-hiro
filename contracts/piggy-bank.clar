;; Piggy Bank Contract
;; Save and withdraw STX

(define-data-var savings uint u0)

(define-public (deposit (amount uint))
  (begin
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    (var-set savings (+ (var-get savings) amount))
    (ok amount)
  )
)

(define-public (withdraw)
  (let ((bal (var-get savings)))
    (try! (as-contract (stx-transfer? bal tx-sender tx-sender)))
    (var-set savings u0)
    (ok bal)
  )
)

(define-read-only (get-savings)
  (ok (var-get savings))
)
