pragma solidity >=0.4.24;

// Open openzeppelin-solidity ERC-721 implemented Standard
import "../node_modules/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract SupplyChain is ERC721 {
    address owner;
    uint skuCount;
    enum State {Plant, Harvest, Process, Grade, Export, Roast, Ship, Purchase}

    struct Coffee {
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
}
