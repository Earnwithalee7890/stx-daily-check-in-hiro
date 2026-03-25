# Staking Guide

Learn how to participate in the Stacks Builder Hub staking ecosystem to earn rewards and governance influence.

## 1. Overview

Staking allows you to lock your STX tokens in our smart contracts to support the ecosystem. In return, you earn:
- **Daily Rewards**: Distributed in a dedicated ecosystem token.
- **Governance Power**: Increased weight in DAO proposals.
- **Builder Rep**: Higher visibility on the leaderboard.

## 2. How to Stake

1. **Connect Wallet**: Ensure your Stacks wallet (Hiro or Xverse) is connected.
2. **Navigate to Staking**: Find the 'Staking Pool' section on your dashboard.
3. **Enter Amount**: Specify the amount of STX you wish to stake (Min: 1 STX).
4. **Confirm Transaction**: Sign the `stake` transaction in your wallet.

## 3. Earning Rewards

Rewards are calculated based on:
- **Amount Staked**: More STX = Higher share of the reward pool.
- **Duration**: We use a time-weighted multiplier to reward long-term stakers.
- **Check-in Streak**: Maintaining a daily check-in streak provides a bonus on top of your base staking rewards.

### Reward Formula
`Reward = (Stake Amount * Blocks Staked * Reward Rate) / 1,000,000`

## 4. Unstaking

You can unstake your STX at any time. 
- **Note**: Unstaking before the minimum period (144 blocks, ~24 hours) may result in forfeiture of pending rewards for that period.
- **Withdrawal**: Once you initiate an unstake, your STX is immediately returned to your wallet.

## 5. Security

Our staking contract `staking-rewards.clar` has been designed with:
- **Non-custodial design**: Only you can initiate the withdrawal of your funds.
- **Post-conditions**: Every transaction is protected by Stacks post-conditions to ensure only the specified amount of STX is transferred.
- **Open Source**: The contract code is fully verifiable on-chain.
