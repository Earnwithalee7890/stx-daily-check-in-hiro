;; STX NFT V2 Contract
;; SIP-009 NFT collection with metadata

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))
(define-constant err-token-not-found (err u102))
(define-constant err-sold-out (err u103))

(define-non-fungible-token stx-nft-v2 uint)

(define-data-var last-token-id uint u0)
(define-data-var max-supply uint u1000)
(define-data-var base-uri (string-ascii 200) "https://api.stxnft.io/metadata/")
(define-data-var mint-price uint u1000000) ;; 1 STX

(define-map token-uris uint (string-ascii 256))

;; SIP-009 Functions
(define-read-only (get-last-token-id)
  (ok (var-get last-token-id))
)

(define-read-only (get-token-uri (token-id uint))
  (ok (map-get? token-uris token-id))
)

(define-read-only (get-owner (token-id uint))
  (ok (nft-get-owner? stx-nft-v2 token-id))
)

(define-public (transfer (token-id uint) (sender principal) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender sender) err-not-token-owner)
    (nft-transfer? stx-nft-v2 token-id sender recipient)
  )
)

;; Mint NFT
(define-public (mint)
  (let (
    (token-id (+ (var-get last-token-id) u1))
    (caller tx-sender)
  )
    (asserts! (<= token-id (var-get max-supply)) err-sold-out)
    (try! (stx-transfer? (var-get mint-price) caller contract-owner))
    (try! (nft-mint? stx-nft-v2 token-id caller))
    (var-set last-token-id token-id)
    (ok token-id)
  )
)

;; Set token URI (owner only)
(define-public (set-token-uri (token-id uint) (uri (string-ascii 256)))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ok (map-set token-uris token-id uri))
  )
)

(define-read-only (get-mint-price)
  (ok (var-get mint-price))
)

(define-read-only (get-max-supply)
  (ok (var-get max-supply))
)
