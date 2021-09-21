pragma solidity ^0.5.16;

// Open openzeppelin-solidity ERC-721 implemented Standard
import "../node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract SupplyChain is ERC721 {
    address owner;
    uint skuCount;
    enum State {Plant, Harvest, Process, Grade, Export, Roast, Ship, Purchase}

    struct Coffee {
        uint id;
        uint sku;
        uint price;
        State state;
        address farmer;
        address inspector;
        address distributor;
        address payable consumer;
    }

    mapping(uint => Coffee) coffees;
    event Planted(uint skuCount);
    event Harvested(uint sku);
    event Processed(uint sku);
    event Graded(uint sku);
    event Exported(uint sku);
    event Roasted(uint sku);
    event Shipped(uint sku);
    event Purchased(uint sku);

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    modifier paidEnough(uint _price){
        require(msg.value >= _price);
        _;
    }

    modifier checkValue(uint _sku){
        _;
        uint _price = coffees[_sku].price;
        uint amountToRefund = msg.value - _price;
        coffees[_sku].consumer.transfer(amountToRefund);
    }

    constructor() public {
        owner = msg.sender;
        skuCount = 0;
    }

    /// @author Miles Hill
    /// @notice Creates a plants a Coffee instance
    function plantCoffee (uint _id) public {
        skuCount = skuCount += 1;
        coffees[skuCount] = Coffee({
            id: _id,
            sku: skuCount,
            price: 0,
            state: State.Plant,
            farmer: msg.sender,
            inspector: address(0),
            distributor: address(0),
            consumer: address(0)
        });
        emit Planted(skuCount);
    }

    function fetchCoffee(uint _sku) public view returns (
        uint id, uint sku, uint price, string memory stateIs, address farmer, address inspector, address distributor, address consumer
    ){
        id = coffees[_sku].id;
        sku = coffees[_sku].sku;
        price = coffees[_sku].price;
        farmer = coffees[_sku].farmer;
        inspector = coffees[_sku].inspector;
        distributor = coffees[_sku].distributor;
        consumer = coffees[_sku].consumer;

        uint state;
        state = uint(coffees[_sku].state);
        if (state == 0){
            stateIs = "Planted";
        }
        if (state == 1){
        stateIs = "Harvested";
        }
        if (state == 2){
        stateIs = "Processed";
        }
        if (state == 3){
        stateIs = "Graded";
        }
        if (state == 4){
        stateIs = "Exported";
        }
        if (state == 5){
        stateIs = "Roasted";
        }
        if (state == 6){
        stateIs = "Shipped";
        }
        if (state == 7){
            stateIs = "Purchased";
        }

    }


}
