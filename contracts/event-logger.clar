;; Event Logger Contract
;; On-chain event logging system

(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))

(define-data-var event-nonce uint u0)

(define-map events uint {
  emitter: principal,
  event-type: (string-ascii 32),
  data: (string-utf8 256),
  block-height: uint
})

(define-map emitter-events principal (list 1000 uint))
(define-map authorized-emitters principal bool)

;; Log an event
(define-public (log-event (event-type (string-ascii 32)) (data (string-utf8 256)))
  (let (
    (caller tx-sender)
    (event-id (var-get event-nonce))
  )
    (map-set events event-id {
      emitter: caller,
      event-type: event-type,
      data: data,
      block-height: stacks-block-height
    })
    (var-set event-nonce (+ event-id u1))
    (print {type: event-type, emitter: caller, id: event-id, data: data})
    (ok event-id)
  )
)

;; Log authorized event (for contracts)
(define-public (log-authorized-event (event-type (string-ascii 32)) (data (string-utf8 256)) (on-behalf principal))
  (let (
    (caller tx-sender)
    (event-id (var-get event-nonce))
  )
    (asserts! (default-to false (map-get? authorized-emitters caller)) err-unauthorized)
    (map-set events event-id {
      emitter: on-behalf,
      event-type: event-type,
      data: data,
      block-height: stacks-block-height
    })
    (var-set event-nonce (+ event-id u1))
    (print {type: event-type, emitter: on-behalf, id: event-id, data: data})
    (ok event-id)
  )
)

;; Authorize emitter
(define-public (authorize-emitter (emitter principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (ok (map-set authorized-emitters emitter true))
  )
)

(define-read-only (get-event (event-id uint))
  (ok (map-get? events event-id))
)

(define-read-only (get-event-count)
  (ok (var-get event-nonce))
)

(define-read-only (get-latest-events (count uint))
  (let ((total (var-get event-nonce)))
    (ok {total: total, latest-id: (if (> total u0) (- total u1) u0)})
  )
)
