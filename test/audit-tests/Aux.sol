// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

// Implementation V1
contract MyContractV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 public value;
    uint256 public WAGE_L1 = 35;

    // Initializer function (replaces constructor)
    function initialize(uint256 _value) public initializer {
        // __Ownable_init();
        __UUPSUpgradeable_init();
        value = _value;
    }

    // Required by UUPSUpgradeable to authorize upgrades
    function _authorizeUpgrade(address newImplementation) internal override {}

    // Function to update the value
    function setValue(uint256 _value) public onlyOwner {
        value = _value;
    }
}

// Implementation V2
contract MyContractV2 is Initializable {
    string public name;
    uint256 public WAGE_L1 = 40;

    // Reinitializer for version 2
    function initializeV2(string memory _name) public reinitializer(2) {
        name = _name;
    }

    // New function in V2
    function setName(string memory _name) public {
        name = _name;
    }
}
