import { useState, useEffect } from 'react';
import styles from './CheckInFeed.module.css';

interface Transaction {
    tx_id: string;
    sender_address: string;
    burn_block_time_iso: string;
    tx_status: string;
}

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
            <div className={styles.header}>
                <h2>👀 Recent Check-Ins</h2>
                <span className={styles.statusText}>
                    Powered by <a href="https://hiro.so" target="_blank" rel="noopener noreferrer" className={styles.hiroLink}>Hiro Chainhooks</a>
                </span>
            </div>
            <div className={styles.listContainer}>
                {loading ? (
                    <p>Loading recent activity...</p>
                ) : transactions.length === 0 ? (
                    <p>No recent check-ins found.</p>
                ) : (
                    <div style={{ display: 'flex', flexDirection: 'column' }}>
                        {transactions.map((tx) => (
                            <div key={tx.tx_id} className={styles.transactionItem}>
                                <div className={styles.senderInfo}>
                                    <span>✅</span>
                                    <div style={{ display: 'flex', flexDirection: 'column' }}>
                                        <span className={styles.address}>
                                            {tx.sender_address.slice(0, 6)}...{tx.sender_address.slice(-4)}
                                        </span>
                                        <span className={styles.statusText}>
                                            Checked In
                                        </span>
                                    </div>
                                </div>
                                <span className={styles.timestamp}>
                                    {new Date(tx.burn_block_time_iso).toLocaleTimeString()}
                                </span>
                                <a
                                    href={`https://explorer.hiro.so/txid/${tx.tx_id}?chain=mainnet`}
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    className={styles.explorerLink}
                                >
                                    ↗️
                                </a>
                            </div>
                        ))}
                    </div>
                )}
            </div>
        </div>
    );
}
