pragma solidity ^0.5.0;

contract Entry {

    struct Warehouse {
        uint maxCapacity;
        uint itemsCount;
        uint[] itemIds;
    }

    struct Item {
        uint price;
        address owner;
    }

    // id -> struct
    mapping(uint => Warehouse) warehouses;
    mapping(uint => Item) items;

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
                                     new uint[](maxCapacity));
        return whId;
    }

    function addItem(
        uint whId,
        uint itemId,
        uint itemPrice,
        bool forceRecreate
    )
        public
        returns (uint)
    {
        Warehouse storage warehouse = warehouses[whId];
        require(warehouse.maxCapacity > 0 &&
                warehouse.itemsCount < warehouse.maxCapacity);

        if (items[itemId].owner == address(0) || forceRecreate) {
            items[itemId] = Item(itemPrice, msg.sender);
        }

        warehouse.itemIds[warehouse.itemsCount] = itemId;
        warehouse.itemsCount++;
        return itemId;
    }

    function getItemPrice(uint itemId) public view returns (uint) {
        require(items[itemId].owner != address(0));

        return items[itemId].price;
    }

    function getItemOwner(uint itemId) public view returns (address) {
        require(items[itemId].owner != address(0));

        return items[itemId].owner;
    }

    function getWarehouseItems(uint whId)
        public
        view
        returns (uint[] memory)
    {
        Warehouse storage warehouse = warehouses[whId];

        require(warehouse.maxCapacity > 0);

        return warehouse.itemIds;
    }
}
