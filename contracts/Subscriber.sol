//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";

/* 

Work on creator flow:
  1. Write logic for increasing supply and distributing tokens
    


*/


contract OwnedToken is ERC20 {
  mapping(address => uint) public cumulativePayments;

  constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
  }

  function mint(address receiver, uint amount) internal {
    // mint initial supply of 1 token
    _mint(receiver, amount);
  }

  function calcMintAmount(address depositor) internal pure returns (uint) {
    
  }

  function deposit() public payable {
    cumulativePayments[msg.sender] += msg.value;
    mint(msg.sender, calcMintAmount(msg.sender));
  }

}

contract TokenManager {
  mapping (address => OwnedToken) private creatorOwnedTokens;

  function _createToken(string memory _name, string memory _symbol) private returns(OwnedToken newToken) {
    return new OwnedToken(_name, _symbol);
  }

  function createToken(address minter, string calldata tokenName, string calldata tokenSymbol) external {
    require(address(creatorOwnedTokens[minter]) != address(0), "Already minted");
    creatorOwnedTokens[minter] = _createToken(tokenName, tokenSymbol);
  }

  function getCreatorTokenContract(address _minter) public view returns(OwnedToken newToken) {
    return creatorOwnedTokens[_minter];
  }
}

enum PaymentFrequency { Monthly, Biweekly, Weekly }

struct Subscription {
  address creator;
  uint256 amount;
  PaymentFrequency frequency;
}

struct Payment {
  address to;
  address from;
  uint timestamp;
  uint amount;
}

contract Subscriber {
  mapping (address => Subscription[]) private userSubscriptions;
  TokenManager public tokenManager;

  function subscribeToCreator(address subscriber, address creator, uint amount, PaymentFrequency frequency) public {
    require(userSubscriptions[subscriber].length == 0, "Already subscribed");
    userSubscriptions[subscriber].push(Subscription(creator, amount, frequency));
  }

  

  
}

