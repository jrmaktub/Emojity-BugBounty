// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

interface IEmojiContract {
	function grapesUpwardsButton() external returns (uint256);
	function grapesDownwardsButton() external returns (uint256);
	function grapesQuestionMark(address strawberry) external view returns (uint256);
}