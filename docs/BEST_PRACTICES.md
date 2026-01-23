# Clarity Best Practices

## Contract Structure

### 1. Organize Code Logically

```clarity
;; Contract: My Contract
;; Description: What it does

;; === CONSTANTS ===
(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u1))

;; === DATA STORAGE ===
(define-map my-map principal uint)
(define-data-var counter uint u0)

;; === PRIVATE FUNCTIONS ===
(define-private (helper-function)
    ;; logic
)

;; === READ-ONLY FUNCTIONS ===
(define-read-only (get-data)
    ;; read logic
)

;; === PUBLIC FUNCTIONS ===
(define-public (main-function)
    ;; write logic
)
```

### 2. Error Handling

```clarity
;; Bad
(define-constant err-1 (err u1))
(define-constant err-2 (err u2))

;; Good
(define-constant err-not-authorized (err u100))
(define-constant err-not-found (err u101))
(define-constant err-invalid-amount (err u102))
```

### 3. Input Validation

```clarity
;; Always validate inputs first
(define-public (transfer (amount uint) (recipient principal))
    (begin
        ;; Validate
        (asserts! (> amount u0) err-invalid-amount)
        (asserts! (not (is-eq recipient tx-sender)) err-self-transfer)
        
        ;; Execute
        (ok true)
    )
)
```

## Performance

### 1. Minimize Map Reads

```clarity
;; Bad - reads map 3 times
(define-public (bad-function)
    (begin
        (asserts! (is-some (map-get? data user)) err-not-found)
        (let ((value (unwrap! (map-get? data user) err-not-found)))
            (map-set data user (+ value u1))
        )
    )
)

;; Good - reads map 1 time
(define-public (good-function)
    (match (map-get? data user)
        value
            (map-set data user (+ value u1))
        err-not-found
    )
)
```

### 2. Use Appropriate Data Structures

- Maps for key-value lookups
- Data-vars for single global values
- Lists for small, fixed-size collections

### 3. Avoid Unnecessary Computations

```clarity
;; Cache expensive operations
(let ((expensive-result (complex-calculation)))
    (do-something expensive-result)
    (do-another-thing expensive-result)
)
```

## Security

### 1. Access Control

```clarity
(define-constant contract-owner tx-sender)

(define-public (admin-only-function)
    (begin
        (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
        ;; admin logic
    )
)
```

### 2. Check Before State Changes

```clarity
;; Checks-Effects-Interactions pattern
(define-public (safe-function)
    (begin
        ;; 1. Checks
        (asserts! (is-authorized tx-sender) err-unauthorized)
        
        ;; 2. Effects
        (map-set state key new-value)
        
        ;; 3. Interactions (if any)
        (ok true)
    )
)
```

### 3. Avoid Integer Overflow

Clarity prevents overflow automatically, but be mindful:

```clarity
;; Safe - will return error on overflow
(+ very-large-number u1)

;; Always validate bounds
(asserts! (<= amount max-amount) err-exceeds-maximum)
```

## Testing

### 1. Test All Paths

```clarity
;; Test success case
;; Test each error case
;; Test edge cases (zero, max values)
;; Test unauthorized access
```

### 2. Use Descriptive Test Names

```typescript
it('should reject transfer from non-owner')
it('should accept transfer when balance sufficient')
it('should emit correct event on successful transfer')
```

## Documentation

### 1. Comment Complex Logic

```clarity
;; Calculate reward based on staking duration
;; Formula: base-reward * (duration / 144 blocks)
;; Where 144 blocks ≈ 1 day on Stacks
(define-private (calculate-reward)
    ;; implementation
)
```

### 2. Document Public Interface

```clarity
;; Public function: stake
;; Stakes STX tokens for rewards
;; @param amount - Amount of STX to stake (micro-STX)
;; @returns (ok uint) - Stake ID
;; @returns (err u1) - Invalid amount
;; @returns (err u2) - Insufficient balance
```
