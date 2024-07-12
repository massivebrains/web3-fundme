// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../src/FundMe.sol";
import {DeployFundMe} from "../script/DeployFundMe.s.sol";

contract FundMetTest is Test {
	FundMe fundMe;
	address user = makeAddr("Test");

	function setUp() external {
		DeployFundMe deployFundMe = new DeployFundMe();
		fundMe = deployFundMe.run();
		vm.deal(user, 10e18);
	}

	function testMinimumDollarIsFive() public {
		assertEq(fundMe.MINIMUM_USD(), 5e18);
	}

	function testOwnerIsMsgSender() public {
		assertEq(fundMe.i_owner(), msg.sender);
	}

	function testPriceFeedVersionIsAccurate() public {
		uint256 version = fundMe.getVersion();
		assertEq(version, 4);
	}

	function testFundFailsWithoutEnoughEth() public {
		vm.expectRevert();
		fundMe.fund();
	}

	function testFundUpdatesSuccess() public {
		vm.prank(user);
		fundMe.fund{value: 10e18}();
		uint256 amountFunded = fundMe.addressToAmountFunded(user);
		assertEq(amountFunded, 10e18);
	}

	function testAddFundertoArrayOfFundersSuccess() public {
		vm.prank(user);
		fundMe.fund{value: 10e18}();
		address funder = fundMe.funders(0);
		assertEq(funder, user);
	}

	function testOnlyOwnerCanWithdraw() public {
		vm.prank(user);
		fundMe.fund{value: 10e18}();

		vm.expectRevert();
		vm.prank(user);
		fundMe.withdraw();
	}
}
