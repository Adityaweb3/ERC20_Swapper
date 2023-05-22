require("@nomiclabs/hardhat-waffle");
require("dotenv").config({ path: ".env" });

const ALCHEMY_HTTP_URL = process.env.ALCHEMY_HTTP_URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;



/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  networks : {
    hardhat : {
      chainId : 1337
    },
    
    mumbai :{
      url: ALCHEMY_HTTP_URL,
      accounts: [PRIVATE_KEY],

    }

    

  },
  solidity: "0.8.0",
};
