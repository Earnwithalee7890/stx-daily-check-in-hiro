;; checkin-rewards contract
;; Users check in separately, then claim rewards

(define-map checkins principal { total-checkins: uint, last-checkin-day: uint })
(define-map rewards principal uint)
(define-map claimed-rewards principal uint)

(define-constant REWARD_PER_CHECKIN u10)

;; Read-only functions
(define-read-only (get-checkin-stats (user principal))
  (default-to { total-checkins: u0, last-checkin-day: u0 } (map-get? checkins user))
)

(define-read-only (get-unclaimed-rewards (user principal))
  (let (
    (total-rewards (default-to u0 (map-get? rewards user)))
    (claimed (default-to u0 (map-get? claimed-rewards user)))
  )
    (- total-rewards claimed)
  )
)

(define-read-only (get-total-checkins (user principal))
  (get total-checkins (get-checkin-stats user))
)

;; Public functions
(define-public (daily-checkin (day uint))
  (let (
    (stats (get-checkin-stats tx-sender))
    (new-total (+ (get total-checkins stats) u1))
    (reward-amount (* new-total REWARD_PER_CHECKIN))
  )
    ;; Prevent double check-in same day
    (asserts! (not (is-eq (get last-checkin-day stats) day)) (err u1))
    
    ;; Update checkin stats
    (map-set checkins tx-sender { total-checkins: new-total, last-checkin-day: day })
    
    ;; Update reward balance
    (map-set rewards tx-sender (+ (default-to u0 (map-get? rewards tx-sender)) REWARD_PER_CHECKIN))
    
    (ok new-total)
  )
)

(define-public (claim-rewards)
  (let (
    (unclaimed (get-unclaimed-rewards tx-sender))
  )
    (asserts! (> unclaimed u0) (err u2))
    
    ;; Mark rewards as claimed
    (map-set claimed-rewards tx-sender 
      (+ (default-to u0 (map-get? claimed-rewards tx-sender)) unclaimed))
    
    (ok unclaimed)
  )
)

(define-public (get-my-stats)
  (ok {
    checkins: (get-total-checkins tx-sender),
    unclaimed: (get-unclaimed-rewards tx-sender),
    claimed: (default-to u0 (map-get? claimed-rewards tx-sender))
  })
)
