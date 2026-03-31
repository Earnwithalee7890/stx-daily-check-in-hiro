;; Split Royalty - Clarity 4
;; Automatic royalty splitting among multiple recipients

(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u900))
(define-constant err-split-not-found (err u901))
(define-constant err-invalid-shares (err u902))
(define-constant err-not-recipient (err u903))

(define-data-var split-counter uint u0)

(define-map splits
    uint
    {
        name: (string-ascii 64),
        creator: principal,
        total-received: uint,
        recipient-count: uint,
        active: bool
    }
)

(define-map split-recipients
    { split-id: uint, index: uint }
    { recipient: principal, share: uint }
)

(define-map recipient-balances
    { split-id: uint, recipient: principal }
    uint
)

(define-read-only (get-split (split-id uint))
    (map-get? splits split-id)
)

(define-read-only (get-recipient (split-id uint) (index uint))
    (map-get? split-recipients { split-id: split-id, index: index })
)

(define-read-only (get-balance (split-id uint) (recipient principal))
    (default-to u0 (map-get? recipient-balances { split-id: split-id, recipient: recipient }))
)

(define-public (create-split (name (string-ascii 64)) (recipients (list 10 principal)) (shares (list 10 uint)))
    (let (
        (split-id (+ (var-get split-counter) u1))
        (recipient-count (len recipients))
    )
        (map-set splits split-id {
            name: name,
            creator: tx-sender,
            total-received: u0,
            recipient-count: recipient-count,
            active: true
        })
        (var-set split-counter split-id)
        (ok split-id)
    )
)

(define-public (add-recipient (split-id uint) (index uint) (recipient principal) (share uint))
    (let (
        (split (unwrap! (map-get? splits split-id) err-split-not-found))
    )
        (asserts! (is-eq tx-sender (get creator split)) err-not-owner)
        (ok (map-set split-recipients { split-id: split-id, index: index } { recipient: recipient, share: share }))
    )
)

(define-public (deposit (split-id uint) (amount uint))
    (let (
        (split (unwrap! (map-get? splits split-id) err-split-not-found))
    )
        (asserts! (get active split) err-split-not-found)
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (ok (map-set splits split-id (merge split { total-received: (+ (get total-received split) amount) })))
    )
)

(define-public (distribute (split-id uint) (index uint) (amount uint))
    (let (
        (split (unwrap! (map-get? splits split-id) err-split-not-found))
        (recipient-data (unwrap! (map-get? split-recipients { split-id: split-id, index: index }) err-not-recipient))
        (recipient (get recipient recipient-data))
        (share (get share recipient-data))
        (payout (/ (* amount share) u1000))
        (current-balance (get-balance split-id recipient))
    )
        (asserts! (is-eq tx-sender (get creator split)) err-not-owner)
        (ok (map-set recipient-balances { split-id: split-id, recipient: recipient } (+ current-balance payout)))
    )
)

(define-public (withdraw (split-id uint))
    (let (
        (balance (get-balance split-id tx-sender))
        (caller tx-sender)
    )
        (asserts! (> balance u0) err-not-recipient)
        (map-set recipient-balances { split-id: split-id, recipient: tx-sender } u0)
        (try! (as-contract (stx-transfer? balance tx-sender caller)))
        (ok balance)
    )
)

(define-public (deactivate-split (split-id uint))
    (let (
        (split (unwrap! (map-get? splits split-id) err-split-not-found))
    )
        (asserts! (is-eq tx-sender (get creator split)) err-not-owner)
        (ok (map-set splits split-id (merge split { active: false })))
    )
)
