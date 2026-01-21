'use client';

import React from 'react';

interface LoadingSpinnerProps {
    size?: 'sm' | 'md' | 'lg';
    color?: string;
    label?: string;
}

const sizeMap = {
    sm: 16,
    md: 24,
    lg: 40,
};

export function LoadingSpinner({
    size = 'md',
    color = '#6366f1',
    label = 'Loading...'
}: LoadingSpinnerProps) {
    const dimension = sizeMap[size];

    return (
        <div
            role="status"
            aria-label={label}
            style={{
                display: 'inline-flex',
                alignItems: 'center',
                gap: '8px'
            }}
        >
            <svg
                width={dimension}
                height={dimension}
                viewBox="0 0 24 24"
                xmlns="http://www.w3.org/2000/svg"
                style={{ animation: 'spin 1s linear infinite' }}
            >
                <style>
                    {`@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }`}
                </style>
                <circle
                    cx="12"
                    cy="12"
                    r="10"
                    stroke={color}
                    strokeWidth="3"
                    fill="none"
                    strokeLinecap="round"
                    strokeDasharray="31.4 31.4"
                />
            </svg>
            {size === 'lg' && (
                <span style={{ color, fontSize: '14px' }}>{label}</span>
            )}
        </div>
    );
}

export default LoadingSpinner;
