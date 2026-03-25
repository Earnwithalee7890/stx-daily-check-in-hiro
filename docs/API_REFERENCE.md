# API Reference

This document provides a technical summary of the primary smart contracts in this codebase.

## 1. Builder Profile Registry
- **Contract Name**: `builder-profile-registry`
- **Purpose**: Manages user identities and professional profiles within the Stacks ecosystem.
- **Key Functions**:
    - `register-profile (name, bio, links)`: Registers a new user profile.
    - `update-profile (name, bio, links)`: Updates existing profile information.
    - `get-profile (user)`: Returns profile data for a specific user.
- **Data Map**: `profiles (principal -> {name, bio, links, registered-at})`

## 2. Builder Rewards Hub (v4)
- **Contract Name**: `builder-rewards-v4`
- **Purpose**: Distributes incentives and tracks contribution milestones.
- **Key Functions**:
    - `claim-daily-bonus ()`: Rewards users for daily activity.
    - `verify-milestone (milestone-id)`: Validates specialized achievements.
    - `get-user-rewards (user)`: Returns total accumulated rewards.
- **Governance**: Only authorized administrators can update reward parameters.

## 3. Decentralized Job Board
- **Contract Name**: `decentralized-job-board`
- **Purpose**: Facilitates talent matching and hiring on-chain.
- **Key Functions**:
    - `post-job (title, description, payment)`: Lists a new opportunity.
    - `apply-for-job (job-id, proposal)`: Submits an application to a listing.
    - `complete-job (job-id, contributor)`: Triggers payment upon fulfillment.

## 4. DAO Treasury
- **Contract Name**: `dao-treasury`
- **Purpose**: Manages community funds and asset distribution.
- **Key Functions**:
    - `deposit (amount)`: Accepts STX or SIP-010 token contributions.
    - `propose-spend (recipient, amount, reason)`: Initiates a funding proposal.
    - `execute-spend (proposal-id)`: Releases funds after governance approval.

## 5. NFT Marketplace
- **Contract Name**: `nft-marketplace-v2`
- **Purpose**: Enables trustless trading of digital assets.
- **Key Functions**:
    - `list-asset (nft-contract, token-id, price)`: Lists an NFT for sale.
    - `purchase-asset (listing-id)`: Executes a trade between buyer and seller.
    - `cancel-listing (listing-id)`: Removes an item from the marketplace.
