;; Toggle Contract
;; Simple on/off toggle

(define-data-var enabled bool false)

(define-public (toggle)
  (ok (var-set enabled (not (var-get enabled))))
)

(define-read-only (is-enabled)
  (ok (var-get enabled))
)
