;; comment-system contract

(define-map comments uint { author: principal, content: (string-utf8 500), post-id: uint })
(define-data-var comment-count uint u0)

(define-read-only (get-comment (id uint))
  (map-get? comments id)
)

(define-public (post-comment (post-id uint) (content (string-utf8 500)))
  (let ((id (+ (var-get comment-count) u1)))
    (map-set comments id { author: tx-sender, content: content, post-id: post-id })
    (var-set comment-count id)
    (ok id)
  )
)

(define-public (delete-comment (id uint))
  (match (map-get? comments id)
    comment (begin
      (asserts! (is-eq (get author comment) tx-sender) (err u1))
      (map-delete comments id)
      (ok true)
    )
    (err u2)
  )
)
