// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EmadStaking {
    string public constant name = "EmadStaking";
    string public constant symbol = "EMADS";
    uint8 public constant decimals = 18;

    mapping(address => uint256) private _stakes;
    mapping(address => uint256) private _rewards;
    address public immutable stakingToken;
    address public immutable rewardToken;
    address public _owner;

    event Staked(address indexed user, uint256 amount);
    event Unstaked(address indexed user, uint256 amount);
    event RewardPaid(address indexed user, uint256 reward);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    constructor(address _stakingToken, address _rewardToken) {
        stakingToken = _stakingToken;
        rewardToken = _rewardToken;
        _owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == _owner, "Caller is not the owner");
        _;
    }

    function stake(uint256 amount) external {
        require(amount > 0, "Cannot stake zero tokens");
        _stakes[msg.sender] += amount;
        emit Staked(msg.sender, amount);
    }

    function unstake(uint256 amount) external {
        require(amount > 0 && amount <= _stakes[msg.sender], "Invalid unstake amount");
        _stakes[msg.sender] -= amount;
        emit Unstaked(msg.sender, amount);
    }

    function claimReward() external {
        uint256 reward = _rewards[msg.sender];
        require(reward > 0, "No rewards to claim");
        _rewards[msg.sender] = 0;
        emit RewardPaid(msg.sender, reward);
    }
}