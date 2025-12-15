;; Post Condition Guard Contract
;; Asset protection using post-conditions

(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))
(define-constant err-limit-exceeded (err u101))
(define-constant err-paused (err u102))

(define-data-var max-transfer-amount uint u10000000000) ;; 10K STX
(define-data-var daily-limit uint u50000000000) ;; 50K STX
(define-data-var is-paused bool false)

(define-map daily-spent principal uint)
(define-map last-reset-block principal uint)
(define-map whitelisted principal bool)

;; Protected transfer with limits
(define-public (protected-transfer (amount uint) (recipient principal))
  (let (
    (caller tx-sender)
    (today-spent (get-today-spent caller))
  )
    (asserts! (not (var-get is-paused)) err-paused)
    (asserts! (<= amount (var-get max-transfer-amount)) err-limit-exceeded)
    (asserts! (<= (+ today-spent amount) (var-get daily-limit)) err-limit-exceeded)
    ;; Update daily spending
    (maybe-reset-daily caller)
    (map-set daily-spent caller (+ today-spent amount))
    ;; Execute transfer
    (try! (stx-transfer? amount caller recipient))
    (print {event: "protected-transfer", from: caller, to: recipient, amount: amount})
    (ok true)
  )
)

;; Check and reset daily limit
(define-private (maybe-reset-daily (user principal))
  (let (
    (last-reset (default-to u0 (map-get? last-reset-block user)))
    (blocks-since-reset (- stacks-block-height last-reset))
  )
    (if (> blocks-since-reset u144) ;; ~1 day
      (begin
        (map-set daily-spent user u0)
        (map-set last-reset-block user stacks-block-height)
        true
      )
      false
    )
  )
)

;; Get today's spending
(define-private (get-today-spent (user principal))
  (let (
    (last-reset (default-to u0 (map-get? last-reset-block user)))
    (blocks-since-reset (- stacks-block-height last-reset))
  )
    (if (> blocks-since-reset u144)
      u0
      (default-to u0 (map-get? daily-spent user))
    )
  )
)

;; Admin functions
(define-public (set-max-transfer (amount uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (ok (var-set max-transfer-amount amount))
  )
)

(define-public (set-daily-limit (amount uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (ok (var-set daily-limit amount))
  )
)

(define-public (pause-contract)
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (ok (var-set is-paused true))
  )
)

(define-public (unpause-contract)
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (ok (var-set is-paused false))
  )
)

(define-read-only (get-limits)
  (ok {
    max-transfer: (var-get max-transfer-amount),
    daily-limit: (var-get daily-limit),
    paused: (var-get is-paused)
  })
)

(define-read-only (get-remaining-daily (user principal))
  (ok (- (var-get daily-limit) (get-today-spent user)))
)
