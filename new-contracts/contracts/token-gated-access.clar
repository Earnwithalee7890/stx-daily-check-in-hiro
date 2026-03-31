;; Token Gated Access - Clarity 4
;; Control access to resources based on token holdings

(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u400))
(define-constant err-gate-exists (err u401))
(define-constant err-gate-not-found (err u402))
(define-constant err-insufficient-balance (err u403))

(define-data-var gate-counter uint u0)

(define-map gates
    uint
    {
        name: (string-ascii 64),
        creator: principal,
        required-amount: uint,
        access-count: uint,
        active: bool
    }
)

(define-map gate-access
    { gate-id: uint, user: principal }
    { granted-at: uint, expires-at: uint }
)

(define-read-only (get-gate (gate-id uint))
    (map-get? gates gate-id)
)

(define-read-only (has-access (gate-id uint) (user principal))
    (match (map-get? gate-access { gate-id: gate-id, user: user })
        access-data (> (get expires-at access-data) block-height)
        false
    )
)

(define-read-only (check-balance-eligible (gate-id uint) (user principal))
    (match (map-get? gates gate-id)
        gate-data (>= (stx-get-balance user) (get required-amount gate-data))
        false
    )
)

(define-public (create-gate (name (string-ascii 64)) (required-amount uint))
    (let (
        (gate-id (+ (var-get gate-counter) u1))
    )
        (map-set gates gate-id {
            name: name,
            creator: tx-sender,
            required-amount: required-amount,
            access-count: u0,
            active: true
        })
        (var-set gate-counter gate-id)
        (ok gate-id)
    )
)

(define-public (request-access (gate-id uint) (duration-blocks uint))
    (let (
        (gate (unwrap! (map-get? gates gate-id) err-gate-not-found))
        (user-balance (stx-get-balance tx-sender))
    )
        (asserts! (get active gate) err-gate-not-found)
        (asserts! (>= user-balance (get required-amount gate)) err-insufficient-balance)
        (map-set gate-access
            { gate-id: gate-id, user: tx-sender }
            { granted-at: block-height, expires-at: (+ block-height duration-blocks) }
        )
        (map-set gates gate-id (merge gate { access-count: (+ (get access-count gate) u1) }))
        (ok true)
    )
)

(define-public (revoke-access (gate-id uint) (user principal))
    (let (
        (gate (unwrap! (map-get? gates gate-id) err-gate-not-found))
    )
        (asserts! (is-eq tx-sender (get creator gate)) err-not-owner)
        (ok (map-delete gate-access { gate-id: gate-id, user: user }))
    )
)

(define-public (deactivate-gate (gate-id uint))
    (let (
        (gate (unwrap! (map-get? gates gate-id) err-gate-not-found))
    )
        (asserts! (is-eq tx-sender (get creator gate)) err-not-owner)
        (ok (map-set gates gate-id (merge gate { active: false })))
    )
)
