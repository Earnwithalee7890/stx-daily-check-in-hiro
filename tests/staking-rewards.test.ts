import { describe, expect, it } from 'vitest';

/**
 * These tests use globals provided by the vitest-environment-clarinet.
 */

describe('Staking Rewards Contract', () => {
    it('should respect minimum stake amount', async () => {
        const result = await callPublic('staking-rewards', 'stake', [
            uint(100) // Less than 1 STX (1,000,000)
        ]);
        expect(result).toBeErr(103n);
    });

    it('should allow a user to stake valid STX amount', async () => {
        const amount = 2000000n; // 2 STX
        const result = await callPublic('staking-rewards', 'stake', [
            uint(amount)
        ]);

        expect(result.value).toBe(true);
        
        const stakeInfo = await callReadOnly('staking-rewards', 'get-stake-info', [
            principal(deployer)
        ]);
        expect(stakeInfo.amount).toBe(amount);
    });

    it('should fail to claim rewards without the token trait', async () => {
        // This should fail to compile if we don't pass the trait
        // In simnet testing, we pass the contract name for the trait
        const result = await callPublic('staking-rewards', 'claim-rewards', [
            principal(deployer + '.sip010-token')
        ]);
        
        // Should be err-too-early (101) because blocks havent passed
        expect(result).toBeErr(101n);
    });

    it('should allow unstaking at any time', async () => {
        const result = await callPublic('staking-rewards', 'unstake', []);
        expect(result.value).toBe(2000000n);

        const stakeInfo = await callReadOnly('staking-rewards', 'get-stake-info', [
            principal(deployer)
        ]);
        expect(stakeInfo).toBeNull();
    });
});
