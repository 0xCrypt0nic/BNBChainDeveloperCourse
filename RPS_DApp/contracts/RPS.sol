// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@binance-oracle/binance-oracle-starter/contracts/mock/VRFConsumerBase.sol";
import "@binance-oracle/binance-oracle-starter/contracts/interfaces/VRFCoordinatorInterface.sol";

contract RPS is VRFConsumerBase {
    enum StatusEnum {
        WON,
        LOST,
        TIE,
        PENDING
    }

    struct ChallengeStatus {
        bool exists;
        uint256 bet;
        address player;
        StatusEnum status;
        uint8 playerChoice;
        uint8 hostChoice;
    }

    uint256 constant minBet = 0.001 ether;
    uint256 constant maxBet = 0.1 ether;
    uint8 constant numWords = 1;
    address owner;

    mapping(address => uint256) public s_currentGame;
    mapping(uint256 => ChallengeStatus) public s_challenges;

    VRFCoordinatorInterface COORDINATOR;

    uint64 subscriptionId;

    bytes32 keyHas;

    uint32 callbackGasLimit;

    uint16 requestConfirmations;

    constructor() {}
}
