// // SPDX-License-Identifier: SEE LICENSE IN LICENSE
// pragma solidity ^0.8.20;

// import "@openzeppelin/contracts/interfaces/IERC20.sol";
// import "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

// contract Voting{
//     IERC20 public token;
//     bool public isVoting; 

//     struct Vote{
//         address receiver;
//     }

//     mapping (address=>Vote) public votes;

//     event AddVote(address indexed voter, address receiver, uint timestamp);
//     event RemoveVote(address voter);
//     event StartVoting(address owner);
//     event StopVoting(address owner);

//     constructor() public {
//         isVoting = false;
//     }

//     function StartVoting() external returns(bool){
//         isVoting = true;
//         emit StartVoting(msg.sender);
//         return true;
//     }

//     function StopVoting() external returns(bool){
//         isVoting = false;
//         emit StopVoting(msg.sender);
//         return true;
//     }

//     // function AddVote(address receiver) 
// }