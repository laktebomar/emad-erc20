## Emad Token — Custom ERC-20 Token (Solidity + Foundry)

A full ERC-20 token implementation built from scratch using Solidity and Foundry.
This project includes a custom token, owner-controlled features, a complete test suite, deployment scripts, and fuzz testing.

Great as a learning project or starter portfolio repository.

## Features
# Custom ERC-20 Token Implementation#

Written manually without OpenZeppelin, for learning and clarity.

# Ownership + Access Control#

Owner can mint

Owner can burn

Owner can enable trading

Owner can transfer ownership

# Trading Lock

Token transfers are blocked until the owner calls enableTrading().

# Minting & Burning #

Dynamic token supply via:

mint(amount)

burn(amount)

# Foundry Test Suite

Includes:

Unit tests

Revert tests

Fuzz tests

Gas reports

# Deployment Script

Automated deployment using Foundry scripts.

## Project Structure
repo/
│
├── src/
│   └── EmadTkn.sol            # ERC-20 token contract
│
├── script/
│   └── EmadTknScript.sol      # Deployment script
│
├── test/
│   └── EmadTkn.t.sol          # Full Foundry test suite
│
└── README.md

# Installation

Requires:

Foundry → https://book.getfoundry.sh/getting-started/installation

Solidity v0.8.x

Install dependencies:

forge install


Build project:

forge build

# Running Tests

Run all tests:

forge test -vvv


Generate gas report:

forge test --gas-report

# Fuzz Testing

This project includes fuzz tests — automated random input tests that find hidden bugs.

Example fuzz test output:

[PASS] testFuzz_Transfer(uint256) (runs: 257)


This confirms the transfer logic works for a wide range of values.

# Deployment

Deploy using Foundry:

forge script script/EmadTknScript.sol \
  --rpc-url <YOUR_RPC_URL> \
  --broadcast \
  --private-key <YOUR_PRIVATE_KEY>


# Use environment variables for safety:

source .env
forge script script/EmadTknScript.sol --rpc-url $RPC_URL --broadcast --private-key $PRIVATE_KEY
