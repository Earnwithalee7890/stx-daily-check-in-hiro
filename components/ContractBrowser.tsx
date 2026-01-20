'use client';

/**
 * Featured Contract Browser component.
 */
export function ContractBrowser() {
    const featuredContracts = [
        { name: 'bns-v2', address: 'SP000000000000000000002Q6VF78.bns', description: 'Bitcoin Naming System - Core identity layer for Stacks.' },
        { name: 'arkadiko-swap-v2-1', address: 'SP2C2WBASTG0RHH7C9NPY4W17SA55C9N8P8B8FGT', description: 'Main decentralized exchange for Stacks assets.' },
        { name: 'stacking-dao-core-v1', address: 'SP4SZE494VC2K069Q4S5E0GNKK30PBA84A12B16P', description: 'Liquid stacking protocol for STX holders.' },
        { name: 'alex-vault', address: 'SP3K8BC0PPEVCV7NZ6QSRWPQ2JE9E5B6N3PA03W9', description: 'Automated Liquidity Exchange (ALEX) core vault.' },
    ];

    return (
        <div className="glass-card contract-browser-card">
            <h2>🔍 Featured Contracts</h2>
            <div className="contract-grid">
                {featuredContracts.map((c, i) => (
                    <div key={i} className="contract-item">
                        <div className="contract-info">
                            <span className="contract-name">{c.name}</span>
                            <span className="contract-addr">{c.address.slice(0, 10)}...</span>
                        </div>
                        <p className="contract-desc">{c.description}</p>
                        <a
                            href={`https://explorer.hiro.so/contract/${c.address}?chain=mainnet`}
                            target="_blank"
                            rel="noopener noreferrer"
                            className="btn-inspect"
                        >
                            Inspect Code ↗️
                        </a>
                    </div>
                ))}
            </div>
        </div>
    );
}
