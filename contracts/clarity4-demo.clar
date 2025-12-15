;; Clarity 4 Demo - Builder Challenge Contract
;; Demonstrates new Clarity 4 features

;; Data storage
(define-data-var counter uint u0)
(define-map user-records principal uint)

;; Public function to increment counter
(define-public (increment)
  (begin
    (var-set counter (+ (var-get counter) u1))
    (map-set user-records tx-sender (+ (default-to u0 (map-get? user-records tx-sender)) u1))
    (ok (var-get counter))
  )
)

;; Read-only function to get counter
(define-read-only (get-counter)
  (var-get counter)
)

;; Read-only function to get user record
(define-read-only (get-user-record (user principal))
  (default-to u0 (map-get? user-records user))
)

;; Clarity 4 feature: Enhanced error handling
(define-public (safe-increment (max-value uint))
  (let ((current (var-get counter)))
    (if (<= current max-value)
      (begin
        (var-set counter (+ current u1))
        (ok {new-value: (var-get counter), success: true}))
      (err u100)))
)
