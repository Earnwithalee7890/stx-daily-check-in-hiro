;; SIP-009 NFT Trait
;; Standard interface for Non-Fungible Tokens on Stacks

(define-trait sip009-nft-trait
  (
    ;; Last token ID
    (get-last-token-id () (response uint uint))

    ;; URI for metadata
    (get-token-uri (uint) (response (optional (string-ascii 256)) uint))

    ;; Owner of a given token identifier
    (get-owner (uint) (response (optional principal) uint))

    ;; Transfer from sender to a new principal
    (transfer (uint principal principal) (response bool uint))
  )
)
