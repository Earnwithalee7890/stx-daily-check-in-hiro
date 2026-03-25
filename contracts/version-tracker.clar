;; title: version-tracker
;; summary: Tracks versions and status of all deployed ecosystem components.

(define-constant err-owner-only (err u100))
(define-data-var contract-owner principal tx-sender)
(define-data-var current-version (string-ascii 10) "1.1.0")
(define-data-var maintenance-mode bool false)

(define-map contract-versions (string-ascii 32) (string-ascii 10))

(define-public (update-version (new-v (string-ascii 10)))
    (begin
        (asserts! (is-eq tx-sender (var-get contract-owner)) err-owner-only)
        (var-set current-version new-v)
        (ok new-v)
    )
)

(define-public (register-contract-version (name (string-ascii 32)) (version (string-ascii 10)))
    (begin
        (asserts! (is-eq tx-sender (var-get contract-owner)) err-owner-only)
        (map-set contract-versions name version)
        (ok true)
    )
)

(define-public (set-maintenance-mode (mode bool))
    (begin
        (asserts! (is-eq tx-sender (var-get contract-owner)) err-owner-only)
        (var-set maintenance-mode mode)
        (ok mode)
    )
)

(define-read-only (get-version)
    (ok (var-get current-version))
)

(define-read-only (get-contract-version (name (string-ascii 32)))
    (map-get? contract-versions name)
)

(define-read-only (get-system-status)
    (ok {
        version: (var-get current-version),
        maintenance-mode: (var-get maintenance-mode),
        owner: (var-get contract-owner)
    })
)
