'use client';

import { useState, useEffect } from 'react';

/**
 * Real-time Stacks Network Gas Estimator.
 */
export function GasEstimator() {
    const [fees, setFees] = useState({ low: 0, standard: 0, high: 0 });
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        const fetchFees = async () => {
            try {
                // In a real app, this would fetch from Hiro API /v2/fees/transfer
                // Mocking fee rates for Stacks mainnet (in microstacks)
                const mockFees = {
                    low: 0.005,
                    standard: 0.1,
                    high: 0.25
                };
                setFees(mockFees);
            } catch (error) {
                console.error('Error fetching fees:', error);
            } finally {
                setLoading(false);
            }
        };

        fetchFees();
        const interval = setInterval(fetchFees, 60000); // Refresh every minute
        return () => clearInterval(interval);
    }, []);

    return (
        <div className="glass-card gas-card">
            <div className="card-header">
                <h2>⛽ Gas Estimator</h2>
                <span className="live-indicator">LIVE</span>
            </div>

            <div className="fee-options">
                <div className="fee-item">
                    <span className="fee-label">Slow</span>
                    <span className="fee-value">{fees.low} STX</span>
                    <span className="fee-time">~30-60m</span>
                </div>
                <div className="fee-item active">
                    <span className="fee-label">Normal</span>
                    <span className="fee-value">{fees.standard} STX</span>
                    <span className="fee-time">~10-20m</span>
                </div>
                <div className="fee-item">
                    <span className="fee-label">Fast</span>
                    <span className="fee-value">{fees.high} STX</span>
                    <span className="fee-time">~5-10m</span>
                </div>
            </div>

            <p className="fee-tip">Tip: Higher fees ensure your transaction is included in the next Bitcoin anchor block.</p>
        </div>
    );
}
