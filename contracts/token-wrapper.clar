;; Token Wrapper Contract
;; Wrap and unwrap tokens for cross-contract use

(define-constant contract-owner tx-sender)
(define-constant err-insufficient-balance (err u100))
(define-constant err-unauthorized (err u101))

(define-fungible-token wrapped-stx)

(define-data-var total-wrapped uint u0)

(define-map wrapped-balances principal uint)

;; Wrap STX into wrapped tokens
(define-public (wrap (amount uint))
  (let ((caller tx-sender))
    (try! (stx-transfer? amount caller (as-contract tx-sender)))
    (try! (ft-mint? wrapped-stx amount caller))
    (map-set wrapped-balances caller (+ (default-to u0 (map-get? wrapped-balances caller)) amount))
    (var-set total-wrapped (+ (var-get total-wrapped) amount))
    (ok amount)
  )
)

;; Unwrap tokens back to STX
(define-public (unwrap (amount uint))
  (let (
    (caller tx-sender)
    (balance (default-to u0 (map-get? wrapped-balances caller)))
  )
    (asserts! (>= balance amount) err-insufficient-balance)
    (try! (ft-burn? wrapped-stx amount caller))
    (try! (as-contract (stx-transfer? amount tx-sender caller)))
    (map-set wrapped-balances caller (- balance amount))
    (var-set total-wrapped (- (var-get total-wrapped) amount))
    (ok amount)
  )
)

;; Transfer wrapped tokens
(define-public (transfer-wrapped (amount uint) (recipient principal))
  (let ((caller tx-sender))
    (try! (ft-transfer? wrapped-stx amount caller recipient))
    (map-set wrapped-balances caller (- (default-to u0 (map-get? wrapped-balances caller)) amount))
    (map-set wrapped-balances recipient (+ (default-to u0 (map-get? wrapped-balances recipient)) amount))
    (ok true)
  )
)

(define-read-only (get-wrapped-balance (user principal))
  (ok (ft-get-balance wrapped-stx user))
)

(define-read-only (get-total-wrapped)
  (ok (var-get total-wrapped))
)
