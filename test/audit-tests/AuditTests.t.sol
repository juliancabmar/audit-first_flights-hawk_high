// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;

import {Test, console2} from "forge-std/Test.sol";
import {DeployLevelOne} from "../../script/DeployLevelOne.s.sol";
import {GraduateToLevelTwo} from "../../script/GraduateToLevelTwo.s.sol";
import {LevelOne} from "../../src/LevelOne.sol";
import {LevelTwo} from "../../src/LevelTwo.sol";
import {MockUSDC} from "../mocks/MockUSDC.sol";

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

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
    // PENDING
    // function testTeachersNotShareOfTheertyfivePercentOfBursary() public {
    //     levelTwoImplementation = new LevelTwo();
    //     levelTwoImplementationAddress = address(levelTwoImplementation);

    //     bytes memory data = abi.encodeCall(LevelTwo.graduate, ());

    //     vm.prank(principal);
    //     levelOneProxy.graduateAndUpgrade(levelTwoImplementationAddress, data);

    //     LevelTwo levelTwoProxy = LevelTwo(proxyAddress);

    //     console2.log(levelTwoProxy.TEACHER_WAGE_L2());
    // }

    // @audit - !(remaining 60% should reflect in the bursary after upgrade)
    function testRemainingSixtyPercentNotReflectedOnBursaryAfterUpgrade() public {
        uint256 teachersNum;
        uint256 studentsNum;
        // adding two teachers
        vm.startPrank(principal);
        levelOneProxy.addTeacher(alice);
        levelOneProxy.addTeacher(bob);
        vm.stopPrank();
        // adding four students
        vm.startPrank(clara);
        usdc.approve(address(levelOneProxy), schoolFees);
        levelOneProxy.enroll();
        vm.stopPrank();

        vm.startPrank(dan);
        usdc.approve(address(levelOneProxy), schoolFees);
        levelOneProxy.enroll();
        vm.stopPrank();

        vm.startPrank(eli);
        usdc.approve(address(levelOneProxy), schoolFees);
        levelOneProxy.enroll();
        vm.stopPrank();

        vm.startPrank(fin);
        usdc.approve(address(levelOneProxy), schoolFees);
        levelOneProxy.enroll();
        vm.stopPrank();

        teachersNum = levelOneProxy.getTotalTeachers();
        studentsNum = levelOneProxy.getTotalStudents();

        uint256 percentToDiscount = (levelOneProxy.TEACHER_WAGE() * teachersNum) + levelOneProxy.PRINCIPAL_WAGE();

        uint256 expectedBursary = levelOneProxy.bursary() - (levelOneProxy.bursary() * percentToDiscount / 100);

        levelTwoImplementation = new LevelTwo();
        levelTwoImplementationAddress = address(levelTwoImplementation);

        bytes memory data = abi.encodeCall(LevelTwo.graduate, ());

        vm.prank(principal);
        levelOneProxy.graduateAndUpgrade(levelTwoImplementationAddress, data);

        assert(LevelTwo(proxyAddress).bursary() != expectedBursary);
        console2.log("Actual Bursary: ", LevelTwo(proxyAddress).bursary());
        console2.log("Expected Bursary: ", expectedBursary);
    }
    // @audit - !(System upgrade should not occur if any student has not gotten 4 reviews)

    function testSystemCanBeUpgradedWithoutFourReviewsPerStudent() public {
        // adding a teacher
        vm.prank(principal);
        levelOneProxy.addTeacher(bob);
        // adding a student
        vm.startPrank(clara);
        usdc.approve(address(levelOneProxy), schoolFees);
        levelOneProxy.enroll();
        vm.stopPrank();
        // advance the time one week
        vm.warp(block.timestamp + 1 weeks);

        // review the student
        vm.prank(bob);
        levelOneProxy.giveReview(clara, true);

        levelTwoImplementation = new LevelTwo();
        levelTwoImplementationAddress = address(levelTwoImplementation);

        bytes memory data = abi.encodeCall(LevelTwo.graduate, ());

        vm.prank(principal);
        levelOneProxy.graduateAndUpgrade(levelTwoImplementationAddress, data);
    }
    // @audit - !(Any student who doesn't meet the `cutOffScore` should not be upgraded)

    function testAStudentWhoNotMeetCutOffScoreCanBeUpgraded() public {
        uint256 cutOffScore = 90;
        // adding a teacher
        vm.prank(principal);
        levelOneProxy.addTeacher(bob);
        // adding a student
        vm.startPrank(clara);
        usdc.approve(address(levelOneProxy), schoolFees);
        levelOneProxy.enroll();
        vm.stopPrank();

        // principal starts session setting 90 for minimun score to pass
        vm.prank(principal);
        levelOneProxy.startSession(cutOffScore);

        // advance the time one week
        vm.warp(block.timestamp + 1 weeks);
        // review the student, now his score is 90
        vm.prank(bob);
        levelOneProxy.giveReview(clara, false);

        // advance the time one week
        vm.warp(block.timestamp + 1 weeks);
        // review the student, now his score is 80
        vm.prank(bob);
        levelOneProxy.giveReview(clara, false);

        levelTwoImplementation = new LevelTwo();
        levelTwoImplementationAddress = address(levelTwoImplementation);

        bytes memory data = abi.encodeCall(LevelTwo.graduate, ());

        vm.prank(principal);
        levelOneProxy.graduateAndUpgrade(levelTwoImplementationAddress, data);

        assertEq(clara, LevelTwo(proxyAddress).getListOfStudents()[0]);
        console2.log("Cut off score: ", cutOffScore);
        console2.log("Clara final score: ", LevelTwo(proxyAddress).studentScore(clara));
    }
    // @audit - !(System upgrade cannot take place unless school's `sessionEnd` has reached)

    function testSystemCanUpgradeWithoutSessionEnds() public {
        // principal starts session setting 90 for minimun score to pass
        vm.prank(principal);
        levelOneProxy.startSession(90);

        // advance the time one week
        vm.warp(block.timestamp + 1 weeks);

        levelTwoImplementation = new LevelTwo();
        levelTwoImplementationAddress = address(levelTwoImplementation);

        bytes memory data = abi.encodeCall(LevelTwo.graduate, ());

        vm.prank(principal);
        levelOneProxy.graduateAndUpgrade(levelTwoImplementationAddress, data);
    }
}
