;; Milestone Payment - Clarity 4
;; Project-based milestone payment system

(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u500))
(define-constant err-not-client (err u501))
(define-constant err-not-freelancer (err u502))
(define-constant err-project-not-found (err u503))
(define-constant err-milestone-not-found (err u504))
(define-constant err-already-paid (err u505))
(define-constant err-not-completed (err u506))

(define-data-var project-counter uint u0)

(define-map projects
    uint
    {
        client: principal,
        freelancer: principal,
        total-amount: uint,
        paid-amount: uint,
        milestone-count: uint,
        status: (string-ascii 20)
    }
)

(define-map milestones
    { project-id: uint, milestone-id: uint }
    {
        description: (string-ascii 128),
        amount: uint,
        completed: bool,
        paid: bool,
        completed-at: uint
    }
)

(define-read-only (get-project (project-id uint))
    (map-get? projects project-id)
)

(define-read-only (get-milestone (project-id uint) (milestone-id uint))
    (map-get? milestones { project-id: project-id, milestone-id: milestone-id })
)

(define-public (create-project (freelancer principal) (total-amount uint) (milestone-count uint))
    (let (
        (project-id (+ (var-get project-counter) u1))
    )
        (try! (stx-transfer? total-amount tx-sender (as-contract tx-sender)))
        (map-set projects project-id {
            client: tx-sender,
            freelancer: freelancer,
            total-amount: total-amount,
            paid-amount: u0,
            milestone-count: milestone-count,
            status: "active"
        })
        (var-set project-counter project-id)
        (ok project-id)
    )
)

(define-public (add-milestone (project-id uint) (milestone-id uint) (description (string-ascii 128)) (amount uint))
    (let (
        (project (unwrap! (map-get? projects project-id) err-project-not-found))
    )
        (asserts! (is-eq tx-sender (get client project)) err-not-client)
        (map-set milestones
            { project-id: project-id, milestone-id: milestone-id }
            {
                description: description,
                amount: amount,
                completed: false,
                paid: false,
                completed-at: u0
            }
        )
        (ok true)
    )
)

(define-public (complete-milestone (project-id uint) (milestone-id uint))
    (let (
        (project (unwrap! (map-get? projects project-id) err-project-not-found))
        (milestone (unwrap! (map-get? milestones { project-id: project-id, milestone-id: milestone-id }) err-milestone-not-found))
    )
        (asserts! (is-eq tx-sender (get freelancer project)) err-not-freelancer)
        (ok (map-set milestones
            { project-id: project-id, milestone-id: milestone-id }
            (merge milestone { completed: true, completed-at: block-height })
        ))
    )
)

(define-public (approve-milestone (project-id uint) (milestone-id uint))
    (let (
        (project (unwrap! (map-get? projects project-id) err-project-not-found))
        (milestone (unwrap! (map-get? milestones { project-id: project-id, milestone-id: milestone-id }) err-milestone-not-found))
        (amount (get amount milestone))
        (freelancer-addr (get freelancer project))
    )
        (asserts! (is-eq tx-sender (get client project)) err-not-client)
        (asserts! (get completed milestone) err-not-completed)
        (asserts! (not (get paid milestone)) err-already-paid)
        (try! (as-contract (stx-transfer? amount tx-sender freelancer-addr)))
        (map-set milestones
            { project-id: project-id, milestone-id: milestone-id }
            (merge milestone { paid: true })
        )
        (ok (map-set projects project-id
            (merge project { paid-amount: (+ (get paid-amount project) amount) })
        ))
    )
)
