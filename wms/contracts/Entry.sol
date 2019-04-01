pragma solidity ^0.5.0;

contract Entry {
    address[16] public warehouses;  // N warehouses

    function addNew(uint whId) public returns (uint) {
        require(whId >= 0 && whId <= 15);

        warehouses[whId] = msg.sender;
        return whId;
    }

    function getItems() public view returns (address[16] memory) {
        return warehouses;
    }
}
