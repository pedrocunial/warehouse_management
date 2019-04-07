pragma solidity ^0.5.0;

import 'truffle/Assert.sol';
import 'truffle/DeployedAddresses.sol';
import '../contracts/Entry.sol';

contract TestEntry {
    Entry entry = Entry(DeployedAddresses.Entry());
    uint constant whId = 7;
    address expectedItem = address(this);

    function beforeEach() public {
        entry.createWarehouse(whId, 30, true);
    }

    function testCreateWarehouse() public {
        uint expectedId = 42;
        uint createdId = entry.createWarehouse(expectedId, 42, true);

        Assert.equal(createdId, expectedId,
                     'ID criado deveria ser o mesmo do esperado');
    }

    function testCanAddNewItem() public {
        address item0 = entry.addItem(whId);
        Assert.equal(item0, expectedItem,
                     'Item adicionado deveria ser o mesmo do esperado');

        address item1 = entry.addItem(whId);  // add same item twice

        Assert.equal(item1, expectedItem,
                     'Item deveria poder ser adicionado mais de uma vez');
    }

    function testGetItemByWhId() public {
        address item = entry.addItem(whId);
        address[] memory items = entry.getWarehouseItems(whId);

        bool contains = false;
        uint itemsLength = items.length;
        for (uint i = 0; i < itemsLength; i++) {
            if (items[i] == item) {
                contains = true;
                break;
            }
        }

        Assert.isTrue(contains, 'Item adicionado deveria ser este contrato');
    }
}
