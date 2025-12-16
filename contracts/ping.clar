;; Ping Contract
;; Simple ping-pong

(define-data-var pings uint u0)

(define-public (ping)
  (begin
    (var-set pings (+ (var-get pings) u1))
    (ok "pong")
  )
)

(define-read-only (get-pings)
  (ok (var-get pings))
)
