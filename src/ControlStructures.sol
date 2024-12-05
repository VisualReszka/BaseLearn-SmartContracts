// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract ControlStructures {
    error InvalidData();
    error AfterHours(uint256 time);

    // Compare two numbers and return a result
    function compareNumbers(uint256 numberOne, uint256 numberTwo) external pure returns (string memory) {
        if (numberOne <= 0 || numberTwo <= 0) {
            revert InvalidData();
        }
        if (numberOne > numberTwo) return "Number one is greater than number two";
        else if (numberOne < numberTwo) return "Number one is less than number two";
        else return "Number one equals number two";
    }

    // Loop example
    function loop() external pure {
        for (uint256 index = 0; index < 8; index++) {
            if (index == 2) {
                // Skipping this iteration
                continue;
            }
            if (index == 4) {
                // Breaking the loop
                break;
            }
        }
    }

    // FizzBuzz function
    function fizzBuzz(uint256 _number) external pure returns (string memory) {
        if (_number % 3 == 0 && _number % 5 == 0) {
            return "FizzBuzz";
        } else if (_number % 3 == 0) {
            return "Fizz";
        } else if (_number % 5 == 0) {
            return "Buzz";
        } else {
            return "Splat";
        }
    }

    // DoNotDisturb function
    function doNotDisturb(uint256 _time) external pure returns (string memory) {
        if (_time > 2400) {
            assert(false); // Panic for out-of-bounds time
        } else if (_time > 2200 || _time < 800) {
            revert AfterHours(_time); // Custom error for after-hours
        } else if (_time >= 1200 && _time <= 1259) {
            revert("At lunch!");
        } else if (_time >= 1800) {
            return "Evening!";
        } else if (_time >= 1300) {
            return "Afternoon!";
        } else {
            return "Morning!";
        }

        // Fallback return to satisfy the compiler (this will never be reached)
        return "";
    }
}
