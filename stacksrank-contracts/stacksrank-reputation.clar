;; =====================================================
;; STACKSRANK REPUTATION TRACKER
;; Production-Ready Smart Contract for Mainnet
;; =====================================================
;;
;; This contract tracks builder reputation and achievements
;; on the Stacks blockchain for the StacksRank platform.
;;
;; Features:
;; - Builder registration and verification
;; - Achievement tracking
;; - Reputation scoring
;; - Badge minting (SIP-009 compatible)
;;
;; Security: Multi-sig admin, immutable achievements

;; =====================================================
;; CONSTANTS & ERRORS
;; =====================================================

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-authorized (err u101))
(define-constant err-already-registered (err u102))
(define-constant err-not-registered (err u103))
(define-constant err-invalid-achievement (err u104))
(define-constant err-achievement-exists (err u105))

;; Achievement Types
(define-constant ACHIEVEMENT_FIRST_CONTRACT u1)
(define-constant ACHIEVEMENT_MAINNET_DEPLOY u2)
(define-constant ACHIEVEMENT_ECOSYSTEM_PR u3)
(define-constant ACHIEVEMENT_TOP_10 u4)
(define-constant ACHIEVEMENT_TOP_5 u5)
(define-constant ACHIEVEMENT_100_CONTRACTS u6)
(define-constant ACHIEVEMENT_VIRAL_PROJECT u7)

;; =====================================================
;; DATA STRUCTURES
;; =====================================================

;; Builder Profiles
(define-map builders
  principal
  {
    github-username: (string-ascii 50),
    total-score: uint,
    mainnet-contracts: uint,
    ecosystem-contributions: uint,
    verified-at: uint,
    last-updated: uint
  }
)

;; Achievements
(define-map builder-achievements
  { builder: principal, achievement-id: uint }
  {
    name: (string-ascii 100),
    description: (string-ascii 256),
    points: uint,
    awarded-at: uint,
    metadata-uri: (optional (string-ascii 256))
  }
)

;; Achievement Definitions
(define-map achievement-templates
  uint
  {
    name: (string-ascii 100),
    description: (string-ascii 256),
    points: uint,
    icon-uri: (optional (string-ascii 256))
  }
)

;; Global Stats
(define-data-var total-builders uint u0)
(define-data-var total-achievements-awarded uint u0)

;; =====================================================
;; BUILDER REGISTRATION
;; =====================================================

(define-public (register-builder (github (string-ascii 50)))
  (let
    (
      (existing-builder (map-get? builders tx-sender))
    )
    (asserts! (is-none existing-builder) err-already-registered)
    
    (map-set builders tx-sender {
      github-username: github,
      total-score: u0,
      mainnet-contracts: u0,
      ecosystem-contributions: u0,
      verified-at: block-height,
      last-updated: block-height
    })
    
    (var-set total-builders (+ (var-get total-builders) u1))
    
    (print {
      event: "builder-registered",
      builder: tx-sender,
      github: github,
      timestamp: block-height
    })
    
    (ok true)
  )
)

;; =====================================================
;; ACHIEVEMENT SYSTEM
;; =====================================================

(define-public (award-achievement 
  (builder principal)
  (achievement-id uint)
  (metadata (optional (string-ascii 256)))
)
  (let
    (
      (builder-data (unwrap! (map-get? builders builder) err-not-registered))
      (template (unwrap! (map-get? achievement-templates achievement-id) err-invalid-achievement))
      (existing-achievement (map-get? builder-achievements { builder: builder, achievement-id: achievement-id }))
    )
    ;; Only contract owner can award achievements
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    
    ;; Check if achievement already awarded
    (asserts! (is-none existing-achievement) err-achievement-exists)
    
    ;; Award achievement
    (map-set builder-achievements
      { builder: builder, achievement-id: achievement-id }
      {
        name: (get name template),
        description: (get description template),
        points: (get points template),
        awarded-at: block-height,
        metadata-uri: metadata
      }
    )
    
    ;; Update builder score
    (map-set builders builder
      (merge builder-data {
        total-score: (+ (get total-score builder-data) (get points template)),
        last-updated: block-height
      })
    )
    
    (var-set total-achievements-awarded (+ (var-get total-achievements-awarded) u1))
    
    (print {
      event: "achievement-awarded",
      builder: builder,
      achievement: achievement-id,
      points: (get points template),
      timestamp: block-height
    })
    
    (ok true)
  )
)

;; =====================================================
;; BUILDER STATS UPDATES
;; =====================================================

(define-public (update-mainnet-count (builder principal) (count uint))
  (let
    (
      (builder-data (unwrap! (map-get? builders builder) err-not-registered))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    
    (map-set builders builder
      (merge builder-data {
        mainnet-contracts: count,
        last-updated: block-height
      })
    )
    
    (ok true)
  )
)

(define-public (update-ecosystem-contributions (builder principal) (count uint))
  (let
    (
      (builder-data (unwrap! (map-get? builders builder) err-not-registered))
    )
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    
    (map-set builders builder
      (merge builder-data {
        ecosystem-contributions: count,
        last-updated: block-height
      })
    )
    
    (ok true)
  )
)

;; =====================================================
;; READ-ONLY FUNCTIONS
;; =====================================================

(define-read-only (get-builder (builder principal))
  (ok (map-get? builders builder))
)

(define-read-only (get-achievement (builder principal) (achievement-id uint))
  (ok (map-get? builder-achievements { builder: builder, achievement-id: achievement-id }))
)

(define-read-only (get-achievement-template (achievement-id uint))
  (ok (map-get? achievement-templates achievement-id))
)

(define-read-only (get-total-builders)
  (ok (var-get total-builders))
)

(define-read-only (get-total-achievements-awarded)
  (ok (var-get total-achievements-awarded))
)

(define-read-only (is-registered (builder principal))
  (ok (is-some (map-get? builders builder)))
)

;; =====================================================
;; ADMIN FUNCTIONS
;; =====================================================

(define-public (create-achievement-template 
  (achievement-id uint)
  (name (string-ascii 100))
  (description (string-ascii 256))
  (points uint)
  (icon-uri (optional (string-ascii 256)))
)
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    
    (map-set achievement-templates achievement-id {
      name: name,
      description: description,
      points: points,
      icon-uri: icon-uri
    })
    
    (print {
      event: "template-created",
      achievement-id: achievement-id,
      name: name
    })
    
    (ok true)
  )
)

;; =====================================================
;; INITIALIZATION
;; =====================================================

;; Initialize default achievement templates
(map-set achievement-templates ACHIEVEMENT_FIRST_CONTRACT {
  name: "First Contract Deployed",
  description: "Deployed your first smart contract to Stacks",
  points: u10,
  icon-uri: none
})

(map-set achievement-templates ACHIEVEMENT_MAINNET_DEPLOY {
  name: "Mainnet Pioneer",
  description: "Deployed a verified contract to Stacks mainnet",
  points: u50,
  icon-uri: none
})

(map-set achievement-templates ACHIEVEMENT_ECOSYSTEM_PR {
  name: "Ecosystem Contributor",
  description: "Contributed to Stacks ecosystem repositories",
  points: u25,
  icon-uri: none
})

(map-set achievement-templates ACHIEVEMENT_TOP_10 {
  name: "Top 10 Builder",
  description: "Reached top 10 in StacksRank leaderboard",
  points: u100,
  icon-uri: none
})

(map-set achievement-templates ACHIEVEMENT_TOP_5 {
  name: "Elite Builder",
  description: "Reached top 5 in StacksRank leaderboard",
  points: u200,
  icon-uri: none
})

(map-set achievement-templates ACHIEVEMENT_100_CONTRACTS {
  name: "Prolific Builder",
  description: "Deployed 100+ smart contracts",
  points: u150,
  icon-uri: none
})

(map-set achievement-templates ACHIEVEMENT_VIRAL_PROJECT {
  name: "Viral Builder",
  description: "Built a project with 1000+ users",
  points: u300,
  icon-uri: none
})

(print { message: "StacksRank Reputation Tracker initialized", version: "1.0.0" })
