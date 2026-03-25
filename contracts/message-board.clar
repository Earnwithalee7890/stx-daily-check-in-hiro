;; Message Board Contract
;; Post and read messages

(define-map messages uint {author: principal, content: (string-utf8 256), timestamp: uint})
(define-data-var message-count uint u0)

(define-public (post-message (content (string-utf8 256)))
  (let 
    ((msg-id (var-get message-count)))
    (map-set messages msg-id {
      author: tx-sender,
      content: content,
      timestamp: stacks-block-height
    })
    (var-set message-count (+ msg-id u1))
    (ok msg-id)
  )
)

(define-public (delete-message (id uint))
  (let ((msg (unwrap! (get-message id) (err u404))))
    (match msg
      message (if (is-eq (get author message) tx-sender)
                  (begin
                    (map-delete messages id)
                    (ok true))
                  (err u403))
      (err u404)
    )
  )
)

(define-read-only (get-message (id uint))
  (map-get? messages id)
)

(define-read-only (get-message-count)
  (ok (var-get message-count))
)
