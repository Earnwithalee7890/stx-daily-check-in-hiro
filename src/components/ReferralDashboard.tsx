'use client';

import { useState, useEffect } from 'react';
import { useConnect } from '@stacks/connect-react';
import { STACKS_MAINNET } from '@stacks/network';
import {
    fetchCallReadOnlyFunction,
    cvToValue,
    standardPrincipalCV
} from '@stacks/transactions';

export default function ReferralDashboard() {
    const { authOptions } = useConnect();
    const [userAddress, setUserAddress] = useState<string | null>(null);
    const [referralStats, setReferralStats] = useState({ referrals: 0, earnings: 0 });
    const [loading, setLoading] = useState(true);

    useEffect(() => {
        if (authOptions.userSession?.isUserSignedIn()) {
            const userData = authOptions.userSession.loadUserData();
            setUserAddress(userData.profile.stxAddress.mainnet);
        }
    }, [authOptions.userSession]);

    useEffect(() => {
        if (userAddress) {
            fetchReferralStats();
        }
    }, [userAddress]);

    const fetchReferralStats = async () => {
        if (!userAddress) return;
        try {
            const result = await fetchCallReadOnlyFunction({
                contractAddress: 'SP2PABAF9FTAJYNFZH93XENAJ8FVY99RRM50D2JG9', // Example, should be user's deployed addr
                contractName: 'referral-system',
                functionName: 'get-referral-stats',
                functionArgs: [standardPrincipalCV(userAddress)],
                network: STACKS_MAINNET,
                senderAddress: userAddress,
            });
            const value = cvToValue(result);
            setReferralStats({
                referrals: Number(value.referrals),
                earnings: Number(value.earnings) / 1000000,
            });
        } catch (error) {
            console.error('Error fetching referral stats:', error);
        } finally {
            setLoading(false);
        }
    };

    const copyReferralLink = () => {
        if (!userAddress) return;
        const link = `${window.location.origin}/?ref=${userAddress}`;
        navigator.clipboard.writeText(link);
        alert('Referral link copied to clipboard!');
    };

    if (!userAddress) return null;

    return (
        <div className="referral-dashboard card-premium glass-card" style={{ marginTop: '3rem', position: 'relative', overflow: 'hidden' }}>
            <div style={{ position: 'absolute', right: '-50px', top: '-50px', width: '200px', height: '200px', background: 'radial-gradient(circle, rgba(99, 102, 241, 0.15) 0%, transparent 70%)', pointerEvents: 'none' }}></div>

            <div className="card-header" style={{ marginBottom: '2rem', textAlign: 'center' }}>
                <h2 style={{ fontSize: '2rem', marginBottom: '0.5rem' }}>🤝 Referral Program</h2>
                <p style={{ color: '#94a3b8', fontSize: '1.1rem' }}>Invite friends and earn rewards when they check in!</p>
            </div>

            <div className="stats-grid premium-grid" style={{ display: 'grid', gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))', gap: '1.5rem', marginBottom: '3rem' }}>
                <div className="stat-card" style={{ background: 'rgba(255,255,255,0.03)', border: '1px solid rgba(255,255,255,0.1)', borderRadius: '20px', padding: '2rem', textAlign: 'center' }}>
                    <div style={{ fontSize: '2.5rem', marginBottom: '0.5rem' }}>👥</div>
                    <span className="stat-label" style={{ display: 'block', color: '#94a3b8', fontSize: '0.9rem', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Total Referrals</span>
                    <span className="stat-value" style={{ fontSize: '2.5rem', fontWeight: '800', color: '#fff' }}>{referralStats.referrals}</span>
                </div>
                <div className="stat-card" style={{ background: 'linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(236, 72, 153, 0.1) 100%)', border: '1px solid rgba(255,255,255,0.1)', borderRadius: '20px', padding: '2rem', textAlign: 'center' }}>
                    <div style={{ fontSize: '2.5rem', marginBottom: '0.5rem' }}>💎</div>
                    <span className="stat-label" style={{ display: 'block', color: '#e2e8f0', fontSize: '0.9rem', textTransform: 'uppercase', letterSpacing: '0.05em' }}>Total Earned</span>
                    <span className="stat-value" style={{ fontSize: '2.5rem', fontWeight: '800', color: '#fff' }}>{referralStats.earnings} <span style={{ fontSize: '1rem', color: '#a5b4fc' }}>STX</span></span>
                </div>
            </div>

            <div className="referral-link-section" style={{ background: 'rgba(0,0,0,0.2)', padding: '2rem', borderRadius: '16px', border: '1px solid rgba(255,255,255,0.05)' }}>
                <h3 style={{ marginBottom: '1rem', fontSize: '1.1rem' }}>Your Unique Referral Link</h3>
                <div className="link-input-group" style={{ display: 'flex', gap: '1rem', flexWrap: 'wrap' }}>
                    <input
                        type="text"
                        readOnly
                        value={`${window.location.origin}/?ref=${userAddress}`}
                        className="referral-input"
                        style={{
                            flex: 1,
                            minWidth: '250px',
                            background: 'rgba(0, 0, 0, 0.3)',
                            border: '1px solid rgba(99, 102, 241, 0.3)',
                            color: '#a5b4fc',
                            padding: '1rem 1.5rem',
                            borderRadius: '12px',
                            fontFamily: 'monospace',
                            fontSize: '1rem'
                        }}
                    />
                    <button onClick={copyReferralLink} className="btn-primary" style={{ padding: '0 2rem', borderRadius: '12px', whiteSpace: 'nowrap' }}>
                        Copy Link 📋
                    </button>
                </div>
            </div>

            {/* Styles removed in favor of inline for consistency with other components or global styles */}
        </div>
    );
}
