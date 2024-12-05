// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "./SillyStringUtils.sol";

contract ImportsExercise {
    using SillyStringUtils for string;

    // Public instance of Haiku struct
    SillyStringUtils.Haiku public haiku;

    // Save Haiku: Accepts three strings and saves them in the Haiku struct
    function saveHaiku(string memory line1, string memory line2, string memory line3) public {
        haiku = SillyStringUtils.Haiku(line1, line2, line3);
    }

    // Get Haiku: Returns the current Haiku as a Haiku type
    function getHaiku() public view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }

    // Shruggie Haiku: Returns a new Haiku with 🤷 added to the end of line3
    function shruggieHaiku() public view returns (SillyStringUtils.Haiku memory) {
        return SillyStringUtils.Haiku(
            haiku.line1,
            haiku.line2,
            haiku.line3.shruggie() // Appends 🤷 to line3
        );
    }
}

