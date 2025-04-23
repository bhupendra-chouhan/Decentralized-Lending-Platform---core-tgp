// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedLending {
    address public owner;
    uint256 public interestRate = 5; // 5% interest
    mapping(address => uint256) public deposits;
    mapping(address => uint256) public loans;

    constructor() {
        owner = msg.sender;
    }

    // Deposit funds into the platform
    function deposit() external payable {
        require(msg.value > 0, "Deposit must be greater than zero");
        deposits[msg.sender] += msg.value;
    }

    // Borrow funds up to 50% of your deposited collateral
    function borrow(uint256 _amount) external {
        require(deposits[msg.sender] > 0, "No collateral found");
        require(_amount <= deposits[msg.sender] / 2, "Exceeds borrow limit");

        loans[msg.sender] += _amount;
        payable(msg.sender).transfer(_amount);
    }

    // Repay borrowed funds (principal only for simplicity)
    function repay() external payable {
        require(loans[msg.sender] > 0, "No outstanding loan");
        require(msg.value >= loans[msg.sender], "Repayment too low");

        loans[msg.sender] = 0;
    }

    // Withdraw your deposited collateral (if no loan is active)
    function withdraw() external {
        require(loans[msg.sender] == 0, "Active loan exists");
        uint256 amount = deposits[msg.sender];
        require(amount > 0, "No funds to withdraw");

        deposits[msg.sender] = 0;
        payable(msg.sender).transfer(amount);
    }
}

