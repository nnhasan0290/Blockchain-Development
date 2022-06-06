import { ethers } from "ethers";
import fs from "fs-extra";

async function main() {
    const provider =  new ethers.providers.JsonRpcBatchProvider("http://127.0.0.1:7545");
    const wallet  = new ethers.wallet("c3b6a94b7358bc4d9e20b8ac41ed1c4a7e382c52301355e75ec3a606c42fd355", provider);
    const abi = fs.readFileSync("./simpleStorage_sol_simpleStorage.abi", "utf8");
    const binary = fs.readFileSync("./simpleStorage_sol_simpleStorage.bin", "utf8");
    const contractFactory = ethers.ContractFactory(abi, binary, wallet);

}