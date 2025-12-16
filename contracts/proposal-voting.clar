;; Proposal Voting Contract
;; Governance proposals with deadline voting

(define-constant contract-owner tx-sender)
(define-constant err-already-voted (err u100))
(define-constant err-voting-ended (err u101))
(define-constant err-voting-active (err u102))
(define-constant err-not-found (err u103))

(define-data-var proposal-nonce uint u0)
(define-data-var voting-duration uint u1008) ;; ~7 days

(define-map proposals uint {
  title: (string-ascii 100),
  description: (string-utf8 500),
  proposer: principal,
  start-block: uint,
  end-block: uint,
  votes-for: uint,
  votes-against: uint,
  executed: bool
})

(define-map votes {proposal-id: uint, voter: principal} bool)

;; Create proposal
(define-public (create-proposal (title (string-ascii 100)) (description (string-utf8 500)))
  (let ((proposal-id (var-get proposal-nonce)))
    (map-set proposals proposal-id {
      title: title,
      description: description,
      proposer: tx-sender,
      start-block: stacks-block-height,
      end-block: (+ stacks-block-height (var-get voting-duration)),
      votes-for: u0,
      votes-against: u0,
      executed: false
    })
    (var-set proposal-nonce (+ proposal-id u1))
    (ok proposal-id)
  )
)

;; Vote on proposal
(define-public (vote (proposal-id uint) (vote-for bool))
  (let (
    (proposal (unwrap! (map-get? proposals proposal-id) err-not-found))
    (voter tx-sender)
  )
    (asserts! (is-none (map-get? votes {proposal-id: proposal-id, voter: voter})) err-already-voted)
    (asserts! (<= stacks-block-height (get end-block proposal)) err-voting-ended)
    (map-set votes {proposal-id: proposal-id, voter: voter} vote-for)
    (if vote-for
      (map-set proposals proposal-id (merge proposal {votes-for: (+ (get votes-for proposal) u1)}))
      (map-set proposals proposal-id (merge proposal {votes-against: (+ (get votes-against proposal) u1)}))
    )
    (ok true)
  )
)

;; Finalize proposal
(define-public (finalize-proposal (proposal-id uint))
  (let (
    (proposal (unwrap! (map-get? proposals proposal-id) err-not-found))
  )
    (asserts! (> stacks-block-height (get end-block proposal)) err-voting-active)
    (asserts! (not (get executed proposal)) err-already-voted)
    (ok (map-set proposals proposal-id (merge proposal {executed: true})))
  )
)

(define-read-only (get-proposal (proposal-id uint))
  (ok (map-get? proposals proposal-id))
)

(define-read-only (get-vote (proposal-id uint) (voter principal))
  (ok (map-get? votes {proposal-id: proposal-id, voter: voter}))
)

(define-read-only (is-proposal-passed (proposal-id uint))
  (match (map-get? proposals proposal-id)
    proposal (ok (> (get votes-for proposal) (get votes-against proposal)))
    (ok false)
  )
)
