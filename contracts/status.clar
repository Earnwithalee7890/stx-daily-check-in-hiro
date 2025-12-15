;; Status Contract
;; User status updates

(define-map statuses principal (string-ascii 50))

(define-public (set-status (status (string-ascii 50)))
  (ok (map-set statuses tx-sender status))
)

(define-read-only (get-status (user principal))
  (ok (map-get? statuses user))
)
