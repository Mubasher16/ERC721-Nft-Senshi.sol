// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Senshi is ERC721,Ownable{
    uint256 private maxSupply = 10000;
    uint256 private tokenPrice =50;
    uint256 private startTime;
    uint256 private endTime;
    string URI;
    bool openForWhitelisters = true;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;
    mapping(address => bool) whitelist;
    modifier checkTime(){
         require((block.timestamp >= startTime && block.timestamp <= endTime), "Not Allowed to mint at that time");
         _;

    }

        constructor(string memory name_, string memory symbol_) ERC721(name_ , symbol_) {
        
            
    }

        function mint() public payable checkTime{
        if (openForWhitelisters){
        require(isWhitelisted(msg.sender), "You are not a whitelist user");
        }

        require(msg.value==tokenPrice, "Insufficient balance to buy token");
        uint256 tokenId = _tokenId.current();
        require(tokenId<=maxSupply, "Max limit reached");
        _mint(msg.sender,tokenId);
        _tokenId.increment();
    }
        
        function mintBatch(uint256 tokensMint) public payable checkTime {
            if(openForWhitelisters){
            require(isWhitelisted(msg.sender), "You are not a whitelist user");
            }
            uint256 alreadyMintedTokens=_tokenId.current();
            require(msg.value==(tokensMint*tokenPrice), "Insufficient balance to buy tokens");
            require(alreadyMintedTokens+tokensMint<=maxSupply, "Max limit reached");
            for(uint8 i=1; i<=tokensMint;i++) {
            uint256 tokenId = _tokenId.current();
            _mint(msg.sender,tokenId);
            _tokenId.increment(); 
            }
    }
        

        function changeWhitelistingStatus() external onlyOwner() returns(bool) {
           openForWhitelisters=!openForWhitelisters;
           return openForWhitelisters;
        }

        function withdraw() external onlyOwner {
            payable(msg.sender).transfer(address(this).balance);
        }

        function currentlyMinted() external view returns(uint256) {
            return _tokenId.current();
    }

        function addWhitelistUser(address _address) public onlyOwner{
            require(_address != address(0));
            whitelist[_address] = true;
    }

        function addBlacklistUser(address _address) public onlyOwner{
            require(_address != address(0));
            whitelist[_address]=false;
    }
    
        function isWhitelisted(address _address) public view returns(bool) {
            return whitelist[_address];
    }

        function Maxsupply() public view returns (uint256) {
            return maxSupply;
    }

        function totalSupply() public view returns (uint256) {
            return _tokenId.current();
    }

        function modifyPrice(uint256 _price) external onlyOwner {
            tokenPrice=_price;
    }

        function getPrice() public view returns (uint256) {
            return tokenPrice;
    }
    
       function setTime(uint256 _startTime,uint256 _endTime) public onlyOwner returns(uint256, uint256) {
            require(_startTime < _endTime, "Try to enter incorrect time");
            startTime=_startTime;
            endTime=_endTime;
            return (startTime,endTime);
  }

        function getstartTime() external view returns(uint256){
            return startTime;
  }

        function getendTime() external view returns(uint256){
            return endTime;
  }

        function setURI(string memory URI_) external onlyOwner {
            require(bytes(URI_).length > 0, "It can't be Null");
            URI= URI_;
    }

}
