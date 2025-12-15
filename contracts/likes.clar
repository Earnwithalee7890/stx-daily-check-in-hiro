;; Likes Contract
;; Count likes per item

(define-map likes uint uint)

(define-public (like (item-id uint))
  (ok (map-set likes item-id (+ (get-likes item-id) u1)))
)

(define-read-only (get-likes (item-id uint))
  (default-to u0 (map-get? likes item-id))
)
