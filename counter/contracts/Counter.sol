// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Counter {
    uint public count;

    function get() public view returns (uint) {
        return count; // function to get the current count
    }

    function inc() public {
        count += 1;
    }

    function dec() public {
        count -= 1;
    }
}
