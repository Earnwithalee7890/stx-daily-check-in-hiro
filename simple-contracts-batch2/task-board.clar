;; task-board contract

(define-map tasks uint { title: (string-utf8 100), owner: principal, completed: bool })
(define-data-var task-count uint u0)

(define-read-only (get-task (id uint))
  (map-get? tasks id)
)

(define-public (create-task (title (string-utf8 100)))
  (let ((id (+ (var-get task-count) u1)))
    (map-set tasks id { title: title, owner: tx-sender, completed: false })
    (var-set task-count id)
    (ok id)
  )
)

(define-public (complete-task (id uint))
  (match (map-get? tasks id)
    task (begin
      (asserts! (is-eq (get owner task) tx-sender) (err u1))
      (map-set tasks id (merge task { completed: true }))
      (ok true)
    )
    (err u2)
  )
)
