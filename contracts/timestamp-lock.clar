;; Timestamp Lock Contract
;; Time-locked transactions using block height

(define-constant contract-owner tx-sender)
(define-constant err-not-unlocked (err u100))
(define-constant err-already-claimed (err u101))
(define-constant err-unauthorized (err u102))
(define-constant err-not-found (err u103))

(define-data-var lock-nonce uint u0)

(define-map time-locks uint {
  owner: principal,
  beneficiary: principal,
  amount: uint,
  unlock-block: uint,
  claimed: bool
})

;; Create time-locked STX
(define-public (create-lock (beneficiary principal) (amount uint) (lock-blocks uint))
  (let (
    (lock-id (var-get lock-nonce))
    (unlock-at (+ stacks-block-height lock-blocks))
  )
    (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
    (map-set time-locks lock-id {
      owner: tx-sender,
      beneficiary: beneficiary,
      amount: amount,
      unlock-block: unlock-at,
      claimed: false
    })
    (var-set lock-nonce (+ lock-id u1))
    (print {event: "lock-created", id: lock-id, unlock-at: unlock-at})
    (ok lock-id)
  )
)

;; Claim unlocked STX
(define-public (claim (lock-id uint))
  (let (
    (lock (unwrap! (map-get? time-locks lock-id) err-not-found))
  )
    (asserts! (is-eq tx-sender (get beneficiary lock)) err-unauthorized)
    (asserts! (>= stacks-block-height (get unlock-block lock)) err-not-unlocked)
    (asserts! (not (get claimed lock)) err-already-claimed)
    (try! (as-contract (stx-transfer? (get amount lock) tx-sender (get beneficiary lock))))
    (map-set time-locks lock-id (merge lock {claimed: true}))
    (print {event: "lock-claimed", id: lock-id})
    (ok (get amount lock))
  )
)

;; Cancel lock (owner only, before unlock)
(define-public (cancel-lock (lock-id uint))
  (let (
    (lock (unwrap! (map-get? time-locks lock-id) err-not-found))
  )
    (asserts! (is-eq tx-sender (get owner lock)) err-unauthorized)
    (asserts! (< stacks-block-height (get unlock-block lock)) err-not-unlocked)
    (asserts! (not (get claimed lock)) err-already-claimed)
    (try! (as-contract (stx-transfer? (get amount lock) tx-sender (get owner lock))))
    (map-set time-locks lock-id (merge lock {claimed: true}))
    (ok true)
  )
)

(define-read-only (get-lock (lock-id uint))
  (ok (map-get? time-locks lock-id))
)

(define-read-only (is-unlocked (lock-id uint))
  (match (map-get? time-locks lock-id)
    lock (ok (>= stacks-block-height (get unlock-block lock)))
    (ok false)
  )
)

(define-read-only (blocks-until-unlock (lock-id uint))
  (match (map-get? time-locks lock-id)
    lock (if (>= stacks-block-height (get unlock-block lock))
      (ok u0)
      (ok (- (get unlock-block lock) stacks-block-height))
    )
    (ok u0)
  )
)
