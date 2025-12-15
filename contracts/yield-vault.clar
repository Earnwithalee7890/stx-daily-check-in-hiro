;; Yield Vault Contract
;; Auto-compounding yield vault

(define-constant contract-owner tx-sender)
(define-constant err-no-deposit (err u100))
(define-constant err-insufficient (err u101))

(define-data-var total-shares uint u0)
(define-data-var total-assets uint u0)
(define-data-var last-harvest-block uint u0)
(define-data-var yield-per-block uint u1) ;; 1 microSTX per block per 1M

(define-map shares principal uint)

;; Deposit and receive vault shares
(define-public (deposit (amount uint))
  (let (
    (caller tx-sender)
    (share-amount (if (is-eq (var-get total-shares) u0)
      amount
      (/ (* amount (var-get total-shares)) (var-get total-assets))
    ))
  )
    (try! (stx-transfer? amount caller (as-contract tx-sender)))
    (map-set shares caller (+ (default-to u0 (map-get? shares caller)) share-amount))
    (var-set total-shares (+ (var-get total-shares) share-amount))
    (var-set total-assets (+ (var-get total-assets) amount))
    (ok share-amount)
  )
)

;; Withdraw assets by burning shares
(define-public (withdraw (share-amount uint))
  (let (
    (caller tx-sender)
    (user-shares (default-to u0 (map-get? shares caller)))
    (asset-amount (/ (* share-amount (var-get total-assets)) (var-get total-shares)))
  )
    (asserts! (>= user-shares share-amount) err-insufficient)
    (try! (as-contract (stx-transfer? asset-amount tx-sender caller)))
    (map-set shares caller (- user-shares share-amount))
    (var-set total-shares (- (var-get total-shares) share-amount))
    (var-set total-assets (- (var-get total-assets) asset-amount))
    (ok asset-amount)
  )
)

;; Harvest yields and compound
(define-public (harvest)
  (let (
    (blocks-elapsed (- stacks-block-height (var-get last-harvest-block)))
    (yield-earned (/ (* (var-get total-assets) (var-get yield-per-block) blocks-elapsed) u1000000))
  )
    (var-set total-assets (+ (var-get total-assets) yield-earned))
    (var-set last-harvest-block stacks-block-height)
    (ok yield-earned)
  )
)

(define-read-only (get-share-balance (user principal))
  (ok (default-to u0 (map-get? shares user)))
)

(define-read-only (get-asset-value (user principal))
  (let ((user-shares (default-to u0 (map-get? shares user))))
    (if (is-eq (var-get total-shares) u0)
      (ok u0)
      (ok (/ (* user-shares (var-get total-assets)) (var-get total-shares)))
    )
  )
)

(define-read-only (get-price-per-share)
  (if (is-eq (var-get total-shares) u0)
    (ok u1000000)
    (ok (/ (* (var-get total-assets) u1000000) (var-get total-shares)))
  )
)
