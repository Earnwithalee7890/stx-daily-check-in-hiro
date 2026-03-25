'use client';

import { useState, useEffect } from 'react';
import { Skeleton } from './Skeleton';

interface LeaderboardEntry {
    address: string;
    contracts: number;
    score: number;
    rank: number;
}

export function Leaderboard() {
    const [entries, setEntries] = useState<LeaderboardEntry[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const mockEntries: LeaderboardEntry[] = [
            { address: 'SP2F500B8DTRK1EANJQ054BRAB8DDKN6QCMXGNFBT', contracts: 102, score: 980, rank: 1 },
            { address: 'SP3X2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9', contracts: 45, score: 850, rank: 2 },
            { address: 'SP1PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9', contracts: 32, score: 720, rank: 3 },
            { address: 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9', contracts: 28, score: 650, rank: 4 },
            { address: 'SP3X6PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9', contracts: 15, score: 420, rank: 5 },
        ];

        setTimeout(() => {
            setEntries(mockEntries);
            setLoading(false);
        }, 800);
    }, []);

    return (
        <div style={{
            background: 'rgba(15, 23, 42, 0.6)',
            backdropFilter: 'blur(16px)',
            border: '1px solid rgba(255, 255, 255, 0.05)',
            borderRadius: '24px',
            padding: '2rem',
            boxShadow: '0 20px 50px rgba(0, 0, 0, 0.2)',
            overflow: 'hidden',
            position: 'relative'
        }}>
            <div style={{ 
                display: 'flex', 
                justifyContent: 'space-between', 
                alignItems: 'center',
                marginBottom: '2rem'
            }}>
                <div>
                    <h2 style={{ 
                        fontSize: '1.5rem', 
                        fontWeight: '700', 
                        color: '#fff', 
                        marginBottom: '0.25rem' 
                    }}>
                        🏆 Builder Council
                    </h2>
                    <p style={{ fontSize: '0.875rem', color: '#94a3b8' }}>
                        Top contributors in the Stacks ecosystem
                    </p>
                </div>
                <div style={{
                    background: 'rgba(99, 102, 241, 0.1)',
                    border: '1px solid rgba(99, 102, 241, 0.2)',
                    padding: '0.5rem 1rem',
                    borderRadius: '30px',
                    fontSize: '0.75rem',
                    fontWeight: '600',
                    color: '#a5b4fc',
                    letterSpacing: '0.05em',
                    textTransform: 'uppercase'
                }}>
                    Live Ranking
                </div>
            </div>

            <div style={{ width: '100%', overflowX: 'auto' }}>
                <table style={{ width: '100%', borderCollapse: 'collapse', textAlign: 'left' }}>
                    <thead>
                        <tr style={{ color: '#64748b', fontSize: '0.75rem', textTransform: 'uppercase', letterSpacing: '0.1em' }}>
                            <th style={{ padding: '0.75rem 1rem', fontWeight: '600' }}>Rank</th>
                            <th style={{ padding: '0.75rem 1rem', fontWeight: '600' }}>Builder</th>
                            <th style={{ padding: '0.75rem 1rem', fontWeight: '600', textAlign: 'center' }}>Contracts</th>
                            <th style={{ padding: '0.75rem 1rem', fontWeight: '600', textAlign: 'right' }}>Impact Score</th>
                        </tr>
                    </thead>
                    <tbody>
                        {loading ? (
                            Array(5).fill(0).map((_, i) => (
                                <tr key={i} style={{ borderTop: '1px solid rgba(255, 255, 255, 0.02)' }}>
                                    <td style={{ padding: '1.25rem 1rem' }}><Skeleton width="24px" height="24px" borderRadius="12px" /></td>
                                    <td style={{ padding: '1.25rem 1rem' }}><Skeleton width="180px" height="1rem" /></td>
                                    <td style={{ padding: '1.25rem 1rem' }}><Skeleton width="40px" height="1rem" /></td>
                                    <td style={{ padding: '1.25rem 1rem' }}><Skeleton width="60px" height="1.5rem" borderRadius="8px" /></td>
                                </tr>
                            ))
                        ) : (
                            entries.map((entry) => (
                                <tr 
                                    key={entry.address}
                                    style={{ 
                                        borderTop: '1px solid rgba(255, 255, 255, 0.02)',
                                        transition: 'all 0.2s ease',
                                        cursor: 'pointer'
                                    }}
                                    onMouseEnter={(e) => e.currentTarget.style.background = 'rgba(255, 255, 255, 0.02)'}
                                    onMouseLeave={(e) => e.currentTarget.style.background = 'transparent'}
                                >
                                    <td style={{ padding: '1.25rem 1rem' }}>
                                        <div style={{ 
                                            width: '32px', 
                                            height: '32px', 
                                            background: entry.rank === 1 ? 'linear-gradient(135deg, #fbbf24, #d97706)' : 
                                                       entry.rank === 2 ? 'linear-gradient(135deg, #94a3b8, #475569)' :
                                                       entry.rank === 3 ? 'linear-gradient(135deg, #b45309, #78350f)' : 'rgba(255, 255, 255, 0.05)',
                                            borderRadius: '8px',
                                            display: 'flex',
                                            alignItems: 'center',
                                            justifyContent: 'center',
                                            fontSize: '0.875rem',
                                            fontWeight: '700',
                                            color: entry.rank <= 3 ? '#fff' : '#94a3b8'
                                        }}>
                                            {entry.rank}
                                        </div>
                                    </td>
                                    <td style={{ padding: '1.25rem 1rem' }}>
                                        <div style={{ display: 'flex', alignItems: 'center', gap: '0.75rem' }}>
                                            <div style={{ 
                                                width: '28px', 
                                                height: '28px', 
                                                background: '#1e293b', 
                                                borderRadius: '6px',
                                                display: 'flex',
                                                alignItems: 'center',
                                                justifyContent: 'center',
                                                fontSize: '0.625rem',
                                                fontWeight: '600',
                                                color: '#6366f1'
                                            }}>
                                                {entry.address.slice(2, 4)}
                                            </div>
                                            <span style={{ fontFamily: 'monospace', color: '#cbd5e1', fontSize: '0.875rem' }}>
                                                {entry.address.slice(0, 6)}...{entry.address.slice(-4)}
                                            </span>
                                        </div>
                                    </td>
                                    <td style={{ padding: '1.25rem 1rem', textAlign: 'center', color: '#fff', fontWeight: '500' }}>
                                        {entry.contracts}
                                    </td>
                                    <td style={{ padding: '1.25rem 1rem', textAlign: 'right' }}>
                                        <span style={{ 
                                            background: 'rgba(99, 102, 241, 0.1)', 
                                            color: '#a5b4fc', 
                                            padding: '0.4rem 0.75rem', 
                                            borderRadius: '10px',
                                            fontSize: '0.875rem',
                                            fontWeight: '600'
                                        }}>
                                            {entry.score} XP
                                        </span>
                                    </td>
                                </tr>
                            ))
                        )}
                    </tbody>
                </table>
            </div>

            <button style={{
                width: '100%',
                marginTop: '1.5rem',
                padding: '0.875rem',
                background: 'transparent',
                border: '1px solid rgba(255, 255, 255, 0.1)',
                borderRadius: '12px',
                color: '#fff',
                fontSize: '0.875rem',
                fontWeight: '600',
                cursor: 'pointer',
                transition: 'all 0.2s ease'
            }}
            onMouseEnter={(e) => e.currentTarget.style.background = 'rgba(255, 255, 255, 0.05)'}
            onMouseLeave={(e) => e.currentTarget.style.background = 'transparent'}
            >
                View Analytics Dashboards
            </button>
        </div>
    );
}
