;; Todo List Contract
;; Personal on-chain task management

(define-map todos
    { owner: principal, id: uint }
    { 
        title: (string-utf8 100), 
        completed: bool, 
        created-at: uint 
    }
)

(define-map user-todo-count principal uint)

(define-read-only (get-todo (owner principal) (id uint))
    (map-get? todos { owner: owner, id: id })
)

(define-read-only (get-todo-count (owner principal))
    (default-to u0 (map-get? user-todo-count owner))
)

(define-public (add-todo (title (string-utf8 100)))
    (let (
        (current-count (get-todo-count tx-sender))
        (new-id (+ current-count u1))
    )
        (map-set todos 
            { owner: tx-sender, id: new-id }
            { title: title, completed: false, created-at: block-height }
        )
        (map-set user-todo-count tx-sender new-id)
        (ok new-id)
    )
)

(define-public (complete-todo (id uint))
    (match (map-get? todos { owner: tx-sender, id: id })
        todo (begin
            (map-set todos 
                { owner: tx-sender, id: id }
                (merge todo { completed: true })
            )
            (ok true)
        )
        (err u1)
    )
)

(define-public (delete-todo (id uint))
    (if (is-some (map-get? todos { owner: tx-sender, id: id }))
        (begin
            (map-delete todos { owner: tx-sender, id: id })
            (ok true)
        )
        (err u1)
    )
)
