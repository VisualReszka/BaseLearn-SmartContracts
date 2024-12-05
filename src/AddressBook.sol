// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AddressBook is Ownable {
    struct Contact {
        uint256 id;
        string firstName;
        string lastName;
        uint256[] phoneNumbers;
    }

    mapping(uint256 => Contact) private contacts;
    uint256[] private contactIds;

    error ContactNotFound(uint256 id);

    /// @dev Pass the initial owner to the Ownable constructor
    constructor(address initialOwner) Ownable(initialOwner) {}

    /// @notice Adds a new contact. Only the owner can use this function.
    function addContact(
        uint256 id,
        string calldata firstName,
        string calldata lastName,
        uint256[] calldata phoneNumbers
    ) external onlyOwner {
        require(contacts[id].id == 0, "Contact with this ID already exists");
        contacts[id] = Contact(id, firstName, lastName, phoneNumbers);
        contactIds.push(id);
    }

    /// @notice Deletes a contact. Reverts if the contact is not found.
    function deleteContact(uint256 id) external onlyOwner {
        if (contacts[id].id == 0) {
            revert ContactNotFound(id);
        }
        delete contacts[id];
        for (uint256 i = 0; i < contactIds.length; i++) {
            if (contactIds[i] == id) {
                contactIds[i] = contactIds[contactIds.length - 1];
                contactIds.pop();
                break;
            }
        }
    }

    /// @notice Gets a contact by ID. Reverts if the contact is not found.
    function getContact(uint256 id)
        external
        view
        returns (
            uint256,
            string memory,
            string memory,
            uint256[] memory
        )
    {
        if (contacts[id].id == 0) {
            revert ContactNotFound(id);
        }
        Contact memory contact = contacts[id];
        return (contact.id, contact.firstName, contact.lastName, contact.phoneNumbers);
    }

    /// @notice Returns all contacts.
    function getAllContacts() external view returns (Contact[] memory) {
        Contact[] memory allContacts = new Contact[](contactIds.length);
        for (uint256 i = 0; i < contactIds.length; i++) {
            allContacts[i] = contacts[contactIds[i]];
        }
        return allContacts;
    }
}

