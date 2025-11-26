// SPDX-License-Identifier : MIT

pragma solidity ^0.8.0;
import "forge-std/Test.sol";
import "../src/EmadTkn.sol";
contract EmadTknTest is Test {
    EmadTkn emad;
    address owner = address(1);
    address user = address(2);
    function setUp() public {
        vm.startPrank(owner);
        emad = new EmadTkn(1_000_000_000);
        vm.stopPrank();
    }
    function testInitialSupply() public {
        uint256 totalSupply = emad.totalSupply();
        assertEq(totalSupply, 1_000_000_000 * 10 ** emad.decimals());
    }

    function testOwnerBalance() public  {
        uint256 balance = emad.balanceOf(owner);
        assertEq(balance,   emad.totalSupply());
    }
    function testEnableTradingAndTransfer () public {
        vm.prank(owner);
        emad.enableTrading();
        vm.prank(owner);
        bool success = emad.transfer(user, 1000);
        assertTrue(success);
        assertEq(emad.balanceOf(user), 1000);
    }

    function testTransferBeforeTradingFails() public {
        vm.prank(user);
        vm.expectRevert("Trading is not enabled");
        emad.transfer(owner, 1);
    }
    function testMintWorks() public {
        vm.startPrank(owner);
        uint256 before = emad.totalSupply();
        emad.mint(10);
        uint256 afterSupply = emad.totalSupply();
        assertEq(afterSupply, before + 10 * 10 ** emad.decimals());
        vm.stopPrank();
    }
    function testMintOnlyOwner() public {
        vm.prank(user);
        vm.expectRevert("Caller is not the owner");
        emad.mint(100000);

    }
    function testBurn() public {
        vm.startPrank(owner);
        uint256 before = emad.totalSupply();
        emad.burn(1000);
        assertEq(emad.totalSupply(), before -  1000 * 10 ** emad.decimals());
        vm.stopPrank();
    }

    function testFuzz_Transfer(uint256 amount) public {
    vm.prank(owner);
    emad.enableTrading();

    // limit the amount so it doesn't exceed owner balance
    amount = bound(amount, 0, emad.totalSupply());

    vm.prank(owner);
    emad.transfer(user, amount);

    assertEq(emad.balanceOf(user), amount);
}
}