pragma solidity ^0.5.0;

import 'truffle/Assert.sol';
import 'truffle/DeployedAddresses.sol';
import '../contracts/Entry.sol';

contract TestEntry {
    Entry entry = Entry(DeployedAddresses.Entry());
    uint constant whId = 7;
    uint constant itemId = 42;
    address expectedOwner = address(this);

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
        uint item0 = entry.addItem(whId, itemId, 42, false);
        Assert.equal(item0, itemId,
                     'Item adicionado deveria ser o mesmo do esperado');

        // add same item twice
        uint item1 = entry.addItem(whId, itemId, 42, false);

        Assert.equal(item1, itemId,
                     'Item deveria poder ser adicionado mais de uma vez');
    }

    function testGetItemByWhId() public {
        uint item = entry.addItem(whId, itemId, 42, true);
        uint[] memory items = entry.getWarehouseItems(whId);

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

    function testGetItemDetails() public {
        entry.addItem(whId, itemId, 42, true);
        uint price = entry.getItemPrice(itemId);
        address owner = entry.getItemOwner(itemId);

        Assert.equal(price, 42, 'O preço encontrado deveria ser o mesmo');
        Assert.equal(owner, expectedOwner,
                     'O criador do item deveria ser esta instancia');
    }

    function testMoveItem() public {
        uint destWdId = entry.createWarehouse(whId + 1, 42, true);
        entry.addItem(whId, itemId, 42, true);  // add item to orig WH
        entry.moveWarehouseItem(itemId, whId, destWdId);

        Assert.isTrue(entry.whContainsItem(destWdId, itemId),
                      'O item deveria ter sido movido para o segundo armazem');
        Assert.isFalse(entry.whContainsItem(whId, itemId),
                      'O item deveria ter sido movido para o segundo armazem');
    }
}
