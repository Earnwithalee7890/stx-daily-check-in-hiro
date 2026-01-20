;; title: metadata-registry
;; summary: Stores metadata for various builder assets.

(define-map metadata (string-ascii 32) (string-ascii 100))

(define-public (store-metadata (key (string-ascii 32)) (val (string-ascii 100)))
    (begin
        (map-set metadata key val)
        (ok true)
    )
)

(define-read-only (get-metadata (key (string-ascii 32)))
    (map-get? metadata key)
)
