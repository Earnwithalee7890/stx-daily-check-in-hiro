import { NetworkType } from './types.js';

export class StxContractClient {
  private network: NetworkType;

  constructor(options: { network: NetworkType }) {
    this.network = options.network;
  }

  getNetwork() {
    return this.network;
  }

  async callContract() {
    // Basic implementation placeholder
    console.log(`Calling contract on ${this.network}...`);
    return { success: true };
  }
}
