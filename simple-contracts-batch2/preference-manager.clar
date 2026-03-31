;; preference-manager contract

(define-map preferences { user: principal, key: (string-ascii 32) } (string-utf8 200))

(define-read-only (get-preference (user principal) (key (string-ascii 32)))
  (map-get? preferences { user: user, key: key })
)

(define-public (set-preference (key (string-ascii 32)) (value (string-utf8 200)))
  (begin
    (map-set preferences { user: tx-sender, key: key } value)
    (ok true)
  )
)

(define-public (delete-preference (key (string-ascii 32)))
  (begin
    (map-delete preferences { user: tx-sender, key: key })
    (ok true)
  )
)
