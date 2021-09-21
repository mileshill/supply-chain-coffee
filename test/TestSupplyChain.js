const SupplyChain = artifacts.require("SupplyChain");

let accounts;
let owner;

contract("SupplyChain", accts => {
    accounts = accts;
    owner = accts[0];
});

