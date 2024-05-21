//SPDX-License-Identifier:MIT

pragma solidity ^0.8.21;

interface IFakeToken {
    function transfer(address _to, uint256 _amount) external;
    function transferFrom(address _from, address _to, uint256 _amount) external;
}

contract AirdropToken {
    function airdropWithTransfer(
        IFakeToken _token,
        address[] memory _addressArray,
        uint[] memory _amountArray
    ) public {
        for (uint i = 0; i < _addressArray.length; i++) {
            _token.transfer(_addressArray[i], _amountArray[i]);
        }
    }

    function airdropWithTransferFrom(
        IFakeToken _token,
        address[] memory _addressArray,
        uint256[] memory _amountArray
    ) public {
        for (uint8 i = 0; i < _addressArray.length; i++) {
            _token.transferFrom(msg.sender, _addressArray[i], _amountArray[i]);
        }
    }
}
