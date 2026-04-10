'use client';

/**
 * EcosystemStats component for high-level Hub metrics.
 * Designed with premium glassmorphism and data-driven aesthetics.
 */
export const EcosystemStats = () => {
    const stats = [
        { label: 'Total TVL', value: '42.5M STX', change: '+12%', icon: '💰' },
        { label: 'Active Builders', value: '1,284', change: '+8%', icon: '👷' },
        { label: 'Proposals Voted', value: '156', change: '+15%', icon: '🗳️' },
        { label: 'NFTs Traded', value: '8.2K', change: '+22%', icon: '🖼️' }
    ];

    return (
        <section style={{
            display: 'grid',
            gridTemplateColumns: 'repeat(auto-fit, minmax(240px, 1fr))',
            gap: '1.5rem',
            margin: '2rem 0'
        }}>
            {stats.map((stat, i) => (
                <div 
                    key={i}
                    style={{
                        background: 'rgba(255, 255, 255, 0.03)',
                        backdropFilter: 'blur(8px)',
                        border: '1px solid rgba(255, 255, 255, 0.05)',
                        borderRadius: '20px',
                        padding: '1.5rem',
                        display: 'flex',
                        flexDirection: 'column',
                        gap: '0.75rem',
                        transition: 'transform 0.3s ease, border-color 0.3s ease',
                        cursor: 'default'
                    }}
                    onMouseEnter={(e) => {
                        e.currentTarget.style.transform = 'translateY(-5px)';
                        e.currentTarget.style.borderColor = 'rgba(99, 102, 241, 0.3)';
                    }}
                    onMouseLeave={(e) => {
                        e.currentTarget.style.transform = 'translateY(0)';
                        e.currentTarget.style.borderColor = 'rgba(255, 255, 255, 0.05)';
                    }}
                >
                    <div style={{
                        display: 'flex',
                        justifyContent: 'space-between',
                        alignItems: 'flex-start'
                    }}>
                        <div style={{
                            width: '40px',
                            height: '40px',
                            background: 'rgba(99, 102, 241, 0.1)',
                            borderRadius: '12px',
                            display: 'flex',
                            alignItems: 'center',
                            justifyContent: 'center',
                            fontSize: '1.25rem'
                        }}>
                            {stat.icon}
                        </div>
                        <span style={{
                            fontSize: '0.75rem',
                            fontWeight: '600',
                            color: '#10b981',
                            background: 'rgba(16, 185, 129, 0.1)',
                            padding: '0.25rem 0.5rem',
                            borderRadius: '6px'
                        }}>
                            {stat.change}
                        </span>
                    </div>

                    <div style={{ display: 'flex', flexDirection: 'column' }}>
                        <span style={{ 
                            fontSize: '0.875rem', 
                            color: '#94a3b8', 
                            fontWeight: '500' 
                        }}>
                            {stat.label}
                        </span>
                        <span style={{ 
                            fontSize: '1.5rem', 
                            fontWeight: '700', 
                            color: '#fff',
                            letterSpacing: '-0.02em',
                            marginTop: '0.25rem'
                        }}>
                            {stat.value}
                        </span>
                    </div>

                    {/* Simple sparkline-style decoration */}
                    <div style={{
                        marginTop: '0.5rem',
                        height: '2px',
                        width: '100%',
                        background: 'rgba(255, 255, 255, 0.05)',
                        borderRadius: '1px',
                        overflow: 'hidden'
                    }}>
                        <div style={{
                            height: '100%',
                            width: `${40 + Math.random() * 50}%`,
                            background: 'linear-gradient(90deg, #6366f1, #a855f7)',
                            borderRadius: '1px'
                        }} />
                    </div>
                </div>
            ))}
        </section>
    );
};
