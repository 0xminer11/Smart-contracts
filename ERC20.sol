pragma solidity ^0.5.0;
interface IERC20{
    
    function getName() external view returns(string memory);
    function getSymbol() external view returns(string memory);
    function getDecimal() external view returns(uint);
    function getTotalSupply() external view returns(uint);
    function BalanceOf(address from) external view returns(uint);
    function approve(address spender,uint tokens) external returns(bool);
    function Transfer(address to,uint tokens) external returns(bool);
    function TransferFrom(address from,address to,uint tokens) external returns(bool);
    function Allowance(address owner,address spender)external view returns(uint);
    function IncreaseAllowance(address spender,uint tokens)external returns(bool);
    function DecreasesAllowance(address spender,uint tokens)external returns(bool);
}
contract ERC20{
string name;
string symbol;
uint decimal;
uint totalsupply;
mapping(address =>uint)public Balance;
mapping(address => mapping(address=>uint))allowed;
uint public TransId =0;
    
    
    
    struct tokenvesting{
        uint TransId;
        uint ammount;
        address from;
        address beneficiary;
        uint onedaytime;
        uint halftime;
        uint releasetime;
        bool completed;
    }
event transfer(
    address from,
    address to,
    uint tokens
);

event allow(
    address owner,
    address spender,
    uint token
);
event increasedallowance(
    address owner,
    address spender,
    uint increasetokens
);
event Decreaseallowance(
address owner,
address spender,
uint decreasetokens
);


constructor() public{ 
name="RapidInnovationCoin";
symbol="RIC";
decimal=2;
totalsupply=10000;
Balance[msg.sender]=totalsupply;
}


//Get Token name
function getName() public view returns(string memory){
    return(name);
}
// Get Token Symbol
function getSymbol() public view returns(string memory){
    return(symbol);
}

// Get Token Decimal
function getDecimal() public view returns(uint){
    return(decimal);
}

//get Total Supply
function getTotalSupply() public view returns(uint){
    return(totalsupply);
}

//Get Balance of Accounts
function BalanceOf(address from) public view returns(uint){
    return(Balance[from]);
}

//Approve allowance for account
function approve(address spender,uint tokens) public returns(bool){
    require(Balance[msg.sender]>=tokens);
    allowed[msg.sender][spender]=tokens;
    emit allow(msg.sender,spender,tokens);
}
//Transfer tokens to other account
function Transfer(address to,uint tokens) public returns(bool){
    require(Balance[msg.sender]>=tokens);
    Balance[msg.sender] -= tokens;
    Balance[to] += tokens;
    emit transfer(msg.sender,to,tokens);
    return true;
}
//Transfer from one account to your account
function TransferFrom(address from,address to,uint tokens) public returns(bool){
    
    if(from == msg.sender){
    require(Balance[from]>=tokens);
    Balance[from] -= tokens;
    Balance[to] += tokens;
    emit transfer(msg.sender,to,tokens);
    return true;
    }else{
    require(allowed[from][msg.sender] >= tokens);
    allowed[from][msg.sender] -= tokens;
    Balance[from] -= tokens;
    Balance[to] += tokens;
    emit transfer(msg.sender,to,tokens);
    return true;
    }
}

//Get Allowance Tokens 
function Allowance(address owner,address spender)public view returns(uint){
    return allowed[owner][spender];
}

// Increase Allowance tokens
function IncreaseAllowance(address spender,uint tokens)public returns(bool){
    //require(allowed[msg.sender][spender]);
    require (Balance[msg.sender]>=tokens);
    allowed[msg.sender][spender] += tokens; 
    emit increasedallowance(msg.sender,spender,tokens);
    return true;
}

// Decrease Allowance tokens
function DecreasesAllowance(address spender,uint tokens)public returns(bool){
    require(Balance[msg.sender]>= tokens);
    require(spender != msg.sender);
    require(Balance[spender]<=tokens);
    allowed[msg.sender][spender] -= tokens; 
    emit Decreaseallowance(msg.sender,spender,tokens);
}

    mapping(uint =>tokenvesting) public Trans;

    modifier time(uint _id){
        require(block.timestamp >= Trans[_id].releasetime,"still time not exceded");
        _;
    }
    function addTransactWithLock(address _beneficiary,uint _ammount) public {   
        uint _releasetime =block.timestamp + 30 days ;
        uint _onedaytime = block.timestamp + 1 days;
        uint _halftime = block.timestamp +15 days;
        require(Balance[msg.sender]>=_ammount);
        Trans[TransId]=tokenvesting(TransId,_ammount,msg.sender,_beneficiary,_onedaytime,_halftime,_releasetime,false);
        TransId ++;
    }


    function releasetime( uint _id)public view returns(uint){
        return(Trans[_id].releasetime);
    }

    function getCurrantTime() public view returns(uint){
        return(block.timestamp);
    }

    function release(uint _id) public time(_id) payable returns(bool) {
        if(block.timestamp >= Trans[_id].onedaytime &&block.timestamp < Trans[_id].halftime){
           uint _ammount = (Trans[_id].ammount/20)*100;
           Transfer(Trans[_id].beneficiary,_ammount); 
        }else if(block.timestamp >= Trans[_id].halftime && block.timestamp < Trans[_id].releasetime){
            uint _ammount = (Trans[_id].ammount/30)*100;
           Transfer(Trans[_id].beneficiary,_ammount);
        }else if(block.timestamp >= Trans[_id].releasetime){
            uint _ammount = (Trans[_id].ammount);
            Transfer(Trans[_id].beneficiary,_ammount);
        }
       Transfer(Trans[_id].beneficiary,Trans[_id].ammount);
       return(true);
    }

    function Forcerelease(uint _id) public payable returns(bool) {
       Transfer(Trans[_id].beneficiary,Trans[_id].ammount);
       return (true);
    }

}