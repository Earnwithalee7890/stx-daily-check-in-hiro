'use client';

import Link from 'next/link';
import { Skeleton } from '@/components/Skeleton';

/**
 * Premium 404 Error Page for a high-end user experience.
 */
export default function NotFound() {
    return (
        <div className="container min-h-screen flex items-center justify-center">
            <div className="glass-card error-card text-center" style={{ maxWidth: '600px', margin: 'auto', marginTop: '10vh' }}>
                <div style={{ position: 'relative', display: 'inline-block', marginBottom: '2rem' }}>
                    <div style={{ fontSize: '8rem', fontWeight: '900', opacity: 0.1 }}>404</div>
                    <div style={{
                        position: 'absolute',
                        top: '50%',
                        left: '50%',
                        transform: 'translate(-50%, -50%)',
                        fontSize: '3rem',
                        fontWeight: '800',
                        color: 'var(--primary)',
                        width: '100%'
                    }}>
                        Lost in Space
                    </div>
                </div>

                <h2 style={{ fontSize: '2rem', marginBottom: '1rem' }}>Block Not Found</h2>
                <p style={{ color: 'var(--text-muted)', marginBottom: '2.5rem' }}>
                    The transaction, contract, or page you're looking for doesn't exist on this branch.
                    Let's get you back to the main block.
                </p>

                <div style={{ display: 'flex', gap: '1rem', justifyContent: 'center' }}>
                    <Link href="/" className="btn btn-primary">
                        🚀 Back to Dashboard
                    </Link>
                    <button className="btn" onClick={() => window.history.back()}>
                        ⬅️ Go Back
                    </button>
                </div>

                <div style={{ marginTop: '3rem', opacity: 0.5 }}>
                    <Skeleton width="100%" height="2px" borderRadius="1px" className="mb-4" />
                    <p style={{ fontSize: '0.8rem' }}>Verification Error: Page Hash Mismatch</p>
                </div>
            </div>
        </div>
    );
}
