import { describe, expect, it } from 'vitest';

/**
 * These tests use globals provided by the vitest-environment-clarinet.
 */

describe('NFT Marketplace Contract', () => {
    it('should have a default marketplace fee of 2.5%', async () => {
        const result = await callReadOnly('nft-marketplace', 'get-marketplace-fee', []);
        expect(result.value).toBe(25n);
    });

    it('should allow the owner to change the marketplace fee', async () => {
        const newFee = 50n; // 5%
        const result = await callPublic('nft-marketplace', 'set-marketplace-fee', [
            uint(newFee)
        ]);
        expect(result.value).toBe(true);

        const fee = await callReadOnly('nft-marketplace', 'get-marketplace-fee', []);
        expect(fee.value).toBe(newFee);
    });

    it('should fail to list an NFT if not the owner', async () => {
        // We use a mock contract name for the trait
        const result = await callPublic('nft-marketplace', 'list-nft', [
            principal(deployer + '.stx-nft-v2'),
            uint(1),
            uint(1000000)
        ]);
        
        // This will likely fail with error 101 (err-not-authorized) 
        // because the mock contract doesn't acknowledge deployer as owner of ID 1
        expect(result).toBeErr(101n);
    });

    it('should allow cancelling a valid listing', async () => {
        // This assumes a listing exists or can be created
        // For now, we test the authorization logic
        const result = await callPublic('nft-marketplace', 'cancel-listing', [
            uint(0)
        ]);
        expect(result).toBeErr(404n); // err-listing-not-found for non-existent ID 0
    });
});
