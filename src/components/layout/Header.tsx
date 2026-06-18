/**
 * @packageDocumentation
 * Header navigation component for the Syncio.
 */
import { useDarkMode } from '../../lib/useDarkMode';
import { STRINGS } from '../../lib/constants/strings';

interface HeaderProps {
    activeTab: string;
    setActiveTab: (tab: string) => void;
    userAddress: string;
    celoAddress?: string;
    handleConnect: () => void;
    handleCeloConnect?: () => void;
    handleDisconnect: () => void;
}

export const Header = ({ activeTab, setActiveTab, userAddress, celoAddress, handleConnect, handleCeloConnect, handleDisconnect }: HeaderProps) => {
    const { isDark, toggleDarkMode } = useDarkMode();

    return (
        <header style={{
            position: 'sticky',
            top: 0,
            zIndex: 100,
            background: 'rgba(15, 23, 42, 0.8)',
            backdropFilter: 'blur(12px)',
            borderBottom: '1px solid rgba(255, 255, 255, 0.05)',
            transition: 'all 0.3s ease'
        }}>
            <div 
                className="nav-container"
                style={{
                    maxWidth: '1440px',
                    margin: '0 auto',
                    padding: '0.75rem 2rem',
                    display: 'flex',
                    alignItems: 'center',
                    justifyContent: 'space-between',
                    gap: '2.5rem'
                }}
            >
                <div 
                    className="brand"
                    onClick={() => setActiveTab('dashboard')} 
                    style={{ 
                        display: 'flex', 
                        alignItems: 'center', 
                        gap: '1rem', 
                        cursor: 'pointer',
                        transition: 'transform 0.2s ease'
                    }}
                    onMouseOver={(e) => e.currentTarget.style.transform = 'scale(1.02)'}
                    onMouseOut={(e) => e.currentTarget.style.transform = 'scale(1)'}
                >
                    <div className="logo-wrapper" style={{
                        width: '42px',
                        height: '42px',
                        background: 'rgba(255, 255, 255, 0.03)',
                        borderRadius: '12px',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        border: '1px solid rgba(255, 255, 255, 0.1)',
                        boxShadow: '0 4px 20px rgba(0, 0, 0, 0.2)',
                        overflow: 'hidden'
                    }}>
                        <img src="/logo.png" alt="Syncio Logo" style={{ width: '100%', height: '100%', objectFit: 'contain' }} />
                    </div>
                    <div style={{ display: 'flex', flexDirection: 'column' }}>
                        <span className="brand-name" style={{ 
                            fontSize: '1.4rem', 
                            fontWeight: '800', 
                            letterSpacing: '-0.03em',
                            background: 'linear-gradient(135deg, #fff 0%, #a855f7 100%)',
                            WebkitBackgroundClip: 'text',
                            WebkitTextFillColor: 'transparent',
                            textShadow: '0 2px 10px rgba(168, 85, 247, 0.2)'
                        }}>
                            Syncio
                        </span>
                    </div>
                </div>

                <nav className="main-nav" style={{ 
                    display: 'flex', 
                    gap: '0.5rem', 
                    justifyContent: 'center',
                    background: 'rgba(255, 255, 255, 0.03)',
                    padding: '0.3rem',
                    borderRadius: '12px',
                    border: '1px solid rgba(255, 255, 255, 0.05)',
                    flex: 1
                }}>
                    {['dashboard', 'activity', 'deploy', 'jobs', 'badges', 'tools'].map((tab) => (
                        <button 
                            key={tab}
                            className="nav-link"
                            onClick={() => setActiveTab(tab)}
                            style={{
                                padding: '0.5rem 1rem',
                                borderRadius: '8px',
                                border: 'none',
                                background: activeTab === tab ? 'rgba(255, 255, 255, 0.08)' : 'transparent',
                                color: activeTab === tab ? '#fff' : '#94a3b8',
                                fontSize: '0.875rem',
                                fontWeight: '500',
                                cursor: 'pointer',
                                transition: 'all 0.2s ease',
                                display: 'flex',
                                alignItems: 'center',
                                gap: '0.5rem'
                            }}
                        >
                            {tab.charAt(0).toUpperCase() + tab.slice(1)}
                        </button>
                    ))}
                </nav>

                <div className="header-actions" style={{ display: 'flex', alignItems: 'center', gap: '0.75rem', flexShrink: 0 }}>
                    <button 
                        className="theme-toggle"
                        onClick={toggleDarkMode} 
                        style={{
                            background: 'rgba(255, 255, 255, 0.05)',
                            border: '1px solid rgba(255, 255, 255, 0.1)',
                            borderRadius: '10px',
                            color: '#e2e8f0',
                            width: '38px',
                            height: '38px',
                            cursor: 'pointer',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            transition: 'all 0.2s',
                            boxShadow: '0 2px 10px rgba(0, 0, 0, 0.1)'
                        }}
                    >
                        {isDark ? '🌙' : '☀️'}
                    </button>

                    {!userAddress ? (
                        <button 
                            className="btn-connect"
                            onClick={handleConnect}
                            style={{
                                background: 'linear-gradient(135deg, #6366f1 0%, #4f46e5 100%)',
                                color: '#fff',
                                padding: '0.5rem 1rem',
                                borderRadius: '10px',
                                border: 'none',
                                fontWeight: '600',
                                fontSize: '0.85rem',
                                cursor: 'pointer',
                                transition: 'all 0.2s ease',
                                boxShadow: '0 4px 12px rgba(99, 102, 241, 0.2)'
                            }}
                        >
                            Connect Stacks
                        </button>
                    ) : (
                        <div 
                            onClick={() => {
                                navigator.clipboard.writeText(userAddress);
                                alert('Address copied to clipboard!');
                            }}
                            style={{ 
                                background: 'linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(79, 70, 229, 0.1) 100%)',
                                padding: '0.4rem 0.75rem',
                                borderRadius: '10px',
                                border: '1px solid rgba(99, 102, 241, 0.3)',
                                display: 'flex',
                                alignItems: 'center',
                                gap: '0.5rem',
                                cursor: 'copy',
                                transition: 'all 0.2s ease',
                                boxShadow: '0 2px 10px rgba(0, 0, 0, 0.1)'
                            }}
                            title="Stacks Wallet"
                        >
                            <div style={{ 
                                width: '6px', 
                                height: '6px', 
                                borderRadius: '50%', 
                                background: '#10b981',
                                boxShadow: '0 0 8px rgba(16, 185, 129, 0.8)'
                            }}></div>
                            <span style={{ 
                                fontFamily: 'monospace', 
                                fontSize: '0.85rem',
                                color: '#f8fafc',
                                fontWeight: '600',
                                letterSpacing: '0.5px'
                            }}>
                                {userAddress.substring(0, 4)}...{userAddress.substring(userAddress.length - 4)}
                            </span>
                        </div>
                    )}
                    
                    {!celoAddress ? (
                        <button 
                            className="btn-connect"
                            onClick={handleCeloConnect}
                            style={{
                                background: 'linear-gradient(135deg, #fbcc5c 0%, #35d07f 100%)',
                                color: '#000',
                                padding: '0.5rem 1rem',
                                borderRadius: '10px',
                                border: 'none',
                                fontWeight: '600',
                                fontSize: '0.85rem',
                                cursor: 'pointer',
                                transition: 'all 0.2s ease',
                                boxShadow: '0 4px 12px rgba(53, 208, 127, 0.3)'
                            }}
                        >
                            Connect Celo
                        </button>
                    ) : (
                        <div 
                            onClick={() => {
                                navigator.clipboard.writeText(celoAddress);
                                alert('Celo Address copied!');
                            }}
                            style={{ 
                                background: 'linear-gradient(135deg, rgba(251, 204, 92, 0.1) 0%, rgba(53, 208, 127, 0.1) 100%)',
                                padding: '0.4rem 0.75rem',
                                borderRadius: '10px',
                                border: '1px solid rgba(251, 204, 92, 0.3)',
                                display: 'flex',
                                alignItems: 'center',
                                gap: '0.5rem',
                                cursor: 'copy',
                                transition: 'all 0.2s ease',
                                boxShadow: '0 2px 10px rgba(0, 0, 0, 0.1)'
                            }}
                            title="Celo Wallet"
                        >
                            <div style={{ 
                                width: '6px', 
                                height: '6px', 
                                borderRadius: '50%', 
                                background: '#35d07f',
                                boxShadow: '0 0 8px rgba(53, 208, 127, 0.8)'
                            }}></div>
                            <span style={{ 
                                fontFamily: 'monospace', 
                                fontSize: '0.85rem',
                                color: '#f8fafc',
                                fontWeight: '600',
                                letterSpacing: '0.5px'
                            }}>
                                {celoAddress.substring(0, 4)}...{celoAddress.substring(celoAddress.length - 4)}
                            </span>
                        </div>
                    )}

                    {(userAddress || celoAddress) && (
                        <button
                            onClick={handleDisconnect}
                            style={{
                                background: 'rgba(255, 255, 255, 0.03)',
                                color: '#94a3b8',
                                padding: '0.4rem 0.75rem',
                                borderRadius: '10px',
                                border: '1px solid rgba(255, 255, 255, 0.1)',
                                fontWeight: '600',
                                fontSize: '0.75rem',
                                cursor: 'pointer',
                                transition: 'all 0.2s ease',
                                display: 'flex',
                                alignItems: 'center',
                                gap: '0.4rem'
                            }}
                            onMouseOver={(e) => {
                                e.currentTarget.style.background = 'rgba(239, 68, 68, 0.1)';
                                e.currentTarget.style.color = '#ef4444';
                                e.currentTarget.style.borderColor = 'rgba(239, 68, 68, 0.3)';
                            }}
                            onMouseOut={(e) => {
                                e.currentTarget.style.background = 'rgba(255, 255, 255, 0.03)';
                                e.currentTarget.style.color = '#94a3b8';
                                e.currentTarget.style.borderColor = 'rgba(255, 255, 255, 0.1)';
                            }}
                            title="Disconnect All Wallets"
                        >
                            <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
                                <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                                <polyline points="16 17 21 12 16 7"></polyline>
                                <line x1="21" y1="12" x2="9" y2="12"></line>
                            </svg>
                        </button>
                    )}
                </div>
            </div>
        </header>
    );
};
