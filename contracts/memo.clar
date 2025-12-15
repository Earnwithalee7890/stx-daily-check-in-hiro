;; Memo Contract
;; Public memo board

(define-data-var memo (string-utf8 100) u"Welcome!")
(define-data-var last-author principal tx-sender)

(define-public (write-memo (text (string-utf8 100)))
  (begin
    (var-set memo text)
    (var-set last-author tx-sender)
    (ok true)
  )
)

(define-read-only (read-memo)
  (ok (var-get memo))
)
