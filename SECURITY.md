# Security Policy

## Supported Versions

The following versions of Stacks Builder Hub are currently being supported with security updates.

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take the security of our smart contracts and frontend very seriously. If you find a vulnerability, please report it responsibly.

**Do not open a public GitHub issue for security vulnerabilities.**

Instead, please send an email to `security@stacksbuilderhub.xyz` (replace with your actual security contact).

### What to include:
- A detailed description of the vulnerability.
- Steps to reproduce the issue (PoC).
- Potential impact on users or funds.

### What to expect:
- You will receive an acknowledgment of your report within 24 hours.
- We will provide a timeline for a fix and keep you updated on progress.
- Once fixed, we will coordinate a public disclosure if appropriate.

## Smart Contract Security

Our Clarity smart contracts are designed with the following principles:
- **Check-Act-Interact**: We always perform assertions and state changes before interacting with other contracts.
- **Post-Conditions**: We strongly recommend all users use Stacks Post-Conditions to prevent unauthorized asset transfers.
- **Fail-Safe**: Important global state changes (like maintenance mode) are restricted to the contract owner.

## Frontend Security

- We do not store private keys or sensitive user data.
- All transactions are signed via the user's preferred Stacks wallet (e.g., Hiro, Xverse).
- We validate all inputs to prevent XSS and other common web vulnerabilities.
