;; Message Board Contract
;; Simple on-chain message storage

(define-map messages 
    { id: uint } 
    { author: principal, content: (string-utf8 280), timestamp: uint }
)

(define-data-var message-count uint u0)

(define-read-only (get-message (id uint))
    (map-get? messages { id: id })
)

(define-read-only (get-message-count)
    (var-get message-count)
)

(define-public (post-message (content (string-utf8 280)))
    (let (
        (new-id (+ (var-get message-count) u1))
    )
        (map-set messages 
            { id: new-id } 
            { author: tx-sender, content: content, timestamp: block-height }
        )
        (var-set message-count new-id)
        (ok new-id)
    )
)

(define-public (delete-message (id uint))
    (match (map-get? messages { id: id })
        msg (if (is-eq (get author msg) tx-sender)
                (begin
                    (map-delete messages { id: id })
                    (ok true)
                )
                (err u1)
            )
        (err u2)
    )
)
