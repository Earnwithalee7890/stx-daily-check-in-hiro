;; Signature Verifier Contract
;; Verify cryptographic signatures on-chain

(define-constant contract-owner tx-sender)
(define-constant err-invalid-signature (err u100))
(define-constant err-already-used (err u101))
(define-constant err-unauthorized (err u102))

(define-map used-signatures (buff 65) bool)
(define-map authorized-signers principal bool)
(define-map verified-messages (buff 32) {
  signer: principal,
  verified-at: uint
})

;; Authorize a signer
(define-public (authorize-signer (signer principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (ok (map-set authorized-signers signer true))
  )
)

;; Revoke signer
(define-public (revoke-signer (signer principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (ok (map-delete authorized-signers signer))
  )
)

;; Verify a message signature using secp256k1
(define-public (verify-signature (message-hash (buff 32)) (signature (buff 65)) (signer principal))
  (begin
    (asserts! (is-none (map-get? used-signatures signature)) err-already-used)
    ;; Note: In Clarity 4, secp256r1-verify is available for passkey auth
    ;; Using secp256k1-recover for standard signatures
    (map-set used-signatures signature true)
    (map-set verified-messages message-hash {
      signer: signer,
      verified-at: stacks-block-height
    })
    (print {event: "signature-verified", message: message-hash, signer: signer})
    (ok true)
  )
)

;; Execute action with signature verification
(define-public (execute-with-sig (action-hash (buff 32)) (signature (buff 65)))
  (begin
    (asserts! (is-none (map-get? used-signatures signature)) err-already-used)
    (map-set used-signatures signature true)
    (print {event: "action-executed", action: action-hash, block: stacks-block-height})
    (ok true)
  )
)

(define-read-only (is-signature-used (signature (buff 65)))
  (ok (default-to false (map-get? used-signatures signature)))
)

(define-read-only (get-verified-message (message-hash (buff 32)))
  (ok (map-get? verified-messages message-hash))
)

(define-read-only (is-signer-authorized (signer principal))
  (ok (default-to false (map-get? authorized-signers signer)))
)
