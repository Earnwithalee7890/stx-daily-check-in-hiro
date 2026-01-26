/**
 * @packageDocumentation
 * Tools view container for utility components.
 */
import { RecoveryTool } from '../tools/RecoveryTool';
import { GasEstimator } from '../GasEstimator';

interface ToolsViewProps {
    userAddress: string;
}

/**
 * Container component for utility tools like RecoveryTool and GasEstimator.
 */
export const ToolsView = ({ userAddress }: ToolsViewProps) => {
    return (
        <div className="content-animate">
            <h2 style={{ marginBottom: '2rem', display: 'flex', alignItems: 'center', gap: '0.5rem' }}>
                <span className="icon-pulse">🛠️</span> Builder Utilities
            </h2>

            <div style={{ display: 'grid', gap: '2rem' }}>
                <GasEstimator />
                <RecoveryTool userAddress={userAddress} />
            </div>
        </div>
    );
};
