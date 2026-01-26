import { useState, useEffect } from 'react';
import { Skeleton } from './Skeleton';
import styles from './CheckInFeed.module.css';

interface Transaction {
    tx_id: string;
    sender_address: string;
    burn_block_time_iso: string;
    tx_status: string;
}

/**
 * Real-time feed component displaying recent builder check-ins.
 * Connects to Hiro Chainhooks (simulated) for updates.
 */
export function CheckInFeed() {
    const [transactions, setTransactions] = useState<Transaction[]>([]);
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchCheckIns = async () => {
            try {
                const response = await fetch(
                    'https://api.mainnet.hiro.so/extended/v1/tx?contract_address=SP2F500B8DTRK1EANJQ054BRAB8DDKN6QCMXGNFBT&contract_name=builder-rewards-v3&function_name=daily-check-in&limit=10'
                );
                const data = await response.json();
                const successTxs = data.results.filter((tx: Transaction) => tx.tx_status === 'success');
                setTransactions(successTxs);
            } catch (error) {
                console.error('Error fetching check-ins:', error);
            } finally {
                setLoading(false);
            }
        };

        fetchCheckIns();
        const interval = setInterval(fetchCheckIns, 30000); // Update every 30s
        return () => clearInterval(interval);
    }, []);

    return (
        <div className={`glass-card ${styles.feedCard}`}>
            <div className={styles.header} style={{ marginBottom: '1.25rem' }}>
                <h2>👀 Recent Check-Ins</h2>
                <span className={styles.statusText}>
                    Powered by <a href="https://hiro.so" target="_blank" rel="noopener noreferrer" className={styles.hiroLink}>Hiro Chainhooks</a>
                </span>
            </div>
            <div className={styles.listContainer} style={{ background: 'rgba(0,0,0,0.2)', borderRadius: '16px', padding: '1rem', maxHeight: '400px', overflowY: 'auto' }}>
                {loading ? (
                    <div style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem' }}>
                        {[1, 2, 3].map(i => (
                            <div key={i} className={styles.transactionItem} style={{
                                padding: '1rem',
                                background: 'rgba(255,255,255,0.03)',
                                borderRadius: '12px',
                                display: 'flex',
                                alignItems: 'center',
                                gap: '1rem'
                            }}>
                                <Skeleton width="40px" height="40px" borderRadius="50%" />
                                <div style={{ flex: 1 }}>
                                    <Skeleton width="120px" height="1rem" className="mb-2" />
                                    <Skeleton width="70px" height="0.8rem" />
                                </div>
                                <Skeleton width="50px" height="0.8rem" />
                            </div>
                        ))}
                    </div>
                ) : transactions.length === 0 ? (
                    <div style={{ textAlign: 'center', padding: '2rem', color: '#94a3b8' }}>
                        <div style={{ fontSize: '2rem', marginBottom: '0.5rem' }}>💤</div>
                        <p>No recent check-ins found.</p>
                    </div>
                ) : (
                    <div style={{ display: 'flex', flexDirection: 'column', gap: '0.75rem' }}>
                        {transactions.map((tx) => (
                            <div key={tx.tx_id} className={styles.transactionItem} style={{
                                display: 'flex',
                                alignItems: 'center',
                                justifyContent: 'space-between',
                                padding: '1rem',
                                background: 'linear-gradient(90deg, rgba(255,255,255,0.03) 0%, rgba(255,255,255,0.01) 100%)',
                                borderRadius: '12px',
                                border: '1px solid rgba(255,255,255,0.05)',
                                transition: 'all 0.2s ease'
                            }}>
                                <div className={styles.senderInfo} style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
                                    <div style={{
                                        width: '40px',
                                        height: '40px',
                                        background: 'rgba(16, 185, 129, 0.1)',
                                        borderRadius: '50%',
                                        display: 'flex',
                                        alignItems: 'center',
                                        justifyContent: 'center',
                                        fontSize: '1.2rem',
                                        border: '1px solid rgba(16, 185, 129, 0.2)'
                                    }}>
                                        ✅
                                    </div>
                                    <div style={{ display: 'flex', flexDirection: 'column' }}>
                                        <span className={styles.address} style={{ fontFamily: 'monospace', fontWeight: 'bold', color: '#e2e8f0' }}>
                                            {tx.sender_address.slice(0, 6)}...{tx.sender_address.slice(-4)}
                                        </span>
                                        <span className={styles.statusText} style={{ fontSize: '0.8rem', color: '#10b981', display: 'flex', alignItems: 'center', gap: '4px' }}>
                                            <span style={{ width: '6px', height: '6px', background: '#10b981', borderRadius: '50%', display: 'inline-block', boxShadow: '0 0 5px #10b981' }}></span>
                                            Checked In
                                        </span>
                                    </div>
                                </div>

                                <div style={{ display: 'flex', flexDirection: 'column', alignItems: 'flex-end', gap: '0.2rem' }}>
                                    <span className={styles.timestamp} style={{ fontSize: '0.8rem', color: '#94a3b8' }}>
                                        {new Date(tx.burn_block_time_iso).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                                    </span>
                                    <a
                                        href={`https://explorer.hiro.so/txid/${tx.tx_id}?chain=mainnet`}
                                        target="_blank"
                                        rel="noopener noreferrer"
                                        className={styles.explorerLink}
                                        style={{ fontSize: '0.8rem', color: '#6366f1', textDecoration: 'none', display: 'flex', alignItems: 'center', gap: '4px' }}
                                    >
                                        View <span style={{ fontSize: '1rem' }}>↗️</span>
                                    </a>
                                </div>
                            </div>
                        ))}
                    </div>
                )}
            </div>
        </div>
    );
}
