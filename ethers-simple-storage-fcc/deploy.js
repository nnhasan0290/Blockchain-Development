const ethers = require("ethers");
const fs = require("fs-extra");

async function main() {
  const provider = new ethers.providers.JsonRpcBatchProvider(
    "http://127.0.0.1:7545"
  );
  const wallet = new ethers.Wallet(
    "37b4b467fc7127880503ec03ff69ade5bdbc170823d43ce9cb2d2e5fc84ad7af",
    provider
  );
  console.log(wallet);
  const abi = fs.readFileSync("./simpleStorage_sol_SimpleStorage.abi", "utf8");
  const binary = fs.readFileSync(
    "./simpleStorage_sol_SimpleStorage.bin",
    "utf8"
  );
  const contractFactory = new ethers.ContractFactory(abi, binary, wallet);
  console.log("Deploying Please wait");
  const contract = await contractFactory.deploy();
  console.log(contract);
}

main()
  .then(() => process.exit(0))
  .catch((err) => {
    console.log(err);
    process.exit(1);
  });
