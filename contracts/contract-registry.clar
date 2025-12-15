;; Contract Registry Contract
;; Registry for verified contract deployments

(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))
(define-constant err-already-registered (err u101))
(define-constant err-not-found (err u102))

(define-data-var registry-nonce uint u0)

(define-map contracts (string-ascii 64) {
  address: principal,
  deployer: principal,
  registered-at: uint,
  version: (string-ascii 20),
  verified: bool,
  category: (string-ascii 32)
})

(define-map deployer-contracts principal (list 50 (string-ascii 64)))
(define-map category-contracts (string-ascii 32) (list 100 (string-ascii 64)))

;; Register a contract
(define-public (register-contract 
  (name (string-ascii 64)) 
  (address principal) 
  (version (string-ascii 20))
  (category (string-ascii 32)))
  (let ((caller tx-sender))
    (asserts! (is-none (map-get? contracts name)) err-already-registered)
    (map-set contracts name {
      address: address,
      deployer: caller,
      registered-at: stacks-block-height,
      version: version,
      verified: false,
      category: category
    })
    (var-set registry-nonce (+ (var-get registry-nonce) u1))
    (print {event: "contract-registered", name: name, address: address})
    (ok true)
  )
)

;; Verify contract (owner only)
(define-public (verify-contract (name (string-ascii 64)))
  (match (map-get? contracts name)
    contract (begin
      (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
      (ok (map-set contracts name (merge contract {verified: true})))
    )
    err-not-found
  )
)

;; Update contract version
(define-public (update-version (name (string-ascii 64)) (new-version (string-ascii 20)))
  (match (map-get? contracts name)
    contract (begin
      (asserts! (is-eq tx-sender (get deployer contract)) err-unauthorized)
      (ok (map-set contracts name (merge contract {version: new-version})))
    )
    err-not-found
  )
)

;; Transfer ownership
(define-public (transfer-contract (name (string-ascii 64)) (new-deployer principal))
  (match (map-get? contracts name)
    contract (begin
      (asserts! (is-eq tx-sender (get deployer contract)) err-unauthorized)
      (ok (map-set contracts name (merge contract {deployer: new-deployer})))
    )
    err-not-found
  )
)

(define-read-only (get-contract (name (string-ascii 64)))
  (ok (map-get? contracts name))
)

(define-read-only (get-contract-address (name (string-ascii 64)))
  (match (map-get? contracts name)
    contract (ok (some (get address contract)))
    (ok none)
  )
)

(define-read-only (get-registry-count)
  (ok (var-get registry-nonce))
)

(define-read-only (is-verified (name (string-ascii 64)))
  (match (map-get? contracts name)
    contract (ok (get verified contract))
    (ok false)
  )
)
