// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    uint256 public constant LOOT_BOX_PRICE = 500; 
    address ownerAddress;

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
        

        _burn(msg.sender, LOOT_BOX_PRICE);

        _mint(ownerAddress, LOOT_BOX_PRICE);

        Item memory item = getRandomItem();

        userItems[msg.sender].push(item);

        uint256 burnAmount = calculateBurnAmount(item);
        _burn(ownerAddress, burnAmount);
    }

    function redeemItems(ItemType itemType, uint256 amount) external {
        uint256 totalTokensToMint = 0;
        uint256 itemIndex = 0;
        bool itemFound = false;

        for (uint256 i = 0; i < userItems[msg.sender].length; i++) {
            if (userItems[msg.sender][i].itemType == itemType && userItems[msg.sender][i].amount >= amount) {
                itemIndex = i;
                itemFound = true;

                if (itemType == ItemType.Cloth) {
                    totalTokensToMint += amount * 10; 
                } else if (itemType == ItemType.Gun) {
                    totalTokensToMint += amount * 20;
                } else if (itemType == ItemType.Emote) {
                    totalTokensToMint += amount * 5; 
                }

                break;
            }
        }

        require(itemFound, "Item not found or insufficient amount");

        if (userItems[msg.sender][itemIndex].amount == amount) {

            userItems[msg.sender][itemIndex] = userItems[msg.sender][userItems[msg.sender].length - 1];
            userItems[msg.sender].pop();
        } else {
   
            userItems[msg.sender][itemIndex].amount -= amount;
        }

        _mint(msg.sender, totalTokensToMint);
    }

    function getRandomItem() private view returns (Item memory) {
        uint256 rand = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 3;
        ItemType itemType;
        uint256 amount;

        if (rand == 0) {
            itemType = ItemType.Cloth;
            amount = randomReward(5) + 1; 
        } else if (rand == 1) {
            itemType = ItemType.Gun;
            amount = randomReward(2) + 1;
        } else {
            itemType = ItemType.Emote;
            amount = randomReward(10) + 1; 
        }

        return Item(itemType, amount);
    }

    function randomReward(uint256 max) private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % max;
    }

    function calculateBurnAmount(Item memory item) private pure returns (uint256) {
        if (item.itemType == ItemType.Cloth) {
            return item.amount * 10; 
        } else if (item.itemType == ItemType.Gun) {
            return item.amount * 20; 
        } else if (item.itemType == ItemType.Emote) {
            return item.amount * 5; 
        } else {
            return 0;
        }
    }
}
