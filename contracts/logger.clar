;; Logger Contract
;; Simple event log

(define-data-var log-count uint u0)

(define-public (log (msg (string-ascii 50)))
  (begin
    (var-set log-count (+ (var-get log-count) u1))
    (print {id: (var-get log-count), msg: msg})
    (ok (var-get log-count))
  )
)

(define-read-only (get-log-count)
  (ok (var-get log-count))
)
