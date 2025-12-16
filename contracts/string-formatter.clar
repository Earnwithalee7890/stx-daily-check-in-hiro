;; String Formatter Contract
;; String utilities for cross-chain messages

(define-constant contract-owner tx-sender)
(define-constant err-string-too-long (err u100))

(define-data-var message-count uint u0)

(define-map formatted-messages uint {
  original: (string-utf8 256),
  formatted: (string-ascii 256),
  created-by: principal,
  created-at: uint
})

;; Store a formatted message
(define-public (store-message (message (string-utf8 256)))
  (let (
    (msg-id (var-get message-count))
    (caller tx-sender)
  )
    (map-set formatted-messages msg-id {
      original: message,
      formatted: "message-stored",
      created-by: caller,
      created-at: stacks-block-height
    })
    (var-set message-count (+ msg-id u1))
    (print {event: "message-stored", id: msg-id, by: caller})
    (ok msg-id)
  )
)

;; Store with ASCII label
(define-public (store-labeled-message (label (string-ascii 32)) (message (string-utf8 256)))
  (let (
    (msg-id (var-get message-count))
    (caller tx-sender)
  )
    (map-set formatted-messages msg-id {
      original: message,
      formatted: label,
      created-by: caller,
      created-at: stacks-block-height
    })
    (var-set message-count (+ msg-id u1))
    (print {event: "labeled-message", id: msg-id, label: label})
    (ok msg-id)
  )
)

;; Create formatted output for external systems
(define-public (format-for-bridge (msg-id uint) (bridge-id (string-ascii 32)))
  (match (map-get? formatted-messages msg-id)
    msg (begin
      (print {
        event: "bridge-format",
        msg-id: msg-id,
        bridge: bridge-id,
        block: stacks-block-height
      })
      (ok true)
    )
    (err u101)
  )
)

(define-read-only (get-message (msg-id uint))
  (ok (map-get? formatted-messages msg-id))
)

(define-read-only (get-message-count)
  (ok (var-get message-count))
)

;; Utility: Check string length
(define-read-only (is-valid-length (s (string-ascii 256)) (max-len uint))
  (ok (<= (len s) max-len))
)

;; Utility: Get creation block for a message
(define-read-only (get-message-block (msg-id uint))
  (match (map-get? formatted-messages msg-id)
    msg (ok (get created-at msg))
    (err u102)
  )
)
