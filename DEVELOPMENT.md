# Development Guide

This guide provides step-by-step instructions for setting up your local development environment for Stacks (Clarity) smart contracts.

## 🛠 Prerequisites

Ensure you have the following installed:
1. **Clarinet**: The essential CLI tool for Clarity development.
   - [Install Clarinet](https://github.com/hirosystems/clarinet)
2. **Node.js**: Required for SDK and automation scripts.
   - [Install Node.js](https://nodejs.org/)
3. **Hiro Wallet**: For testnet and mainnet deployments.
   - [Get Hiro Wallet](https://wallet.hiro.so/)

## 🚀 Getting Started

### 1. Project Setup
Clone this repository and install dependencies:
```bash
git clone <your-repo-url>
npm install
```

### 2. Contract Verification
Run the following command to verify all contracts in this repository:
```bash
# Check all contracts for syntax errors
npm run check

# Or use clarinet directly
clarinet check
```

### 3. Testing
Run the project's test suite:
```bash
npm test
```

## 📜 Coding Style

- Use **snake_case** for function and variable names in Clarity.
- Always include **post-conditions** in your interactions.
- Document functions with clear comments.

## 📡 Deployment

Refer to the [Hiro Deployment Guide](https://docs.hiro.so/deploy-contracts) for detailed instructions on deploying to testnet.
