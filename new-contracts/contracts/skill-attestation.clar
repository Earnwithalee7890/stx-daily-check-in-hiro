;; Skill Attestation - Clarity 4
;; Decentralized skill certification and endorsement system

(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u200))
(define-constant err-not-issuer (err u201))
(define-constant err-already-attested (err u202))
(define-constant err-attestation-not-found (err u203))

(define-data-var attestation-counter uint u0)

(define-map issuers principal { name: (string-ascii 64), active: bool })

(define-map attestations
    uint
    {
        recipient: principal,
        issuer: principal,
        skill: (string-ascii 64),
        level: uint,
        issued-at: uint
    }
)

(define-map user-attestations
    { user: principal, skill: (string-ascii 64) }
    uint
)

(define-read-only (get-attestation (attestation-id uint))
    (map-get? attestations attestation-id)
)

(define-read-only (get-user-skill (user principal) (skill (string-ascii 64)))
    (match (map-get? user-attestations { user: user, skill: skill })
        att-id (map-get? attestations att-id)
        none
    )
)

(define-read-only (is-issuer (addr principal))
    (match (map-get? issuers addr)
        issuer-data (get active issuer-data)
        false
    )
)

(define-public (register-issuer (issuer principal) (name (string-ascii 64)))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-not-owner)
        (ok (map-set issuers issuer { name: name, active: true }))
    )
)

(define-public (issue-attestation (recipient principal) (skill (string-ascii 64)) (level uint))
    (let (
        (att-id (+ (var-get attestation-counter) u1))
    )
        (asserts! (is-issuer tx-sender) err-not-issuer)
        (asserts! (is-none (map-get? user-attestations { user: recipient, skill: skill })) err-already-attested)
        (map-set attestations att-id {
            recipient: recipient,
            issuer: tx-sender,
            skill: skill,
            level: level,
            issued-at: block-height
        })
        (map-set user-attestations { user: recipient, skill: skill } att-id)
        (var-set attestation-counter att-id)
        (ok att-id)
    )
)

(define-public (revoke-attestation (attestation-id uint))
    (let (
        (att (unwrap! (map-get? attestations attestation-id) err-attestation-not-found))
    )
        (asserts! (is-eq tx-sender (get issuer att)) err-not-issuer)
        (map-delete user-attestations { user: (get recipient att), skill: (get skill att) })
        (ok (map-delete attestations attestation-id))
    )
)
