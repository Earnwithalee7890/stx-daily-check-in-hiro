;; Escrow Dispute - Clarity 4
;; Escrow with built-in dispute resolution

(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u700))
(define-constant err-not-party (err u701))
(define-constant err-escrow-not-found (err u702))
(define-constant err-already-resolved (err u703))
(define-constant err-no-dispute (err u704))
(define-constant err-not-arbiter (err u705))

(define-data-var escrow-counter uint u0)
(define-data-var arbiter-fee uint u30) ;; 3% in basis points

(define-map arbiters principal bool)
(define-map escrows
    uint
    {
        buyer: principal,
        seller: principal,
        amount: uint,
        status: (string-ascii 20),
        dispute-reason: (string-ascii 256),
        created-at: uint
    }
)

;; Initialize owner as arbiter
(map-set arbiters tx-sender true)

(define-read-only (get-escrow (escrow-id uint))
    (map-get? escrows escrow-id)
)

(define-read-only (is-arbiter (addr principal))
    (default-to false (map-get? arbiters addr))
)

(define-public (add-arbiter (new-arbiter principal))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-not-owner)
        (ok (map-set arbiters new-arbiter true))
    )
)

(define-public (create-escrow (seller principal) (amount uint))
    (let (
        (escrow-id (+ (var-get escrow-counter) u1))
    )
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (map-set escrows escrow-id {
            buyer: tx-sender,
            seller: seller,
            amount: amount,
            status: "active",
            dispute-reason: "",
            created-at: block-height
        })
        (var-set escrow-counter escrow-id)
        (ok escrow-id)
    )
)

(define-public (release-to-seller (escrow-id uint))
    (let (
        (escrow (unwrap! (map-get? escrows escrow-id) err-escrow-not-found))
    )
        (asserts! (is-eq tx-sender (get buyer escrow)) err-not-party)
        (asserts! (is-eq (get status escrow) "active") err-already-resolved)
        (try! (as-contract (stx-transfer? (get amount escrow) tx-sender (get seller escrow))))
        (ok (map-set escrows escrow-id (merge escrow { status: "completed" })))
    )
)

(define-public (open-dispute (escrow-id uint) (reason (string-ascii 256)))
    (let (
        (escrow (unwrap! (map-get? escrows escrow-id) err-escrow-not-found))
    )
        (asserts! (or (is-eq tx-sender (get buyer escrow)) (is-eq tx-sender (get seller escrow))) err-not-party)
        (asserts! (is-eq (get status escrow) "active") err-already-resolved)
        (ok (map-set escrows escrow-id (merge escrow { status: "disputed", dispute-reason: reason })))
    )
)

(define-public (resolve-dispute (escrow-id uint) (favor-buyer bool))
    (let (
        (escrow (unwrap! (map-get? escrows escrow-id) err-escrow-not-found))
        (amount (get amount escrow))
        (fee (/ (* amount (var-get arbiter-fee)) u1000))
        (payout (- amount fee))
        (recipient (if favor-buyer (get buyer escrow) (get seller escrow)))
    )
        (asserts! (is-arbiter tx-sender) err-not-arbiter)
        (asserts! (is-eq (get status escrow) "disputed") err-no-dispute)
        (try! (as-contract (stx-transfer? payout tx-sender recipient)))
        (try! (as-contract (stx-transfer? fee tx-sender contract-owner)))
        (ok (map-set escrows escrow-id (merge escrow { status: "resolved" })))
    )
)

(define-public (refund-buyer (escrow-id uint))
    (let (
        (escrow (unwrap! (map-get? escrows escrow-id) err-escrow-not-found))
    )
        (asserts! (is-eq tx-sender (get seller escrow)) err-not-party)
        (asserts! (is-eq (get status escrow) "active") err-already-resolved)
        (try! (as-contract (stx-transfer? (get amount escrow) tx-sender (get buyer escrow))))
        (ok (map-set escrows escrow-id (merge escrow { status: "refunded" })))
    )
)
