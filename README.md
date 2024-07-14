# DegenToken Smart Contract

Welcome to the DegenToken repository! This Solidity smart contract implements an ERC20 token called "Degen" (symbol: DGN) with additional functionalities for a loot box system and item redemption. Below you will find an overview of the contract, its main features, and instructions on how to use it.

## Table of Contents

- [Overview](#overview)
- [Contract Features](#contract-features)
- [Functions](#functions)
- [Setup and Deployment](#setup-and-deployment)
- [Usage](#usage)
- [License](#license)

## Overview

DegenToken is an ERC20 token contract that includes functionalities for minting and burning tokens, purchasing loot boxes, and redeeming items obtained from loot boxes. The contract uses the OpenZeppelin library for standard ERC20 functionalities and ownership control.

## Contract Features

- **ERC20 Token**: Standard ERC20 token functionalities.
- **Minting**: Owner can mint new tokens.
- **Burning**: Tokens can be burned by anyone.
- **Loot Box System**: Users can buy loot boxes with tokens to receive random items.
- **Item Redemption**: Users can redeem items for additional tokens.

## Functions

### Constructor

```solidity
constructor(address payable initialOwner) ERC20("Degen", "DGN") Ownable(initialOwner)
```

Initializes the contract with the token name "Degen" and symbol "DGN". Sets the initial owner.

### Minting

```solidity
function mint(uint256 amount) external onlyOwner
```

Allows the owner to mint new tokens.

### Burning

```solidity
function anyoneBurn(uint256 amount) public
```

Allows anyone to burn tokens from the owner's address.

### Transfer

```solidity
function transfer(address recipient, uint256 amount) public override returns (bool)
```

Overrides the standard ERC20 transfer function to enable token transfers.

### Buying Loot Boxes

```solidity
function buyLootBox() external
```

Allows users to buy a loot box for a set price of 500 Degen tokens. The loot box contains a random item.

### Redeeming Items

```solidity
function redeemItems(ItemType itemType, uint256 amount) external
```

Allows users to redeem items they have for additional tokens.

### Internal Helper Functions

- `getRandomItem()`: Generates a random item.
- `randomReward(uint256 max)`: Generates a random number for rewards.
- `calculateBurnAmount(Item memory item)`: Calculates the number of tokens to burn based on the item type and amount.

## Setup and Deployment

### Prerequisites

- [Node.js](https://nodejs.org/)
- [Truffle](https://www.trufflesuite.com/truffle)
- [Ganache](https://www.trufflesuite.com/ganache) or an Ethereum testnet

### Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/DegenToken.git
    cd DegenToken
    ```

2. Install dependencies:
    ```bash
    npm install
    ```

### Deployment

1. Update the `truffle-config.js` file with your network configuration.

2. Compile the contracts:
    ```bash
    truffle compile
    ```

3. Deploy the contracts:
    ```bash
    truffle migrate --network <network-name>
    ```

## Usage

### Interacting with the Contract

- **Mint Tokens**: The contract owner can mint new tokens by calling the `mint` function.
- **Burn Tokens**: Anyone can burn tokens by calling the `anyoneBurn` function.
- **Buy Loot Box**: Users can buy loot boxes by calling the `buyLootBox` function.
- **Redeem Items**: Users can redeem items for tokens by calling the `redeemItems` function.

### Testing

You can write and run tests using the Truffle framework:

1. Create test files in the `test` directory.
2. Run tests:
    ```bash
    truffle test
    ```

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

Feel free to open issues or contribute to the project by submitting pull requests. Enjoy using DegenToken!

---

For more information, visit the [OpenZeppelin documentation](https://docs.openzeppelin.com/contracts/4.x/).

