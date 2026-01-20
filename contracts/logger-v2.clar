;; title: logger-v2
;; summary: Enhanced logging for builder activity and protocol events.

(define-public (log-event (msg (string-ascii 50)) (code uint))
    (begin
        (print { msg: msg, code: code, user: tx-sender, time: stacks-block-height })
        (ok true)
    )
)
