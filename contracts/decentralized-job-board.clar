;; Decentralized Job Board
;; Post jobs, apply, and hire with STX payments
;; Built for Stacks Builder Challenge Week 3

(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_NOT_AUTHORIZED (err u401))
(define-constant ERR_JOB_NOT_FOUND (err u404))
(define-constant ERR_JOB_ALREADY_FILLED (err u405))
(define-constant ERR_INSUFFICIENT_FUNDS (err u406))
(define-constant ERR_INVALID_PAYMENT (err u407))

(define-constant POSTING_FEE u10000) ;; 0.01 STX fee to post a job
(define-constant FEE_RECIPIENT 'SP2F500B8DTRK1EANJQ054BRAB8DDKN6QCMXGNFBT)

(define-data-var total-jobs uint u0)

(define-map jobs
    uint
    {
        employer: principal,
        title: (string-ascii 100),
        description: (string-ascii 500),
        budget: uint,
        status: (string-ascii 20), ;; "open", "filled", "completed", "cancelled"
        freelancer: (optional principal),
        created-at: uint
    }
)

(define-map job-applications
    {job-id: uint, applicant: principal}
    {proposal: (string-ascii 500), timestamp: uint}
)

;; Post a new job
(define-public (post-job (title (string-ascii 100)) (description (string-ascii 500)) (budget uint))
    (let
        (
            (job-id (+ (var-get total-jobs) u1))
        )
        ;; Collect posting fee
        (try! (stx-transfer? POSTING_FEE tx-sender FEE_RECIPIENT))
        
        ;; Save job
        (map-set jobs job-id {
            employer: tx-sender,
            title: title,
            description: description,
            budget: budget,
            status: "open",
            freelancer: none,
            created-at: stacks-block-height
        })
        
        (var-set total-jobs job-id)
        (print {event: "job-posted", job-id: job-id, employer: tx-sender, budget: budget})
        (ok job-id)
    )
)

;; Apply for a job
(define-public (apply-for-job (job-id uint) (proposal (string-ascii 500)))
    (let
        (
            (job (unwrap! (map-get? jobs job-id) ERR_JOB_NOT_FOUND))
        )
        (asserts! (is-eq (get status job) "open") ERR_JOB_ALREADY_FILLED)
        
        (map-set job-applications {job-id: job-id, applicant: tx-sender} {
            proposal: proposal,
            timestamp: stacks-block-height
        })
        
        (print {event: "job-application", job-id: job-id, applicant: tx-sender})
        (ok true)
    )
)

;; Hire a freelancer
(define-public (hire-freelancer (job-id uint) (freelancer principal))
    (let
        (
            (job (unwrap! (map-get? jobs job-id) ERR_JOB_NOT_FOUND))
        )
        (asserts! (is-eq (get employer job) tx-sender) ERR_NOT_AUTHORIZED)
        (asserts! (is-eq (get status job) "open") ERR_JOB_ALREADY_FILLED)
        
        ;; Update job status
        (map-set jobs job-id (merge job {
            status: "filled",
            freelancer: (some freelancer)
        }))
        
        (print {event: "job-hired", job-id: job-id, freelancer: freelancer})
        (ok true)
    )
)

;; Complete job and release payment
(define-public (complete-job (job-id uint))
    (let
        (
            (job (unwrap! (map-get? jobs job-id) ERR_JOB_NOT_FOUND))
            (freelancer (unwrap! (get freelancer job) ERR_JOB_NOT_FOUND))
            (budget (get budget job))
        )
        (asserts! (is-eq (get employer job) tx-sender) ERR_NOT_AUTHORIZED)
        (asserts! (is-eq (get status job) "filled") ERR_JOB_NOT_FOUND)
        
        ;; Transfer budget to freelancer
        (try! (stx-transfer? budget tx-sender freelancer))
        
        ;; Update status
        (map-set jobs job-id (merge job {
            status: "completed"
        }))
        
        (print {event: "job-completed", job-id: job-id, budget: budget})
        (ok true)
    )
)

;; Read-only functions
(define-read-only (get-job (job-id uint))
    (ok (map-get? jobs job-id))
)

(define-read-only (get-application (job-id uint) (applicant principal))
    (ok (map-get? job-applications {job-id: job-id, applicant: applicant}))
)

(define-read-only (get-total-jobs)
    (ok (var-get total-jobs))
)
