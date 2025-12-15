;; Subscription Manager Contract
;; Manage recurring subscription payments

(define-constant contract-owner tx-sender)
(define-constant err-not-found (err u100))
(define-constant err-expired (err u101))
(define-constant err-unauthorized (err u102))

(define-data-var subscription-nonce uint u0)

(define-map subscriptions uint {
  subscriber: principal,
  service: principal,
  amount: uint,
  interval-blocks: uint,
  start-block: uint,
  end-block: uint,
  last-charged: uint,
  active: bool
})

(define-map service-subscribers principal (list 100 uint))

;; Create subscription
(define-public (subscribe (service principal) (amount uint) (interval-blocks uint) (duration-blocks uint))
  (let (
    (sub-id (var-get subscription-nonce))
    (caller tx-sender)
  )
    (try! (stx-transfer? amount caller service))
    (map-set subscriptions sub-id {
      subscriber: caller,
      service: service,
      amount: amount,
      interval-blocks: interval-blocks,
      start-block: stacks-block-height,
      end-block: (+ stacks-block-height duration-blocks),
      last-charged: stacks-block-height,
      active: true
    })
    (var-set subscription-nonce (+ sub-id u1))
    (ok sub-id)
  )
)

;; Charge subscription (called by service)
(define-public (charge (sub-id uint))
  (let (
    (sub (unwrap! (map-get? subscriptions sub-id) err-not-found))
  )
    (asserts! (is-eq tx-sender (get service sub)) err-unauthorized)
    (asserts! (get active sub) err-expired)
    (asserts! (<= stacks-block-height (get end-block sub)) err-expired)
    (asserts! (>= (- stacks-block-height (get last-charged sub)) (get interval-blocks sub)) err-unauthorized)
    (try! (stx-transfer? (get amount sub) (get subscriber sub) (get service sub)))
    (ok (map-set subscriptions sub-id (merge sub {last-charged: stacks-block-height})))
  )
)

;; Cancel subscription
(define-public (cancel (sub-id uint))
  (let ((sub (unwrap! (map-get? subscriptions sub-id) err-not-found)))
    (asserts! (is-eq tx-sender (get subscriber sub)) err-unauthorized)
    (ok (map-set subscriptions sub-id (merge sub {active: false})))
  )
)

(define-read-only (get-subscription (sub-id uint))
  (ok (map-get? subscriptions sub-id))
)

(define-read-only (is-active (sub-id uint))
  (match (map-get? subscriptions sub-id)
    sub (ok (and (get active sub) (<= stacks-block-height (get end-block sub))))
    (ok false)
  )
)
