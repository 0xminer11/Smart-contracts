pragma solidity ^0.5.0;

import "./ERC721.sol";

interface ERC721ExtendedV{
    function makePause(address spender,uint TokenId) external returns(bool);
    function makeunPause(address spender,uint TokenId) external returns(bool);
}
contract ERC721Extended is ERC721 {


    event Paused(
        address owner,
        address spender,
        uint    TokenId,
        bool Paused
        
    );

    event UnPaused(
    address owner,
    address spender,
    uint TokenId,
    bool Paused
    );


    mapping(address =>mapping(address => bool))public Pause;

function makePause(address spender,uint TokenId) public returns(bool){
    require(Allowed[msg.sender][spender] == TokenId);
    Pause[msg.sender][spender]=true;
    emit Paused(msg.sender,spender,TokenId,true);
}

function makeunPause(address spender,uint TokenId) public returns(bool){
    require(Allowed[msg.sender][spender] == TokenId);
    Pause[msg.sender][spender]=false;
    emit UnPaused(msg.sender,spender,TokenId,false);
}
}