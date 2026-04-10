/**
 * Custom hook for async data fetching with loading and error states
 */
import { useState, useEffect, useCallback } from 'react';

interface UseAsyncState<T> {
    data: T | null;
    loading: boolean;
    error: Error | null;
}

interface UseAsyncResult<T> extends UseAsyncState<T> {
    execute: () => Promise<void>;
    reset: () => void;
}

export function useAsync<T>(
    asyncFunction: () => Promise<T>,
    immediate: boolean = true
): UseAsyncResult<T> {
    const [state, setState] = useState<UseAsyncState<T>>({
        data: null,
        loading: immediate,
        error: null,
    });

    const execute = useCallback(async () => {
        setState({ data: null, loading: true, error: null });

        try {
            const response = await asyncFunction();
            setState({ data: response, loading: false, error: null });
        } catch (error) {
            setState({ data: null, loading: false, error: error as Error });
        }
    }, [asyncFunction]);

    const reset = useCallback(() => {
        setState({ data: null, loading: false, error: null });
    }, []);

    useEffect(() => {
        if (immediate) {
            execute();
        }
    }, [execute, immediate]);

    return { ...state, execute, reset };
}

export default useAsync;
