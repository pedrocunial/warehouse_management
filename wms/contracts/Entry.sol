pragma solidity ^0.5.0;

contract Entry {

    struct Warehouse {
        uint maxCapacity;
        string address_;
        address[] items;
    }

    // id -> struct
    mapping(address => Warehouse) warehouses;

    function createWarehouse(uint whId, uint maxCapacity, string address_)
        returns (uint)
    {
        warehouses[whId] = Warehouse(maxCapacity, address_, new uint[]());
    }

    function addNew(address whId) public returns (uint) {
        require(whId >= 0);

        Warehouse storage warehouse = warehouses[whId];
        require(warehouse.maxCapacity > 0 &&
                warehouse.items.length < warehouse.maxCapacity);

        warehouse.items.push(msg.sender);
        return warehouse.items.length - 1;
    }

    function getWarehouseItems(address whId)
        public
        view
        returns (address[] memory)
    {
        require(whId >= 0);

        return warehouses[whId].items;
    }
}
