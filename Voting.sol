pragma solidity ^0.5.0;

contract Voting{

   uint public candidateCount=0;
   
    //Structure for candidates 
    struct Candidate{
        uint cid;
        string Name;
        address contestant;
        uint votes;
        bool voted;

    }

    mapping(address => Candidate) public candidates;
    Candidate[] public cands;
    uint initialVotes=0;
    //mapping(uint => Candidate) public cands;



    function register(string memory _name) public{
        require(_name.length>0);
        candidateCount++;
        candidates[msg.sender]= Candidate(candidateCount, _name,msg.sender,initialVotes,false);            
    }




    function castVote(address _contestant) public{
        require(_contestant.length>0);
        if(candidates[_contestant].voted==false && _contestant != msg.sender){
            candidates[_contestant].votes++;
            candidates[_contestant].voted=true;
            
        }
    }


    function Winner() public view returns(address){
    uint maxvote=0;
     address  win=cands[0].contestant;
    for (uint i=0;i<cands.length;i++){
        if(cands[i].votes>maxvote){
            maxvote=cands[i].votes;
            win=cands[i].contestant;
        }
    }  
    return(win);
    }

    function RemoveVote(address _contestant) public{
        if(candidates[_contestant].voted==true){
            candidates[_contestant].votes--;
            candidates[_contestant].voted=false;
        }
    }


}