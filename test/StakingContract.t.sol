// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/StakingContract.sol";
import "../src/MaliciousContract.sol";

contract StakingContractTest is Test {
    StakingContract stakingContract;
    MaliciousContract maliciousContract;

    function setUp() public {
        stakingContract = new StakingContract();
        // Deploy the malicious contract with the staking contract's address
        maliciousContract = new MaliciousContract(address(stakingContract));

        // Allocate 1 ether to the staking contract to simulate staked funds
        vm.deal(address(stakingContract), 1 ether);

        // Allocate 1 ether to the malicious contract for the attack
        vm.deal(address(maliciousContract), 1 ether);
    }

    function testAttack() public {
        // Initial balance of the malicious contract before the attack
        uint initialBalance = address(maliciousContract).balance;

        // Start the attack by calling the attack function with 1 ether
        // Using vm.prank to make the call from the malicious contract
        vm.prank(address(maliciousContract));
        maliciousContract.attack{value: 1 ether}();

        // Balance of the malicious contract after the attack
        uint finalBalance = address(maliciousContract).balance;

        // Check if the balance of the malicious contract increased after the attack
        assertTrue(finalBalance > initialBalance, "Attack did not increase balance");

        // Check if the balance of the staking contract decreased to zero after the attack
        uint stakingContractBalance = address(stakingContract).balance;
        assertTrue(stakingContractBalance == 0, "Staking contract still has funds");
    }
}
