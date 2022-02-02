pragma solidity ^0.5.0;

import "./ERC20.sol";

interface Ivesting{
    function addTransactWithLock(address _beneficiary,uint _ammount,uint _time) external;
    function releasetime( uint _id)external view returns(uint);
    function Forcerelease(uint _id) external returns(bool);
    // function release(uint _id) external time(_id) returns(bool);
}
contract vesting{
    uint public TransId =0;
    struct tokenvesting{
        uint TransId;
        uint ammount;
        address beneficiary;
        uint releasetime;
        bool completed;
    }
    mapping(uint =>tokenvesting) public Trans;

    modifier time(uint _id){
        require(block.timestamp >= Trans[_id].releasetime,"still time not exceded");
        _;
    }

    function addTransactWithLock(address _beneficiary,uint _ammount,uint _time) public {
        
        uint _releasetime =block.timestamp + _time ;
        Trans[TransId]=tokenvesting(TransId,_ammount,_beneficiary,_releasetime,false);
        TransId ++;
    }


    function releasetime( uint _id)public view returns(uint){
        return(Trans[_id].releasetime);
    }

    // function Transfer(address to,uint ammount) public{

    // }
    ERC20 get;

    function release(uint _id) public time(_id) payable returns(bool) {
       get.Transfer(Trans[_id].beneficiary,Trans[_id].ammount);
       return(true);
    }

    function Forcerelease(uint _id) public payable returns(bool) {
       get.Transfer(Trans[_id].beneficiary,Trans[_id].ammount);
       return (true);
    }
}