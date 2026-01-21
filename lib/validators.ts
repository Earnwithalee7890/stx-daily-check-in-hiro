/**
 * Validation utilities for forms and data
 */

/**
 * Validate a Stacks wallet address
 */
export function isValidStacksAddress(address: string): boolean {
    if (!address) return false;
    // Mainnet addresses start with SP, testnet with ST
    const validPrefixes = ['SP', 'ST'];
    const prefix = address.substring(0, 2);
    if (!validPrefixes.includes(prefix)) return false;
    // Address should be 41 characters (2 prefix + 39 data)
    return address.length === 41;
}

/**
 * Validate contract name (Clarity naming rules)
 */
export function isValidContractName(name: string): boolean {
    if (!name || name.length === 0 || name.length > 128) return false;
    // Must start with lowercase letter, followed by alphanumeric or hyphens
    const pattern = /^[a-z][a-z0-9-]*$/;
    return pattern.test(name);
}

/**
 * Validate required field
 */
export function isRequired(value: string | undefined | null): boolean {
    return value !== undefined && value !== null && value.trim().length > 0;
}

/**
 * Validate email format
 */
export function isValidEmail(email: string): boolean {
    const pattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return pattern.test(email);
}

/**
 * Validate URL format
 */
export function isValidUrl(url: string): boolean {
    try {
        new URL(url);
        return true;
    } catch {
        return false;
    }
}

/**
 * Validate number range
 */
export function isInRange(value: number, min: number, max: number): boolean {
    return value >= min && value <= max;
}

/**
 * Validate positive number
 */
export function isPositive(value: number): boolean {
    return value > 0;
}
