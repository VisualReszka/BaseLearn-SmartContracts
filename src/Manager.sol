// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Manager {
    uint[] public employeeIds;

    function addReport(uint _employeeId) public {
        employeeIds.push(_employeeId);
    }

    function resetReports() public {
        delete employeeIds;
    }
}
