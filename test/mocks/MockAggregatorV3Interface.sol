// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {AggregatorV3Interface} from "@chainlink.git/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

contract MockAggregatorV3Interface is AggregatorV3Interface {
    uint8 private s_decimals;
    int256 private s_latestAnswer;
    uint256 private s_latestTimestamp;
    uint256 private s_latestRound;

    constructor(uint8 _decimals, int256 _initialAnswer) {
        s_decimals = _decimals;
        s_latestAnswer = _initialAnswer;
        s_latestTimestamp = block.timestamp;
        s_latestRound = 1;
    }

    function decimals() external view override returns (uint8) {
        return s_decimals;
    }

    function description() external pure override returns (string memory) {
        return "Mock ETH/USD Price Feed";
    }

    function version() external pure override returns (uint256) {
        return 1;
    }

    function getRoundData(uint80 _roundId)
        external
        view
        override
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        return (_roundId, s_latestAnswer, s_latestTimestamp, s_latestTimestamp, _roundId);
    }

    function latestRoundData()
        external
        view
        override
        returns (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound)
    {
        return (
            uint80(s_latestRound),
            s_latestAnswer,
            s_latestTimestamp,
            s_latestTimestamp,
            uint80(s_latestRound)
        );
    }

    function updateAnswer(int256 _answer) external {
        s_latestAnswer = _answer;
        s_latestTimestamp = block.timestamp;
        s_latestRound++;
    }
}
