;; referral-tracker contract

(define-map referrals principal { referrer: principal, count: uint })
(define-map referred-by principal principal)

(define-read-only (get-referrer (user principal))
  (map-get? referred-by user)
)

(define-read-only (get-referral-count (user principal))
  (default-to u0 (get count (map-get? referrals user)))
)

(define-public (register-referral (referrer principal))
  (begin
    (asserts! (is-none (map-get? referred-by tx-sender)) (err u1))
    (map-set referred-by tx-sender referrer)
    (map-set referrals referrer { referrer: referrer, count: (+ (get-referral-count referrer) u1) })
    (ok true)
  )
)
