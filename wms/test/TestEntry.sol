pragma solidity ^0.5.0;

import 'truffle/Assert.sol';
import 'truffle/DeployedAddresses.sol';
import '../contracts/Entry.sol';

contract TestEntry {
    Entry entry = Entry(DeployedAddresses.Entry());
    uint whId = 7;
    address expectedItem = address(this);

    function beforeAll() {
        for (uint i = 0; i < 10; i++) {
            entry.createWarehouse(30, 'Some street');
        }
    }

    function testWhCanGetEntry() public {
        uint retId = entry.addNew(whId);
        Assert.equal(retId, whId,
                     'Adição retornada deveria ser a mesma da enviada');
    }

    function testGetItemByWhId() public {
        address item = entry.warehouses(whId);
        Assert.equal(item, expectedItem,
                     'Item adicionado deveria ser este contrato');
    }

    function testGetWhAddressByItemId() public {
        address[16] memory items = entry.getWarehouses();
        Assert.equal(items[whId], expectedItem,
                     'Item do armazem deveria ser o mesmo deste contrato');
    }
}
