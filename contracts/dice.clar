;; Dice Contract
;; Simple random dice roll

(define-data-var last-roll uint u0)

(define-public (roll-dice)
  (let ((roll (+ (mod stacks-block-height u6) u1)))
    (var-set last-roll roll)
    (ok roll)
  )
)

(define-read-only (get-last-roll)
  (ok (var-get last-roll))
)
