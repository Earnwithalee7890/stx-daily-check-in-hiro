;; Counter V2 Contract
;; Double counter

(define-data-var counter-a uint u0)
(define-data-var counter-b uint u0)

(define-public (inc-a)
  (ok (var-set counter-a (+ (var-get counter-a) u1)))
)

(define-public (inc-b)
  (ok (var-set counter-b (+ (var-get counter-b) u1)))
)

(define-read-only (get-counts)
  (ok {a: (var-get counter-a), b: (var-get counter-b)})
)
