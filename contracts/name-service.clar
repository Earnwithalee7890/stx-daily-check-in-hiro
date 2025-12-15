;; Name Service Contract
;; Simple naming service for principals

(define-constant contract-owner tx-sender)
(define-constant err-name-taken (err u100))
(define-constant err-unauthorized (err u101))
(define-constant err-not-found (err u102))

(define-data-var registration-fee uint u100000) ;; 0.1 STX

(define-map names (string-ascii 32) {
  owner: principal,
  registered-at: uint,
  expires-at: uint
})

(define-map reverse-lookup principal (string-ascii 32))

;; Register a name
(define-public (register-name (name (string-ascii 32)))
  (let (
    (caller tx-sender)
    (existing (map-get? names name))
  )
    (match existing
      entry (begin
        (asserts! (> stacks-block-height (get expires-at entry)) err-name-taken)
        (try! (stx-transfer? (var-get registration-fee) caller contract-owner))
        (map-set names name {
          owner: caller,
          registered-at: stacks-block-height,
          expires-at: (+ stacks-block-height u52560) ;; ~1 year
        })
        (ok (map-set reverse-lookup caller name))
      )
      (begin
        (try! (stx-transfer? (var-get registration-fee) caller contract-owner))
        (map-set names name {
          owner: caller,
          registered-at: stacks-block-height,
          expires-at: (+ stacks-block-height u52560)
        })
        (ok (map-set reverse-lookup caller name))
      )
    )
  )
)

;; Transfer name to new owner
(define-public (transfer-name (name (string-ascii 32)) (new-owner principal))
  (match (map-get? names name)
    entry (begin
      (asserts! (is-eq tx-sender (get owner entry)) err-unauthorized)
      (map-set names name (merge entry {owner: new-owner}))
      (map-delete reverse-lookup tx-sender)
      (ok (map-set reverse-lookup new-owner name))
    )
    err-not-found
  )
)

;; Renew name registration
(define-public (renew-name (name (string-ascii 32)))
  (match (map-get? names name)
    entry (begin
      (asserts! (is-eq tx-sender (get owner entry)) err-unauthorized)
      (try! (stx-transfer? (var-get registration-fee) tx-sender contract-owner))
      (ok (map-set names name (merge entry {expires-at: (+ (get expires-at entry) u52560)})))
    )
    err-not-found
  )
)

(define-read-only (resolve-name (name (string-ascii 32)))
  (match (map-get? names name)
    entry (if (<= stacks-block-height (get expires-at entry))
      (ok (get owner entry))
      err-not-found
    )
    err-not-found
  )
)

(define-read-only (get-name (owner principal))
  (ok (map-get? reverse-lookup owner))
)
