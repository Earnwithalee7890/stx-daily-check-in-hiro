import { describe, expect, it } from 'vitest';

describe('Message Board Contract', () => {
    it('should post a message', async () => {
        const result = await callPublic('message-board', 'post-message', [
            stringUtf8('Hello World')
        ]);

        expect(result.value).toBe(0n); // first message id is 0
    });

    it('should retrieve a message', async () => {
        const message = await callReadOnly('message-board', 'get-message', [
            uint(0)
        ]);

        expect(message).toBeDefined();
        expect(message.author).toBe(deployer);
        expect(message.content).toBe('Hello World');
    });

    it('should delete own message', async () => {
        const result = await callPublic('message-board', 'delete-message', [
            uint(0)
        ]);

        expect(result.value).toBe(true);
        
        const message = await callReadOnly('message-board', 'get-message', [
            uint(0)
        ]);
        expect(message).toBeNull();
    });

    it('should return 404 for non-existent message', async () => {
        const result = await callPublic('message-board', 'delete-message', [
            uint(999)
        ]);
        expect(result).toBeErr(404n);
    });

    it('should not delete another user message', async () => {
        // first post a message as deployer
        await callPublic('message-board', 'post-message', [
            stringUtf8('Protected')
        ]);
        
        // try to delete as wallet1
        const result = await callPublicAs('message-board', 'delete-message', [
            uint(1)
        ], wallet1);

        expect(result).toBeErr(403n);
    });
});
