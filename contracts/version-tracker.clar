;; title: version-tracker
;; summary: Tracks versions of deployed protocols and contracts.

(define-data-var current-version (string-ascii 10) "1.0.0")

(define-public (update-version (new-v (string-ascii 10)))
    (begin
        (var-set current-version new-v)
        (ok new-v)
    )
)

(define-read-only (get-version)
    (ok (var-get current-version))
)
