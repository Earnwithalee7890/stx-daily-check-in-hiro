;; Greeting Contract
;; Store and read greetings

(define-map greetings principal (string-ascii 50))

(define-public (set-greeting (msg (string-ascii 50)))
  (ok (map-set greetings tx-sender msg))
)

(define-read-only (get-greeting (user principal))
  (ok (map-get? greetings user))
)
