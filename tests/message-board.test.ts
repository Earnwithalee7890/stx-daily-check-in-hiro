import { describe, expect, it } from 'vitest';

describe('Message Board Contract', () => {
    it('should post a message', async () => {
        const result = await callPublic('message-board', 'post-message', [
            stringUtf8('Hello World')
        ]);

        expect(result).toHaveProperty('value');
        expect(result.value).toBe(1n);
    });

    it('should retrieve a message', async () => {
        await callPublic('message-board', 'post-message', [
            stringUtf8('Test Message')
        ]);

        const message = await callReadOnly('message-board', 'get-message', [
            uint(1)
        ]);

        expect(message).toBeDefined();
        expect(message.author).toBe(deployer);
        expect(message.content).toBe('Test Message');
    });

    it('should delete own message', async () => {
        await callPublic('message-board', 'post-message', [
            stringUtf8('Delete me')
        ]);

        const result = await callPublic('message-board', 'delete-message', [
            uint(1)
        ]);

        expect(result.value).toBe(true);
    });

    it('should not delete another user message', async () => {
        await callPublic('message-board', 'post-message', [
            stringUtf8('Protected')
        ]);

        const result = await callPublicAs('message-board', 'delete-message', [
            uint(1)
        ], wallet2);

        expect(result).toBeErr();
    });
});
