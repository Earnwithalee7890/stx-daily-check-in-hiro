;; Governance Token Contract
;; Token with snapshot-based governance

(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))
(define-constant err-insufficient (err u101))

(define-fungible-token gov-token)

(define-data-var snapshot-nonce uint u0)

(define-map balances principal uint)
(define-map snapshots uint {block-height: uint, total-supply: uint})
(define-map balance-at-snapshot {user: principal, snapshot-id: uint} uint)

;; Mint governance tokens
(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (try! (ft-mint? gov-token amount recipient))
    (map-set balances recipient (+ (default-to u0 (map-get? balances recipient)) amount))
    (ok true)
  )
)

;; Transfer tokens
(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) err-unauthorized)
    (try! (ft-transfer? gov-token amount sender recipient))
    (map-set balances sender (- (default-to u0 (map-get? balances sender)) amount))
    (map-set balances recipient (+ (default-to u0 (map-get? balances recipient)) amount))
    (ok true)
  )
)

;; Create snapshot for governance voting
(define-public (create-snapshot)
  (let ((snapshot-id (var-get snapshot-nonce)))
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (map-set snapshots snapshot-id {
      block-height: stacks-block-height,
      total-supply: (ft-get-supply gov-token)
    })
    (var-set snapshot-nonce (+ snapshot-id u1))
    (ok snapshot-id)
  )
)

;; Record user balance at snapshot
(define-public (record-balance-at-snapshot (snapshot-id uint))
  (let (
    (caller tx-sender)
    (current-balance (ft-get-balance gov-token caller))
  )
    (ok (map-set balance-at-snapshot {user: caller, snapshot-id: snapshot-id} current-balance))
  )
)

(define-read-only (get-balance (user principal))
  (ok (ft-get-balance gov-token user))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply gov-token))
)

(define-read-only (get-snapshot (snapshot-id uint))
  (ok (map-get? snapshots snapshot-id))
)

(define-read-only (get-balance-at-snapshot (user principal) (snapshot-id uint))
  (ok (default-to u0 (map-get? balance-at-snapshot {user: user, snapshot-id: snapshot-id})))
)
