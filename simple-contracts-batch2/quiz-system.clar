;; quiz-system contract

(define-map quiz-scores { user: principal, quiz-id: uint } { score: uint, attempts: uint })

(define-read-only (get-score (user principal) (quiz-id uint))
  (map-get? quiz-scores { user: user, quiz-id: quiz-id })
)

(define-public (submit-score (quiz-id uint) (score uint))
  (let ((current (map-get? quiz-scores { user: tx-sender, quiz-id: quiz-id })))
    (match current
      existing (map-set quiz-scores { user: tx-sender, quiz-id: quiz-id } 
        { score: score, attempts: (+ (get attempts existing) u1) })
      (map-set quiz-scores { user: tx-sender, quiz-id: quiz-id } 
        { score: score, attempts: u1 })
    )
    (ok score)
  )
)
