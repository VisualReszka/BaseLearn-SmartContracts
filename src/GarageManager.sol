// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

contract GarageManager {
    // Struct to store car details
    struct Car {
        string make;
        string model;
        string color;
        uint256 numberOfDoors;
    }

    // Mapping from an address to an array of cars
    mapping(address => Car[]) public garage;

    // Custom error for invalid car index
    error BadCarIndex(uint256 index);

    // Adds a car to the caller's garage
    function addCar(
        string calldata make,
        string calldata model,
        string calldata color,
        uint256 numberOfDoors
    ) external {
        garage[msg.sender].push(Car(make, model, color, numberOfDoors));
    }

    // Retrieves all cars owned by the caller
    function getMyCars() external view returns (Car[] memory) {
        return garage[msg.sender];
    }

    // Retrieves all cars owned by a specific user
    function getUserCars(address user) external view returns (Car[] memory) {
        return garage[user];
    }

    // Updates a car at a specific index in the caller's garage
    function updateCar(
        uint256 index,
        string calldata make,
        string calldata model,
        string calldata color,
        uint256 numberOfDoors
    ) external {
        if (index >= garage[msg.sender].length) {
            revert BadCarIndex(index);
        }
        garage[msg.sender][index] = Car(make, model, color, numberOfDoors);
    }

    // Resets the caller's garage
    function resetMyGarage() external {
        delete garage[msg.sender];
    }
}
