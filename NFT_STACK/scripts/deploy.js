const { ethers } = require("hardhat");

async function main() {
  const contract = await ethers.getContractFactory("NFTStaking");

  const rewardsTokenAddress = "";
  const nftCollectionAddress = "";

  const deployedContract = await contract.deploy(
    nftCollectionAddress,
    rewardsTokenAddress
  );

  console.log(`Contract deployed : ${deployedContract.target}`);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
