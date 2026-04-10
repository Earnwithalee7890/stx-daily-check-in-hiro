'use client';

import { useState } from 'react';

/**
 * User Settings panel for profile customization.
 */
export function UserSettings() {
    const [displayName, setDisplayName] = useState('Stacks Explorer');
    const [notifications, setNotifications] = useState(true);

    return (
        <div className="glass-card settings-card">
            <h2>⚙️ User Settings</h2>
            <div className="settings-form">
                <div className="setting-item">
                    <label>Display Name</label>
                    <input
                        type="text"
                        value={displayName}
                        onChange={(e) => setDisplayName(e.target.value)}
                        placeholder="Enter your name"
                    />
                </div>

                <div className="setting-item">
                    <div className="setting-info">
                        <label>Enable Achievement Toasts</label>
                        <p>Receive real-time notifications for milestones.</p>
                    </div>
                    <label className="switch">
                        <input
                            type="checkbox"
                            checked={notifications}
                            onChange={() => setNotifications(!notifications)}
                        />
                        <span className="slider round"></span>
                    </label>
                </div>

                <button className="btn btn-save" onClick={() => alert('Settings saved locally!')}>
                    Save Changes
                </button>

                <div className="settings-danger" style={{ marginTop: '1rem', paddingTop: '1rem', borderTop: '1px solid rgba(255,255,255,0.05)' }}>
                    <button className="btn" style={{ borderColor: 'rgba(255, 75, 75, 0.3)', color: '#ff4b4b' }} onClick={() => { localStorage.clear(); window.location.reload(); }}>
                        🧹 Clear App Cache
                    </button>
                    <p style={{ fontSize: '0.75rem', marginTop: '0.5rem' }}>This will reset your local preferences and reconnect your wallet.</p>
                </div>
            </div>
        </div>
    );
}
