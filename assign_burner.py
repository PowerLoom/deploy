import os
import sys
import json
import requests
from getpass import getpass
from web3 import Web3
from eth_account import Account
from eth_account.messages import encode_defunct
from dotenv import load_dotenv

load_dotenv()

ABI = json.loads("""[{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"slotSnapshotterMapping","outputs":[{"internalType":"address","name":"","type":"address"}],"stateMutability":"view","type":"function"}]""")

def get_env_variable(name):
    value = os.getenv(name)
    if not value:
        print(f"Error: Environment variable {name} not set.")
        sys.exit(1)
    return value

def assign_burner_wallet():
    slot_id = get_env_variable('SLOT_ID')
    contract_address = get_env_variable('PROTOCOL_STATE_CONTRACT')
    prost_rpc = get_env_variable('PROST_RPC_URL')
    signer_account_address = get_env_variable('SIGNER_ACCOUNT_ADDRESS')

    w3 = Web3(Web3.HTTPProvider(prost_rpc))
    contract = w3.eth.contract(address=contract_address, abi=ABI)

    burner_wallet = contract.functions.slotSnapshotterMapping(int(slot_id)).call()
    while True:
        if burner_wallet == "0x" + "0" * 40:
            print(f"Slot {slot_id} is not assigned to any burner wallet.")
            assign_burner = input("Do you want to assign a burner wallet to a slot? (yes/no): ")
            if assign_burner != "yes":
                print("Cannot proceed without assigning a burner wallet.")
                sys.exit(1)
            else:
                break
        else:
            print(f"Slot {slot_id} is already assigned to burner wallet {burner_wallet}")
            if burner_wallet.lower() == signer_account_address.lower():
                print("Burner wallet matches with the signer account address, continuing...")
                sys.exit(0)
            else:
                print("Burner wallet does not match with the signer account address.")
                assign_burner = input("Do you want to assign a burner wallet to a slot? (yes/no): ")
                if assign_burner != "yes":
                    print("Cannot proceed with a different burner wallet.")
                    sys.exit(1)

    print("To assign a burner wallet to a slot, you need to sign a message with the private key of the Account holding the slot.")
    private_key = getpass("Private Key: ")

    message = encode_defunct(text=f'Assign Burner Wallet to Slot {slot_id}')
    signed_message = Account.sign_message(message, private_key=private_key)

    url = "https://devnet-reg-api.powerloom.dev/assignBurnerWallet"
    payload = {
        "address": signer_account_address,
        "slotId": slot_id,
        "signature": signed_message.signature.hex(),
        "contractAddress": contract_address
    }

    try:
        response = requests.post(url, json=payload)
        print("Response:", response.json())
        response.raise_for_status()
        if response.json().get('info', {}).get('success'):
            print("Burner wallet assigned successfully.")
        else:
            print("Error assigning burner wallet to slot.")
            sys.exit(1)
    except requests.RequestException as e:
        print(f"Error communicating with registration server: {e}")
        sys.exit(1)

if __name__ == '__main__':
    assign_burner_wallet()
