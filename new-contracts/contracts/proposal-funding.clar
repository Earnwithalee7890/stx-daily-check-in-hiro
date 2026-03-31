;; Proposal Funding - Clarity 4
;; Community-driven proposal funding with quadratic voting

(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u600))
(define-constant err-proposal-not-found (err u601))
(define-constant err-already-voted (err u602))
(define-constant err-round-ended (err u603))
(define-constant err-round-active (err u604))

(define-data-var proposal-counter uint u0)
(define-data-var round-counter uint u0)
(define-data-var current-round-end uint u0)
(define-data-var matching-pool uint u0)

(define-map proposals
    uint
    {
        creator: principal,
        title: (string-ascii 64),
        description: (string-ascii 256),
        round-id: uint,
        votes: uint,
        funding: uint,
        contributors: uint
    }
)

(define-map contributions
    { proposal-id: uint, contributor: principal }
    uint
)

(define-read-only (get-proposal (proposal-id uint))
    (map-get? proposals proposal-id)
)

(define-read-only (get-contribution (proposal-id uint) (contributor principal))
    (default-to u0 (map-get? contributions { proposal-id: proposal-id, contributor: contributor }))
)

(define-read-only (is-round-active)
    (> (var-get current-round-end) block-height)
)

(define-read-only (get-matching-pool)
    (var-get matching-pool)
)

(define-public (start-round (duration-blocks uint))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-not-owner)
        (asserts! (not (is-round-active)) err-round-active)
        (var-set round-counter (+ (var-get round-counter) u1))
        (var-set current-round-end (+ block-height duration-blocks))
        (ok (var-get round-counter))
    )
)

(define-public (fund-matching-pool (amount uint))
    (begin
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (var-set matching-pool (+ (var-get matching-pool) amount))
        (ok true)
    )
)

(define-public (create-proposal (title (string-ascii 64)) (description (string-ascii 256)))
    (let (
        (proposal-id (+ (var-get proposal-counter) u1))
    )
        (asserts! (is-round-active) err-round-ended)
        (map-set proposals proposal-id {
            creator: tx-sender,
            title: title,
            description: description,
            round-id: (var-get round-counter),
            votes: u0,
            funding: u0,
            contributors: u0
        })
        (var-set proposal-counter proposal-id)
        (ok proposal-id)
    )
)

(define-public (contribute (proposal-id uint) (amount uint))
    (let (
        (proposal (unwrap! (map-get? proposals proposal-id) err-proposal-not-found))
        (existing (get-contribution proposal-id tx-sender))
    )
        (asserts! (is-round-active) err-round-ended)
        (try! (stx-transfer? amount tx-sender (as-contract tx-sender)))
        (map-set contributions { proposal-id: proposal-id, contributor: tx-sender } (+ existing amount))
        (map-set proposals proposal-id
            (merge proposal {
                funding: (+ (get funding proposal) amount),
                contributors: (if (is-eq existing u0)
                    (+ (get contributors proposal) u1)
                    (get contributors proposal)
                ),
                votes: (+ (get votes proposal) (/ amount u1000000))
            })
        )
        (ok true)
    )
)

(define-public (distribute-matching (proposal-id uint))
    (let (
        (proposal (unwrap! (map-get? proposals proposal-id) err-proposal-not-found))
        (creator (get creator proposal))
        (total-funding (get funding proposal))
    )
        (asserts! (not (is-round-active)) err-round-active)
        (try! (as-contract (stx-transfer? total-funding tx-sender creator)))
        (ok true)
    )
)
