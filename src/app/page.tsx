'use client';

import dynamic from 'next/dynamic';
import { ErrorBoundary } from '../components/ErrorBoundary';

const ClientPage = dynamic(() => import('../components/ClientPage'), {
    ssr: false,
    loading: () => (
        <div style={{
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'center',
            alignItems: 'center',
            minHeight: '100vh',
            background: '#020617',
            color: '#94a3b8',
            fontFamily: 'system-ui, sans-serif'
        }}>
            <div style={{
                width: '40px',
                height: '40px',
                border: '3px solid rgba(99, 102, 241, 0.1)',
                borderTopColor: '#6366f1',
                borderRadius: '50%',
                animation: 'spin 1s linear infinite',
                marginBottom: '1rem'
            }} />
            <span style={{ fontSize: '0.875rem', fontWeight: '500', letterSpacing: '0.05em' }}>
                INITIALIZING STACKS HUB...
            </span>
            <style>{`
                @keyframes spin { to { transform: rotate(360deg); } }
            `}</style>
        </div>
    ),
});

export default function Home() {
    return (
        <main style={{ background: '#020617', minHeight: '100vh', position: 'relative', overflow: 'hidden' }}>
            {/* Premium Animated Background Blobs */}
            <div style={{
                position: 'fixed',
                top: '-10%',
                left: '-10%',
                width: '40%',
                height: '40%',
                background: 'radial-gradient(circle, rgba(99, 102, 241, 0.15) 0%, transparent 70%)',
                filter: 'blur(80px)',
                zIndex: 0,
                pointerEvents: 'none'
            }} />
            <div style={{
                position: 'fixed',
                bottom: '-10%',
                right: '-10%',
                width: '50%',
                height: '50%',
                background: 'radial-gradient(circle, rgba(168, 85, 247, 0.1) 0%, transparent 70%)',
                filter: 'blur(100px)',
                zIndex: 0,
                pointerEvents: 'none'
            }} />

            <div style={{ position: 'relative', zIndex: 1 }}>
                <ErrorBoundary>
                    <ClientPage />
                </ErrorBoundary>
            </div>
        </main>
    );
}
