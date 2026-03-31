;; Achievement NFT - Clarity 4
;; Soulbound achievement tokens for on-chain accomplishments

(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u800))
(define-constant err-not-minter (err u801))
(define-constant err-already-claimed (err u802))
(define-constant err-achievement-not-found (err u803))
(define-constant err-not-transferable (err u804))

(define-data-var token-counter uint u0)
(define-data-var achievement-counter uint u0)

(define-map minters principal bool)

(define-map achievements
    uint
    {
        name: (string-ascii 64),
        description: (string-ascii 256),
        points: uint,
        max-supply: uint,
        minted: uint,
        active: bool
    }
)

(define-map tokens
    uint
    {
        achievement-id: uint,
        owner: principal,
        minted-at: uint
    }
)

(define-map user-achievements
    { user: principal, achievement-id: uint }
    uint
)

(define-map user-points principal uint)

;; Initialize owner as minter
(map-set minters tx-sender true)

(define-read-only (get-achievement (achievement-id uint))
    (map-get? achievements achievement-id)
)

(define-read-only (get-token (token-id uint))
    (map-get? tokens token-id)
)

(define-read-only (has-achievement (user principal) (achievement-id uint))
    (is-some (map-get? user-achievements { user: user, achievement-id: achievement-id }))
)

(define-read-only (get-user-points (user principal))
    (default-to u0 (map-get? user-points user))
)

(define-read-only (is-minter (addr principal))
    (default-to false (map-get? minters addr))
)

(define-public (add-minter (new-minter principal))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-not-owner)
        (ok (map-set minters new-minter true))
    )
)

(define-public (create-achievement (name (string-ascii 64)) (description (string-ascii 256)) (points uint) (max-supply uint))
    (let (
        (achievement-id (+ (var-get achievement-counter) u1))
    )
        (asserts! (is-eq tx-sender contract-owner) err-not-owner)
        (map-set achievements achievement-id {
            name: name,
            description: description,
            points: points,
            max-supply: max-supply,
            minted: u0,
            active: true
        })
        (var-set achievement-counter achievement-id)
        (ok achievement-id)
    )
)

(define-public (mint-achievement (recipient principal) (achievement-id uint))
    (let (
        (achievement (unwrap! (map-get? achievements achievement-id) err-achievement-not-found))
        (token-id (+ (var-get token-counter) u1))
        (current-points (get-user-points recipient))
    )
        (asserts! (is-minter tx-sender) err-not-minter)
        (asserts! (get active achievement) err-achievement-not-found)
        (asserts! (< (get minted achievement) (get max-supply achievement)) err-achievement-not-found)
        (asserts! (not (has-achievement recipient achievement-id)) err-already-claimed)
        (map-set tokens token-id {
            achievement-id: achievement-id,
            owner: recipient,
            minted-at: block-height
        })
        (map-set user-achievements { user: recipient, achievement-id: achievement-id } token-id)
        (map-set user-points recipient (+ current-points (get points achievement)))
        (map-set achievements achievement-id (merge achievement { minted: (+ (get minted achievement) u1) }))
        (var-set token-counter token-id)
        (ok token-id)
    )
)

(define-public (deactivate-achievement (achievement-id uint))
    (let (
        (achievement (unwrap! (map-get? achievements achievement-id) err-achievement-not-found))
    )
        (asserts! (is-eq tx-sender contract-owner) err-not-owner)
        (ok (map-set achievements achievement-id (merge achievement { active: false })))
    )
)
