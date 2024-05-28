// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/utils/Strings.sol";

contract IconsNFT is ERC721, ERC721Enumerable, Ownable(msg.sender) {
    using Strings for uint256;
    uint256 maxSupply = 10;
    uint256 cost = 0.001 ether;
    string baseURI = "ipfs://QmaFGF4WKYbyxvmSYzuqR8Djd3WVosjLn1VQ6D4kUFdsrZ";

    constructor() ERC721("IconsNFT", "NFT") {}

    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function tokenURI(
        uint256 tokenId
    ) public view override returns (string memory) {
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.ToString(), ".json"))
                : "";
    }

    function safeMint(address to) public payable {
        uint256 _currentSupply = totalSupply();
        require(_currentSupply < maxSupply, "You reached max !");
        require(msg.value == cost, "Please, add amount value !");
        _safeMint(to, _currentSupply);
    }

    function withdraw() public onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success);
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address to,
        uint256 tokenId,
        address auth
    ) internal override(ERC721, ERC721Enumerable) returns (address) {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(
        address account,
        uint128 value
    ) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    function supportsInterface(
        bytes4 interfaceId
    ) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }
}
