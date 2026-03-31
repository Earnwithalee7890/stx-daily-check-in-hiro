;; Social Verify - Clarity 4
;; On-chain social identity verification system

(define-constant contract-owner tx-sender)
(define-constant err-not-owner (err u100))
(define-constant err-already-verified (err u101))
(define-constant err-not-verified (err u102))
(define-constant err-invalid-platform (err u103))

(define-data-var verification-fee uint u1000000) ;; 1 STX

(define-map verifications
    { user: principal, platform: (string-ascii 20) }
    {
        handle: (string-ascii 64),
        verified-at: uint,
        verifier: principal
    }
)

(define-map trusted-verifiers principal bool)

;; Initialize owner as verifier
(map-set trusted-verifiers tx-sender true)

(define-read-only (is-verified (user principal) (platform (string-ascii 20)))
    (is-some (map-get? verifications { user: user, platform: platform }))
)

(define-read-only (get-verification (user principal) (platform (string-ascii 20)))
    (map-get? verifications { user: user, platform: platform })
)

(define-read-only (is-trusted-verifier (verifier principal))
    (default-to false (map-get? trusted-verifiers verifier))
)

(define-public (add-verifier (new-verifier principal))
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-not-owner)
        (ok (map-set trusted-verifiers new-verifier true))
    )
)

(define-public (verify-user (user principal) (platform (string-ascii 20)) (handle (string-ascii 64)))
    (begin
        (asserts! (is-trusted-verifier tx-sender) err-not-owner)
        (asserts! (not (is-verified user platform)) err-already-verified)
        (ok (map-set verifications
            { user: user, platform: platform }
            {
                handle: handle,
                verified-at: block-height,
                verifier: tx-sender
            }
        ))
    )
)

(define-public (request-verification (platform (string-ascii 20)) (handle (string-ascii 64)))
    (begin
        (asserts! (not (is-verified tx-sender platform)) err-already-verified)
        (try! (stx-transfer? (var-get verification-fee) tx-sender contract-owner))
        (ok true)
    )
)

(define-public (revoke-verification (user principal) (platform (string-ascii 20)))
    (begin
        (asserts! (is-trusted-verifier tx-sender) err-not-owner)
        (asserts! (is-verified user platform) err-not-verified)
        (ok (map-delete verifications { user: user, platform: platform }))
    )
)
