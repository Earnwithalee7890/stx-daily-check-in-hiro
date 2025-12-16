;; Flag Contract
;; Simple feature flags

(define-map flags (string-ascii 20) bool)

(define-public (set-flag (name (string-ascii 20)) (val bool))
  (ok (map-set flags name val))
)

(define-read-only (get-flag (name (string-ascii 20)))
  (ok (default-to false (map-get? flags name)))
)
