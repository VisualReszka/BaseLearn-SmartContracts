// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract UnburnableToken {
    // State Variables
    mapping(address => uint256) public balances;
    uint256 public totalSupply;
    uint256 public totalClaimed;

    // Errors
    error TokensClaimed();
    error AllTokensClaimed();
    error UnsafeTransfer(address to);

    // Events
    event Claimed(address indexed claimant, uint256 amount);
    event Transferred(address indexed from, address indexed to, uint256 amount);

    // Constructor
    constructor() {
        totalSupply = 100_000_000; // Initialize total supply to 100,000,000
    }

    // Claim Function
    function claim() public {
        // Ensure the total supply has not been fully claimed
        if (totalClaimed >= totalSupply) {
            revert AllTokensClaimed();
        }

        // Ensure the caller has not claimed before
        if (balances[msg.sender] > 0) {
            revert TokensClaimed();
        }

        // Allocate 1000 tokens to the caller
        uint256 claimAmount = 1000;
        balances[msg.sender] = claimAmount;

        // Update the totalClaimed counter
        totalClaimed += claimAmount;

        // Emit Claimed event
        emit Claimed(msg.sender, claimAmount);
    }

    // Safe Transfer Function
    function safeTransfer(address _to, uint256 _amount) public {
        // Check if the recipient address is valid
        if (_to == address(0)) {
            revert UnsafeTransfer(_to);
        }

        // Check if the recipient address has ETH balance
        if (_to.balance == 0) {
            revert UnsafeTransfer(_to);
        }

        // Check if the sender has enough tokens
        if (balances[msg.sender] < _amount) {
            revert UnsafeTransfer(_to);
        }

        // Perform the transfer
        balances[msg.sender] -= _amount;
        balances[_to] += _amount;

        // Emit the Transferred event
        emit Transferred(msg.sender, _to, _amount);
    }
}
