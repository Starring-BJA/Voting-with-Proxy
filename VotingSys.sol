// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";


contract VotingSystem is Initializable, OwnableUpgradeable {
    event ProposalCreated(address indexed initiator, uint proposalID);

     function initialize() public initializer{
        __Ownable_init(msg.sender);
    }

    struct Proposal {
        address iniitiator;
        string question;
        string[] options;
        uint[] votes;
        uint startTime;
        uint endTime;
        uint result;
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
}