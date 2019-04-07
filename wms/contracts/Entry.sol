pragma solidity ^0.5.0;

contract Entry {

    struct Warehouse {
        uint maxCapacity;
        uint itemsCount;
        address[] items;
    }

    // id -> struct
    mapping(uint => Warehouse) warehouses;

    function createWarehouse(
            uint whId,
            uint maxCapacity,
            bool forceRecreate
        )
        public
        returns (uint)
    {
        require(warehouses[whId].maxCapacity == 0 || forceRecreate);

        warehouses[whId] = Warehouse(maxCapacity, 0,
                                     new address[](maxCapacity));
        return whId;
    }

    function addItem(uint whId) public returns (address) {
        Warehouse storage warehouse = warehouses[whId];
        require(warehouse.maxCapacity > 0 &&
                warehouse.itemsCount < warehouse.maxCapacity);

        warehouse.items[warehouse.itemsCount] = msg.sender;
        warehouse.itemsCount++;
        return warehouse.items[warehouse.itemsCount - 1];
    }

    function getWarehouseItems(uint whId)
        public
        view
        returns (address[] memory)
    {
        Warehouse storage warehouse = warehouses[whId];

        require(warehouse.maxCapacity > 0);

        return warehouse.items;
    }
}
