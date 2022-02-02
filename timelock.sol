pragma solidity ^0.4.18;

contract timeblock{

    uint public duration =2 days - 172740;
    address owner;
    uint public end;
    uint public currant = block.timestamp;
    constructor(address  _owner) public{
        end = block.timestamp + duration;
        owner =_owner;
    }

    function deposit() external payable{

    }

     function gettime() public view returns(uint){
        return(block.timestamp);
     } 

    function withdraw() external payable{
        require(block.timestamp >= end,"Locked");
        require(msg.sender == owner);
        (msg.sender).transfer(address(this).balance);

    }
    
      
}