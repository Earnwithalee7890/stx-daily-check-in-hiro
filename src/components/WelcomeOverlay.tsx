'use client';

import { useState, useEffect } from 'react';
import { STRINGS } from '../lib/constants/strings';

export const WelcomeOverlay = () => {
    const [show, setShow] = useState(true);
    const [phase, setPhase] = useState(0);

    useEffect(() => {
        const t1 = setTimeout(() => setPhase(1), 500);
        const t2 = setTimeout(() => setPhase(2), 1500);
        const t3 = setTimeout(() => setPhase(3), 3500);
        const t4 = setTimeout(() => setShow(false), 4500);

        return () => {
            clearTimeout(t1);
            clearTimeout(t2);
            clearTimeout(t3);
            clearTimeout(t4);
        };
    }, []);

    const handleSkip = () => {
        setPhase(3);
        setTimeout(() => setShow(false), 500);
    };

    if (!show) return null;

    return (
        <div style={{
            position: 'fixed',
            top: 0,
            left: 0,
            width: '100vw',
            height: '100vh',
            background: 'radial-gradient(circle at 50% 50%, #1e1b4b 0%, #020617 100%)',
            zIndex: 9999,
            display: 'flex',
            flexDirection: 'column',
            justifyContent: 'center',
            alignItems: 'center',
            opacity: phase === 3 ? 0 : 1,
            transition: 'opacity 0.8s ease-out',
            pointerEvents: phase === 3 ? 'none' : 'auto',
            backdropFilter: 'blur(20px)'
        }}>
            <div style={{
                position: 'absolute',
                top: 0,
                left: 0,
                width: '100%',
                height: '100%',
                backgroundImage: 'url("https://www.transparenttextures.com/patterns/carbon-fibre.png")',
                opacity: 0.05,
                pointerEvents: 'none'
            }} />

            <button
                onClick={handleSkip}
                style={{
                    position: 'absolute',
                    top: '2rem',
                    right: '2rem',
                    background: 'rgba(255, 255, 255, 0.05)',
                    border: '1px solid rgba(255, 255, 255, 0.1)',
                    backdropFilter: 'blur(10px)',
                    color: '#94a3b8',
                    padding: '0.6rem 1.2rem',
                    borderRadius: '30px',
                    cursor: 'pointer',
                    fontSize: '0.875rem',
                    fontWeight: '500',
                    letterSpacing: '0.025em',
                    opacity: phase >= 1 ? 1 : 0,
                    transition: 'all 0.3s ease',
                    boxShadow: '0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06)'
                }}
                onMouseEnter={(e) => {
                    e.currentTarget.style.background = 'rgba(255, 255, 255, 0.1)';
                    e.currentTarget.style.color = '#fff';
                }}
                onMouseLeave={(e) => {
                    e.currentTarget.style.background = 'rgba(255, 255, 255, 0.05)';
                    e.currentTarget.style.color = '#94a3b8';
                }}
            >
                Skip Intro
            </button>

            <div style={{
                display: 'flex',
                flexDirection: 'column',
                alignItems: 'center',
                gap: '2rem',
                maxWidth: '800px',
                padding: '0 2rem'
            }}>
                <h1 style={{
                    fontSize: 'clamp(3.5rem, 10vw, 7rem)',
                    fontWeight: '800',
                    color: '#fff',
                    textAlign: 'center',
                    lineHeight: 0.95,
                    letterSpacing: '-0.04em',
                    opacity: phase >= 1 ? 1 : 0,
                    transform: phase >= 1 ? 'translateY(0)' : 'translateY(40px)',
                    transition: 'all 1.2s cubic-bezier(0.16, 1, 0.3, 1)'
                }}>
                    <span style={{ 
                        opacity: 0.7, 
                        fontSize: '0.4em', 
                        display: 'block', 
                        letterSpacing: '0.2em', 
                        marginBottom: '0.5rem' 
                    }}>
                        WELCOME TO
                    </span>
                    <span style={{
                        background: 'linear-gradient(to bottom right, #fff 20%, #6366f1 100%)',
                        WebkitBackgroundClip: 'text',
                        WebkitTextFillColor: 'transparent',
                        filter: 'drop-shadow(0 20px 40px rgba(99, 102, 241, 0.4))'
                    }}>
                        STACKS HUB
                    </span>
                </h1>

                <div style={{
                    fontSize: 'clamp(1rem, 3vw, 1.25rem)',
                    color: '#94a3b8',
                    textAlign: 'center',
                    maxWidth: '500px',
                    lineHeight: 1.6,
                    opacity: phase >= 2 ? 1 : 0,
                    transform: phase >= 2 ? 'translateY(0)' : 'translateY(20px)',
                    transition: 'all 1s ease-out',
                    fontWeight: '400'
                }}>
                    {STRINGS.overlay.description}
                </div>

                <div style={{
                    marginTop: '2rem',
                    width: '280px',
                    height: '2px',
                    background: 'rgba(255, 255, 255, 0.05)',
                    borderRadius: '1px',
                    overflow: 'hidden'
                }}>
                    <div style={{
                        height: '100%',
                        background: 'linear-gradient(90deg, transparent, #6366f1, transparent)',
                        width: phase > 0 ? '100%' : '0%',
                        transition: 'width 4s cubic-bezier(0.65, 0, 0.35, 1)'
                    }} />
                </div>
            </div>
        </div>
    );
};

