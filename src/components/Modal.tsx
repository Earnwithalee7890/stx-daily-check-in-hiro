'use client';

/**
 * Premium Modal component for focused interactions.
 */
export function Modal({
    isOpen,
    onClose,
    title,
    children
}: {
    isOpen: boolean,
    onClose: () => void,
    title: string,
    children: React.ReactNode
}) {
    if (!isOpen) return null;

    return (
        <div className="modal-overlay" onClick={onClose}>
            <div className="modal-content glass-card" onClick={(e) => e.stopPropagation()}>
                <div className="modal-header">
                    <h3>{title}</h3>
                    <button className="modal-close" onClick={onClose}>&times;</button>
                </div>
                <div className="modal-body">
                    {children}
                </div>
            </div>
        </div>
    );
}
