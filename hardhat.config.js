

require("@nomiclabs/hardhat-waffle");

/**
 * @type import('hardhat/config').HardhatUserConfig
 */

module.exports = {
  solidity: "0.8.4",
  networks: {
   rinkeby: {
     url: "RINKEBY_API_KEY", //Infura url with projectId
     accounts: ["PRIVATE_KEY"] // add the account that will deploy the contract (private key)
    },
  },
};
