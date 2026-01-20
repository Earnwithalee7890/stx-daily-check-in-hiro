'use client';

/**
 * Premium Loading Skeleton component for modern UI shimmer effects.
 */
export function Skeleton({
    width = '100%',
    height = '1rem',
    borderRadius = '8px',
    className = ''
}: {
    width?: string | number,
    height?: string | number,
    borderRadius?: string,
    className?: string
}) {
    return (
        <div
            className={`skeleton-shimmer ${className}`}
            style={{
                width,
                height,
                borderRadius
            }}
        />
    );
}

/**
 * Pre-defined skeleton patterns for common UI elements.
 */
export function CardSkeleton() {
    return (
        <div className="glass-card skeleton-card">
            <Skeleton width="40%" height="1.5rem" className="mb-4" />
            <Skeleton width="100%" height="4rem" className="mb-4" />
            <Skeleton width="60%" height="1rem" />
        </div>
    );
}
