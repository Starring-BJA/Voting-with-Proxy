// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

library AddressArray {
    function checkAddress(address[] memory voters, address currentVoter) internal pure returns(bool){
        for(uint i=0; i<voters.length; i++){
            if(voters[i] == currentVoter){
                return true;
            }
        }
        return false;
    }
}
contract VotingSystem2 is Initializable, OwnableUpgradeable {
    using AddressArray for address[];

    event ProposalCreated(address indexed initiator, uint proposalID);
    event Voted(address indexed voterAddress, uint indexed proposalID, uint VoteOption);

    //  function initialize(uint num) public initializer{
    //     _Ownable_init(msg.sender);
    // }

    struct Proposal {
        address iniitiator;
        string question;
        string[] options;
        uint[] votes;
        uint startTime;
        uint endTime;
        uint result;
        address[] voters;
    }

    mapping(uint => Proposal) public proposals;
    uint totalProposals;

    function createProposal (string memory question, string[] memory options, uint finishTime) external{
        Proposal storage newProposal = proposals[totalProposals];
        newProposal.iniitiator = msg.sender;
        newProposal.question = question;
        newProposal.options = options;
        newProposal.votes = new uint[] (options.length);
        newProposal.startTime = block.timestamp + 5;
        newProposal.endTime = finishTime;
        newProposal.result = options.length;

        emit ProposalCreated(msg.sender, totalProposals);
        totalProposals++;
    }

    function vote(uint proposalID, uint vote) external{
        Proposal storage proposal = proposals[proposalID];
        require(!proposal.voters.checkAddress(msg.sender), "You've already voted");
        require(proposal.startTime <= block.timestamp, "Voting will start soon");
        require(proposal.endTime > block.timestamp, "Voting finished");
        require(vote < proposal.options.length, "There is no option");

        proposal.votes[vote]++;
        proposal.voters.push(msg.sender);

        emit Voted(msg.sender, proposalID, vote);
    }

    function getVotes (uint proposal) public view returns(uint[] memory results){
        results = proposals[proposal].votes;
    }
    

}