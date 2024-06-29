
# DegenToken Smart Contract

## Overview
`DegenToken` is an ERC20 token contract built on Solidity that allows for the creation, transfer, and burning of tokens. It also features a loot box system where users can buy loot boxes with `DegenToken` and receive random items. These items can be redeemed for more tokens.

## Features
- Minting and burning of `DegenToken`
- Buying loot boxes with `DegenToken`
- Redeeming items for more `DegenToken`
- Ownership control for minting

## Prerequisites
- Solidity `^0.8.18`
- OpenZeppelin Contracts

## Installation
1. Install the required dependencies:
    ```bash
    npm install @openzeppelin/contracts
    ```

## Contract Details

### State Variables
- `LOOT_BOX_PRICE`: The price of a loot box in `DegenToken`.
- `ownerAddress`: Address of the contract owner.
- `ItemType`: Enum representing types of items (Cloth, Gun, Emote).
- `Item`: Struct representing an item with type and amount.
- `userItems`: Mapping from user address to an array of their items.

### Constructor
Initializes the contract with an owner and sets the token name and symbol.
```solidity
constructor(address payable initialOwner) ERC20("Degen", "DGN") Ownable(initialOwner) {
    ownerAddress = initialOwner;
}
```

### Functions
- `mint(uint256 amount)`: Mints new tokens to the owner's address. Only the owner can call this.
- `anyoneBurn(uint256 amount)`: Burns a specified amount of tokens from the owner's address. Anyone can call this.
- `transfer(address recipient, uint256 amount)`: Transfers tokens to a specified address. Overrides the default ERC20 transfer function.
- `buyLootBox()`: Allows a user to buy a loot box if they have enough `DegenToken`. The tokens are burned, and the user receives a random item.
- `redeemItems(ItemType itemType, uint256 amount)`: Allows a user to redeem items for `DegenToken` based on a predefined conversion rate.
- `getRandomItem()`: Generates a random item for the loot box.
- `randomReward(uint256 max)`: Generates a random number for rewards.

## Usage
1. Deploy the contract:
    ```solidity
    const DegenToken = await ethers.getContractFactory("DegenToken");
    const degenToken = await DegenToken.deploy(ownerAddress);
    await degenToken.deployed();
    console.log("DegenToken deployed to:", degenToken.address);
    ```

2. Mint tokens (only the owner can do this):
    ```solidity
    await degenToken.mint(1000);
    ```

3. Buy a loot box:
    ```solidity
    await degenToken.buyLootBox();
    ```

4. Redeem items for tokens:
    ```solidity
    await degenToken.redeemItems(0, 2); // Redeem 2 Cloth items
    ```

## License
This project is licensed under the MIT License.

---

Feel free to customize this README further to fit your project's specific needs!
