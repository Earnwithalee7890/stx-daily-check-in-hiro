;; Liquidity Pool Contract
;; Simple AMM-style liquidity pool

(define-constant contract-owner tx-sender)
(define-constant err-zero-amount (err u100))
(define-constant err-insufficient-liquidity (err u101))

(define-data-var reserve-stx uint u0)
(define-data-var reserve-token uint u0)
(define-data-var total-lp-tokens uint u0)

(define-map lp-balances principal uint)

;; Add liquidity to pool
(define-public (add-liquidity (stx-amount uint) (token-amount uint))
  (let (
    (caller tx-sender)
    (lp-tokens (if (is-eq (var-get total-lp-tokens) u0)
      stx-amount
      (/ (* stx-amount (var-get total-lp-tokens)) (var-get reserve-stx))
    ))
  )
    (asserts! (> stx-amount u0) err-zero-amount)
    (try! (stx-transfer? stx-amount caller (as-contract tx-sender)))
    (var-set reserve-stx (+ (var-get reserve-stx) stx-amount))
    (var-set reserve-token (+ (var-get reserve-token) token-amount))
    (var-set total-lp-tokens (+ (var-get total-lp-tokens) lp-tokens))
    (map-set lp-balances caller (+ (default-to u0 (map-get? lp-balances caller)) lp-tokens))
    (ok lp-tokens)
  )
)

;; Remove liquidity from pool
(define-public (remove-liquidity (lp-amount uint))
  (let (
    (caller tx-sender)
    (user-lp (default-to u0 (map-get? lp-balances caller)))
    (stx-out (/ (* lp-amount (var-get reserve-stx)) (var-get total-lp-tokens)))
    (token-out (/ (* lp-amount (var-get reserve-token)) (var-get total-lp-tokens)))
  )
    (asserts! (>= user-lp lp-amount) err-insufficient-liquidity)
    (try! (as-contract (stx-transfer? stx-out tx-sender caller)))
    (var-set reserve-stx (- (var-get reserve-stx) stx-out))
    (var-set reserve-token (- (var-get reserve-token) token-out))
    (var-set total-lp-tokens (- (var-get total-lp-tokens) lp-amount))
    (map-set lp-balances caller (- user-lp lp-amount))
    (ok {stx: stx-out, token: token-out})
  )
)

;; Swap STX for tokens
(define-public (swap-stx-for-token (stx-in uint))
  (let (
    (token-out (get-amount-out stx-in (var-get reserve-stx) (var-get reserve-token)))
  )
    (try! (stx-transfer? stx-in tx-sender (as-contract tx-sender)))
    (var-set reserve-stx (+ (var-get reserve-stx) stx-in))
    (var-set reserve-token (- (var-get reserve-token) token-out))
    (ok token-out)
  )
)

;; Calculate output amount (constant product formula)
(define-private (get-amount-out (amount-in uint) (reserve-in uint) (reserve-out uint))
  (let (
    (amount-in-with-fee (* amount-in u997))
    (numerator (* amount-in-with-fee reserve-out))
    (denominator (+ (* reserve-in u1000) amount-in-with-fee))
  )
    (/ numerator denominator)
  )
)

(define-read-only (get-reserves)
  (ok {stx: (var-get reserve-stx), token: (var-get reserve-token)})
)

(define-read-only (get-lp-balance (user principal))
  (ok (default-to u0 (map-get? lp-balances user)))
)
