;; SIP-010 Fungible Token Contract
;; Standard fungible token implementation

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-insufficient-balance (err u101))

(define-fungible-token builder-token)

(define-data-var token-name (string-ascii 32) "Builder Token")
(define-data-var token-symbol (string-ascii 10) "BUILD")
(define-data-var token-decimals uint u6)
(define-data-var token-uri (optional (string-utf8 256)) none)

;; SIP-010 Functions
(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (is-eq tx-sender sender) err-owner-only)
    (try! (ft-transfer? builder-token amount sender recipient))
    (match memo to-print (print to-print) 0x)
    (ok true)
  )
)

(define-read-only (get-name)
  (ok (var-get token-name))
)

(define-read-only (get-symbol)
  (ok (var-get token-symbol))
)

(define-read-only (get-decimals)
  (ok (var-get token-decimals))
)

(define-read-only (get-balance (who principal))
  (ok (ft-get-balance builder-token who))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply builder-token))
)

(define-read-only (get-token-uri)
  (ok (var-get token-uri))
)

;; Mint tokens (owner only)
(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ft-mint? builder-token amount recipient)
  )
)

;; Burn tokens
(define-public (burn (amount uint))
  (ft-burn? builder-token amount tx-sender)
)
