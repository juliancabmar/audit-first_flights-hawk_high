// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;

import {Test, console2} from "forge-std/Test.sol";
import {MyContractV1, MyContractV2} from "./Aux.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract AuditTests is Test {
    ERC1967Proxy proxy;
    MyContractV1 implementOne;
    MyContractV2 implementTwo;

    function testAux() public {
        // Deploy One
        implementOne = new MyContractV1();
        // Deploy proxy and pass One address how first implementation
        proxy = new ERC1967Proxy(address(implementOne), "");
        // Call the initializer function on new implementation
        address(proxy).call(abi.encodeCall(implementOne.initialize, (666)));
        // Call WAGE_L1 constant
        (, bytes memory wageL1) = address(proxy).call(abi.encodeCall(implementOne.WAGE_L1, ()));
        console2.log("WAGE_L1:", abi.decode(wageL1, (uint256)));
    }
}
