;; Note Storage Contract
;; Private notes on-chain

(define-map notes
    { owner: principal, id: uint }
    { 
        title: (string-utf8 100),
        content: (string-utf8 500),
        updated-at: uint
    }
)

(define-map note-count principal uint)

(define-read-only (get-note (owner principal) (id uint))
    (map-get? notes { owner: owner, id: id })
)

(define-read-only (get-note-count (owner principal))
    (default-to u0 (map-get? note-count owner))
)

(define-public (create-note (title (string-utf8 100)) (content (string-utf8 500)))
    (let (
        (count (get-note-count tx-sender))
        (new-id (+ count u1))
    )
        (map-set notes
            { owner: tx-sender, id: new-id }
            { title: title, content: content, updated-at: block-height }
        )
        (map-set note-count tx-sender new-id)
        (ok new-id)
    )
)

(define-public (update-note (id uint) (title (string-utf8 100)) (content (string-utf8 500)))
    (match (map-get? notes { owner: tx-sender, id: id })
        note (begin
            (map-set notes
                { owner: tx-sender, id: id }
                { title: title, content: content, updated-at: block-height }
            )
            (ok true)
        )
        (err u1)
    )
)

(define-public (delete-note (id uint))
    (if (is-some (map-get? notes { owner: tx-sender, id: id }))
        (begin
            (map-delete notes { owner: tx-sender, id: id })
            (ok true)
        )
        (err u1)
    )
)
