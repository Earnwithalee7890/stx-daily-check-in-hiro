#!/bin/bash

# Deploy all contracts to testnet
echo "Deploying all contracts to testnet..."

# Simple contracts
for contract in simple-contracts/*.clar; do
    name=$(basename "$contract" .clar)
    echo "Deploying $name..."
    clarinet deploy --testnet "$name"
    sleep 2
done

echo "All contracts deployed!"
