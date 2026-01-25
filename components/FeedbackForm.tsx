'use client';

import { useState } from 'react';
import { useToast } from './AchievementSystem';

/**
 * Enhanced Feedback Form component.
 */
export function FeedbackForm() {
    const [feedback, setFeedback] = useState('');
    const [submitting, setSubmitting] = useState(false);
    const { addToast } = useToast();

    const handleSubmit = (e: React.FormEvent) => {
        e.preventDefault();
        setSubmitting(true);

        // Simulate API call
        setTimeout(() => {
            addToast('Feedback Sent!', 'Thank you for helping us improve the Stacks ecosystem.', 'success');
            setFeedback('');
            setSubmitting(false);
        }, 1500);
    };

    return (
        <div className="glass-card feedback-card" style={{ position: 'relative' }}>
            <h2 style={{ marginBottom: '0.5rem' }}>💬 Feedback</h2>
            <p className="card-desc" style={{ marginBottom: '1.5rem', color: '#94a3b8' }}>Help us improve. Share your thoughts or report an issue.</p>
            <form className="feedback-form" onSubmit={handleSubmit} style={{ display: 'flex', flexDirection: 'column', gap: '1rem' }}>
                <textarea
                    value={feedback}
                    onChange={(e) => setFeedback(e.target.value)}
                    placeholder="Tell us what you think..."
                    required
                    rows={4}
                    style={{
                        width: '100%',
                        padding: '1rem',
                        borderRadius: '12px',
                        background: 'rgba(255,255,255,0.03)',
                        border: '1px solid rgba(255,255,255,0.1)',
                        color: 'white',
                        resize: 'none',
                        fontSize: '1rem',
                        transition: 'all 0.3s ease'
                    }}
                    onFocus={(e) => {
                        e.target.style.background = 'rgba(255,255,255,0.05)';
                        e.target.style.borderColor = '#6366f1';
                        e.target.style.outline = 'none';
                        e.target.style.boxShadow = '0 0 0 2px rgba(99, 102, 241, 0.2)';
                    }}
                    onBlur={(e) => {
                        e.target.style.background = 'rgba(255,255,255,0.03)';
                        e.target.style.borderColor = 'rgba(255,255,255,0.1)';
                        e.target.style.boxShadow = 'none';
                    }}
                />
                <button
                    type="submit"
                    className="btn btn-primary"
                    disabled={submitting}
                    style={{
                        display: 'flex',
                        alignItems: 'center',
                        justifyContent: 'center',
                        gap: '0.5rem',
                        padding: '0.8rem'
                    }}
                >
                    {submitting ? (
                        <>
                            <span className="loading" style={{ width: '1rem', height: '1rem', borderTopColor: 'currentColor' }}></span>
                            Sending...
                        </>
                    ) : (
                        <>
                            Send Feedback 📤
                        </>
                    )}
                </button>
            </form>
        </div>
    );
}
