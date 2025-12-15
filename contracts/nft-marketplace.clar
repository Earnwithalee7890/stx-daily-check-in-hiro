;; NFT Marketplace Contract
;; Buy and sell NFTs

(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u100))
(define-constant err-listing-not-found (err u101))
(define-constant err-wrong-price (err u102))

(define-data-var listing-nonce uint u0)
(define-data-var marketplace-fee uint u25) ;; 2.5%

(define-map listings uint {
  seller: principal,
  nft-contract: principal,
  token-id: uint,
  price: uint,
  active: bool
})

(define-map seller-listings principal (list 50 uint))

;; List NFT for sale
(define-public (list-nft (nft-contract principal) (token-id uint) (price uint))
  (let (
    (listing-id (var-get listing-nonce))
    (caller tx-sender)
  )
    (map-set listings listing-id {
      seller: caller,
      nft-contract: nft-contract,
      token-id: token-id,
      price: price,
      active: true
    })
    (var-set listing-nonce (+ listing-id u1))
    (ok listing-id)
  )
)

;; Buy listed NFT
(define-public (buy-nft (listing-id uint))
  (let (
    (listing (unwrap! (map-get? listings listing-id) err-listing-not-found))
    (buyer tx-sender)
    (fee (/ (* (get price listing) (var-get marketplace-fee)) u1000))
    (seller-amount (- (get price listing) fee))
  )
    (asserts! (get active listing) err-listing-not-found)
    (try! (stx-transfer? seller-amount buyer (get seller listing)))
    (try! (stx-transfer? fee buyer contract-owner))
    (map-set listings listing-id (merge listing {active: false}))
    (ok true)
  )
)

;; Cancel listing
(define-public (cancel-listing (listing-id uint))
  (let ((listing (unwrap! (map-get? listings listing-id) err-listing-not-found)))
    (asserts! (is-eq tx-sender (get seller listing)) err-not-owner)
    (ok (map-set listings listing-id (merge listing {active: false})))
  )
)

(define-read-only (get-listing (listing-id uint))
  (ok (map-get? listings listing-id))
)

(define-read-only (get-marketplace-fee)
  (ok (var-get marketplace-fee))
)
