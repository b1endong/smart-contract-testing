// SPDX-License-Identifier: MIT
pragma solidity 0.8.30;

import {Test} from "forge-std/Test.sol";
import {CrowdFunding} from "../../src/CrowdFunding.sol";

contract CrowdFundingTest is Test {
    address public constant USER = address(0x123);
    address public constant OWNER = address(0x456);
    uint256 public constant USER_BALANCE = 100 ether; 
    uint256 public constant FUND_AMOUNT = 5 ether; 
    CrowdFunding public crowdFunding;

    function setUp() public {
        crowdFunding = new CrowdFunding(address(0)); 
        vm.deal(USER, USER_BALANCE);
    }

    function testInputFund() public {
        
    }

    function testFund() public {
        uint256 beforeContractBalance = address(crowdFunding).balance;
        uint256 beforeUserBalance = USER_BALANCE;

        // Kiểm tra sự kiện Funded được phát ra khi người dùng gửi tiền
        vm.expectEmit();
        emit CrowdFunding.Funded(USER, FUND_AMOUNT);

        // Giả lập người dùng gửi tiền vào hợp đồng
        vm.prank(USER);
        crowdFunding.fund{value: FUND_AMOUNT}();

        uint256 afterContractBalance = address(crowdFunding).balance;
        uint256 afterUserBalance = USER_BALANCE - FUND_AMOUNT;

        assertEq(beforeContractBalance + FUND_AMOUNT, afterContractBalance); // Kiểm tra số dư trong hợp đồng trước và sau khi fund
        assertEq(beforeUserBalance - FUND_AMOUNT, afterUserBalance); // Kiểm tra số dư của người dùn trước và sau khi fund
        assertEq(crowdFunding.addressToAmountFunded(USER), FUND_AMOUNT); //Kiểm tra số tiền người dừng đã fund có bằng fund_amount
        assertTrue(crowdFunding.isFunder(USER)); // Kiểm tra người dùng có trở thành funder không sau khi fund
        assertEq(crowdFunding.getFunderLength(), 1); //Kiểm tra danh sách funders có tăng lên không sau khi fund
    }

}