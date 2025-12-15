;; Registry Contract
;; Simple key-value registry

(define-map registry (string-ascii 20) (string-ascii 50))

(define-public (register (key (string-ascii 20)) (val (string-ascii 50)))
  (ok (map-set registry key val))
)

(define-read-only (lookup (key (string-ascii 20)))
  (ok (map-get? registry key))
)
