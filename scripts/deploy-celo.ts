import { ethers } from "hardhat";

async function main() {
  console.log("Deploying SyncioCelo contract...");

  const SyncioCelo = await ethers.getContractFactory("SyncioCelo");
  const syncio = await SyncioCelo.deploy();

  await syncio.waitForDeployment();

  const address = await syncio.getAddress();
  console.log(`SyncioCelo deployed to: ${address}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
