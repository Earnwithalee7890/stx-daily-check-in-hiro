;; Whitelist Contract
;; Simple whitelist manager

(define-map whitelist principal bool)
(define-data-var owner principal tx-sender)

(define-public (add-to-whitelist (user principal))
  (ok (map-set whitelist user true))
)

(define-public (remove-from-whitelist (user principal))
  (ok (map-delete whitelist user))
)

(define-read-only (is-whitelisted (user principal))
  (ok (default-to false (map-get? whitelist user)))
)
