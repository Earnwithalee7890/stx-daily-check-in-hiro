export default function SocialLinks() {
    return (
        <div className="social-links">
            <h3>Follow the Dev</h3>
            <div className="social-buttons">
                <a
                    href="https://farcaster.xyz/aleekhoso"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="social-link farcaster"
                >
                    <span className="icon">🟣</span>
                    Farcaster
                </a>
                <a
                    href="https://x.com/aleeasghar78"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="social-link twitter"
                >
                    <span className="icon">𝕏</span>
                    Twitter
                </a>
                <a
                    href="https://github.com/Earnwithalee7890"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="social-link github"
                >
                    <span className="icon">⚫</span>
                    GitHub
                </a>
                <a
                    href="https://explorer.hiro.so"
                    target="_blank"
                    rel="noopener noreferrer"
                    className="social-link"
                    style={{ background: '#ff4b4b22', border: '1px solid #ff4b4b44' }}
                >
                    <span className="icon">🚀</span>
                    Hiro Explorer
                </a>
            </div>
        </div>
    )
}
