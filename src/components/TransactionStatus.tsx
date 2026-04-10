'use client';

import { useState, useEffect } from 'react';

interface TransactionStatusProps {
    txId?: string;
    onClose: () => void;
}

export default function TransactionStatus({ txId, onClose }: TransactionStatusProps) {
    const [status, setStatus] = useState<'pending' | 'success' | 'error'>('pending');

    useEffect(() => {
        if (!txId) return;

        let isMounted = true;
        let pollCount = 0;
        const maxPolls = 60; // 5 minutes at 5s interval

        const pollStatus = async () => {
            if (!isMounted) return;

            try {
                // Poll from the mainnet API by default
                const url = `https://api.mainnet.hiro.so/extended/v1/tx/${txId}`;
                const response = await fetch(url);
                
                if (response.status === 404) {
                    // Not found yet (mempool), keep waiting
                    if (pollCount < maxPolls) {
                        pollCount++;
                        setTimeout(pollStatus, 5000);
                    } else {
                        setStatus('error');
                    }
                    return;
                }

                const data = await response.json();
                
                if (data.tx_status === 'success') {
                    setStatus('success');
                } else if (data.tx_status === 'abort_by_post_condition' || data.tx_status === 'abort_by_response') {
                    setStatus('error');
                } else {
                    // Still pending/mempool
                    if (pollCount < maxPolls) {
                        pollCount++;
                        setTimeout(pollStatus, 5000);
                    } else {
                        setStatus('error');
                    }
                }
            } catch (error) {
                console.error('Failed to poll tx status:', error);
                // On error, let's just wait and try again
                setTimeout(pollStatus, 8000);
            }
        };

        pollStatus();

        return () => {
            isMounted = false;
        };
    }, [txId]);


    return (
        <div className="transaction-status-overlay">
            <div className="status-card glass-card">
                <button className="close-btn" onClick={onClose}>&times;</button>
                
                {status === 'pending' && (
                    <div className="status-content">
                        <div className="spinner"></div>
                        <h3>Transaction Pending</h3>
                        <p>Waiting for broadcast confirmation...</p>
                        {txId && <code className="tx-id-short">{txId.substring(0, 10)}...</code>}
                    </div>
                )}

                {status === 'success' && (
                    <div className="status-content">
                        <div className="success-icon">✅</div>
                        <h3>Transaction Successful!</h3>
                        <p>Your action has been confirmed on the blockchain.</p>
                        <button className="btn-done" onClick={onClose}>Great!</button>
                    </div>
                )}

                {status === 'error' && (
                    <div className="status-content">
                        <div className="error-icon">❌</div>
                        <h3>Transaction Failed</h3>
                        <p>Something went wrong during the process.</p>
                        <button className="btn-retry" onClick={onClose}>Try Again</button>
                    </div>
                )}
            </div>

            <style jsx>{`
                .transaction-status-overlay {
                    position: fixed;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    background: rgba(0, 0, 0, 0.8);
                    backdrop-filter: blur(8px);
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    z-index: 1000;
                    animation: fadeIn 0.3s ease;
                }
                .status-card {
                    background: rgba(30, 41, 59, 0.7);
                    border: 1px solid rgba(255, 255, 255, 0.1);
                    padding: 3rem;
                    border-radius: 2rem;
                    text-align: center;
                    max-width: 400px;
                    width: 90%;
                    position: relative;
                }
                .close-btn {
                    position: absolute;
                    top: 1rem;
                    right: 1rem;
                    background: none;
                    border: none;
                    color: white;
                    font-size: 1.5rem;
                    cursor: pointer;
                    opacity: 0.5;
                }
                .spinner {
                    width: 50px;
                    height: 50px;
                    border: 4px solid rgba(255, 255, 255, 0.1);
                    border-left-color: #6366f1;
                    border-radius: 50%;
                    margin: 0 auto 1.5rem;
                    animation: spin 1s linear infinite;
                }
                @keyframes spin {
                    to { transform: rotate(360deg); }
                }
                @keyframes fadeIn {
                    from { opacity: 0; }
                    to { opacity: 1; }
                }
                .success-icon, .error-icon {
                    font-size: 4rem;
                    margin-bottom: 1.5rem;
                }
                .tx-id-short {
                    display: block;
                    margin-top: 1rem;
                    color: #94a3b8;
                    font-family: monospace;
                    background: rgba(0,0,0,0.2);
                    padding: 0.3rem 0.6rem;
                    border-radius: 4px;
                }
                .btn-done, .btn-retry {
                    margin-top: 2rem;
                    padding: 0.8rem 2rem;
                    border-radius: 0.8rem;
                    background: #6366f1;
                    color: white;
                    border: none;
                    cursor: pointer;
                    font-weight: 600;
                    transition: all 0.2s;
                }
                .btn-done:hover, .btn-retry:hover {
                    background: #4f46e5;
                    transform: translateY(-2px);
                }

            `}</style>
        </div>
    );
}
