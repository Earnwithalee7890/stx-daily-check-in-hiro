# Project Architecture

## Overview
This project is a comprehensive Stacks ecosystem dashboard and smart contract collection. it integrates Stacks (Clarity) smart contracts with a modern Next.js frontend to provide a seamless "Daily Check-in" and exploration experience for the Stacks Builder Rewards program.

## System Components

### 1. Smart Contracts (Clarity 2.0)
- **Core Logic**: Located in `contracts/`.
- **Simple Contracts**: 100+ production-ready utility contracts for various use cases (Voting, Escrow, DeFi, NFTs).
- **Registry & Rewards**: Centralized contracts like `builder-profile-registry.clar` and `builder-rewards-v4.clar` manage user identity and incentive distribution.

### 2. Frontend (Next.js 15)
- **Framework**: Developed with Next.js 15 using React 19.
- **State Management**: Uses React hooks and `@stacks/connect` for wallet state.
- **UI System**: Modern, responsive design with glassmorphism and Framer Motion animations.

### 3. Integration Layer
- **Hiro SDKs**: Utilizes `@hirosystems/clarinet-sdk` for local simulation and testing.
- **Stacks.js**: Integrates `@stacks/transactions` and `@stacks/connect` for blockchain interaction.
- **Chainhooks**: Reactive API interactions via `@hirosystems/chainhooks-client`.

## Data Flow
1. **User Interaction**: User connects wallet (Leather/Xverse) via Hiro Connect.
2. **Contract Interaction**: UI builds and signs transactions using Stacks.js.
3. **Execution**: Transactions are broadcast to the Stacks blockchain.
4. **Verification**: Frontend updates state based on on-chain events and data fetched via Stacks API.

## Testing Strategy
- **Simnet Testing**: Unit tests run in a simulated environment using Vitest and `vitest-environment-clarinet`.
- **Clarinet Check**: Static analysis of all Clarity contracts.
- **E2E Testing**: Manual and automated UI testing of the integration layer.
