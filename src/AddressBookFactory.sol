// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./AddressBook.sol";

contract AddressBookFactory {
    event AddressBookDeployed(address indexed owner, address addressBook);

    /// @notice Deploys a new AddressBook contract.
    /// @return address of the newly deployed AddressBook.
    function deploy() external returns (address) {
        AddressBook addressBook = new AddressBook(msg.sender); // Pass msg.sender as initialOwner
        emit AddressBookDeployed(msg.sender, address(addressBook));
        return address(addressBook);
    }
}


