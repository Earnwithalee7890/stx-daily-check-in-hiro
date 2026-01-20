'use client';

import { useState } from 'react';

/**
 * Premium Tooltip component for contextual information.
 */
export function Tooltip({
    text,
    children,
    position = 'top'
}: {
    text: string,
    children: React.ReactNode,
    position?: 'top' | 'bottom' | 'left' | 'right'
}) {
    const [isVisible, setIsVisible] = useState(false);

    return (
        <div
            className="tooltip-wrapper"
            onMouseEnter={() => setIsVisible(true)}
            onMouseLeave={() => setIsVisible(false)}
        >
            {children}
            {isVisible && (
                <div className={`tooltip-box tooltip-${position}`}>
                    {text}
                    <div className="tooltip-arrow"></div>
                </div>
            )}
        </div>
    );
}
