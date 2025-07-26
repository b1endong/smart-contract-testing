// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {AggregatorV3Interface} from "@chainlink.git/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverted {
    function getPrice(address priceFeedAddress) internal view returns (int256) {
        AggregatorV3Interface dataFeed = AggregatorV3Interface(priceFeedAddress);
        (, int256 answer,,,) = dataFeed.latestRoundData();
        require(answer > 0, "Invalid Price");
        //Nhận về 8 digit, nhân thêm 10 chữ số thành 18 -> wei
        return answer * 1e10;
    }

    function getPriceInUSD(uint256 ethAmount, address priceFeedAddress) internal view returns (uint256) {
        uint256 ethPrice = uint256(getPrice(priceFeedAddress));
        uint256 valueInUSD = (ethAmount * ethPrice) / 1e18;
        return valueInUSD;
    }
}
