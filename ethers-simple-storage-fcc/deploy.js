const ethers = require("ethers");
const fs = require("fs-extra");
require("dotenv").config();

async function main() {
  const provider = new ethers.providers.JsonRpcBatchProvider(
    process.env.RPC_URL
  );
  const wallet = new ethers.Wallet(process.env.WALLET_KEY, provider);

  const abi = fs.readFileSync("./simpleStorage_sol_SimpleStorage.abi", "utf8");
  const binary = fs.readFileSync(
    "./simpleStorage_sol_SimpleStorage.bin",
    "utf8"
  );
  const contractFactory = new ethers.ContractFactory(abi, binary, wallet);
  console.log("Deploying Please wait");
  const contract = await contractFactory.deploy();
  const transactionReceipt = await contract.deployTransaction.wait(1);
  const currentFavoriteNumber = await contract.retrieve();
  console.log(currentFavoriteNumber.toString());
  const storing = await contract.store("7");
  await storing.wait(1);
  const updatedFavoriteNumber = await contract.retrieve();
  console.log(updatedFavoriteNumber.toString());
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.log(err);
    process.exit(1);
  });
