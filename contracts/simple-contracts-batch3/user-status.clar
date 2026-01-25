
;; Contract 3: Status Storage
(define-map user-status principal (string-ascii 20))

(define-public (set-status (status (string-ascii 20)))
    (ok (map-set user-status tx-sender status))
)

(define-read-only (get-status (user principal))
    (ok (map-get? user-status user))
)
