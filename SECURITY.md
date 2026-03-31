# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 1.0.x   | :white_check_mark: |

## Reporting a Vulnerability

If you discover a security vulnerability, please report it to us privately:

1. **DO NOT** open a public GitHub issue.
2. Email: security@stacks-contracts.io
3. Include a detailed description and steps to reproduce.
4. Wait for confirmation before public disclosure.

## Stacks-Specific Security Best Practices

### 🛡️ Post-Conditions
Always use **Post-Conditions** when interacting with smart contracts. They are the most powerful security feature of Stacks, ensuring that a transaction can only transfer the exact amount of assets specified.

### 🧩 Trait Validation
When using traits, ensure you are validating the contract identifier to prevent "Trait Substitution" attacks. Always verify that the passed contract implements the expected interface correctly.

### 🔐 Access Control
- Use `is-eq tx-sender contract-owner` or similar patterns for administrative functions.
- Be aware of the difference between `tx-sender` and `contract-caller`.

### 📉 Arithmetic Safety
Clarity 2 includes built-in overflow checks, but always be mindful of precision when performing divisions, especially in DeFi applications.

## General Best Practices

1. **Checks-Effects-Interactions**: Always perform all checks, then update state, and finally interact with other contracts.
2. **Input Sanitization**: Never trust user-provided data.
3. **Thorough Testing**: Use `clarinet test` to simulate edge cases and ensure 100% code coverage.

## Audit Status

These contracts are provided for educational and template purposes. **Always conduct your own professional security audit before deploying to Stacks Mainnet.**

