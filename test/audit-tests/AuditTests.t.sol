// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;

import {Test, console2} from "forge-std/Test.sol";
import {DeployLevelOne} from "../../script/DeployLevelOne.s.sol";
import {GraduateToLevelTwo} from "../../script/GraduateToLevelTwo.s.sol";
import {LevelOne} from "../../src/LevelOne.sol";
import {LevelTwo} from "../../src/LevelTwo.sol";
import {MockUSDC} from "../mocks/MockUSDC.sol";

contract AuditTests is Test {
    DeployLevelOne deployBot;
    GraduateToLevelTwo graduateBot;

    LevelOne levelOneProxy;
    LevelTwo levelTwoImplementation;

    address proxyAddress;
    address levelOneImplementationAddress;
    address levelTwoImplementationAddress;

    MockUSDC usdc;

    address principal;
    uint256 schoolFees;

    // teachers
    address alice;
    address bob;
    // students
    address clara;
    address dan;
    address eli;
    address fin;
    address grey;
    address harriet;

    function setUp() public {
        deployBot = new DeployLevelOne();
        proxyAddress = deployBot.deployLevelOne();
        levelOneProxy = LevelOne(proxyAddress);

        // graduateBot = new GraduateToLevelTwo();

        usdc = deployBot.getUSDC();
        principal = deployBot.principal();
        schoolFees = deployBot.getSchoolFees();
        levelOneImplementationAddress = deployBot.getImplementationAddress();

        alice = makeAddr("first_teacher");
        bob = makeAddr("second_teacher");

        clara = makeAddr("first_student");
        dan = makeAddr("second_student");
        eli = makeAddr("third_student");
        fin = makeAddr("fourth_student");
        grey = makeAddr("fifth_student");
        harriet = makeAddr("six_student");

        usdc.mint(clara, schoolFees);
        usdc.mint(dan, schoolFees);
        usdc.mint(eli, schoolFees);
        usdc.mint(fin, schoolFees);
        usdc.mint(grey, schoolFees);
        usdc.mint(harriet, schoolFees);
    }

    // ## Not Confirmed Invariants
    // @audit - !(A school session lasts 4 weeks)
    function testSeesionCanExceedFourWeeks() public {
        vm.prank(principal);
        levelOneProxy.startSession(0);

        vm.warp(block.timestamp + 5 weeks);

        assertEq(levelOneProxy.getSessionStatus(), true);
    }
    // - `teachers` share of 35% of `bursary`

    function testTeachersNotShareOfTheertyfivePercentOfBursary() public {
        levelTwoImplementation = new LevelTwo();
        levelTwoImplementationAddress = address(levelTwoImplementation);

        bytes memory data = abi.encodeCall(LevelTwo.graduate, ());

        vm.prank(principal);
        levelOneProxy.graduateAndUpgrade(levelTwoImplementationAddress, data);

        LevelTwo levelTwoProxy = LevelTwo(proxyAddress);

        console2.log(levelOneProxy.TEACHER_WAGE());
    }
    // - remaining 60% should reflect in the bursary after upgrade
    // - Students must have gotten all reviews before system upgrade.
    // - System upgrade should not occur if any student has not gotten 4 reviews (one for each week)
    // - Any student who doesn't meet the `cutOffScore` should not be upgraded
    // - System upgrade cannot take place unless school's `sessionEnd` has reached
}
