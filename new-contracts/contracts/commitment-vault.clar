;; Commitment Vault - Clarity 4
;; Lock funds with commitment conditions and accountability partners

(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u1000))
(define-constant err-commitment-not-found (err u1001))
(define-constant err-not-participant (err u1002))
(define-constant err-already-completed (err u1003))
(define-constant err-not-expired (err u1004))
(define-constant err-still-active (err u1005))

(define-data-var commitment-counter uint u0)

(define-map commitments
    uint
    {
        creator: principal,
        accountability-partner: principal,
        stake-amount: uint,
        goal: (string-ascii 128),
        deadline: uint,
        status: (string-ascii 20),
        created-at: uint
    }
)

(define-map commitment-evidence
    uint
    { evidence-hash: (buff 32), submitted-at: uint }
)

(define-read-only (get-commitment (commitment-id uint))
    (map-get? commitments commitment-id)
)

(define-read-only (get-evidence (commitment-id uint))
    (map-get? commitment-evidence commitment-id)
)

(define-read-only (is-expired (commitment-id uint))
    (match (map-get? commitments commitment-id)
        commitment (> block-height (get deadline commitment))
        false
    )
)

(define-public (create-commitment (accountability-partner principal) (goal (string-ascii 128)) (deadline uint) (stake-amount uint))
    (let (
        (commitment-id (+ (var-get commitment-counter) u1))
    )
        (try! (stx-transfer? stake-amount tx-sender (as-contract tx-sender)))
        (map-set commitments commitment-id {
            creator: tx-sender,
            accountability-partner: accountability-partner,
            stake-amount: stake-amount,
            goal: goal,
            deadline: deadline,
            status: "active",
            created-at: block-height
        })
        (var-set commitment-counter commitment-id)
        (ok commitment-id)
    )
)

(define-public (submit-evidence (commitment-id uint) (evidence-hash (buff 32)))
    (let (
        (commitment (unwrap! (map-get? commitments commitment-id) err-commitment-not-found))
    )
        (asserts! (is-eq tx-sender (get creator commitment)) err-not-participant)
        (asserts! (is-eq (get status commitment) "active") err-already-completed)
        (map-set commitment-evidence commitment-id {
            evidence-hash: evidence-hash,
            submitted-at: block-height
        })
        (ok (map-set commitments commitment-id (merge commitment { status: "pending-review" })))
    )
)

(define-public (verify-completion (commitment-id uint) (approved bool))
    (let (
        (commitment (unwrap! (map-get? commitments commitment-id) err-commitment-not-found))
        (stake (get stake-amount commitment))
    )
        (asserts! (is-eq tx-sender (get accountability-partner commitment)) err-not-participant)
        (asserts! (is-eq (get status commitment) "pending-review") err-already-completed)
        (if approved
            (begin
                (try! (as-contract (stx-transfer? stake tx-sender (get creator commitment))))
                (ok (map-set commitments commitment-id (merge commitment { status: "completed" })))
            )
            (ok (map-set commitments commitment-id (merge commitment { status: "failed" })))
        )
    )
)

(define-public (claim-expired (commitment-id uint))
    (let (
        (commitment (unwrap! (map-get? commitments commitment-id) err-commitment-not-found))
        (stake (get stake-amount commitment))
        (partner (get accountability-partner commitment))
    )
        (asserts! (is-eq tx-sender partner) err-not-participant)
        (asserts! (> block-height (get deadline commitment)) err-not-expired)
        (asserts! (is-eq (get status commitment) "active") err-already-completed)
        (try! (as-contract (stx-transfer? stake tx-sender partner)))
        (ok (map-set commitments commitment-id (merge commitment { status: "forfeited" })))
    )
)

(define-public (cancel-commitment (commitment-id uint))
    (let (
        (commitment (unwrap! (map-get? commitments commitment-id) err-commitment-not-found))
        (stake (get stake-amount commitment))
        (creator-addr (get creator commitment))
    )
        (asserts! (is-eq tx-sender creator-addr) err-not-participant)
        (asserts! (is-eq (get status commitment) "active") err-already-completed)
        (asserts! (<= block-height (get deadline commitment)) err-not-expired)
        (try! (as-contract (stx-transfer? stake tx-sender creator-addr)))
        (ok (map-set commitments commitment-id (merge commitment { status: "cancelled" })))
    )
)
