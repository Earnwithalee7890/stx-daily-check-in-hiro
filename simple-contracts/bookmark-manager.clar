;; Bookmark Manager Contract
;; Store and organize bookmarks on-chain

(define-map bookmarks
    { owner: principal, id: uint }
    { 
        url: (string-ascii 200), 
        title: (string-utf8 100),
        tags: (string-ascii 100),
        saved-at: uint 
    }
)

(define-map bookmark-count principal uint)

(define-read-only (get-bookmark (owner principal) (id uint))
    (map-get? bookmarks { owner: owner, id: id })
)

(define-read-only (get-bookmark-count (owner principal))
    (default-to u0 (map-get? bookmark-count owner))
)

(define-public (save-bookmark (url (string-ascii 200)) (title (string-utf8 100)) (tags (string-ascii 100)))
    (let (
        (count (get-bookmark-count tx-sender))
        (new-id (+ count u1))
    )
        (map-set bookmarks
            { owner: tx-sender, id: new-id }
            { url: url, title: title, tags: tags, saved-at: block-height }
        )
        (map-set bookmark-count tx-sender new-id)
        (ok new-id)
    )
)

(define-public (update-bookmark (id uint) (url (string-ascii 200)) (title (string-utf8 100)) (tags (string-ascii 100)))
    (match (map-get? bookmarks { owner: tx-sender, id: id })
        bookmark (begin
            (map-set bookmarks
                { owner: tx-sender, id: id }
                { url: url, title: title, tags: tags, saved-at: (get saved-at bookmark) }
            )
            (ok true)
        )
        (err u1)
    )
)

(define-public (delete-bookmark (id uint))
    (if (is-some (map-get? bookmarks { owner: tx-sender, id: id }))
        (begin
            (map-delete bookmarks { owner: tx-sender, id: id })
            (ok true)
        )
        (err u1)
    )
)
