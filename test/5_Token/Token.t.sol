pragma solidity ^0.8.14;


import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../../src/5_Token/Token.sol";

contract TokenTest is Test {
    Token public victim;
    address public owner;
    address public addr1;

    function setUp() public {
        owner = vm.addr(1);
        addr1 = vm.addr(2);

        vm.deal(addr1, 1 ether);

        vm.prank(owner);
        victim = new Token(20);
    }

    function testAttack() public {
        //ingreasr valor al diccionario

        console.log(victim.balanceOf(addr1));


        uint256 max = type(uint256).max;

        vm.prank(owner);

        unchecked {
            victim.transfer(addr1, 1000);
        }


        console.log(victim.balanceOf(addr1));

       //assertEq(victim.balanceOf(addr1), 21);

    }
}