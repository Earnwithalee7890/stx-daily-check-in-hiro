;; Example: Creating and voting on polls

;; Create a poll
(contract-call? .voting-poll create-poll 
    u"What's your favorite blockchain?"
    "Stacks"
    "Bitcoin"
    u1440  ;; 1440 blocks (~10 days)
)

;; Vote on poll #1 for option 1 (Stacks)
(contract-call? .voting-poll vote u1 u1)

;; Check poll results
(contract-call? .voting-poll get-poll u1)

;; Check if user has voted
(contract-call? .voting-poll has-voted u1 tx-sender)
