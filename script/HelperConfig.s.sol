// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Script} from "forge-std/Script.sol";
import {AggregatorV3Interface} from "@chainlink.git/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";
import {MockAggregatorV3Interface} from "../test/mocks/MockAggregatorV3Interface.sol";


contract HelperConfig is Script {

    uint public constant SEPOLIA_CHAIN_ID = 11155111;
    uint public constant ANVIL_CHAIN_ID = 31337;
    uint8 public constant PRICE_FEED_DECIMALS = 8;
    int public constant PRICE_FEED_INITIAL_ANSWER = 3000e8; 

    struct NetworkConfig {
        address ethUsdPriceFeed;
    }

    mapping (uint256 chainID => NetworkConfig) public networkConfigs;

    constructor() {
        networkConfigs[SEPOLIA_CHAIN_ID] = NetworkConfig({
            ethUsdPriceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306 // Sepolia ETH/USD Price Feed
        });

        // Anvil sẽ sử dụng mock contract thay vì mainnet address
        // networkConfigs[ANVIL_CHAIN_ID] sẽ được set trong getActiveNetworkConfig()
    }

    function getLocalNetworkConfig() public returns (NetworkConfig memory) {
        MockAggregatorV3Interface mockPriceFeed = new MockAggregatorV3Interface(
            PRICE_FEED_DECIMALS,
            PRICE_FEED_INITIAL_ANSWER
        );
        
        return NetworkConfig({
            ethUsdPriceFeed: address(mockPriceFeed)
        });
    }

    function getActiveNetworkConfig() public returns (NetworkConfig memory) {
        if (block.chainid == SEPOLIA_CHAIN_ID) {
            return networkConfigs[SEPOLIA_CHAIN_ID];
        } else {
            return getLocalNetworkConfig();
        }
    }

}