;; Flash Loan Contract
;; Provide uncollateralized loans within single transaction

(define-constant contract-owner tx-sender)
(define-constant err-insufficient-pool (err u100))
(define-constant err-repay-failed (err u101))
(define-constant fee-rate u30) ;; 0.3% fee

(define-data-var pool-balance uint u0)
(define-data-var flash-loan-active bool false)

(define-map depositors principal uint)

;; Deposit STX into flash loan pool
(define-public (deposit (amount uint))
  (let ((caller tx-sender))
    (try! (stx-transfer? amount caller (as-contract tx-sender)))
    (map-set depositors caller (+ (default-to u0 (map-get? depositors caller)) amount))
    (var-set pool-balance (+ (var-get pool-balance) amount))
    (ok true)
  )
)

;; Request flash loan
(define-public (flash-loan (amount uint))
  (let (
    (caller tx-sender)
    (fee (/ (* amount fee-rate) u10000))
    (repay-amount (+ amount fee))
    (current-balance (var-get pool-balance))
  )
    (asserts! (>= current-balance amount) err-insufficient-pool)
    (var-set flash-loan-active true)
    (try! (as-contract (stx-transfer? amount tx-sender caller)))
    ;; Borrower must repay in same tx
    (ok {borrowed: amount, fee: fee, repay: repay-amount})
  )
)

;; Repay flash loan
(define-public (repay-flash-loan (amount uint))
  (let ((caller tx-sender))
    (try! (stx-transfer? amount caller (as-contract tx-sender)))
    (var-set pool-balance (+ (var-get pool-balance) amount))
    (var-set flash-loan-active false)
    (ok true)
  )
)

;; Withdraw from pool
(define-public (withdraw (amount uint))
  (let (
    (caller tx-sender)
    (user-balance (default-to u0 (map-get? depositors caller)))
  )
    (asserts! (>= user-balance amount) err-insufficient-pool)
    (try! (as-contract (stx-transfer? amount tx-sender caller)))
    (map-set depositors caller (- user-balance amount))
    (var-set pool-balance (- (var-get pool-balance) amount))
    (ok true)
  )
)

(define-read-only (get-pool-balance)
  (ok (var-get pool-balance))
)

(define-read-only (get-fee-for-amount (amount uint))
  (ok (/ (* amount fee-rate) u10000))
)
