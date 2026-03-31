;; Voting Poll Contract
;; Simple on-chain polls and voting

(define-map polls
    uint
    { 
        creator: principal, 
        question: (string-utf8 200),
        option-a: (string-ascii 50),
        option-b: (string-ascii 50),
        votes-a: uint,
        votes-b: uint,
        end-block: uint
    }
)

(define-map user-votes
    { poll-id: uint, voter: principal }
    uint
)

(define-data-var poll-counter uint u0)

(define-read-only (get-poll (poll-id uint))
    (map-get? polls poll-id)
)

(define-read-only (has-voted (poll-id uint) (voter principal))
    (is-some (map-get? user-votes { poll-id: poll-id, voter: voter }))
)

(define-read-only (get-vote (poll-id uint) (voter principal))
    (map-get? user-votes { poll-id: poll-id, voter: voter })
)

(define-public (create-poll (question (string-utf8 200)) (option-a (string-ascii 50)) (option-b (string-ascii 50)) (duration uint))
    (let (
        (poll-id (+ (var-get poll-counter) u1))
    )
        (map-set polls poll-id {
            creator: tx-sender,
            question: question,
            option-a: option-a,
            option-b: option-b,
            votes-a: u0,
            votes-b: u0,
            end-block: (+ block-height duration)
        })
        (var-set poll-counter poll-id)
        (ok poll-id)
    )
)

(define-public (vote (poll-id uint) (choice uint))
    (match (map-get? polls poll-id)
        poll (begin
            (asserts! (< block-height (get end-block poll)) (err u1))
            (asserts! (not (has-voted poll-id tx-sender)) (err u2))
            (asserts! (or (is-eq choice u1) (is-eq choice u2)) (err u3))
            (map-set user-votes { poll-id: poll-id, voter: tx-sender } choice)
            (if (is-eq choice u1)
                (map-set polls poll-id (merge poll { votes-a: (+ (get votes-a poll) u1) }))
                (map-set polls poll-id (merge poll { votes-b: (+ (get votes-b poll) u1) }))
            )
            (ok true)
        )
        (err u4)
    )
)
