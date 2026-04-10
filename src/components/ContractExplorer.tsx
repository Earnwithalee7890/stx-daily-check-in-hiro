'use client';

import { useState } from 'react';

/**
 * ContractExplorer component to interact with ecosystem contracts.
 * Provides a professional, developer-focused interface.
 */
export const ContractExplorer = () => {
    const contracts = [
        { name: 'builder-profile-registry', category: 'Core', status: 'Active' },
        { name: 'message-board', category: 'Social', status: 'Active' },
        { name: 'dao-governance', category: 'Governance', status: 'Active' },
        { name: 'staking-rewards', category: 'DeFi', status: 'Beta' },
        { name: 'nft-marketplace', category: 'NFT', status: 'Active' },
        { name: 'version-tracker', category: 'Utils', status: 'Active' }
    ];

    const [search, setSearch] = useState('');

    const filtered = contracts.filter(c => 
        c.name.toLowerCase().includes(search.toLowerCase()) || 
        c.category.toLowerCase().includes(search.toLowerCase())
    );

    return (
        <div style={{
            background: 'rgba(15, 23, 42, 0.4)',
            border: '1px solid rgba(255, 255, 255, 0.05)',
            borderRadius: '20px',
            padding: '1.5rem',
            marginTop: '2rem'
        }}>
            <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', marginBottom: '1.5rem' }}>
                <h3 style={{ fontSize: '1.125rem', fontWeight: '600', color: '#fff' }}>
                    🔍 Ecosystem Contracts
                </h3>
                <input 
                    type="text" 
                    placeholder="Search contracts..." 
                    value={search}
                    onChange={(e) => setSearch(e.target.value)}
                    style={{
                        background: 'rgba(255, 255, 255, 0.05)',
                        border: '1px solid rgba(255, 255, 255, 0.1)',
                        borderRadius: '10px',
                        padding: '0.5rem 1rem',
                        color: '#fff',
                        fontSize: '0.875rem',
                        outline: 'none',
                        width: '200px'
                    }}
                />
            </div>

            <div style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fill, minmax(280px, 1fr))', gap: '1rem' }}>
                {filtered.map((contract) => (
                    <div 
                        key={contract.name}
                        style={{
                            background: 'rgba(255, 255, 255, 0.02)',
                            border: '1px solid rgba(255, 255, 255, 0.05)',
                            borderRadius: '12px',
                            padding: '1rem',
                            display: 'flex',
                            flexDirection: 'column',
                            gap: '0.5rem',
                            cursor: 'pointer',
                            transition: 'all 0.2s'
                        }}
                        onMouseEnter={(e) => {
                            e.currentTarget.style.background = 'rgba(255, 255, 255, 0.05)';
                            e.currentTarget.style.borderColor = 'rgba(99, 102, 241, 0.3)';
                        }}
                        onMouseLeave={(e) => {
                            e.currentTarget.style.background = 'rgba(255, 255, 255, 0.02)';
                            e.currentTarget.style.borderColor = 'rgba(255, 255, 255, 0.05)';
                        }}
                    >
                        <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center' }}>
                            <span style={{ fontSize: '0.875rem', fontWeight: '600', color: '#fff' }}>
                                {contract.name}.clar
                            </span>
                            <span style={{ 
                                fontSize: '0.625rem', 
                                padding: '0.2rem 0.5rem', 
                                borderRadius: '4px',
                                background: contract.status === 'Active' ? 'rgba(16, 185, 129, 0.1)' : 'rgba(245, 158, 11, 0.1)',
                                color: contract.status === 'Active' ? '#10b981' : '#f59e0b',
                                fontWeight: '700',
                                textTransform: 'uppercase'
                            }}>
                                {contract.status}
                            </span>
                        </div>
                        <span style={{ fontSize: '0.75rem', color: '#64748b' }}>
                            Category: <span style={{ color: '#94a3b8' }}>{contract.category}</span>
                        </span>
                    </div>
                ))}
            </div>
        </div>
    );
};
