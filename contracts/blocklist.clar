;; Blocklist Contract
;; Simple blocklist manager

(define-map blocked principal bool)

(define-public (block-user (user principal))
  (ok (map-set blocked user true))
)

(define-public (unblock-user (user principal))
  (ok (map-delete blocked user))
)

(define-read-only (is-blocked (user principal))
  (ok (default-to false (map-get? blocked user)))
)
