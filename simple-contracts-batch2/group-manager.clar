;; group-manager contract

(define-map groups uint { name: (string-ascii 50), owner: principal, member-count: uint })
(define-map group-members { group-id: uint, member: principal } bool)
(define-data-var group-id-counter uint u0)

(define-read-only (get-group (id uint))
  (map-get? groups id)
)

(define-read-only (is-member (group-id uint) (member principal))
  (default-to false (map-get? group-members { group-id: group-id, member: member }))
)

(define-public (create-group (name (string-ascii 50)))
  (let ((id (+ (var-get group-id-counter) u1)))
    (map-set groups id { name: name, owner: tx-sender, member-count: u1 })
    (map-set group-members { group-id: id, member: tx-sender } true)
    (var-set group-id-counter id)
    (ok id)
  )
)

(define-public (join-group (group-id uint))
  (begin
    (map-set group-members { group-id: group-id, member: tx-sender } true)
    (ok true)
  )
)
