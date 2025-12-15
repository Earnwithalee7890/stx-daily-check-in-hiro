;; Delegation System Contract
;; Delegate voting power to others

(define-constant err-already-delegated (err u100))
(define-constant err-cannot-delegate-to-self (err u101))
(define-constant err-no-delegation (err u102))

(define-map delegations principal principal)
(define-map delegation-power principal uint)
(define-map voting-power principal uint)

;; Set initial voting power
(define-public (set-voting-power (user principal) (power uint))
  (begin
    (map-set voting-power user power)
    (map-set delegation-power user power)
    (ok true)
  )
)

;; Delegate votes to another user
(define-public (delegate (to principal))
  (let (
    (caller tx-sender)
    (caller-power (default-to u0 (map-get? voting-power caller)))
    (current-delegate (map-get? delegations caller))
  )
    (asserts! (not (is-eq caller to)) err-cannot-delegate-to-self)
    ;; Remove from current delegate if exists
    (match current-delegate
      prev-delegate (map-set delegation-power prev-delegate 
        (- (default-to u0 (map-get? delegation-power prev-delegate)) caller-power))
      true
    )
    ;; Add to new delegate
    (map-set delegations caller to)
    (map-set delegation-power to 
      (+ (default-to u0 (map-get? delegation-power to)) caller-power))
    (ok true)
  )
)

;; Remove delegation
(define-public (undelegate)
  (let (
    (caller tx-sender)
    (caller-power (default-to u0 (map-get? voting-power caller)))
    (current-delegate (unwrap! (map-get? delegations caller) err-no-delegation))
  )
    (map-set delegation-power current-delegate 
      (- (default-to u0 (map-get? delegation-power current-delegate)) caller-power))
    (map-set delegation-power caller 
      (+ (default-to u0 (map-get? delegation-power caller)) caller-power))
    (ok (map-delete delegations caller))
  )
)

(define-read-only (get-delegate (user principal))
  (ok (map-get? delegations user))
)

(define-read-only (get-voting-power (user principal))
  (ok (default-to u0 (map-get? voting-power user)))
)

(define-read-only (get-effective-power (user principal))
  (ok (default-to u0 (map-get? delegation-power user)))
)
