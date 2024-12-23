// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./Hourly.sol";

contract Salesperson is Hourly {
    constructor(uint _idNumber, uint _managerId, uint _hourlyRate)
        Hourly(_idNumber, _managerId, _hourlyRate)
    {}
}
