require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY;
const SECRET_KEY = process.env.SECRET_KEY;

module.exports = {
  solidity: "0.8.24",
  networks: {
    bnbTestnet: {
      url: "https://data-seed-prebsc-1-s1.bnbchain.org:8545/",
      chainId: 97,
      accounts: [SECRET_KEY],
    },
    etherscan: {
      apiKey: ETHERSCAN_API_KEY,
    },
  },
};
