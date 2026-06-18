;; title: Builder Activity Tracker
;; version: 1.0.0
;; summary: A community activity tracker and grant distributor with 0 STX fees for users.

;; constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-already-claimed (err u101))
(define-constant err-not-found (err u102))
(define-constant err-invalid-amount (err u103))
(define-constant err-contract-inactive (err u104))

;; Fee constants (0 STX)
(define-constant app-fee-log u0)
(define-constant app-fee-claim u0)
(define-constant grant-amount u100000) ;; 0.1 STX grant (if funded)

;; data vars
(define-data-var total-grants-distributed uint u0)
(define-data-var contract-active bool true)
(define-data-var total-unique-users uint u0)
(define-data-var total-activities-logged uint u0)
(define-data-var total-claims uint u0)

;; data maps
(define-map user-claims principal bool)
(define-map daily-activities principal (list 365 uint))

(define-map user-activity principal {
  first-interaction: uint,
  total-interactions: uint
})

;; public functions

;; Log daily activity with 0 STX fee
(define-public (log-activity)
  (let
    (
      (caller tx-sender)
      (current-day (/ stacks-block-height u144))
      (existing-activities (default-to (list) (map-get? daily-activities caller)))
    )
    (asserts! (var-get contract-active) err-contract-inactive)
    
    (track-user caller)
    (var-set total-activities-logged (+ (var-get total-activities-logged) u1))
    
    (map-set daily-activities caller 
      (unwrap-panic (as-max-len? (append existing-activities current-day) u365)))
    
    (ok true)
  )
)

;; Claim grant with 0 STX fee (Status upgrade instead of STX transfer)
(define-public (claim-grant)
  (let
    (
      (caller tx-sender)
      (has-claimed (default-to false (map-get? user-claims caller)))
    )
    (asserts! (var-get contract-active) err-contract-inactive)
    (asserts! (not has-claimed) err-already-claimed)
    
    (track-user caller)
    (map-set user-claims caller true)
    (var-set total-claims (+ (var-get total-claims) u1))
    (var-set total-grants-distributed (+ (var-get total-grants-distributed) u1))
    
    (ok true)
  )
)

;; Removed fund-grants as this contract no longer handles STX

(define-public (toggle-contract-status)
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (var-set contract-active (not (var-get contract-active)))
    (ok (var-get contract-active))
  )
)

;; read only functions

(define-read-only (get-unique-user-count)
  (ok (var-get total-unique-users))
)

(define-read-only (get-user-activity (user principal))
  (ok (map-get? user-activity user))
)

(define-read-only (get-total-grants)
  (ok (var-get total-grants-distributed))
)

;; grant pool removed

(define-read-only (has-user-claimed (user principal))
  (ok (default-to false (map-get? user-claims user)))
)

(define-read-only (get-activity-count (user principal))
  (ok (len (default-to (list) (map-get? daily-activities user))))
)

(define-read-only (is-contract-active)
  (ok (var-get contract-active))
)

;; private functions

(define-private (track-user (user principal))
  (match (map-get? user-activity user)
    activity (map-set user-activity user {
      first-interaction: (get first-interaction activity),
      total-interactions: (+ (get total-interactions activity) u1)
    })
    (begin
      (map-set user-activity user {
        first-interaction: stacks-block-height,
        total-interactions: u1
      })
      (var-set total-unique-users (+ (var-get total-unique-users) u1))
    )
  )
)
