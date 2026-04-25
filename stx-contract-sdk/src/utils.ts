/**
 * Stacks Address and Unit Utilities
 */

const STANDARD_PRINCIPAL_REGEX = /^S[TPM][0-9A-HJ-NP-Za-km-z]{33,41}$/;
const CONTRACT_PRINCIPAL_REGEX = /^S[TPM][0-9A-HJ-NP-Za-km-z]{33,41}\.[a-zA-Z][a-zA-Z0-9-]*$/;

/**
 * Validates if a string is a valid Stacks principal (standard or contract)
 */
export const isValidPrincipal = (address: string): boolean => {
  if (!address || typeof address !== 'string') return false;
  const trimmed = address.trim();
  return STANDARD_PRINCIPAL_REGEX.test(trimmed) || CONTRACT_PRINCIPAL_REGEX.test(trimmed);
};

/**
 * Formats a Stacks address for display (e.g., SP2J...05NNC)
 */
export const formatAddress = (address: string, startChars = 6, endChars = 4): string => {
  if (!address || address.length <= startChars + endChars) return address;
  return `${address.slice(0, startChars)}...${address.slice(-endChars)}`;
};

/**
 * Converts STX to microSTX
 */
export const stxToMicroStx = (stx: number | string): bigint => {
  const amount = typeof stx === 'string' ? parseFloat(stx) : stx;
  return BigInt(Math.floor(amount * 1_000_000));
};

/**
 * Converts microSTX to STX
 */
export const microStxToStx = (microStx: bigint | number | string): number => {
  const amount = typeof microStx === 'bigint' ? Number(microStx) : Number(microStx);
  return amount / 1_000_000;
};
