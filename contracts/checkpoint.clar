;; Checkpoint Contract
;; Record block checkpoints

(define-data-var last-checkpoint uint u0)
(define-data-var checkpoint-count uint u0)

(define-public (checkpoint)
  (begin
    (var-set last-checkpoint stacks-block-height)
    (var-set checkpoint-count (+ (var-get checkpoint-count) u1))
    (ok stacks-block-height)
  )
)

(define-read-only (get-checkpoint)
  (ok (var-get last-checkpoint))
)
