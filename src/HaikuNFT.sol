// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract HaikuNFT is ERC721 {
    struct Haiku {
        address author;
        string line1;
        string line2;
        string line3;
    }

    Haiku[] public haikus; // Array to store all Haikus
    mapping(address => uint256[]) public sharedHaikus; // Mapping of shared Haikus
    mapping(bytes32 => bool) private usedLines; // Track used lines for uniqueness
    uint256 public counter = 1; // Counter for Haiku IDs

    // Custom errors
    error HaikuNotUnique();
    error NotYourHaiku(uint256 haikuId);
    error NoHaikusShared();

    constructor() ERC721("HaikuNFT", "HAIKU") {}

    /**
     * @notice Mint a unique Haiku NFT.
     * @param line1 First line of the Haiku.
     * @param line2 Second line of the Haiku.
     * @param line3 Third line of the Haiku.
     */
    function mintHaiku(string memory line1, string memory line2, string memory line3) external {
        // Hash and check the uniqueness of each line
        bytes32 line1Hash = keccak256(abi.encodePacked(line1));
        bytes32 line2Hash = keccak256(abi.encodePacked(line2));
        bytes32 line3Hash = keccak256(abi.encodePacked(line3));

        if (usedLines[line1Hash] || usedLines[line2Hash] || usedLines[line3Hash]) {
            revert HaikuNotUnique();
        }

        // Mark lines as used
        usedLines[line1Hash] = true;
        usedLines[line2Hash] = true;
        usedLines[line3Hash] = true;

        // Create and store the Haiku
        haikus.push(Haiku({
            author: msg.sender,
            line1: line1,
            line2: line2,
            line3: line3
        }));

        // Mint the NFT with the current counter
        _mint(msg.sender, counter);

        // Increment the counter for the next Haiku
        counter++;
    }

    /**
     * @notice Share a Haiku with another user.
     * @param recipient The address of the user to share with.
     * @param haikuId The ID of the Haiku to share.
     */
    function shareHaiku(address recipient, uint256 haikuId) public {
        // Verify that the sender owns the Haiku
        if (ownerOf(haikuId) != msg.sender) {
            revert NotYourHaiku(haikuId);
        }

        // Add the Haiku ID to the recipient's shared Haikus
        sharedHaikus[recipient].push(haikuId);
    }

    /**
     * @notice Retrieve all Haikus shared with the caller.
     * @return An array of IDs of shared Haikus.
     */
    function getMySharedHaikus() public view returns (uint256[] memory) {
        uint256 totalShared = sharedHaikus[msg.sender].length;
        if (totalShared == 0) {
            revert NoHaikusShared();
        }
        return sharedHaikus[msg.sender];
    }
}
