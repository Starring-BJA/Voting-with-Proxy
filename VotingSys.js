const {    
    loadFixture,
  } = require("@nomicfoundation/hardhat-toolbox/network-helpers");
  const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
  const { expect } = require("chai");
  const {ethers, upgrades} = require("hardhat");


describe("Voting", ()=>{
    async function deployFixture(){
        const[owner, otherAccount] = await ethers.getSigners();

        const VotingFactory = await ethers.getContractFactory("VotingSystem");
        const VotingV1 = await upgrades.deployProxy(VotingFactory, [],{
            initializer: "initialize"
        })

        return {owner, otherAccount, VotingV1}
    }

    it("Should create proposal", async ()=>{
        const {owner, otherAccount, VotingV1} = await loadFixture(deployFixture);
        
        const finishTime = Math.floor(Date.now() / 1000)+10;

        expect(await VotingV1.createProposal("Voting for test", ["yes", "no", "abstained"], finishTime)).not.to.be.reverted;
        const createdProposal = await VotingV1.proposals(0);
        expect(createdProposal[0]).to.eq(owner.address);

        const VotingV2Factory = await ethers.getContractFactory("VotingSystem2");
        const VotingV2 = await upgrades.upgradeProxy(VotingV1.target, VotingV2Factory);

        createdProposal = await VotingV2.proposals(0);
        expect(createdProposal[0]).to.eq(owner.address);

        time.increase(5);

        expect (await VotingV2.vote(0, 1)).not.to.be.reverted;

        createdProposal = await VotingV2.getVotes(0);

        expect(createdProposal[1]).to.eq(1);

        const VotingV3Factory = await ethers.getContractFactory("VotingSystem3");
        const VotingV3 = await upgrades.upgradeProxy(VotingV2.target, VotingV3Factory);

        expect (await VotingV3.executeProposal(0)).not.to.be.reverted;

        expect (await VotingV3.getResultOfProposal(0)).to.eq("no");
    })
})