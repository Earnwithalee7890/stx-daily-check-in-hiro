# 🎯 STX Builder Hub

> The premium all-in-one platform for Stacks builders. Powered by **Hiro Chainhooks**, built for the Stacks community. Check-in daily, deploy contracts easier, and manage your assets with style.

![STX Builder Hub](https://i.imgur.com/example-screenshot.png)

## ✨ Features

- **📝 Daily Check-In:** Earn points and rewards by checking in daily on the Stacks mainnet.
- **🛠️ Contract Deployer:** 
  - **Standard Mode:** Write and deploy custom Clarity contracts directly from your browser.
  - **NFT Creator:** Generate and deploy SIP-009 NFT contracts instantly without writing code.
- **💸 Revenue Share:** A 0.05 STX service fee is automatically applied to all deployments, supporting the platform.
- **👀 Live Activity Feed:** Watch real-time check-ins from the community.
- **💎 Premium Design:** Experience a state-of-the-art Glassmorphism UI with animated mesh gradients and smooth interactions.

## 🚀 Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v18+)
- [Leather Wallet](https://leather.io/) extension installed.

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Earnwithalee7890/stx-daily-check-in.git
   cd stx-daily-check-in
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Run locally**
   ```bash
   npm run dev
   ```
   Open [https://stx-daily-check-in.vercel.app/](https://stx-daily-check-in.vercel.app/) in your browser.

## 📜 Smart Contracts

This project interacts with the Stacks Mainnet.

- **Builder Rewards Contract (v3):** `SP2F500B8DTRK1EANJQ054BRAB8DDKN6QCMXGNFBT.builder-rewards-v3`
- **Fee Recipient:** `SP2F500B8DTRK1EANJQ054BRAB8DDKN6QCMXGNFBT`
- **Explorer:** [View on Hiro Explorer](https://explorer.hiro.so/contact/SP2F500B8DTRK1EANJQ054BRAB8DDKN6QCMXGNFBT.builder-rewards-v3?chain=mainnet)

## 🛠️ Built With

- **Next.js 16** (App Directory, Turbopack)
- **Stacks.js** (Connect, Transactions)
- **Clarity** (Smart Contracts)
- **CSS Modules** (Premium Glassmorphism)

## 🔗 Chainhooks Integration (Week 2)

This project uses **Hiro Chainhooks** to automatically track on-chain contract interactions in real-time, satisfying the **Stacks Builder Challenge Week 2** requirements.

### What We Track

The chainhook monitors three core contract functions on mainnet:
- **`daily-check-in`** - When users check in and pay fees (5 microSTX)
- **`claim-daily-reward`** - When users claim rewards (10 microSTX fee)
- **`record-score`** - When users submit scores (5 microSTX fee)

### How It Works

1. **Chainhook Registration**: A chainhook filter is registered with Hiro's service
2. **Event Detection**: When a transaction calls our contract, Chainhooks detects it instantly
3. **Webhook Trigger**: Event data is sent to `/api/chainhook` endpoint
4. **Event Processing**: Backend logs the activity, tracks fees, and updates statistics

**Contract Monitored**: `SP2F500B8DTRK1EANJQ054BRAB8DDKN6QCMXGNFBT.builder-rewards-v3`  
**Network**: Mainnet

### Setup Instructions

```bash
# 1. Install dependencies (already done during npm install)
npm install

# 2. Configure environment variables
cp .env.example .env.local
# Edit .env.local with your webhook URL and secret

# 3. Register chainhook (outputs JSON config)
npx tsx scripts/register-chainhook.ts

# 4. Visit https://platform.hiro.so/ to register the chainhook
# Paste the JSON output from step 3

# 5. [ADVANCED] Manage hooks programmatically using Hiro SDK
# Requires HIRO_API_KEY in .env.local
npx tsx scripts/manage-hooks.ts list
npx tsx scripts/manage-hooks.ts register
```

### Hiro SDK Deep Integration (Week 2 🚀)

We leverage the `@hirosystems/chainhooks-client` to manage the lifecycle of our on-chain triggers. This allows for:
- **Scalable Monitoring**: Programmatically register and scale event hooks.
- **Real-time Awareness**: The SDK ensures our backend is always in sync with Hiro's infra.
- **Superior Reliability**: Reorg-safe event delivery handled by Hiro's production-grade network.


### Monitoring Chainhook Activity

**Check webhook status:**
```bash
# Start dev server
npm run dev

# Visit in browser or curl
curl http://localhost:3000/api/chainhook
```

**Test webhook locally:**
```bash
curl -X POST http://localhost:3000/api/chainhook \
  -H "Content-Type: application/json" \
  -d '{"chain":"stacks","apply":[{"type":"contract_call","method":"daily-check-in","sender":"SP123","tx_id":"0xabc","block_identifier":{"index":12345,"hash":"0xdef"}}]}'
```

**View live events** (after deployment):
- Visit `https://your-app.vercel.app/api/chainhook` to see real-time stats
- Check server logs for detailed event processing

### Week 2 Compliance ✅

This implementation demonstrates:
- ✅ **Use of Hiro Chainhooks** - Registered chainhook monitoring contract calls
- ✅ **Users & fees generated** - Tracks real user interactions with fee collection
- ✅ **GitHub contributions** - All code committed to public repository


## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

---
*Built for the Stacks Builder Challenge 🏆 Powered by [Hiro](https://hiro.so)*
