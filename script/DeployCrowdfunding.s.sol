// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Script, console} from "forge-std/Script.sol";
import {CrowdFunding} from "../src/CrowdFunding.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployCrowdfunding is Script {
    function run() external returns (CrowdFunding, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        address ethUsdPriceFeed = helperConfig.getActiveNetworkConfig().ethUsdPriceFeed;

        console.log("Deploying CrowdFunding contract with ETH/USD Price Feed at:", ethUsdPriceFeed);

        vm.startBroadcast();
        CrowdFunding crowdFunding = new CrowdFunding(ethUsdPriceFeed);
        vm.stopBroadcast();

        return (crowdFunding, helperConfig);
    }
}