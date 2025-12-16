;; Oracle Reader Contract
;; Read price data from oracles

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-stale-price (err u101))

(define-data-var max-staleness uint u144) ;; ~1 day in blocks

(define-map price-feeds (string-ascii 20) {
  price: uint,
  decimals: uint,
  last-updated: uint,
  source: principal
})

(define-map authorized-sources principal bool)

;; Update price feed
(define-public (update-price (asset (string-ascii 20)) (price uint) (decimals uint))
  (let ((caller tx-sender))
    (asserts! (default-to false (map-get? authorized-sources caller)) err-owner-only)
    (ok (map-set price-feeds asset {
      price: price,
      decimals: decimals,
      last-updated: stacks-block-height,
      source: caller
    }))
  )
)

;; Authorize oracle source
(define-public (authorize-source (source principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-set authorized-sources source true))
  )
)

;; Revoke oracle source
(define-public (revoke-source (source principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-delete authorized-sources source))
  )
)

(define-read-only (get-price (asset (string-ascii 20)))
  (match (map-get? price-feeds asset)
    feed (let ((age (- stacks-block-height (get last-updated feed))))
      (if (> age (var-get max-staleness))
        err-stale-price
        (ok (get price feed))
      )
    )
    (err u102)
  )
)

(define-read-only (get-price-feed (asset (string-ascii 20)))
  (ok (map-get? price-feeds asset))
)

(define-read-only (is-authorized (source principal))
  (ok (default-to false (map-get? authorized-sources source)))
)
