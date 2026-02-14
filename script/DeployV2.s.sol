// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "forge-std/Script.sol";
import "../src/MockSTEALTH.sol";
import "../src/WorldEngineV2.sol";

contract DeployV2 is Script {
    function run() external {
        vm.startBroadcast();
        // MockSTEALTH already deployed, just deploy WorldEngineV2
        WorldEngineV2 engine = new WorldEngineV2(vm.envAddress("STEALTH_ADDR"));
        vm.stopBroadcast();
        console.log("WorldEngineV2:", address(engine));
    }
}
