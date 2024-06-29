// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    uint256 public constant LOOT_BOX_PRICE = 500; // Price of 1 loot box in Degen Token
    address ownerAddress = address(0);

    enum ItemType { Cloth, Gun, Emote }

    struct Item {
        ItemType itemType;
        uint256 amount;
    }

    mapping(address => Item[]) public userItems;

    constructor(address payable initialOwner) ERC20("Degen", "DGN") Ownable(initialOwner) {
       ownerAddress = initialOwner;
    }

    function mint(uint256 amount) external onlyOwner {
        _mint(ownerAddress, amount);
    }

    function anyoneBurn(uint256 amount) public {
        _burn(ownerAddress, amount);
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function buyLootBox() external {
        require(balanceOf(msg.sender) >= LOOT_BOX_PRICE, "Insufficient Degen Token balance");
        
        // Burn the tokens used to buy the loot box
        _burn(msg.sender, LOOT_BOX_PRICE);
        
        // Generate random rewards
        Item memory item = getRandomItem();

        // Update user items
        userItems[msg.sender].push(item);
    }

    function redeemItems(ItemType itemType, uint256 amount) external {
        uint256 totalTokensToMint = 0;

        // Calculate the total amount of Degen Tokens to mint based on the items redeemed
        for (uint256 i = 0; i < userItems[msg.sender].length; i++) {
            if (userItems[msg.sender][i].itemType == itemType && userItems[msg.sender][i].amount >= amount) {
                if (itemType == ItemType.Cloth) {
                    totalTokensToMint += amount * 10; // Example conversion rate
                } else if (itemType == ItemType.Gun) {
                    totalTokensToMint += amount * 20; // Example conversion rate
                } else if (itemType == ItemType.Emote) {
                    totalTokensToMint += amount * 5; // Example conversion rate
                }

                userItems[msg.sender][i].amount -= amount;
                break;
            }
        }

        // Mint the tokens to the sender
        _mint(msg.sender, totalTokensToMint);
    }

    function getRandomItem() private view returns (Item memory) {
        uint256 rand = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 3;
        ItemType itemType;
        uint256 amount;

        if (rand == 0) {
            itemType = ItemType.Cloth;
            amount = randomReward(5) + 1; // Random between 1 and 5
        } else if (rand == 1) {
            itemType = ItemType.Gun;
            amount = randomReward(2) + 1; // Random between 1 and 2
        } else {
            itemType = ItemType.Emote;
            amount = randomReward(10) + 1; // Random between 1 and 10
        }

        return Item(itemType, amount);
    }

    function randomReward(uint256 max) private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % max;
    }
}
