'use client';

import React from 'react';

interface ErrorBoundaryProps {
    children: React.ReactNode;
}

interface ErrorBoundaryState {
    hasError: boolean;
    error: Error | null;
}

export class ErrorBoundary extends React.Component<ErrorBoundaryProps, ErrorBoundaryState> {
    constructor(props: ErrorBoundaryProps) {
        super(props);
        this.state = { hasError: false, error: null };
    }

    static getDerivedStateFromError(error: Error) {
        return { hasError: true, error };
    }

    componentDidCatch(error: Error, errorInfo: React.ErrorInfo) {
        console.error('ErrorBoundary caught an error:', error, errorInfo);
    }

    render() {
        if (this.state.hasError) {
            return (
                <div className="error-boundary-container" style={{
                    minHeight: '400px',
                    display: 'flex',
                    flexDirection: 'column',
                    alignItems: 'center',
                    justifyContent: 'center',
                    padding: '3rem',
                    background: 'rgba(239, 68, 68, 0.05)',
                    border: '1px solid rgba(239, 68, 68, 0.2)',
                    borderRadius: '2rem',
                    margin: '2rem 0',
                    textAlign: 'center',
                    backdropFilter: 'blur(10px)'
                }}>
                    <div style={{ fontSize: '4rem', marginBottom: '1.5rem' }}>⚠️</div>
                    <h2 style={{ fontSize: '2rem', marginBottom: '1rem', color: '#f87171' }}>System Exception Detected</h2>
                    <p style={{ color: '#94a3b8', marginBottom: '2rem', maxWidth: '500px' }}>
                        The application encountered an unexpected error. Our engineers have been notified.
                    </p>
                    
                    <div style={{
                        width: '100%',
                        maxWidth: '600px',
                        background: 'rgba(0, 0, 0, 0.3)',
                        padding: '1.5rem',
                        borderRadius: '1rem',
                        marginBottom: '2rem',
                        textAlign: 'left',
                        overflowX: 'auto'
                    }}>
                        <code style={{ fontSize: '0.9rem', color: '#fca5a5', fontFamily: 'monospace' }}>
                            {this.state.error?.name}: {this.state.error?.message}
                        </code>
                    </div>

                    <button
                        onClick={() => window.location.reload()}
                        style={{
                            padding: '0.8rem 2.5rem',
                            borderRadius: '1rem',
                            background: '#ef4444',
                            color: 'white',
                            border: 'none',
                            fontWeight: '600',
                            cursor: 'pointer',
                            transition: 'all 0.2s',
                            boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)'
                        }}
                        onMouseOver={(e) => e.currentTarget.style.background = '#dc2626'}
                        onMouseOut={(e) => e.currentTarget.style.background = '#ef4444'}
                    >
                        Restore Application
                    </button>
                </div>
            );
        }

        return this.props.children;
    }
}
