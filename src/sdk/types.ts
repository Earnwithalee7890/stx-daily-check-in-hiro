export type NetworkType = 'mainnet' | 'testnet' | 'devnet';

export interface ContractCall {
  contractAddress: string;
  contractName: string;
  functionName: string;
  functionArgs: any[];
}

export interface TransactionStatus {
  txid: string;
  status: 'pending' | 'success' | 'failed';
  height?: number;
}
