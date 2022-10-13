//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;   
import "@openzeppelin/contracts/utils/Counters.sol";//using counter from openzepplin
import "hardhat/console.sol";

contract Voting{

    using Counters for Counters.Counter;
    Counters.Counter public voterID;
    Counters.Counter public candidateID;

    //Candidate variable
    address public owner;// the one who deploy contract

    struct Candidate{
        uint id;//id of candidate
        string name;
        address address_;
        uint256 voteCount;

    }

    event candCreated( uint indexed id,string name,address address_ ,uint   voteCount);//save data on the blockchain
    address[] public addressOfCandidate;//array of candidates

    mapping(address=>Candidate) public candidates;
    //Voter 
    struct Voter{
       
        uint256 id;
        string name;
        bool isVoted;
        address address_;
        uint256 voterAllowed;
        uint256 vote;

        
    }
    event VoterCreated( uint indexed id,string name,
        bool isVoted,
        address address_,
        uint256 voterAllowed,
        uint256 vote );

        address [] public votedVoters;
    address[] public addressOfVoters;
    mapping(address=>Voter) public voters;
   
constructor(){
   owner=msg.sender;
}
function setCandidate(string memory name_, address address_) public{
    require(owner==msg.sender,"Only owner can set");
    candidateID.increment();
    uint256 idNum=candidateID.current();
    Candidate storage candidate =candidates[address_];

    candidate.name=name_;
    candidate.address_=address_;
    candidate.id=idNum;
    candidate.voteCount=0;

    addressOfCandidate.push(address_);
    
    emit candCreated( idNum , name_, address_ );

}

function getCandidate() public view returns(address[] memory){
    return addressOfCandidate;

}
function getCandidateLength() public view returns (uint256){
    return addressOfCandidate.length;
}
function voterRight(address address_,string memory name_) public {

require(owner==msg.sender,"only owner can create voter");
    voterID.increment();
    uint256 idNum=voterID.current();
    Voter storage voter =voters[address_];
    require(voter.voterAllowed==0);
    voter.voterAllowed=1;
    voter.name=name_;
    voter.address_=address_;
    voter.id=idNum;
    voter.vote=100;
    voter.isVoted=false;
    addressOfVoters.push(address_);
    emit VoterCreated(idNum, name_, voter.isVoted,address_,voter.voterAllowed,voter.vote);

}
function vote(address addressOfCandidate_,uint256 candidateID_)external{

Voter storage voter =voters[msg.sender];//copy of voter struct 
require(!voter.isVoted,"you've lready voted");//condidtitons
require(voter.voterAllowed != 0,"you cannot vote");
voter.isVoted=true;//make vote happen 
voter.vote=candidateID_;
votedVoters.push(msg.sender);
candidates[addressOfCandidate_].voteCount += voter.voterAllowed;//voter number added to the candidate count

}

}