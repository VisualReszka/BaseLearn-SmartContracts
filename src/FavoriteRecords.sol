// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract FavoriteRecords {
    // State variables
    mapping(string => bool) public approvedRecords;
    mapping(address => mapping(string => bool)) private userFavorites;
    string[] private approvedRecordList;

    // Custom error
    error NotApproved(string albumName);

    // Constructor to initialize approved records
    constructor() {
        _addApprovedRecord("Thriller");
        _addApprovedRecord("Back in Black");
        _addApprovedRecord("The Bodyguard");
        _addApprovedRecord("The Dark Side of the Moon");
        _addApprovedRecord("Their Greatest Hits (1971-1975)");
        _addApprovedRecord("Hotel California");
        _addApprovedRecord("Come On Over");
        _addApprovedRecord("Rumours");
        _addApprovedRecord("Saturday Night Fever");
    }

    // Internal function to add approved records
    function _addApprovedRecord(string memory albumName) internal {
        if (!approvedRecords[albumName]) {
            approvedRecords[albumName] = true;
            approvedRecordList.push(albumName);
        }
    }

    // Function to get all approved records
    function getApprovedRecords() public view returns (string[] memory) {
        return approvedRecordList;
    }

    // Function to add a record to user's favorites
    function addRecord(string memory albumName) public {
        if (!approvedRecords[albumName]) {
            revert NotApproved(albumName);
        }
        userFavorites[msg.sender][albumName] = true;
    }

    // Function to get user's favorite records
    function getUserFavorites(address user) public view returns (string[] memory) {
        string[] memory favorites = new string[](approvedRecordList.length);
        uint count = 0;
        for (uint i = 0; i < approvedRecordList.length; i++) {
            string memory album = approvedRecordList[i];
            if (userFavorites[user][album]) {
                favorites[count] = album;
                count++;
            }
        }
        // Resize the array to fit the actual number of favorites
        string[] memory result = new string[](count);
        for (uint i = 0; i < count; i++) {
            result[i] = favorites[i];
        }
        return result;
    }

    // Function to reset user's favorites
    function resetUserFavorites() public {
        for (uint i = 0; i < approvedRecordList.length; i++) {
            string memory album = approvedRecordList[i];
            if (userFavorites[msg.sender][album]) {
                userFavorites[msg.sender][album] = false;
            }
        }
    }
}
