;; achievement-tracker contract

(define-map achievements { user: principal, achievement-id: uint } { unlocked: bool, progress: uint })

(define-read-only (is-unlocked (user principal) (achievement-id uint))
  (default-to false (get unlocked (map-get? achievements { user: user, achievement-id: achievement-id })))
)

(define-public (unlock-achievement (achievement-id uint))
  (begin
    (map-set achievements { user: tx-sender, achievement-id: achievement-id } { unlocked: true, progress: u100 })
    (ok true)
  )
)

(define-public (update-progress (achievement-id uint) (progress uint))
  (begin
    (map-set achievements { user: tx-sender, achievement-id: achievement-id } { unlocked: false, progress: progress })
    (ok progress)
  )
)
