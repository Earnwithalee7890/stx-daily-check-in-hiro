'use client';

import { memo } from 'react';

/**
 * Visual Roadmap component showing project milestones.
 */
export const Roadmap = memo(function Roadmap() {
    const milestones = [
        { phase: 'Phase 1', title: 'Genesis', status: 'completed', description: 'Core smart contract deployment and basic dashboard.' },
        { phase: 'Phase 2', title: 'Expansion', status: 'completed', description: 'Hiro Chainhooks integration and live activity feed.' },
        { phase: 'Phase 3', title: 'Utility', status: 'current', description: 'Advanced builder tools, 20+ features, and premium UI redesign.' },
        { phase: 'Phase 4', title: 'Governance', status: 'upcoming', description: 'DAO voting system and community-led rewards.' },
    ];

    return (
        <div className="glass-card roadmap-card">
            <h2>🗺️ Project Roadmap</h2>
            <div className="roadmap-timeline">
                {milestones.map((m, i) => (
                    <div key={i} className={`roadmap-item ${m.status}`}>
                        <div className="roadmap-point"></div>
                        <div className="roadmap-content">
                            <div className="roadmap-meta">
                                <span className="phase-tag">{m.phase}</span>
                                <span className={`status-tag ${m.status}`}>{m.status}</span>
                            </div>
                            <h3>{m.title}</h3>
                            <p>{m.description}</p>
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );
});
