// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

error CandidateAlreadyExists();
error AlreadyVoted();
error CandidateSelfVote();

contract BlockchainVoting {
    address public manager;
    uint256 public totalCandidates;
    uint256 public totalVoters;
 
    constructor() {
        manager = msg.sender;
    }

    struct Voter {
        uint256 id;
        string name;
        address voterAddress;
        address candidateAddress;
    }

    struct Candidate {
        string name;
        address candidateAddress;
        uint256 voteCount;
    }

    struct Proposal {
        string name;
        address candidateAddress;
    }

    Voter[] public voters;
    Candidate[] public candidates;
    Proposal[] public proposals;

    function setCandidate(address _address, string memory _name) external onlyManager {
        for (uint256 i = 0; i < candidates.length; i++) {
            require(candidates[i].candidateAddress != _address, "Candidate already exists");
        }
        candidates.push(Candidate(_name, _address, 0));
        totalCandidates++;
    }

    function vote(uint256 _id, string memory _name, address _voterAddress, address _candidateAddress) external {
        require(candidates.length >= 2, "Candidates should be at least 2");
        
        for (uint256 i = 0; i < voters.length; i++) {
            require(!(voters[i].id == _id && voters[i].voterAddress == _voterAddress), "Already voted");
        }

        require(_voterAddress != _candidateAddress, "Voter cannot vote for themselves");

        for (uint256 i = 0; i < candidates.length; i++) {
            if (candidates[i].candidateAddress == _candidateAddress) {
                candidates[i].voteCount++;
                voters.push(Voter(_id, _name, _voterAddress, _candidateAddress));
                totalVoters++;
                break;
            }
        }
    }

    function requestForNextVoting(address _requestAddress, string memory _name) external {
        proposals.push(Proposal(_name, _requestAddress));
    }

    function getRequestProposal() external view returns (Proposal[] memory) {
        return proposals;
    }

    function getCandidates() external view returns (Candidate[] memory) {
        return candidates;
    }

    function getVoters() external view returns (Voter[] memory) {
        return voters;
    }

    modifier onlyManager() {
        require(msg.sender == manager, "Only manager can perform this operation");
        _;
    }
}
