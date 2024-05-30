const { expect } = require("chai");

describe("NFTStaking", function () {
  let NFTStaking;
  let nftStaking;
  let owner;
  let user1;
  let user2;
  let NFTCollection;
  let RewardsToken;

  this.beforeEach(async () => {
    [owner, user1, user2] = await ethers.getSigners();

    const rewardsToken = await ethers.getContractFactory("RewardToken");
    RewardsToken = await rewardsToken.deploy();

    const nftCollection = await ethers.getContractFactory("NFTCollection");
    NFTCollection = await nftCollection.deploy();

    NFTStaking = await ethers.getContractFactory("NFTStaking");
    nftStaking = await ethers.deployContract(
      "NFTStaking",
      [NFTCollection.target, RewardsToken.target],
      {}
    );
    await nftStaking.waitForDeployment();
    await NFTCollection.mint(user1); // Mint an NFT to user 1

    it("Should allow users to stake tokens", async () => {
      const tokenIdsToStake = [1];
      await NFTCollection.connect(user1).approve(
        nftStaking.target,
        tokenIdsToStake[0]
      );
      await nftStaking.connect(user1).stake(tokenIdsToStake);
      const staker = await nftStaking.stakers(user1.address);
      const result = await nftStaking.isStaked(user1, tokenIdsToStake[0]);
      expect(result).to.equal(true);
    });

    it("Should allow users to withdraw tokens", async () => {
      const tokenIdsToStake = [1];
      await NFTCollection.connect(user1).approve(
        nftStaking.target,
        tokenIdsToStake[0]
      );
      await nftStaking.connect(user1).stake(tokenIdsToStake);
      await nftStaking.connect(user1).withdraw(tokenIdsToStake);
      const staker = await nftStaking.stakers(user1.address);
      const result = await nftStaking.isStaked(user1, tokenIdsToStake[0]);
      expect(result).to.equal(false);
    });
  });
});
