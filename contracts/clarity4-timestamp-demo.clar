;; Clarity 4 Demo - Block Timestamp Feature
;; This contract showcases new Clarity 4 functionality

;; Data vars
(define-data-var last-timestamp uint u0)
(define-data-var timestamp-count uint u0)

;; Public function that uses the new Clarity 4 'block-timestamp' keyword
(define-public (record-timestamp)
  (let ((current-time block-timestamp))
    (var-set last-timestamp current-time)
    (var-set timestamp-count (+ (var-get timestamp-count) u1))
    (ok {timestamp: current-time, count: (var-get timestamp-count)})
  )
)

;; Read-only functions
(define-read-only (get-last-timestamp)
  (var-get last-timestamp)
)

(define-read-only (get-timestamp-count)
  (var-get timestamp-count)
)

(define-read-only (get-current-block-time)
  block-timestamp
)
