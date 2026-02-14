// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;
import "forge-std/Script.sol";
import "../src/ClawartsWorld.sol";

contract DeployScript is Script {
    function run() external {
        vm.startBroadcast();
        ClawartsWorld world = new ClawartsWorld();
        console.log("ClawartsWorld deployed at:", address(world));
        vm.stopBroadcast();
    }
}
