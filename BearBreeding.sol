// SPDX-License-Identifier: MIT
pragma solidity >= 0.7.0 < 0.9.0;
import '@openzeppelin/contracts/access/Ownable.sol';
interface IBearNFT {
  function balanceOf(address _user) external view returns(uint256);
  function transferFrom(address _user1, address _user2, uint256 _tokenId) external;
  function ownerOf(uint256 _tokenId) external returns(address);
}
interface IBabyNFT {
  function balanceOf(address _user) external view returns(uint256);
  function transferFrom(address _user1, address _user2, uint256 _tokenId) external;
  function ownerOf(uint256 _tokenId) external returns(address);
  function mint(address _user, uint256 _amount) external;
}
interface IBearerToken {
  function balanceOf(address _user) external view returns(uint256);
  function transferFrom(address _user1, address _user2, uint256 _amount) external;
  function transfer(address _user, uint256 _amount) external;  
  function burn(address _user, uint256 _amount) external;
}
contract BearFarm is Ownable {
  IBearNFT public bearNFT;
  IBearerToken public yieldToken;
  IBabyNFT public babyNFT;
  address public admin = 0xD4577dA97872816534068B3aa8c9fFEd2ED7860C;
  uint256 public breedTokenAmount = 10 ether;
  mapping(address => uint256) public harvests;
  mapping(address => uint256) public lastUpdate;
  mapping(uint => address) public ownerOfToken;
  mapping(address => uint) public stakeBalances;
  mapping(address => mapping(uint256 => uint256)) public ownedTokens;
  mapping(uint256 => uint256) public ownedTokensIndex;

  constructor(
    address _bearNFTAddr,
    address _bearerTokenAddr,
    address _babyNFTAddr
  ) {
    bearNFT = IBearNFT(_bearNFTAddr);
    yieldToken = IBearerToken(_bearerTokenAddr);
    babyNFT = IBabyNFT(_babyNFTAddr);
  }

  function breed() external {
    require(bearNFT.balanceOf(msg.sender) >= 2, "need more NFT");
    require(yieldToken.balanceOf(msg.sender) >= breedTokenAmount, "need more bearer token");
    yieldToken.burn(msg.sender, breedTokenAmount);
    babyNFT.mint(msg.sender, 1);
  }

  function setNFtContractAddr(address _nftAddr) public onlyOwner {
    bearNFT = IBearNFT(_nftAddr);
  }

  function setFtContractAddr(address ftAddr) public onlyOwner {
    yieldToken = IBearerToken(ftAddr);
  }
}