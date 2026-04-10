/**
 * API helper utilities for making HTTP requests
 */

import { ApiResponse } from './types';

const DEFAULT_TIMEOUT = 10000;

interface FetchOptions extends RequestInit {
    timeout?: number;
}

/**
 * Fetch with timeout support
 */
export async function fetchWithTimeout(
    url: string,
    options: FetchOptions = {}
): Promise<Response> {
    const { timeout = DEFAULT_TIMEOUT, ...fetchOptions } = options;

    const controller = new AbortController();
    const timeoutId = setTimeout(() => controller.abort(), timeout);

    try {
        const response = await fetch(url, {
            ...fetchOptions,
            signal: controller.signal,
        });
        return response;
    } finally {
        clearTimeout(timeoutId);
    }
}

/**
 * Generic API request helper
 */
export async function apiRequest<T>(
    endpoint: string,
    options: FetchOptions = {}
): Promise<ApiResponse<T>> {
    try {
        const response = await fetchWithTimeout(endpoint, {
            headers: {
                'Content-Type': 'application/json',
                ...options.headers,
            },
            ...options,
        });

        const data = await response.json();

        if (!response.ok) {
            return {
                success: false,
                error: data.error || 'Request failed',
            };
        }

        return {
            success: true,
            data,
        };
    } catch (error) {
        const message = error instanceof Error ? error.message : 'Unknown error';
        return {
            success: false,
            error: message,
        };
    }
}

/**
 * GET request helper
 */
export function get<T>(endpoint: string): Promise<ApiResponse<T>> {
    return apiRequest<T>(endpoint, { method: 'GET' });
}

/**
 * POST request helper
 */
export function post<T>(endpoint: string, body: unknown): Promise<ApiResponse<T>> {
    return apiRequest<T>(endpoint, {
        method: 'POST',
        body: JSON.stringify(body),
    });
}
