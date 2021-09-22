const SupplyChain = artifacts.require("SupplyChain");

// Errors from the EVM
const prefix = "Returned error: VM Exception while processing transaction: "
const errorTypes = {
    revert: prefix + "revert"
}

// State mapping
const states = {
    planted: "Planted",
    harvested: "Harvested",
    processed: "Processed",
    graded: "Graded",
    exported: "Exported",
    roasted: "Roasted",
    shipped: "Shipped",
    purchased: "Purchased"
}

// Chain info
let accounts;
let owner;

// Contract
contract("SupplyChain", accts => {
    accounts = accts;
    owner = accts[0];
});

// Named accounts for use in multiple tests
const FARMER = accounts[0];
const INSPECTOR = accounts[1];
const COFFEEID = 1;

// createAndPlant
// Helper to create basic coffee onchain
async function createAndPlant(id, acct){
    let instance = await SupplyChain.deployed()
    await instance.plantCoffee(id, {from: acct})
}

it ("can plantCoffee", async () => {
    let instance = await SupplyChain.deployed();
    await instance.plantCoffee(COFFEEID, {from: FARMER});
    let result = await instance.fetchCoffee(COFFEEID)
    assert.equal(result.id, COFFEEID)
    assert.equal(result.stateIs, states.planted)
})

it ("can not harvestCoffee", async () => {
    let instance = await SupplyChain.deployed();
    // Harvest from not farmer to raise an error
    try{
        await instance.harvestCoffee(COFFEEID, {from: INSPECTOR})
    }catch (err){
        assert.equal(err.message, errorTypes.revert)
    }

})

it ("can harvestCoffee", async () => {
    let instance = await SupplyChain.deployed();
    await instance.harvestCoffee(COFFEEID, {from: FARMER})
    result = await instance.fetchCoffee(COFFEEID)
    assert.equal(result.stateIs, states.harvested)
})
