'use client';

import { useState } from 'react';

/**
 * Interactive FAQ Accordion component.
 */
export function FAQ() {
    const [openIndex, setOpenIndex] = useState<number | null>(0);

    const questions = [
        { q: 'What is the Stacks Builder Challenge?', a: 'A multi-week event where developers build and deploy Clarity smart contracts on the Stacks blockchain to earn rewards.' },
        { q: 'How do I start building?', a: 'You can use our built-in Contract Deployer or explore the Code base to see examples of Clarity smart contracts.' },
        { q: 'What is the "Check-In" fee?', a: 'Each check-in costs 0.1 STX. This small fee ensures network activity and qualifies you for builder rewards.' },
        { q: 'How are milestones tracked?', a: 'We use Hiro Chainhooks to monitor the Stacks blockchain in real-time. Your activity is automatically recorded and displayed on your dashboard.' },
    ];

    return (
        <div className="glass-card faq-card">
            <h2>❓ Frequently Asked Questions</h2>
            <div className="faq-list">
                {questions.map((item, i) => (
                    <div key={i} className={`faq-item ${openIndex === i ? 'open' : ''}`}>
                        <button className="faq-question" onClick={() => setOpenIndex(openIndex === i ? null : i)}>
                            <span>{item.q}</span>
                            <span className="faq-toggle">{openIndex === i ? '−' : '+'}</span>
                        </button>
                        {openIndex === i && (
                            <div className="faq-answer">
                                <p>{item.a}</p>
                            </div>
                        )}
                    </div>
                ))}
            </div>
        </div>
    );
}
