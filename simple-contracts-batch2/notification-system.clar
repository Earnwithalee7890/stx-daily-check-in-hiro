;; notification-system contract

(define-map notifications uint { recipient: principal, message: (string-utf8 200), read: bool })
(define-data-var notification-id uint u0)

(define-read-only (get-notification (id uint))
  (map-get? notifications id)
)

(define-public (send-notification (recipient principal) (message (string-utf8 200)))
  (let ((id (+ (var-get notification-id) u1)))
    (map-set notifications id { recipient: recipient, message: message, read: false })
    (var-set notification-id id)
    (ok id)
  )
)

(define-public (mark-as-read (id uint))
  (match (map-get? notifications id)
    notif (begin
      (asserts! (is-eq (get recipient notif) tx-sender) (err u1))
      (map-set notifications id (merge notif { read: true }))
      (ok true)
    )
    (err u2)
  )
)
