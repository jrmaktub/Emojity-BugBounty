// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

// import "./IEmojiContract.sol";

contract StakingContract {
    
    mapping(address account => uint balance) stakeBalance;

    function stake() public payable returns(bool success) {
        stakeBalance[msg.sender] += msg.value;
        return true;
    }

    function unstake() public returns(bool success) {
        uint senderStake = stakeBalance[msg.sender];
        stakeBalance[msg.sender] = 0;
        (bool sent, bytes memory data) = msg.sender.call{value: senderStake}("");
        data;
        return sent;
    }

    function getStake(address account) public view returns(uint balance) {
        return stakeBalance[account];
    }
}