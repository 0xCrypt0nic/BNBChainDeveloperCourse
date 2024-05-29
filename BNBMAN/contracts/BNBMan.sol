// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract NFTHuman is ERC721URIStorage {
    using Strings for uint256;
    uint256 private _tokenIds;
    address private owner;

    mapping(uint256 => uint256) public tokenIdToAges;

    constructor() ERC721("BNBMan", "BNBMan") {
        owner = msg.sender;
    }

    function generateCharacter(
        uint256 tokenId
    ) public view returns (string memory) {
        bytes memory svg = abi.encodePacked(
            '<svg enable-background="new 0 0 91 91" height="91px" id="Layer_1" version="1.1" viewBox="0 0 91 91" width="91px" xml:space="preserve" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink"><path d="M38.391,56.001c-5.693-1.266-10.791-4.121-14.814-8.086c-6.549,3.213-9.785,7.955-9.785,14.494v22.193    c3.148,1.465,11.26,4.762,22.541,5.967l-2.637-2.109c-0.832-0.664-1.225-1.74-1.008-2.783L38.391,56.001z" fill="#647F94"/><path d="M45.01,51.079c13.783,0,25-11.295,25-25.174s-11.217-25.172-25-25.172    c-13.775,0-24.982,11.293-24.982,25.172S31.234,51.079,45.01,51.079z" fill="#647F94"/><polygon fill="#6EC4A7" points="43.977,56.978 38.59,85.118 45.242,90.437 51.881,85.122 46.414,56.978   "/><path d="M66.475,47.896c-3.943,3.895-8.932,6.709-14.492,8.016l5.803,29.758c0.219,1.047-0.172,2.123-1.002,2.791    l-2.496,1.996c6.957-0.83,14.496-2.648,22.398-5.959V62.409C76.686,55.862,73.309,51.114,66.475,47.896z" fill="#647F94"/>',
            getAge(tokenId),
            "</svg>"
        );
        return
            string(
                abi.encodePacked(
                    "data:image/svg+xml;base64,",
                    Base64.encode(svg)
                )
            );
    }

    function getAge(uint256 tokenId) public view returns (string memory) {
        uint256 age = tokenIdAges[tokenId];
        return age.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory) {
        bytes memory dataURI = abi.encorePacked(
            "{",
            '"name": "BNB Man Character #',
            tokenId.toString(),
            '",',
            '"description": "Collectible Characters",',
            '"image": "',
            generateCharacter(tokenId),
            '"',
            "}"
        );
        return
            string(
                abi.encodePacked(
                    "data:application/json;base6,",
                    Base64.encode(dataURI)
                )
            );
    }

    function mint() public {
        require(msg.sender == owner, "Only owner can call this function");
        _tokenIds++;
        uint256 newItemId = _tokenIds;
        tokenIdToAges[newItemId] = 0;
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, getTokenURI(newItemId));
    }

    function growUp(uint256 tokenId) public {
        require(ownerOf(tokenId) == address(0), "Please use an existing token");
        require(
            ownerOf(tokenId) == msg.sender,
            "You must own this token to grow up!"
        );
        uint256 currentAge = tokenIdToAges[tokenId];
        tokenIdToAges[tokenId] = currentAge + 1;
        _setTokenURI(tokenId, getTokenURI(tokenId));
    }
}
