/**
 * @packageDocumentation
 * Header navigation component for the STX Builder Hub.
 */
import { useDarkMode } from '@/lib/useDarkMode';
import { STRINGS } from '@/lib/constants/strings';

interface HeaderProps {
    activeTab: string;
    setActiveTab: (tab: string) => void;
    userAddress: string;
    handleConnect: () => void;
}

export const Header = ({ activeTab, setActiveTab, userAddress, handleConnect }: HeaderProps) => {
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
            <div style={{
                maxWidth: '1440px',
                margin: '0 auto',
                padding: '0.75rem 2rem',
                display: 'grid',
                gridTemplateColumns: 'auto 1fr auto',
                alignItems: 'center',
                gap: '2.5rem'
            }}>
                <div 
                    onClick={() => setActiveTab('dashboard')} 
                    style={{ 
                        display: 'flex', 
                        alignItems: 'center', 
                        gap: '1rem', 
                        cursor: 'pointer' 
                    }}
                >
                    <div style={{
                        width: '36px',
                        height: '36px',
                        background: 'linear-gradient(135deg, #6366f1 0%, #a855f7 100%)',
                        borderRadius: '10px',
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        boxShadow: '0 0 20px rgba(99, 102, 241, 0.3)'
                    }}>
                        <img src="/logo.png" alt="S" style={{ width: '20px' }} />
                    </div>
                    <div style={{ display: 'flex', flexDirection: 'column' }}>
                        <span style={{ 
                            fontSize: '1.125rem', 
                            fontWeight: '700', 
                            letterSpacing: '-0.02em',
                            color: '#fff'
                        }}>
                            Stacks <span style={{ color: '#6366f1' }}>Builder</span> Hub
                        </span>
                        <span style={{ 
                            fontSize: '0.625rem', 
                            color: '#94a3b8', 
                            letterSpacing: '0.05em', 
                            textTransform: 'uppercase' 
                        }}>
                            Hyper-Expansion Phase
                        </span>
                    </div>
                </div>

                <nav style={{ 
                    display: 'flex', 
                    gap: '0.5rem', 
                    justifyContent: 'center',
                    background: 'rgba(255, 255, 255, 0.03)',
                    padding: '0.3rem',
                    borderRadius: '12px',
                    border: '1px solid rgba(255, 255, 255, 0.05)'
                }}>
                    {['dashboard', 'activity', 'deploy', 'jobs', 'badges', 'tools'].map((tab) => (
                        <button 
                            key={tab}
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

                <div style={{ display: 'flex', alignItems: 'center', gap: '1rem' }}>
                    <button 
                        onClick={toggleDarkMode} 
                        style={{
                            background: 'transparent',
                            border: '1px solid rgba(255, 255, 255, 0.1)',
                            borderRadius: '10px',
                            color: '#94a3b8',
                            width: '40px',
                            height: '40px',
                            cursor: 'pointer',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            transition: 'all 0.2s'
                        }}
                    >
                        {isDark ? '🌙' : '☀️'}
                    </button>

                    {!userAddress ? (
                        <button 
                            onClick={handleConnect}
                            style={{
                                background: 'linear-gradient(135deg, #6366f1 0%, #4f46e5 100%)',
                                color: '#fff',
                                padding: '0.6rem 1.25rem',
                                borderRadius: '10px',
                                border: 'none',
                                fontWeight: '600',
                                fontSize: '0.875rem',
                                cursor: 'pointer',
                                transition: 'all 0.2s ease',
                                boxShadow: '0 4px 12px rgba(99, 102, 241, 0.2)'
                            }}
                        >
                            Connect Wallet
                        </button>
                    ) : (
                        <div 
                            onClick={() => {
                                navigator.clipboard.writeText(userAddress);
                                alert('Address copied to clipboard!');
                            }}
                            style={{ 
                                background: 'rgba(255, 255, 255, 0.05)',
                                padding: '0.4rem 0.6rem 0.4rem 1rem',
                                borderRadius: '12px',
                                border: '1px solid rgba(255, 255, 255, 0.1)',
                                display: 'flex',
                                alignItems: 'center',
                                gap: '0.75rem',
                                cursor: 'copy'
                            }}
                            title="Click to copy address"
                        >
                            <span style={{ fontSize: '0.75rem', fontWeight: '600', color: '#fff' }}>
                                {userAddress.slice(0, 4)}...{userAddress.slice(-4)}
                            </span>
                            <div style={{
                                width: '28px',
                                height: '28px',
                                background: '#1e293b',
                                borderRadius: '6px',
                                display: 'flex',
                                alignItems: 'center',
                                justifyContent: 'center',
                                fontSize: '0.75rem',
                                color: '#6366f1',
                                border: '1px solid rgba(99, 102, 241, 0.2)'
                            }}>
                                📋
                            </div>
                        </div>
                    )}
                </div>
            </div>
        </header>
    );
};
