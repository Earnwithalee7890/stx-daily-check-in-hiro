;; NFT Marketplace Contract
;; Buy and sell NFTs with SIP-009 compatibility

(use-trait nft-trait .sip009-nft-trait.sip009-nft-trait)

(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u100))
(define-constant err-not-authorized (err u101))
(define-constant err-listing-not-found (err u404))
(define-constant err-wrong-price (err u400))
(define-constant err-transfer-failed (err u500))

(define-data-var listing-nonce uint u0)
(define-data-var marketplace-fee uint u25) ;; 2.5% (basis points / 1000)

(define-map listings uint {
  seller: principal,
  nft-contract: principal,
  token-id: uint,
  price: uint,
  active: bool
})

;; Floor price tracking per collection
(define-map collection-stats principal { floor-price: uint, total-volume: uint, last-sale: uint })

;; List NFT for sale
(define-public (list-nft (nft-contract <nft-trait>) (token-id uint) (price uint))
  (let (
    (listing-id (var-get listing-nonce))
    (caller tx-sender)
    (nft-owner (unwrap! (contract-call? nft-contract get-owner token-id) err-not-found))
  )
    (asserts! (is-eq (some caller) nft-owner) err-not-authorized)
    (map-set listings listing-id {
      seller: caller,
      nft-contract: (contract-of nft-contract),
      token-id: token-id,
      price: price,
      active: true
    })
    (var-set listing-nonce (+ listing-id u1))
    (print { event: "nft-listed", listing-id: listing-id, seller: caller, price: price })
    (ok listing-id)
  )
)

;; Buy listed NFT
(define-public (buy-nft (listing-id uint) (nft-contract <nft-trait>))
  (let (
    (listing (unwrap! (map-get? listings listing-id) err-listing-not-found))
    (buyer tx-sender)
    (price (get price listing))
    (fee (/ (* price (var-get marketplace-fee)) u1000))
    (seller-amount (- price fee))
    (stats (default-to { floor-price: price, total-volume: u0, last-sale: u0 } (map-get? collection-stats (get nft-contract listing))))
  )
    (asserts! (get active listing) err-listing-not-found)
    (asserts! (is-eq (contract-of nft-contract) (get nft-contract listing)) err-wrong-price)
    
    ;; Transfers
    (try! (stx-transfer? seller-amount buyer (get seller listing)))
    (try! (stx-transfer? fee buyer contract-owner))
    (try! (contract-call? nft-contract transfer (get token-id listing) (get seller listing) buyer))
    
    ;; Update state
    (map-set listings listing-id (merge listing {active: false}))
    
    ;; Update collection stats
    (map-set collection-stats (get nft-contract listing) {
        floor-price: (if (< price (get floor-price stats)) price (get floor-price stats)),
        total-volume: (+ (get total-volume stats) price),
        last-sale: price
    })
    
    (print { event: "nft-sold", listing-id: listing-id, buyer: buyer, price: price })
    (ok true)
  )
)

;; Cancel listing
(define-public (cancel-listing (listing-id uint))
  (let ((listing (unwrap! (map-get? listings listing-id) err-listing-not-found)))
    (asserts! (is-eq tx-sender (get seller listing)) err-not-owner)
    (map-set listings listing-id (merge listing {active: false}))
    (ok true)
  )
)

;; Admin: Set marketplace fee
(define-public (set-marketplace-fee (new-fee uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-not-authorized)
    (var-set marketplace-fee new-fee)
    (ok true)
  )
)

(define-read-only (get-listing (listing-id uint))
  (ok (map-get? listings listing-id))
)

(define-read-only (get-collection-stats (collection principal))
  (ok (map-get? collection-stats collection))
)

(define-read-only (get-marketplace-fee)
  (ok (var-get marketplace-fee))
)
