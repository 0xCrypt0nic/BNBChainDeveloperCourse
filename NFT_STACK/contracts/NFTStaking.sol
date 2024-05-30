// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTStaking is Ownable {
    IERC20 public immutable rewardsToken;
    IERC721 public immutable nftCollection;
    uint256 private rewardsPerHour = 100000;
    mapping(address => Staker) public stakers;

    struct Staker {
        uint256[] stackedTokenIds;
        uint256[] lastUpdatedTime;
        uint256[] unclaimedRewards;
    }

    constructor(
        IERC721 _nftCollection,
        IERC20 _rewardsToken
    ) Ownable(msg.sender) {
        nftCollection = _nftCollection;
        rewardsToken = _rewardsToken;
    }

    function stake(uint256[] calldata _tokenIds) external {
        Stacker storage staker = stakers[msg.sender];
        require(_tokenIds.length > 0, "No tokens to stake");
        for (uint256 i = 0; i < _tokenIds.length; i++) {
            uint256 tokensIds = _tokenIds[i];
            require(
                nftCollection.ownerOf(tokenId) == msg.sender,
                "Can't stake tokens you don't own"
            );
            nftCollection.transferFrom(msg.sender, address(this), tokenId);
            staker.stackedTokenIds.push(tokenId);
        }
        updateRewards(msg.sender);
    }

    function withdraw(uint256[] calldata _tokenIds) external {
        Staker storage staker = stakers[msg.sender];
        require(stacker.stackedTokenIds.length > 0, "No tokens staked");
        updateRewards(msg.sender);

        for (uint256 i = 0; i < _tokenIds.length; i++) {
            uint256 tokenId = _tokenIds[i];
            require(isStaked(msg.sender, tokenId), "Not your staked token");
            uint256 index = getTokenIndex(msg.sender, tokenId);
            uint256 lastIndex = staker.stackedTokenIds.length - 1;

            if (index != lastIndex) {
                staker.stackedTokenIds[index] = staker.stackedTokenIds[
                    lastIndex
                ];
            }

            staker.stackedTokenIds.pop();
            nftCollection.transferFrom(address(this), msg.sender, tokenId);
        }
    }
}
