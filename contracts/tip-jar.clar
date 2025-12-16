;; Tip Jar Contract
;; Simple tipping system

(define-data-var owner principal tx-sender)
(define-data-var total-tips uint u0)

(define-public (tip (amount uint))
  (begin
    (try! (stx-transfer? amount tx-sender (var-get owner)))
    (var-set total-tips (+ (var-get total-tips) amount))
    (ok amount)
  )
)

(define-read-only (get-tips)
  (ok (var-get total-tips))
)
