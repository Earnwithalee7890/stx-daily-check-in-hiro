;; title: address-utils
;; summary: Address and principal utility functions.

(define-read-only (is-contract (addr principal))
    (ok (is-some (get-block-info? header-hash u0))) ;; Basic check
)

(define-read-only (is-owner (addr principal))
    (ok (is-eq addr (var-get contract-owner)))
)

(define-data-var contract-owner principal tx-sender)
