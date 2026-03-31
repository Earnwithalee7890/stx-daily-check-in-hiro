;; Content License - Clarity 4
;; Digital content licensing and royalty distribution

(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u300))
(define-constant err-not-creator (err u301))
(define-constant err-license-exists (err u302))
(define-constant err-license-not-found (err u303))
(define-constant err-insufficient-payment (err u304))

(define-data-var license-counter uint u0)
(define-data-var platform-fee uint u50) ;; 5% in basis points

(define-map licenses
    uint
    {
        creator: principal,
        content-hash: (buff 32),
        price: uint,
        royalty-rate: uint,
        total-sold: uint,
        active: bool
    }
)

(define-map user-licenses
    { user: principal, license-id: uint }
    { purchased-at: uint }
)

(define-read-only (get-license (license-id uint))
    (map-get? licenses license-id)
)

(define-read-only (has-license (user principal) (license-id uint))
    (is-some (map-get? user-licenses { user: user, license-id: license-id }))
)

(define-read-only (get-license-count)
    (var-get license-counter)
)

(define-public (create-license (content-hash (buff 32)) (price uint) (royalty-rate uint))
    (let (
        (license-id (+ (var-get license-counter) u1))
    )
        (map-set licenses license-id {
            creator: tx-sender,
            content-hash: content-hash,
            price: price,
            royalty-rate: royalty-rate,
            total-sold: u0,
            active: true
        })
        (var-set license-counter license-id)
        (ok license-id)
    )
)

(define-public (purchase-license (license-id uint))
    (let (
        (license (unwrap! (map-get? licenses license-id) err-license-not-found))
        (price (get price license))
        (creator (get creator license))
        (fee-amount (/ (* price (var-get platform-fee)) u1000))
        (creator-amount (- price fee-amount))
    )
        (asserts! (get active license) err-license-not-found)
        (asserts! (not (has-license tx-sender license-id)) err-license-exists)
        (try! (stx-transfer? creator-amount tx-sender creator))
        (try! (stx-transfer? fee-amount tx-sender contract-owner))
        (map-set user-licenses { user: tx-sender, license-id: license-id } { purchased-at: block-height })
        (map-set licenses license-id (merge license { total-sold: (+ (get total-sold license) u1) }))
        (ok true)
    )
)

(define-public (deactivate-license (license-id uint))
    (let (
        (license (unwrap! (map-get? licenses license-id) err-license-not-found))
    )
        (asserts! (is-eq tx-sender (get creator license)) err-not-creator)
        (ok (map-set licenses license-id (merge license { active: false })))
    )
)
