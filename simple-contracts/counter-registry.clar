;; Counter Registry Contract
;; Personal counters for any use

(define-map counters
    { owner: principal, name: (string-ascii 32) }
    uint
)

(define-read-only (get-counter (owner principal) (name (string-ascii 32)))
    (default-to u0 (map-get? counters { owner: owner, name: name }))
)

(define-public (create-counter (name (string-ascii 32)))
    (begin
        (asserts! (is-none (map-get? counters { owner: tx-sender, name: name })) (err u1))
        (map-set counters { owner: tx-sender, name: name } u0)
        (ok true)
    )
)

(define-public (increment (name (string-ascii 32)))
    (let (
        (current (get-counter tx-sender name))
    )
        (map-set counters { owner: tx-sender, name: name } (+ current u1))
        (ok (+ current u1))
    )
)

(define-public (decrement (name (string-ascii 32)))
    (let (
        (current (get-counter tx-sender name))
    )
        (asserts! (> current u0) (err u2))
        (map-set counters { owner: tx-sender, name: name } (- current u1))
        (ok (- current u1))
    )
)

(define-public (reset-counter (name (string-ascii 32)))
    (begin
        (map-set counters { owner: tx-sender, name: name } u0)
        (ok u0)
    )
)

(define-public (set-counter (name (string-ascii 32)) (value uint))
    (begin
        (map-set counters { owner: tx-sender, name: name } value)
        (ok value)
    )
)
