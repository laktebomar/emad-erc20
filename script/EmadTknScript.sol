// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/EmadTkn.sol";

contract EmadTknScript is Script{
    function setUp() public {}
    function run() public {
        vm.startBroadcast();
        address deployer = msg.sender;
        address emadTkn = address(new EmadTkn(1_000_000_000));
        console.log("EmadTkn deployed at:", emadTkn, " deployer ", deployer);
        vm.stopBroadcast();
    }
}