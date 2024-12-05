// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract BasicMath {
    // Function: Adder
    function adder(uint256 _a, uint256 _b) public pure returns (uint256 sum, bool error) {
        unchecked {
            uint256 result = _a + _b;
            if (result < _a) {
                return (0, true); // Overflow occurred
            }
            return (result, false); // No overflow
        }
    }

    // Function: Subtractor
    function subtractor(uint256 _a, uint256 _b) public pure returns (uint256 difference, bool error) {
        unchecked {
            if (_b > _a) {
                return (0, true); // Underflow occurred
            }
            return (_a - _b, false); // No underflow
        }
    }
}
