// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract EmployeeStorage {
    // State variables optimized for packing
    uint16 private shares = 1000; // Employee's shares, hardcoded to 1000
    uint32 private salary = 50000; // Employee's salary, hardcoded to 50,000
    uint256 public idNumber = 112358132134; // Employee's ID, hardcoded
    string public name = "Pat"; // Employee's name, hardcoded to "Pat"

    // Custom error for exceeding share limits
    error TooManyShares(uint256 totalShares);

    // Function to view the salary (private variable accessor)
    function viewSalary() public view returns (uint32) {
        return salary;
    }

    // Function to view the shares (private variable accessor)
    function viewShares() public view returns (uint16) {
        return shares;
    }

    // Public function to grant new shares to the employee
        function grantShares(uint16 _newShares) public {
    uint256 newTotalShares = shares + _newShares;

    if (_newShares > 5000) {
        revert("Too many shares"); // Revert when _newShares > 5000
    }

    if (newTotalShares > 5000) {
        revert TooManyShares(newTotalShares); // Revert when total shares > 5000
    }

    shares = uint16(newTotalShares);
    }


    /**
     * Do not modify this function.  It is used to enable the unit test for this pin
     * to check whether or not you have configured your storage variables to make
     * use of packing.
     *
     * If you wish to cheat, simply modify this function to always return `0`
     * I'm not your boss ¯\_(ツ)_/¯
     *
     * Fair warning though, if you do cheat, it will be on the blockchain having been
     * deployed by your wallet....FOREVER!
     */
    function checkForPacking(uint _slot) public view returns (uint r) {
        assembly {
            r := sload(_slot)
        }
    }

    /**
     * Warning: Anyone can use this function at any time!
     */
    function debugResetShares() public {
        shares = 1000;
    }
}
// 🚨 Warning: This contract is for **testnet use only**.
