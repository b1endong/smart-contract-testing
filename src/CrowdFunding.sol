// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {PriceConverted} from "./lib/PriceConverted.sol";

contract CrowdFunding {
    using PriceConverted for uint256;

    uint256 public constant MINIMUM_USD = 5e18; //5 USD in Wei
    address public immutable i_owner;
    address public immutable i_priceFeed;
    mapping(address funder => bool isFunded) public isFunder;
    mapping(address funder => uint256 fundedAmount) public addressToAmountFunded;

    address[] public funders;

    event Funded(address indexed funder, uint256 amount);
    event Withdrawn (uint256 amount);

    constructor(address priceFeed) payable {
        i_owner = payable(msg.sender);
        i_priceFeed = priceFeed;    
    }

    fallback() external payable {
        fund();
    }

    receive() external payable {
        fund();
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) {
            revert();
        }

        _;
    }

    function fund() public payable {
        uint256 valueInUSD = msg.value.getPriceInUSD(i_priceFeed);
        require(valueInUSD >= MINIMUM_USD, "You need to fund at least 5 USD");
        addressToAmountFunded[msg.sender] += msg.value;
        if (!isFunder[msg.sender]) {
            funders.push(msg.sender);
            isFunder[msg.sender] = true;
        }
        emit Funded(msg.sender, msg.value);
    }

    function withdraw() public onlyOwner {
        (bool success,) = i_owner.call{value: address(this).balance}("");
        require(success, "Withdraw failed");
        emit Withdrawn(address(this).balance);
    }

    function getFunderLength() public view returns (uint256) {
        return funders.length;
    }
}
