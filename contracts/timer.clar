;; Timer Contract
;; Block-based timer

(define-data-var start-block uint u0)
(define-data-var running bool false)

(define-public (start-timer)
  (begin
    (var-set start-block stacks-block-height)
    (var-set running true)
    (ok true)
  )
)

(define-public (stop-timer)
  (ok (var-set running false))
)

(define-read-only (elapsed)
  (ok (- stacks-block-height (var-get start-block)))
)
