;; DAO Treasury Contract
;; Multi-sig treasury management

(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))
(define-constant err-already-signed (err u101))
(define-constant err-not-enough-sigs (err u102))
(define-constant err-proposal-not-found (err u103))

(define-data-var required-signatures uint u2)
(define-data-var proposal-nonce uint u0)

(define-map signers principal bool)
(define-map proposals uint {
  recipient: principal,
  amount: uint,
  signatures: uint,
  executed: bool,
  created-at: uint
})
(define-map has-signed {proposal-id: uint, signer: principal} bool)

;; Initialize signers
(define-public (add-signer (signer principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (ok (map-set signers signer true))
  )
)

;; Remove signer
(define-public (remove-signer (signer principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (ok (map-delete signers signer))
  )
)

;; Propose treasury spend
(define-public (propose-spend (recipient principal) (amount uint))
  (let ((proposal-id (var-get proposal-nonce)))
    (asserts! (default-to false (map-get? signers tx-sender)) err-unauthorized)
    (map-set proposals proposal-id {
      recipient: recipient,
      amount: amount,
      signatures: u1,
      executed: false,
      created-at: stacks-block-height
    })
    (map-set has-signed {proposal-id: proposal-id, signer: tx-sender} true)
    (var-set proposal-nonce (+ proposal-id u1))
    (ok proposal-id)
  )
)

;; Sign proposal
(define-public (sign-proposal (proposal-id uint))
  (let (
    (proposal (unwrap! (map-get? proposals proposal-id) err-proposal-not-found))
  )
    (asserts! (default-to false (map-get? signers tx-sender)) err-unauthorized)
    (asserts! (not (default-to false (map-get? has-signed {proposal-id: proposal-id, signer: tx-sender}))) err-already-signed)
    (map-set has-signed {proposal-id: proposal-id, signer: tx-sender} true)
    (ok (map-set proposals proposal-id (merge proposal {signatures: (+ (get signatures proposal) u1)})))
  )
)

;; Execute approved proposal
(define-public (execute-proposal (proposal-id uint))
  (let (
    (proposal (unwrap! (map-get? proposals proposal-id) err-proposal-not-found))
  )
    (asserts! (>= (get signatures proposal) (var-get required-signatures)) err-not-enough-sigs)
    (asserts! (not (get executed proposal)) err-already-signed)
    (try! (as-contract (stx-transfer? (get amount proposal) tx-sender (get recipient proposal))))
    (ok (map-set proposals proposal-id (merge proposal {executed: true})))
  )
)

;; Deposit to treasury
(define-public (deposit (amount uint))
  (stx-transfer? amount tx-sender (as-contract tx-sender))
)

(define-read-only (get-proposal (proposal-id uint))
  (ok (map-get? proposals proposal-id))
)

(define-read-only (get-treasury-balance)
  (ok (stx-get-balance (as-contract tx-sender)))
)
