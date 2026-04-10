# Stacks Builder Hub

[![30 High-Quality Commits](https://img.shields.io/badge/Commits-30%20High--Quality-blueviolet?style=for-the-badge&logo=github)](https://github.com/Earnwithalee7890/stx-daily-check-in-hiro)
[![Stacks Ecosystem](https://img.shields.io/badge/Stacks-Ecosystem-orange?style=for-the-badge&logo=stacks)](https://stacks.co)
[![StacksRank SDK](https://img.shields.io/npm/v/@earnwithalee/stacksrank-sdk?style=for-the-badge&logo=npm&color=CB3837)](https://www.npmjs.com/package/@earnwithalee/stacksrank-sdk)
[![NPM Downloads](https://img.shields.io/npm/dw/@earnwithalee/stacksrank-sdk?style=for-the-badge&logo=npm&color=brightgreen)](https://www.npmjs.com/package/@earnwithalee/stacksrank-sdk)
[![Clarity 2.0](https://img.shields.io/badge/Smart%20Contracts-Clarity%202.0-blue?style=for-the-badge)](https://docs.stacks.co/docs/clarity)

Stacks Builder Hub is a premium, developer-focused platform designed to catalyze growth in the Stacks ecosystem. It is powered by the [**StacksRank SDK**](https://www.npmjs.com/package/@earnwithalee/stacksrank-sdk), allowing for professional-grade check-in tracking and ranking.

## 🚀 Key Features

- **Advanced Staking**: Non-custodial staking with time-weighted rewards and streak bonuses.
- **NFT Marketplace**: SIP-009 compatible marketplace with floor price tracking and collection analytics.
- **DAO Governance**: Quadratic voting and proposal management for decentralized decision making.
- **Premium UI/UX**: Glassmorphism-based design with real-time transaction feedback and ecosystem visualizations.
- **Developer First**: Unified transaction hooks, comprehensive documentation, and robust testing suites.

## ❓ Developer FAQ

### How do I run the tests?
Use `npm run test` to execute the Vitest suite against the Clarity contracts. Ensure you have the Clarinet SDK environment configured.

### Can I deploy this to testnet?
Yes, follow the instructions in [DEPLOYMENT_OPTIONS.md](DEPLOYMENT_OPTIONS.md) to use the Stacks CLI for testnet deployment.

### How do I contribute?
Please refer to the [CONTRIBUTING.md](CONTRIBUTING.md) and [CONTRIBUTING_ES.md](docs/CONTRIBUTING_ES.md) guides for standards and process.

## 🛠️ Technical Highlights (30 Commits)

This repository includes **30 high-quality, professional commits** implemented for the Stacks Talent Protocol event:
1.  **Architecture**: Comprehensive system design and data flow documentation.
2.  **Infrastructure**: Automated CI/CD pipelines and security policies.
3.  **Smart Contracts**: Optimized logic for reward distribution and voting persistence.
4.  **Testing**: Full-coverage unit tests for critical protocol functions.
5.  **UI/UX**: Complete refactor to premium glassmorphism aesthetics.
6.  **Accessibility**: Internationalization with Spanish community documentation.

## 🚦 Getting Started

### Prerequisites
- Node.js v18+
- [Hiro Wallet](https://wallet.hiro.so/) or [Xverse](https://www.xverse.app/)
- [Clarinet](https://github.com/hirosystems/clarinet) (for contract testing)

### Installation
```bash
git clone https://github.com/Earnwithalee7890/stx-daily-check-in-hiro.git
cd stx-daily-check-in-hiro
npm install
```

### SDK Integration (Official Package)
Integrate the **StacksRank SDK** into any project to start tracking builder activity:
```bash
npm install @earnwithalee/stacksrank-sdk
```
View the official package on npm: [**@earnwithalee/stacksrank-sdk**](https://www.npmjs.com/package/@earnwithalee/stacksrank-sdk)

### Environment Configuration
Create a `.env.local` file in the root directory:
```env
NEXT_PUBLIC_NETWORK=mainnet
NEXT_PUBLIC_CONTRACT_ADDRESS=SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9
NEXT_PUBLIC_APP_NAME="STX Builder Hub"
```

### Running Locally
```bash
npm run dev
```

## 🚢 Deployment

### Vercel Deployment
1. Push your changes to GitHub.
2. Connect your repository to Vercel.
3. Add the environment variables listed above.
4. The build command should be `npm run build`.

### Smart Contract Deployment
1. Ensure you have [Clarinet](https://github.com/hirosystems/clarinet) installed.
2. Run `clarinet check` to verify contract integrity.
3. Use the Stacks CLI or Hiro Explorer for mainnet/testnet deployment.

## 🤝 Contributing
Contributions are welcome! Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## 📜 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
