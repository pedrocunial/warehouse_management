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

    function whContainsItem(uint whId, uint itemId) public view returns (bool) {
        require(items[itemId].owner != address(0));

        bool contains = false;
        uint[] memory whItems = getWarehouseItems(whId);
        for (uint i = 0; i < whItems.length; i++) {
            if (whItems[i] == itemId) {
                contains = true;
                break;
            }
        }
        return contains;
    }

    function moveWarehouseItem(
        uint itemId,
        uint fromWhId,
        uint toWhId
    )
        public
        returns (address)
    {
        require(items[itemId].owner != address(0));

        bool contains = false;
        uint[] memory whItems = getWarehouseItems(fromWhId);
        for (uint i = 0; i < whItems.length; i++) {
            if (whItems[i] == itemId) {
                contains = true;
                break;
            }
        }
        // contained in origin WH
        require(contains);

        contains = false;
        whItems = getWarehouseItems(toWhId);
        for (uint i = 0; i < whItems.length; i++) {
            if (whItems[i] == itemId) {
                contains = true;
                break;
            }
        }
        // not contained in dest WH
        require(!contains);

        // delete item from origin WH
        Warehouse storage fromWh = warehouses[fromWhId];
        uint itemLength = fromWh.itemIds.length;
        for (uint i = 0; i < itemLength; i++) {
            if (fromWh.itemIds[i] == itemId) {
                delete fromWh.itemIds[i];
                break;
            }
        }

        // add item to dest WH
        uint addedId = addItem(toWhId, itemId, 0, false);
        require(addedId == itemId);

        return items[itemId].owner;
    }
}
