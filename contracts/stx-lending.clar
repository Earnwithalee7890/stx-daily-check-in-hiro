;; STX Lending Contract
;; A simple lending pool for STX tokens

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-insufficient-balance (err u101))
(define-constant err-no-deposit (err u102))

(define-data-var total-deposits uint u0)
(define-data-var interest-rate uint u5) ;; 5% APY

(define-map user-deposits principal uint)
(define-map deposit-block principal uint)

;; Deposit STX into lending pool
(define-public (deposit (amount uint))
  (let ((caller tx-sender))
    (try! (stx-transfer? amount caller (as-contract tx-sender)))
    (map-set user-deposits caller (+ (default-to u0 (map-get? user-deposits caller)) amount))
    (map-set deposit-block caller stacks-block-height)
    (var-set total-deposits (+ (var-get total-deposits) amount))
    (ok amount)
  )
)

;; Withdraw STX with interest
(define-public (withdraw (amount uint))
  (let (
    (caller tx-sender)
    (balance (default-to u0 (map-get? user-deposits caller)))
    (interest (calculate-interest caller))
  )
    (asserts! (>= balance amount) err-insufficient-balance)
    (try! (as-contract (stx-transfer? (+ amount interest) tx-sender caller)))
    (map-set user-deposits caller (- balance amount))
    (ok (+ amount interest))
  )
)

;; Calculate accrued interest
(define-private (calculate-interest (user principal))
  (let (
    (deposit-height (default-to stacks-block-height (map-get? deposit-block user)))
    (blocks-elapsed (- stacks-block-height deposit-height))
    (balance (default-to u0 (map-get? user-deposits user)))
  )
    (/ (* balance (var-get interest-rate) blocks-elapsed) (* u100 u52560))
  )
)

(define-read-only (get-balance (user principal))
  (ok (default-to u0 (map-get? user-deposits user)))
)

(define-read-only (get-total-deposits)
  (ok (var-get total-deposits))
)
