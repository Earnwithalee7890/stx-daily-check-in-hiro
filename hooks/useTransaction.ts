'use client';

import { useState } from 'react';
import { openContractCall } from '@stacks/connect';
import { StacksMainnet, StacksTestnet } from '@stacks/network';

interface TransactionOptions {
    contractAddress: string;
    contractName: string;
    functionName: string;
    functionArgs: any[];
    onSuccess?: (data: any) => void;
    onError?: (error: any) => void;
}

/**
 * Unified hook for handling Stacks transactions with professional error handling.
 */
export const useTransaction = () => {
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);

    const execute = async (options: TransactionOptions) => {
        setIsLoading(true);
        setError(null);

        try {
            await openContractCall({
                contractAddress: options.contractAddress,
                contractName: options.contractName,
                functionName: options.functionName,
                functionArgs: options.functionArgs,
                network: process.env.NEXT_PUBLIC_NETWORK === 'mainnet' ? new StacksMainnet() : new StacksTestnet(),
                onFinish: (data) => {
                    setIsLoading(false);
                    if (options.onSuccess) options.onSuccess(data);
                },
                onCancel: () => {
                    setIsLoading(false);
                },
            });
        } catch (err: any) {
            setIsLoading(false);
            const errMsg = err.message || 'Transaction failed';
            setError(errMsg);
            if (options.onError) options.onError(err);
        }
    };

    return { execute, isLoading, error };
};
