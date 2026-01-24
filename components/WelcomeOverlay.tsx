'use client';

import { useState, useEffect } from 'react';

export const WelcomeOverlay = () => {
    const [show, setShow] = useState(true);
    const [phase, setPhase] = useState(0);

    useEffect(() => {
        // Phase 0: Initial state
        // Phase 1: Text appears
        const t1 = setTimeout(() => setPhase(1), 500);
        // Phase 2: Secondary text
        const t2 = setTimeout(() => setPhase(2), 1500);
        // Phase 3: Fade out
        const t3 = setTimeout(() => setPhase(3), 3500);
        // Remove from DOM
        const t4 = setTimeout(() => setShow(false), 4500);

        return () => {
            clearTimeout(t1);
            clearTimeout(t2);
            clearTimeout(t3);
            clearTimeout(t4);
        };
    }, []);

    if (!show) return null;

    return (
        <div style={{
            position: 'fixed',
            top: 0,
            left: 0,
            width: '100vw',
            height: '100vh',
            background: '#000',
            zIndex: 9999,
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'center',
            alignItems: 'center',
            opacity: phase === 3 ? 0 : 1,
            transition: 'opacity 1s ease-out',
            pointerEvents: phase === 3 ? 'none' : 'auto'
        }}>
            <h1 style={{
                fontSize: '4rem',
                fontWeight: '900',
                color: 'transparent',
                background: 'linear-gradient(135deg, #fff 0%, #6366f1 100%)',
                backgroundClip: 'text',
                WebkitBackgroundClip: 'text',
                opacity: phase >= 1 ? 1 : 0,
                transform: phase >= 1 ? 'scale(1)' : 'scale(0.8)',
                transition: 'all 0.8s cubic-bezier(0.34, 1.56, 0.64, 1)',
                textAlign: 'center',
                lineHeight: 1.1,
                marginBottom: '1rem'
            }}>
                WELCOME TO<br />
                <span style={{ color: '#ff4b4b', background: 'none', WebkitTextFillColor: '#ff4b4b' }}>STACKS CHECK IN</span>
            </h1>

            <div style={{
                fontSize: '1.5rem',
                color: '#94a3b8',
                opacity: phase >= 2 ? 1 : 0,
                transform: phase >= 2 ? 'translateY(0)' : 'translateY(20px)',
                transition: 'all 0.8s ease-out'
            }}>
                Top Base Builders: January Event
            </div>

            <div style={{
                marginTop: '3rem',
                width: '200px',
                height: '4px',
                background: 'rgba(255,255,255,0.1)',
                borderRadius: '2px',
                overflow: 'hidden'
            }}>
                <div style={{
                    height: '100%',
                    background: '#6366f1',
                    width: phase > 0 ? '100%' : '0%',
                    transition: 'width 3s ease-out'
                }} />
            </div>
        </div>
    );
};
