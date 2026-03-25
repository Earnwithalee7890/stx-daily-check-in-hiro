'use client';

import { useState, useEffect } from 'react';

/**
 * Toast types for different status levels.
 */
export type ToastType = 'success' | 'error' | 'info' | 'warning';

interface ToastProps {
    message: string;
    type: ToastType;
    duration?: number;
    onClose: () => void;
}

/**
 * Premium Toast Notification component with glassmorphism and animations.
 */
export const ToastNotification = ({ message, type, duration = 5000, onClose }: ToastProps) => {
    const [isVisible, setIsVisible] = useState(false);

    useEffect(() => {
        setIsVisible(true);
        const timer = setTimeout(() => {
            setIsVisible(false);
            setTimeout(onClose, 500); // Wait for fade-out animation
        }, duration);

        return () => clearTimeout(timer);
    }, [duration, onClose]);

    const colors = {
        success: '#10b981',
        error: '#ef4444',
        info: '#6366f1',
        warning: '#f59e0b'
    };

    const icons = {
        success: '✅',
        error: '❌',
        info: 'ℹ️',
        warning: '⚠️'
    };

    return (
        <div style={{
            position: 'fixed',
            bottom: '2rem',
            right: '2rem',
            zIndex: 10000,
            background: 'rgba(15, 23, 42, 0.9)',
            backdropFilter: 'blur(12px)',
            border: `1px solid ${colors[type]}44`,
            borderRadius: '16px',
            padding: '1rem 1.5rem',
            display: 'flex',
            alignItems: 'center',
            gap: '1rem',
            color: '#fff',
            boxShadow: `0 10px 30px -10px ${colors[type]}44`,
            transform: isVisible ? 'translateX(0)' : 'translateX(120%)',
            opacity: isVisible ? 1 : 0,
            transition: 'all 0.5s cubic-bezier(0.16, 1, 0.3, 1)',
            maxWidth: '400px'
        }}>
            <div style={{
                width: '32px',
                height: '32px',
                background: `${colors[type]}22`,
                borderRadius: '8px',
                display: 'flex',
                alignItems: 'center',
                justifyContent: 'center',
                fontSize: '1rem'
            }}>
                {icons[type]}
            </div>
            
            <div style={{ display: 'flex', flexDirection: 'column', flex: 1 }}>
                <span style={{ fontSize: '0.875rem', fontWeight: '600', textTransform: 'capitalize' }}>
                    {type}
                </span>
                <span style={{ fontSize: '0.8125rem', color: '#94a3b8', lineHeight: 1.4 }}>
                    {message}
                </span>
            </div>

            <button 
                onClick={() => setIsVisible(false)}
                style={{
                    background: 'transparent',
                    border: 'none',
                    color: '#475569',
                    cursor: 'pointer',
                    fontSize: '1.25rem',
                    padding: '0.25rem',
                    lineHeight: 1,
                    transition: 'color 0.2s'
                }}
                onMouseEnter={(e) => e.currentTarget.style.color = '#fff'}
                onMouseLeave={(e) => e.currentTarget.style.color = '#475569'}
            >
                ×
            </button>

            {/* Progress bar */}
            <div style={{
                position: 'absolute',
                bottom: 0,
                left: 0,
                height: '2px',
                background: colors[type],
                width: isVisible ? '0%' : '100%',
                transition: `width ${duration}ms linear`,
                borderRadius: '0 0 16px 16px'
            }} />
        </div>
    );
};
