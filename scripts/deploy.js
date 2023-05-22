const { ethers } = require("hardhat");

async function main() {
  const TokenSwap = await ethers.getContractFactory("TokenSwap");
  const tokenSwap = await TokenSwap.deploy();
  await tokenSwap.deployed();

  console.log("TokenSwap contract deployed to:", tokenSwap.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
