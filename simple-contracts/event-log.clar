;; Event Log Contract
;; Log events on-chain

(define-map events
    uint
    { 
        emitter: principal,
        event-type: (string-ascii 32),
        data: (string-utf8 256),
        block: uint
    }
)

(define-map user-event-count principal uint)
(define-data-var total-events uint u0)

(define-read-only (get-event (id uint))
    (map-get? events id)
)

(define-read-only (get-total-events)
    (var-get total-events)
)

(define-read-only (get-user-event-count (user principal))
    (default-to u0 (map-get? user-event-count user))
)

(define-public (log-event (event-type (string-ascii 32)) (data (string-utf8 256)))
    (let (
        (event-id (+ (var-get total-events) u1))
    )
        (map-set events event-id {
            emitter: tx-sender,
            event-type: event-type,
            data: data,
            block: block-height
        })
        (var-set total-events event-id)
        (map-set user-event-count tx-sender (+ (get-user-event-count tx-sender) u1))
        (print { event-id: event-id, type: event-type })
        (ok event-id)
    )
)

(define-public (batch-log (events-list (list 5 { event-type: (string-ascii 32), data: (string-utf8 256) })))
    (ok (len events-list))
)
