pragma solidity ^0.5.0;

contract multisign{
    address[] public owners;
    uint public numConfirmationRequired; 
    uint public TransactionCount=0;
    struct Transaction{
        uint TransactionID;
        address to;
        uint value;
        bytes data;
        bool executed;
        mapping(address=>bool) isConfirmed;
        uint numConfirmation;
    }

    Transaction[] public Transactions;
    // mapping(uint =>Transaction) public Transactions;
    mapping(address =>bool) public isOwner;

    constructor(address[] memory _owners,uint _numConfirmationRequired) public{
        require( _owners.length >0);
        require(_numConfirmationRequired >0 && _numConfirmationRequired <= _owners.length);


        
        for(uint256 i =0;i<_owners.length;i++){
                address owner =_owners[i];

                require(owner != address(0),"Invalid Owner");
                require(!isOwner[owner],"AllReady Exist");

                isOwner[owner]=true;
                owners.push(owner);
            
        }
        numConfirmationRequired =_numConfirmationRequired;    
    }


    modifier onlyOwner(){
        require(isOwner[msg.sender]);
        _;
    }

    modifier txExist(uint TransactionID){
        require(TransactionID <= Transactions.length);
        _;
    }

    modifier TxConfirmed(uint TransactionID){
        require(!Transactions[TransactionID].isConfirmed[msg.sender]);
        _;
    }

    modifier TxExicuted(uint TransactionID){
        require(Transactions[TransactionID].executed == false);
        _;
    }

        function deposit( ) payable external{
        
        }

        function () payable external{

        }


    function SubmitTransaction(address _to, uint _value, bytes memory _data) public onlyOwner {
        require(_value>0);
        Transactions.push(Transaction({
            TransactionID:TransactionCount,
            to:_to,
            value:_value,
            data:_data,
            executed: false,
            numConfirmation:0
        }));
        TransactionCount++;
    }


    function confirmTransaction(uint _id )public payable onlyOwner TxConfirmed(_id) TxExicuted(_id) txExist(_id){
        Transactions[_id].isConfirmed[msg.sender] =true;
        Transactions[_id].numConfirmation += 1;
    }

    function executeTransaction(uint _id) public onlyOwner txExist(_id) TxExicuted(_id){
        require(Transactions[_id].numConfirmation >= numConfirmationRequired);
        Transactions[_id].executed =true;
        (bool success, ) =Transactions[_id].to.call.value(Transactions[_id].value)(Transactions[_id].data);
        require(success);
    }


    function revokeTransaction(uint _id) public onlyOwner txExist(_id) TxExicuted(_id){
        require(Transactions[_id].isConfirmed[msg.sender]);
        Transactions[_id].isConfirmed[msg.sender] ==false;
        Transactions[_id].numConfirmation -= 1;
    }





}

 