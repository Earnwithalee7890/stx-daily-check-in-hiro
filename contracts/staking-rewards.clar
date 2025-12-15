;; Staking Rewards Contract
;; Stake STX to earn rewards over time

(define-constant contract-owner tx-sender)
(define-constant err-no-stake (err u100))
(define-constant err-too-early (err u101))

(define-data-var reward-rate uint u10) ;; 10 tokens per block
(define-data-var min-stake-blocks uint u144) ;; ~1 day

(define-map stakers principal {amount: uint, start-block: uint, rewards-claimed: uint})

;; Stake STX tokens
(define-public (stake (amount uint))
  (let ((caller tx-sender))
    (try! (stx-transfer? amount caller (as-contract tx-sender)))
    (map-set stakers caller {
      amount: (+ amount (get amount (default-to {amount: u0, start-block: u0, rewards-claimed: u0} (map-get? stakers caller)))),
      start-block: stacks-block-height,
      rewards-claimed: u0
    })
    (ok true)
  )
)

;; Claim accumulated rewards
(define-public (claim-rewards)
  (let (
    (caller tx-sender)
    (stake-info (unwrap! (map-get? stakers caller) err-no-stake))
    (blocks-staked (- stacks-block-height (get start-block stake-info)))
    (pending-rewards (/ (* (get amount stake-info) blocks-staked (var-get reward-rate)) u1000000))
  )
    (asserts! (>= blocks-staked (var-get min-stake-blocks)) err-too-early)
    (map-set stakers caller (merge stake-info {rewards-claimed: (+ (get rewards-claimed stake-info) pending-rewards)}))
    (ok pending-rewards)
  )
)

;; Unstake tokens
(define-public (unstake)
  (let (
    (caller tx-sender)
    (stake-info (unwrap! (map-get? stakers caller) err-no-stake))
  )
    (try! (as-contract (stx-transfer? (get amount stake-info) tx-sender caller)))
    (map-delete stakers caller)
    (ok (get amount stake-info))
  )
)

(define-read-only (get-stake-info (user principal))
  (ok (map-get? stakers user))
)

(define-read-only (get-pending-rewards (user principal))
  (match (map-get? stakers user)
    stake-info (ok (/ (* (get amount stake-info) (- stacks-block-height (get start-block stake-info)) (var-get reward-rate)) u1000000))
    (ok u0)
  )
)
