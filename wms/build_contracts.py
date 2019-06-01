# https://medium.com/coinmonks/how-to-develop-ethereum-contract-using-python-flask-9758fe65976e

import json
from web3 import Web3
from solc import compile_files


def deploy_contract(contract_interface):
    # Instantiate and deploy contract
    contract = w3.eth.contract(
        abi=contract_interface['abi'],
        bytecode=contract_interface['bin']
    )
    # Get transaction hash from deployed contract
    tx_hash = contract.deploy(transaction={'from': w3.eth.accounts[1]})
    # Get tx receipt to get contract address
    tx_receipt = w3.eth.getTransactionReceipt(tx_hash)
    return tx_receipt['contractAddress']


w3 = Web3(Web3.HTTPProvider('http://127.0.0.1:8545'))

contracts = compile_files(['contracts/Entry.sol'])
main_contract = contracts.pop('contracts/Entry.sol:Entry')

with open('data/data.json', 'w') as outfile:
    data = {
        'abi': main_contract['abi'],
        'contract_address': deploy_contract(main_contract)
    }
    json.dump(data, outfile)
