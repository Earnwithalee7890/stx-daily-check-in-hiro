;; Token Vesting Contract
;; Time-locked token vesting schedules

(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u100))
(define-constant err-no-schedule (err u101))
(define-constant err-already-claimed (err u102))
(define-constant err-not-vested (err u103))

(define-data-var vesting-nonce uint u0)

(define-map vesting-schedules uint {
  beneficiary: principal,
  total-amount: uint,
  start-block: uint,
  cliff-blocks: uint,
  vesting-blocks: uint,
  claimed: uint
})

(define-map beneficiary-schedules principal (list 10 uint))

;; Create vesting schedule
(define-public (create-schedule 
  (beneficiary principal) 
  (amount uint) 
  (cliff-blocks uint) 
  (vesting-blocks uint))
  (let (
    (schedule-id (var-get vesting-nonce))
  )
    (asserts! (is-eq tx-sender contract-owner) err-not-owner)
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    (map-set vesting-schedules schedule-id {
      beneficiary: beneficiary,
      total-amount: amount,
      start-block: stacks-block-height,
      cliff-blocks: cliff-blocks,
      vesting-blocks: vesting-blocks,
      claimed: u0
    })
    (var-set vesting-nonce (+ schedule-id u1))
    (ok schedule-id)
  )
)

;; Claim vested tokens
(define-public (claim (schedule-id uint))
  (let (
    (schedule (unwrap! (map-get? vesting-schedules schedule-id) err-no-schedule))
    (caller tx-sender)
    (vested (get-vested-amount schedule-id))
    (claimable (- vested (get claimed schedule)))
  )
    (asserts! (is-eq caller (get beneficiary schedule)) err-not-owner)
    (asserts! (> claimable u0) err-not-vested)
    (try! (as-contract (stx-transfer? claimable tx-sender caller)))
    (map-set vesting-schedules schedule-id (merge schedule {claimed: vested}))
    (ok claimable)
  )
)

;; Calculate vested amount
(define-private (get-vested-amount (schedule-id uint))
  (match (map-get? vesting-schedules schedule-id)
    schedule 
    (let (
      (elapsed (- stacks-block-height (get start-block schedule)))
      (cliff (get cliff-blocks schedule))
    )
      (if (< elapsed cliff)
        u0
        (let ((vesting-elapsed (- elapsed cliff)))
          (if (>= vesting-elapsed (get vesting-blocks schedule))
            (get total-amount schedule)
            (/ (* (get total-amount schedule) vesting-elapsed) (get vesting-blocks schedule))
          )
        )
      )
    )
    u0
  )
)

(define-read-only (get-schedule (schedule-id uint))
  (ok (map-get? vesting-schedules schedule-id))
)

(define-read-only (get-claimable (schedule-id uint))
  (match (map-get? vesting-schedules schedule-id)
    schedule (ok (- (get-vested-amount schedule-id) (get claimed schedule)))
    (ok u0)
  )
)
