
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../../src/4_Telephone/Telephone.sol";

contract TelephoneTest is Test {
    Telephone public victim;
    address public owner;
    address public addr1;

    function setUp() public {
        owner = vm.addr(1);
        addr1 = vm.addr(2);

        vm.deal(addr1, 1 ether);

        vm.prank(owner);
        victim = new Telephone();
    }

    function testAttack() public {
        //ingreasr valor al diccionario

        victim.changeOwner(addr1);

        assertEq(victim.owner(), addr1);

    }
}