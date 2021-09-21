const SupplyChain = artifacts.require("SupplyChain");

let accounts;
let owner;

contract("SupplyChain", accts => {
    accounts = accts;
    owner = accts[0];
});


it ("can plantCoffee", async () => {
    let instance = await SupplyChain.deployed();
    const coffeeId = 1;
    await instance.plantCoffee(coffeeId, {from: accounts[0]});
    let result = await instance.fetchCoffee(1)
    console.log(result);
    assert.equal(result.id, coffeeId)
})
