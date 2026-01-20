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
        <div className="glass-card feedback-card">
            <h2>💬 Feedback</h2>
            <p className="card-desc">Help us improve. Share your thoughts or report an issue.</p>
            <form className="feedback-form" onSubmit={handleSubmit}>
                <textarea
                    value={feedback}
                    onChange={(e) => setFeedback(e.target.value)}
                    placeholder="Message..."
                    required
                />
                <button type="submit" className="btn btn-primary" disabled={submitting}>
                    {submitting ? <span className="loading"></span> : 'Send Feedback'}
                </button>
            </form>
        </div>
    );
}
