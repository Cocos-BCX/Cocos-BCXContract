pragma solidity ^0.5.0;

import "../interface/IPlayerBook.sol";
import "../library/SafeERC20.sol";



contract PlayerBookReward {
    using SafeMath for uint256;
    using Address for address;
    using SafeERC20 for IERC20;

    IPlayerBook public playerBook = IPlayerBook(0x0);
    IERC20 public token = IERC20(0x0);

    uint256 public totalReward = 0;

    constructor(IPlayerBook _playerBook,IERC20 _token,uint256 _totalReward) public {
        playerBook  = _playerBook;
        token       = _token;
        totalReward = _totalReward;
    }
    function bindRefer(string memory affCode) public {
        if (!playerBook.hasRefer(msg.sender)) {
            playerBook.bindRefer(msg.sender, affCode);
        }
    }

    function getReward() public {
        uint256 reward = 10*(10**18);
        require(totalReward>=reward,"not enough reward");
        uint256 fee = playerBook.settleReward(msg.sender, reward);
        if(fee > 0){
            token.safeTransfer(address(playerBook), fee);
        }
        uint256 leftReward = reward.sub(fee);
        token.safeTransfer(msg.sender, leftReward);
        totalReward = totalReward.sub(reward);
    }
}