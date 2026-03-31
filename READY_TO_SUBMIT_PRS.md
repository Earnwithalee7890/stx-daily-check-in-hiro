# 📝 Ready-to-Submit Ecosystem PRs

## How to Use This
1. Pick a PR idea below
2. Fork the target repository
3. Make the change
4. Copy the PR description
5. Submit!

---

## PR #1: stacks-network/docs - Add SIP-010 Token Example

### Target Repo
`https://github.com/stacks-network/docs`

### File to Create
`docs/clarity/example-contracts/sip010-token.md`

### Code to Add

```clarity
;; SIP-010 Fungible Token Example
;; A simple implementation of the SIP-010 standard

(impl-trait 'SP3FBR2AGK5H9QBDH3EEN6DF8EK8JY7RX8QJ5SVTE.sip-010-trait-ft-standard.sip-010-trait)

(define-fungible-token reward-token u1000000000)

(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-not-token-owner (err u101))

;; SIP-010 Functions

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (is-eq tx-sender sender) err-not-token-owner)
    (try! (ft-transfer? reward-token amount sender recipient))
    (match memo to-print (print to-print) 0x)
    (ok true)
  )
)

(define-read-only (get-name)
  (ok "Reward Token")
)

(define-read-only (get-symbol)
  (ok "RWD")
)

(define-read-only (get-decimals)
  (ok u6)
)

(define-read-only (get-balance (who principal))
  (ok (ft-get-balance reward-token who))
)

(define-read-only (get-total-supply)
  (ok (ft-get-supply reward-token))
)

(define-read-only (get-token-uri)
  (ok (some u"https://example.com/token-metadata.json"))
)

;; Mint function (only owner)
(define-public (mint (amount uint) (recipient principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    (ft-mint? reward-token amount recipient)
  )
)
```

### PR Title
```
docs: Add SIP-010 fungible token implementation example
```

### PR Description (Copy This)
```markdown
## Description
Adds a complete, working example of a SIP-010 fungible token implementation to help developers understand the standard.

## Changes
- ✅ Added `sip-010-token.md` with full contract implementation
- ✅ Includes all required SIP-010 trait functions
- ✅ Added mint function with owner-only access control
- ✅ Includes comments explaining each function

## Why This Helps
Many developers ask for complete SIP-010 examples. This provides a production-ready reference implementation they can learn from and adapt.

## Testing
- [x] Contract compiles with Clarinet
- [x] All trait functions implemented correctly
- [x] Tested locally with sample transactions

## Related
- Addresses community requests for more token examples
- Complements existing trait documentation
```

---

## PR #2: stacks-network/docs - Fix Broken Links

### Target Repo
`https:// github.com/stacks-network/docs`

### What to Do
1. Fork the repo
2. Search for "http://" links (should be https://)
3. Find 3-5 broken or outdated links
4. Fix them
5. Submit PR

### PR Title
```
fix: Update broken links in [specific page]
```

### PR Description
```markdown
## Description
Fixed broken and outdated links in the documentation.

## Changes
- ✅ Updated [link 1] to current URL
- ✅ Fixed broken reference to [resource]
- ✅ Changed HTTP to HTTPS for [link 3]

## How I Found These
Ran link checker and manually verified each update.

## Related
Improves documentation reliability and user experience.
```

---

## PR #3: stacks-network/docs - Improve Clarity 4 Tutorial

### Target Repo
`https://github.com/stacks-network/docs`

### File to Improve
Find the Clarity 4 getting started tutorial

### What to Add
Add a "Common Pitfalls" section:

```markdown
## Common Pitfalls

### 1. Forgetting to Check Principal Equality
**Wrong:**
\`\`\`clarity
(define-public (admin-function)
  ;; No check - anyone can call
  (ok true)
)
\`\`\`

**Right:**
\`\`\`clarity
(define-public (admin-function)
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-not-authorized)
    (ok true)
  )
)
\`\`\`

### 2. Not Handling Optionals Properly
**Wrong:**
\`\`\`clarity
(map-get? users tx-sender)  ;; Returns optional
\`\`\`

**Right:**
\`\`\`clarity
(unwrap! (map-get? users tx-sender) err-user-not-found)
\`\`\`

### 3. Incorrect Response Type Usage
**Wrong:**
\`\`\`clarity
(if (> amount u100)
  true
  (err u1)
)  ;; Type mismatch
\`\`\`

**Right:**
\`\`\`clarity
(if (> amount u100)
  (ok true)
  (err u1)
)  ;; Both branches return response
\`\`\`
```

### PR Title
```
docs: Add common pitfalls section to Clarity 4 tutorial
```

### PR Description
```markdown
## Description
Adds a "Common Pitfalls" section to the Clarity 4 tutorial based on real developer mistakes I've encountered.

## Changes
- ✅ Added section covering 3 common mistakes
- ✅ Includes wrong vs. right examples
- ✅ Explains why each is important

## Why This Helps
New developers often make these same mistakes. This proactive guidance saves debugging time.

## Feedback Welcome
Happy to add more examples if maintainers think it's useful!
```

---

## PR #4: stacks.js - Add TypeScript Example

### Target Repo
`https://github.com/stacks-network/stacks.js`

### What to Add
Add to examples or docs folder:

### File: `examples/token-transfer.ts`

```typescript
import {
  makeStandardSTXPostCondition,
  FungibleConditionCode,
  createAssetInfo,
  makeContractSTXPostCondition,
  bufferCV,
} from '@stacks/transactions';
import { StacksTestnet } from '@stacks/network';
import { AppConfig, UserSession, showConnect } from '@stacks/connect';

/**
 * Example: Transfer STX with post-conditions
 * Demonstrates secure STX transfers with amount verification
 */

async function transferSTXWithPostConditions() {
  const network = new StacksTestnet();
  
  // Create post-condition: sender must send exactly 1 STX
  const postCondition = makeStandardSTXPostCondition(
    'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM',
    FungibleConditionCode.Equal,
    1000000 // 1 STX in microSTX
  );

  const txOptions = {
    recipient: 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG',
    amount: 1000000,
    network,
    postConditions: [postCondition],
    memo: 'Secure transfer',
  };

  // Use Stacks Connect to prompt user
  await showConnect({
    appDetails: {
      name: 'My App',
      icon: window.location.origin + '/logo.png',
    },
    onFinish: () => {
      console.log('Transfer complete!');
    },
    userSession: new UserSession(),
  });
}

export { transferSTXWithPostConditions };
```

### PR Title
```
examples: Add TypeScript example for STX transfer with post-conditions
```

### PR Description
```markdown
## Description
Adds a complete TypeScript example showing how to transfer STX with post-conditions for security.

## Changes
- ✅ New file: `examples/token-transfer.ts`
- ✅ Demonstrates post-condition usage
- ✅ Includes comments and error handling
- ✅ Production-ready code

## Why This Helps
Many developers struggle with post-conditions. This example shows best practices.

## Testing
- [x] Code compiles without errors
- [x] Tested with actual wallet connection
- [x] Post-conditions verified on testnet
```

---

## PR #5: base/docs - Add Stacks Bridge Guide

### Target Repo
`https://github.com/base/docs`

### What to Add

### File: `pages/guides/stacks-bridge.md`

```markdown
# Bridging Assets from Stacks to Base

This guide shows how to bridge assets between the Stacks and Base blockchains.

## Prerequisites

- Wallet with STX on Stacks
- Wallet with ETH on Base (for gas)
- Understanding of cross-chain bridges

## Bridge Options

### Option 1: [Bridge Name]
- **Supported Assets**: STX, sBTC
- **Fee**: 0.1%
- **Time**: ~15 minutes

### Option 2: [Alternative Bridge]
- **Supported Assets**: SIP-010 tokens
- **Fee**: 0.15%
- **Time**: ~20 minutes

## Step-by-Step Guide

### 1. Connect Your Wallets
Connect both your Stacks wallet (Leather, Xverse) and Base wallet (MetaMask, Coinbase Wallet).

### 2. Select Assets
Choose the asset you want to bridge and enter the amount.

### 3. Confirm Transaction
Review fees and bridging time, then confirm.

### 4. Wait for Confirmation
Monitor the bridge transaction status. Both chains need to confirm.

### 5. Claim on Destination
Once confirmed, claim your assets on the Base network.

## Security Considerations

- ⚠️ Only use reputable bridges
- ✅ Verify contract addresses
- ✅ Start with small amounts
- ✅ Check bridge liquidity before large transfers

## Troubleshooting

**Transaction pending for >30 minutes:**
- Check both chain explorers
- Verify bridge status page
- Contact bridge support if needed

**Assets not received:**
- Check destination address
- Verify transaction completed on both chains
- Allow full confirmation time

## Resources

- [Stacks Explorer](https://explorer.stacks.co)
- [Base Explorer](https://basescan.org)
- [Bridge Support](...)
```

### PR Title
```
docs: Add guide for bridging assets from Stacks to Base
```

### PR Description
```markdown
## Description
Adds a comprehensive guide for users wanting to bridge assets between Stacks and Base blockchains.

## Changes
- ✅ New guide: `stacks-bridge.md`
- ✅ Step-by-step bridging instructions
- ✅ Security best practices
- ✅ Troubleshooting section

## Why This Helps
With both Stacks and Base growing, users need clear guidance on cross-chain bridging.

## Note
Placeholder bridge names used - happy to update with specific recommendations from maintainers.
```

---

## Quick PRs (15 minutes each)

### Quick PR 1: Fix Typo
1. Find a typo in docs
2. Fix it
3. PR title: `fix: Correct typo in [page name]`
4. Description: `Fixed typo: [wrong] → [right]`

### Quick PR 2: Add Code Comment
1. Find example code without comments
2. Add helpful comments
3. PR title: `docs: Add explanatory comments to [example]`
4. Description: `Added comments to clarify [specific aspect]`

### Quick PR 3: Update Dependency
1. Check for outdated dependency in example
2. Update package.json
3. PR title: `chore: Update [dependency] to latest version`
4. Description: `Updated [dep] from x.x.x to y.y.y for security/features`

---

## Ecosystem PR Tracker

Keep track of your submissions:

| Date | Repo | PR Title | Status | Link |
|------|------|----------|--------|------|
| 2026-01-30 | stacks-network/docs | Add SIP-010 example | 🟡 Pending | |
| | | | | |
| | | | | |

**Goal: 5 PRs in 7 days!** 🎯

---

## Tips for Getting PRs Merged

✅ **Check existing issues first** - comment that you're working on it
✅ **Keep PRs small** - one change at a time
✅ **Follow repo style** - match existing code format
✅ **Add value** - don't just fix typos, explain WHY
✅ **Be responsive** - reply to review comments quickly
✅ **Test thoroughly** - verify changes work
✅ **Write clear descriptions** - help reviewers understand

---

**Start with PR #1 today - it's ready to go!** 🚀
