;; title: snapshot-helper
;; summary: Helper for taking on-chain builder activity snapshots.

(define-map snapshots uint { count: uint, block: uint })

(define-public (take-snapshot (id uint) (count uint))
    (begin
        (map-set snapshots id { count: count, block: stacks-block-height })
        (ok true)
    )
)

(define-read-only (get-snapshot (id uint))
    (map-get? snapshots id)
)
