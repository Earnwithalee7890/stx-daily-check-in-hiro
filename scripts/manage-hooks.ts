/**
 * Hiro Chainhooks Management Script (SDK-based)
 * 
 * This script uses the @hirosystems/chainhooks-client to programmatically
 * manage chainhooks for the Stacks Builder Challenge Week 2.
 */

import { ChainhooksClient } from '@hirosystems/chainhooks-client';
import * as fs from 'fs';
import * as path from 'path';

// Configuration
/**
 * HIRO_API_KEY from .env.local used for authenticating with Hiro Platform API.
 */
const HIRO_API_KEY = process.env.HIRO_API_KEY || '';

/**
 * Path to the standard chainhook definition JSON file.
 */
const HOOK_DEFINITION_PATH = path.join(process.cwd(), 'chainhooks', 'builder-rewards-v3.json');

/**
 * Main management function that interface with the Hiro Chainhooks Client SDK.
 * Supports: list, register, delete.
 */
async function manageHooks() {
    if (!HIRO_API_KEY) {
        console.warn('⚠️  HIRO_API_KEY not found in environment. Please set it in .env.local');
        console.log('💡 You can get an API key at https://platform.hiro.so/');
        // We continue in "demo mode" if no key is provided
    }

    const client = new ChainhooksClient({
        apiKey: HIRO_API_KEY,
        baseUrl: 'https://api.hiro.so', // Explicitly provide the base URL
    });

    const command = process.argv[2] || 'list';

    try {
        switch (command) {
            case 'list':
                console.log('📋 Listing registered Chainhooks...');
                // Corrected method name to getChainhooks based on lint feedback
                const hooks = await client.getChainhooks();
                console.table(hooks.results.map((h: any) => ({
                    uuid: h.uuid,
                    name: h.definition.name || h.uuid,
                    status: h.status,
                    chain: h.chain
                })));
                break;

            case 'register':
                console.log('🚀 Registering new Chainhook from definition...');
                const rawData = fs.readFileSync(HOOK_DEFINITION_PATH, 'utf8');
                const definition = JSON.parse(rawData);

                const result = await client.registerChainhook(definition);
                console.log('✅ Chainhook registered successfully!');
                console.log('   UUID:', result.uuid);
                break;

            case 'delete':
                const uuid = process.argv[3];
                if (!uuid) {
                    console.error('❌ Please provide a UUID to delete');
                    process.exit(1);
                }
                console.log(`🗑️  Deleting Chainhook ${uuid}...`);
                await client.deleteChainhook(uuid);
                console.log('✅ Deleted.');
                break;

            default:
                console.log('❓ Unknown command. Use: list, register, delete [uuid]');
        }
    } catch (error) {
        console.error('❌ Error managing hooks:', error instanceof Error ? error.message : error);
    }
}

console.log('🛡️  Hiro Chainhooks Manager (Week 2 Integration)\n');
manageHooks();
