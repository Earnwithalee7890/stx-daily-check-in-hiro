'use client';

import { useState, useEffect, createContext, useContext } from 'react';

interface Toast {
    id: string;
    title: string;
    message: string;
    type: 'achievement' | 'success' | 'info';
}

const ToastContext = createContext<{
    addToast: (title: string, message: string, type: Toast['type']) => void;
} | undefined>(undefined);

export function ToastProvider({ children }: { children: React.ReactNode }) {
    const [toasts, setToasts] = useState<Toast[]>([]);

    const addToast = (title: string, message: string, type: Toast['type']) => {
        const id = Math.random().toString(36).substr(2, 9);
        setToasts(prev => [...prev, { id, title, message, type }]);
        setTimeout(() => {
            setToasts(prev => prev.filter(t => t.id !== id));
        }, 5000);
    };

    return (
        <ToastContext.Provider value={{ addToast }}>
            {children}
            <div className="toast-container" style={{
                position: 'fixed',
                bottom: '2rem',
                right: '2rem',
                display: 'flex',
                flexDirection: 'column',
                gap: '1rem',
                zIndex: 9999,
                pointerEvents: 'none'
            }}>
                {toasts.map(toast => (
                    <div key={toast.id} className={`toast ${toast.type}`} style={{
                        background: 'rgba(30, 41, 59, 0.9)',
                        backdropFilter: 'blur(16px)',
                        padding: '1rem',
                        borderRadius: '16px',
                        border: '1px solid rgba(255, 255, 255, 0.1)',
                        boxShadow: '0 10px 30px rgba(0, 0, 0, 0.5)',
                        display: 'flex',
                        alignItems: 'center',
                        gap: '1rem',
                        minWidth: '320px',
                        maxWidth: '400px',
                        animation: 'slideInRight 0.4s cubic-bezier(0.16, 1, 0.3, 1)',
                        pointerEvents: 'auto',
                        position: 'relative',
                        overflow: 'hidden'
                    }}>
                        <div style={{
                            position: 'absolute',
                            left: 0,
                            top: 0,
                            bottom: 0,
                            width: '6px',
                            background: toast.type === 'achievement' ? '#fbbf24' : toast.type === 'success' ? '#10b981' : '#6366f1'
                        }}></div>

                        <div className="toast-icon" style={{
                            fontSize: '1.5rem',
                            background: 'rgba(255, 255, 255, 0.05)',
                            padding: '0.5rem',
                            borderRadius: '12px'
                        }}>
                            {toast.type === 'achievement' ? '🏆' : toast.type === 'success' ? '✅' : 'ℹ️'}
                        </div>
                        <div className="toast-content" style={{ flex: 1 }}>
                            <div className="toast-title" style={{ fontWeight: 'bold', fontSize: '0.95rem', color: '#fff', marginBottom: '2px' }}>{toast.title}</div>
                            <div className="toast-message" style={{ fontSize: '0.85rem', color: '#cbd5e1' }}>{toast.message}</div>
                        </div>
                        <button className="toast-close" onClick={() => setToasts(prev => prev.filter(t => t.id !== toast.id))} style={{
                            background: 'none',
                            border: 'none',
                            color: '#64748b',
                            fontSize: '1.25rem',
                            cursor: 'pointer',
                            padding: '0.25rem'
                        }}>
                            &times;
                        </button>
                    </div>
                ))}
            </div>
            <style jsx global>{`
                @keyframes slideInRight {
                    from { transform: translateX(100%); opacity: 0; }
                    to { transform: translateX(0); opacity: 1; }
                }
            `}</style>
        </ToastContext.Provider>
    );
}

export const useToast = () => {
    const context = useContext(ToastContext);
    if (!context) throw new Error('useToast must be used within ToastProvider');
    return context;
};
