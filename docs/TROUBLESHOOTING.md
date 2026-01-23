# Troubleshooting Guide

## Common Issues

### "Unable to parse node response"

**Cause:** Contract syntax error or invalid Clarity code

**Solutions:**
1. Run `clarinet check` to find syntax errors
2. Verify all functions return `(ok ...)` or `(err ...)`
3. Check for typos in variable names
4. Ensure all `asserts!` use proper error constants

### "Failed to broadcast transaction"

**Cause:** Network issues or insufficient STX balance

**Solutions:**
1. Check wallet has enough STX for gas
2. Verify network connection (testnet/mainnet)
3. Wait and retry - network may be congested
4. Use lower gas price

### "Contract already exists"

**Cause:** Contract name already deployed by this address

**Solutions:**
1. Use a different contract name
2. Deploy from a different wallet
3. This is expected if redeploying

### Clarinet Check Fails

**Common Issues:**
- Missing closing parenthesis
- Undefined variable
- Type mismatch
- Invalid function signature

**Debug Steps:**
1. Read error message carefully
2. Check line number indicated
3. Verify all `define-*` statements
4. Ensure proper indentation

### Gas Estimation Too High

**Solutions:**
1. Simplify contract logic
2. Reduce map complexity
3. Split into multiple contracts
4. Optimize loops and iterations

### Read-Only Function Returns Error

**Cause:** Function trying to modify state

**Solutions:**
1. Use `define-public` instead
2. Remove state-modifying operations
3. Use pure computations only

## Getting Help

1. Check documentation in `/docs`
2. Search existing issues on GitHub
3. Ask in Stacks Discord
4. Review contract examples in `/examples`

## Debug Checklist

- [ ] `clarinet check` passes
- [ ] All tests pass
- [ ] No unused variables
- [ ] Error codes documented
- [ ] Gas costs reasonable
- [ ] Contract tested on testnet
