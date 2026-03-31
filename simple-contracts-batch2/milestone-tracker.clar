;; milestone-tracker contract

(define-map milestones { user: principal, milestone-id: uint } { reached: bool, progress: uint })

(define-read-only (get-milestone (user principal) (milestone-id uint))
  (map-get? milestones { user: user, milestone-id: milestone-id })
)

(define-public (reach-milestone (milestone-id uint))
  (begin
    (map-set milestones { user: tx-sender, milestone-id: milestone-id } { reached: true, progress: u100 })
    (ok true)
  )
)

(define-public (update-milestone-progress (milestone-id uint) (progress uint))
  (begin
    (map-set milestones { user: tx-sender, milestone-id: milestone-id } { reached: false, progress: progress })
    (ok progress)
  )
)
