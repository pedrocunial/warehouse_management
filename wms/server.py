import json
import uuid

from flask import Flask, Response, request, jsonify
from marshmallow import Schema, fields
from web3 import Web3
from hexbytes import HexBytes


class HexJsonEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, HexBytes):
            return obj.hex()
        return super().default(obj)


class Warehouse(Schema):
    maxCapacity = fields.Int(required=True)
    itemsCount = fields.Int()
    itemIds = fields.List(fields.Int())


with open('data/data.json', 'r') as f:
    datastore = json.load(f)
    abi = datastore['abi']
    contract_address = datastore['contract_address']

app = Flask(__name__)
w3 = Web3(Web3.HTTPProvider('http://localhost:8545'))
w3.eth.defaultAccount = w3.eth.accounts[1]


@app.route('/warehouse', methods=['POST'])
def warehouse():
    body = request.get_json()
    entry = w3.eth.contract(address=contract_address, abi=abi)
    result, error = Warehouse().load(body)
    if error:
        return jsonify(error), 422

    wh_id = uuid.uuid4().int
    tx_hash = entry.functions.createWarehouse(
        wh_id,
        result['maxCapacity'],
        False
    ).transact()

    receipt = w3.eth.waitForTransactionReceipt(tx_hash)
    return jsonify({'data': {
        'wh_id': wh_id,
        'receipt': json.dumps(dict(receipt), cls=HexJsonEncoder)
    }}), 200


if __name__ == '__main__':
    app.run()
