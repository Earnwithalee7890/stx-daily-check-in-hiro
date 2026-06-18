/**
 * @packageDocumentation
 * Main client-side application entry point.
 */
'use client';

import '../lib/polyfill';

import { useState, useCallback, useTransition } from 'react';
import { WelcomeOverlay } from './WelcomeOverlay';
import { CheckInFeed } from './CheckInFeed';
import { ContractDeployer } from './ContractDeployer';
import { JobBoard } from './JobBoard';
import { Governance } from './Governance';
import { AchievementBadges } from './AchievementBadges';
import { CodeExplorer } from './CodeExplorer';
import SocialLinks from './SocialLinks';
import ReferralDashboard from './ReferralDashboard';
import BadgeMinter from './BadgeMinter';
import { Leaderboard } from './Leaderboard';
import { useEffect } from 'react';
import { useDarkMode } from '../lib/useDarkMode';
import { useToast } from './AchievementSystem';
import { Tooltip } from './Tooltip';
import { Roadmap } from './Roadmap';
import { FAQ } from './FAQ';
import { GasEstimator } from './GasEstimator';
import { ContractBrowser } from './ContractBrowser';
import { UserSettings } from './UserSettings';
import { FeedbackForm } from './FeedbackForm';
import { Modal } from './Modal';
import { AdminPanelView } from './views/AdminPanelView';
import TransactionStatus from './TransactionStatus';
import { Header } from './layout/Header';
import { Footer } from './layout/Footer';
import { DashboardView } from './views/DashboardView';
import { ToolsView } from './views/ToolsView';


import { Connect } from '@stacks/connect-react';
import { AppConfig, UserSession } from '@stacks/connect';
import * as StacksConnectModule from '@stacks/connect';
import * as StacksTransactionsModule from '@stacks/transactions';

const appConfig = new AppConfig(['store_write', 'publish_data']);
export const userSession = new UserSession({ appConfig });

/**
 * The main client-side entry point for the STX Builder Hub.
 * Manages wallet connection, navigation, and core dashboard actions.
 * 
 * Includes logic for routing between:
 * - Dashboard (Stats & Actions)
 * - Admin Panel (Owner Only)
 * - Tools & Utilities
 * 
 * Week 3: Migrated to WalletKit SDK for Week 3 tracking compliance.
 */
export default function ClientPage() {
    /** The authenticated user's Stacks address */
    const [userAddress, setUserAddress] = useState('');
    const { isDark, toggleDarkMode } = useDarkMode();
    const { addToast } = useToast();
    const [activeTxId, setActiveTxId] = useState<string | undefined>(undefined);

    /** Current active navigation tab */
    const [activeTab, setActiveTabStart] = useState<'dashboard' | 'deploy' | 'activity' | 'jobs' | 'governance' | 'badges' | 'explorer' | 'referrals' | 'nft-badges' | 'admin' | 'tools'>('dashboard');
    const [isPending, startTransition] = useTransition();

    const setActiveTab = (tab: any) => {
        startTransition(() => {
            setActiveTabStart(tab);
        });
    };

    // Handle tab change with scroll to content
    const handleTabChange = useCallback((tab: string) => {
        console.log('Tab clicked:', tab);
        setActiveTab(tab);

        // Scroll to content after tab change
        setTimeout(() => {
            // Find the main content area (after the header)
            const header = document.querySelector('.sticky-header');
            if (header) {
                const headerHeight = header.getBoundingClientRect().height;
                // Scroll to just below the header with some padding
                window.scrollTo({
                    top: headerHeight + 100,
                    behavior: 'smooth'
                });
            } else {
                // Fallback: scroll to a reasonable position
                window.scrollTo({
                    top: 400,
                    behavior: 'smooth'
                });
            }
        }, 100);
    }, []);

    // Dashboard state
    /** Total number of successful check-ins detected locally */
    const [checkInCount, setCheckInCount] = useState(0);
    const [loading, setLoading] = useState(false);
    const [message, setMessage] = useState('');

    useEffect(() => {
        // Detect referral in URL
        const params = new URLSearchParams(window.location.search);
        const ref = params.get('ref');
        if (ref) {
            localStorage.setItem('referral_code', ref);
            console.log('Referral detected:', ref);
        }

        // Handle Stacks session loading
        if (userSession.isSignInPending()) {
            userSession.handlePendingSignIn().then((userData) => {
                setUserAddress(userData.profile.stxAddress.mainnet);
            });
        } else if (userSession.isUserSignedIn()) {
            setUserAddress(userSession.loadUserData().profile.stxAddress.mainnet);
        }
    }, []);

    const handleConnect = useCallback(() => {
        if (typeof window === 'undefined') return;

        StacksConnectModule.authenticate({
            userSession,
            appDetails: {
                name: 'STX Builder Hub',
                icon: window.location.origin + '/logo.png',
            },
            onFinish: (data: any) => {
                const addr = data.userSession.loadUserData().profile.stxAddress.mainnet;
                setUserAddress(addr);
                setMessage('✅ Wallet connected!');
                addToast('New Milestone!', 'Builder Portfolio Connected successfully.', 'achievement');
            },
            onCancel: () => {
                setMessage('❌ Connection cancelled');
            },
        });
    }, []);

    const handleDisconnect = useCallback(() => {
        if (typeof window === 'undefined') return;
        userSession.signUserOut();
        setUserAddress('');
        setMessage('Wallet disconnected');
    }, []);

    const handleCheckIn = async () => {
        if (!userAddress) {
            setMessage('❌ Please connect wallet first');
            return;
        }

        setLoading(true);
        setMessage('');

        try {
            await StacksConnectModule.openContractCall({
                contractAddress: 'SP2F500B8DTRK1EANJQ054BRAB8DDKN6QCMXGNFBT',
                contractName: 'presidential-crimson-vicuna', // Deployed activity tracking contract
                functionName: 'log-activity',
                functionArgs: [],
                network: 'mainnet',
                anchorMode: StacksTransactionsModule.AnchorMode.Any,
                postConditionMode: StacksTransactionsModule.PostConditionMode.Allow,
                onFinish: (data: any) => {
                    setMessage(`✅ Activity logged successfully! | TX: ${data.txId}`);
                    setActiveTxId(data.txId);
                    setCheckInCount(prev => prev + 1);
                    setLoading(false);
                },

                onCancel: () => {
                    setMessage('❌ Transaction cancelled');
                    setLoading(false);
                },
            });
        } catch (error) {
            setMessage(`❌ Error: ${error instanceof Error ? error.message : 'Unknown error'}`);
            setLoading(false);
        }
    };

    const handleClaimReward = async () => {
        if (!userAddress) {
            setMessage('❌ Please connect wallet first');
            return;
        }

        setLoading(true);
        setMessage('');

        try {
            await StacksConnectModule.openContractCall({
                contractAddress: 'SP2F500B8DTRK1EANJQ054BRAB8DDKN6QCMXGNFBT',
                contractName: 'presidential-crimson-vicuna',
                functionName: 'claim-grant',
                functionArgs: [],
                network: 'mainnet',
                anchorMode: StacksTransactionsModule.AnchorMode.Any,
                postConditionMode: StacksTransactionsModule.PostConditionMode.Allow,
                onFinish: (data: any) => {
                    setMessage(`✅ Grant claimed! Your profile has been upgraded! | TX: ${data.txId}`);
                    setActiveTxId(data.txId);
                    setLoading(false);
                },

                onCancel: () => {
                    setMessage('❌ Transaction cancelled');
                    setLoading(false);
                },
            });
        } catch (error) {
            setMessage(`❌ Error: ${error instanceof Error ? error.message : 'Unknown error'}`);
            setLoading(false);
        }
    };

    const handleClaimCheckinRewards = async () => {
        if (!userAddress) {
            setMessage('❌ Please connect wallet first');
            return;
        }

        setLoading(true);
        setMessage('');

        try {
            await StacksConnectModule.openContractCall({
                contractAddress: 'SP2F500B8DTRK1EANJQ054BRAB8DDKN6QCMXGNFBT',
                contractName: 'presidential-crimson-vicuna',
                functionName: 'claim-grant',
                functionArgs: [],
                network: 'mainnet',
                anchorMode: StacksTransactionsModule.AnchorMode.Any,
                postConditionMode: StacksTransactionsModule.PostConditionMode.Allow,
                onFinish: (data: any) => {
                    setMessage(`✅ Grant claimed successfully! TX: ${data.txId}`);
                    setActiveTxId(data.txId);
                    setLoading(false);
                },

                onCancel: () => {
                    setMessage('❌ Transaction cancelled');
                    setLoading(false);
                },
            });
        } catch (error) {
            setMessage(`❌ Error: ${error instanceof Error ? error.message : 'Unknown error'}`);
            setLoading(false);
        }
    };

    const handleShare = () => {
        if (typeof window === 'undefined') return;
        navigator.clipboard.writeText(window.location.href);
        addToast('Link Copied!', 'Dashboard URL has been copied to your clipboard.', 'success');
    };

    const authOptions = {
        appDetails: {
            name: 'STX Builder Hub',
            icon: typeof window !== 'undefined' ? window.location.origin + '/logo.png' : 'https://stacks-builder-challenge.vercel.app/logo.png',
        },
        userSession,
        onFinish: (data: any) => {
            const addr = data.userSession.loadUserData().profile.stxAddress.mainnet;
            setUserAddress(addr);
            setMessage('✅ Wallet connected!');
        }
    };

    return (
        <Connect authOptions={authOptions}>
            <WelcomeOverlay />
            <main className="container app-main">
                <Header
                    activeTab={activeTab}
                    setActiveTab={handleTabChange}
                    userAddress={userAddress}
                    handleConnect={handleConnect}
                    handleDisconnect={handleDisconnect}
                />

                <div className="glass-card main-content-wrapper" style={{ padding: '2rem', marginTop: '2rem' }}>
                    {activeTab === 'dashboard' && (
                        <DashboardView
                            userAddress={userAddress}
                            checkInCount={checkInCount}
                            loading={loading}
                            message={message}
                            handleCheckIn={handleCheckIn}
                            handleClaimReward={handleClaimReward}
                            handleClaimCheckinRewards={handleClaimCheckinRewards}
                        />
                    )}

                    {userAddress && (
                        <>
                            {activeTab === 'deploy' && <div className="content-animate"><ContractDeployer /></div>}

                            {activeTab === 'activity' && <div className="content-animate"><CheckInFeed /></div>}

                            {activeTab === 'jobs' && <div className="content-animate"><JobBoard userAddress={userAddress} setMessage={setMessage} /></div>}

                            {activeTab === 'governance' && <div className="content-animate"><Governance userAddress={userAddress} setMessage={setMessage} /></div>}

                            {activeTab === 'explorer' && <div className="content-animate"><CodeExplorer /></div>}

                            {activeTab === 'badges' && <div className="content-animate"><AchievementBadges /></div>}

                            {activeTab === 'referrals' && <div className="content-animate"><ReferralDashboard /></div>}

                            {activeTab === 'nft-badges' && <div className="content-animate"><BadgeMinter /></div>}

                            {activeTab === 'tools' && <ToolsView userAddress={userAddress} />}

                            {activeTab === 'admin' && <AdminPanelView userAddress={userAddress} />}

                        </>
                    )}
                </div>

                <SocialLinks />

                <Footer setActiveTab={handleTabChange} />
            </main>
            {activeTxId && (
                <TransactionStatus 
                    txId={activeTxId} 
                    onClose={() => setActiveTxId(undefined)} 
                />
            )}
            <div className="page-transition-overlay"></div>
        </Connect>
    );
}
