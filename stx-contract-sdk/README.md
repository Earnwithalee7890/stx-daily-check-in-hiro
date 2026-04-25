# @earnwithalee/stx-contract

> Premium SDK for interacting with Stacks smart contracts.

![NPM Version](https://img.shields.io/npm/v/@earnwithalee/stx-contract?style=for-the-badge)
![NPM Downloads](https://img.shields.io/npm/dw/@earnwithalee/stx-contract?style=for-the-badge)
![License](https://img.shields.io/npm/l/@earnwithalee/stx-contract?style=for-the-badge)

## 🚀 Features

- **Dual Build Support**: Publishes both ESM (modern) and CJS (legacy) entrypoints.
- **Stacks Utilities**: Built-in address validation, formatting, and unit conversion.
- **Network Agnostic**: Seamlessly switch between Mainnet, Testnet, and Devnet.
- **Type Safe**: Fully written in TypeScript with high-quality definition files.

## 📦 Installation

```bash
npm install @earnwithalee/stx-contract
```

## 🛠️ Usage

### Address Validation & Formatting

```typescript
import { isValidPrincipal, formatAddress } from '@earnwithalee/stx-contract';

const addr = 'SP2JHG361ZXG51QTKY2NQCVBPPRRE2KZB1HR05NNC';

if (isValidPrincipal(addr)) {
  console.log(formatAddress(addr)); // "SP2JHG...05NNC"
}
```

### Unit Conversion

```typescript
import { stxToMicroStx, microStxToStx } from '@earnwithalee/stx-contract';

const micro = stxToMicroStx(0.5); // 500000n
const stx = microStxToStx(500000n); // 0.5
```

### Client Usage

```typescript
import { StxContractClient } from '@earnwithalee/stx-contract';

const client = new StxContractClient({ network: 'mainnet' });
console.log(client.getNetwork()); // 'mainnet'
```


## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📜 License

MIT © [earnwithalee](https://github.com/Earnwithalee7890)
