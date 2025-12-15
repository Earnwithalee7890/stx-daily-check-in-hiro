;; Data Registry Contract
;; General purpose key-value data store

(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))
(define-constant err-not-found (err u101))

(define-map data-entries (string-ascii 64) {
  value: (string-utf8 500),
  owner: principal,
  created-at: uint,
  updated-at: uint
})

(define-map owner-entries principal (list 100 (string-ascii 64)))

;; Set data entry
(define-public (set-entry (key (string-ascii 64)) (value (string-utf8 500)))
  (let (
    (caller tx-sender)
    (existing (map-get? data-entries key))
  )
    (match existing
      entry (begin
        (asserts! (is-eq caller (get owner entry)) err-unauthorized)
        (ok (map-set data-entries key {
          value: value,
          owner: caller,
          created-at: (get created-at entry),
          updated-at: stacks-block-height
        }))
      )
      (ok (map-set data-entries key {
        value: value,
        owner: caller,
        created-at: stacks-block-height,
        updated-at: stacks-block-height
      }))
    )
  )
)

;; Delete data entry
(define-public (delete-entry (key (string-ascii 64)))
  (match (map-get? data-entries key)
    entry (begin
      (asserts! (is-eq tx-sender (get owner entry)) err-unauthorized)
      (ok (map-delete data-entries key))
    )
    err-not-found
  )
)

;; Transfer entry ownership
(define-public (transfer-ownership (key (string-ascii 64)) (new-owner principal))
  (match (map-get? data-entries key)
    entry (begin
      (asserts! (is-eq tx-sender (get owner entry)) err-unauthorized)
      (ok (map-set data-entries key (merge entry {owner: new-owner})))
    )
    err-not-found
  )
)

(define-read-only (get-entry (key (string-ascii 64)))
  (ok (map-get? data-entries key))
)

(define-read-only (get-value (key (string-ascii 64)))
  (match (map-get? data-entries key)
    entry (ok (get value entry))
    (err u102)
  )
)
