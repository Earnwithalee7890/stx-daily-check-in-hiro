;; Quadratic Voting Contract
;; Quadratic voting for fair governance

(define-constant contract-owner tx-sender)
(define-constant err-insufficient-credits (err u100))
(define-constant err-already-voted (err u101))
(define-constant err-not-found (err u102))

(define-data-var poll-nonce uint u0)

(define-map polls uint {
  question: (string-ascii 200),
  options: (list 10 (string-ascii 50)),
  votes: (list 10 uint),
  end-block: uint
})

(define-map vote-credits principal uint)
(define-map user-votes {poll-id: uint, voter: principal} (list 10 uint))

;; Give vote credits
(define-public (allocate-credits (user principal) (credits uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-insufficient-credits)
    (ok (map-set vote-credits user (+ (default-to u0 (map-get? vote-credits user)) credits)))
  )
)

;; Create poll
(define-public (create-poll (question (string-ascii 200)) (options (list 10 (string-ascii 50))) (duration uint))
  (let ((poll-id (var-get poll-nonce)))
    (map-set polls poll-id {
      question: question,
      options: options,
      votes: (list u0 u0 u0 u0 u0 u0 u0 u0 u0 u0),
      end-block: (+ stacks-block-height duration)
    })
    (var-set poll-nonce (+ poll-id u1))
    (ok poll-id)
  )
)

;; Quadratic vote (cost = votes^2)
(define-public (vote (poll-id uint) (option-index uint) (vote-amount uint))
  (let (
    (caller tx-sender)
    (credits (default-to u0 (map-get? vote-credits caller)))
    (cost (* vote-amount vote-amount)) ;; Quadratic cost
    (poll (unwrap! (map-get? polls poll-id) err-not-found))
  )
    (asserts! (>= credits cost) err-insufficient-credits)
    (asserts! (<= stacks-block-height (get end-block poll)) err-not-found)
    (map-set vote-credits caller (- credits cost))
    (ok vote-amount)
  )
)

(define-read-only (get-poll (poll-id uint))
  (ok (map-get? polls poll-id))
)

(define-read-only (get-credits (user principal))
  (ok (default-to u0 (map-get? vote-credits user)))
)

;; Calculate vote cost for given amount
(define-read-only (calculate-cost (votes uint))
  (ok (* votes votes))
)
