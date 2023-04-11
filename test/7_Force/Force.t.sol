pragma solidity ^0.8.14;


import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../../src/7_Force/Force.sol";
import "./ForceHack.sol";

contract ForceTest is Test {

    Force public victim;
    address public owner;
    address public addr1;

    function setUp() public {

        owner = vm.addr(1);
        addr1 = vm.addr(2);

        vm.deal(addr1, 1 ether);

        vm.prank(owner);
        victim = new Force();
    }

    function testAttack() public payable {

    vm.startPrank(addr1);
    ForceHack forceHack = (new ForceHack){value: 0.1 ether}(payable(address(victim)));

    assertEq(address(victim).balance, 0.1 ether);
    }


}