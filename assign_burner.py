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

            if assign_burner == "no":
                print("Cannot proceed without assigning a burner wallet.")
                sys.exit(1)
            elif assign_burner == "yes":
                break
            else:
                continue
        else:
            print(f"Slot {slot_id} is already assigned to burner wallet {burner_wallet}")
            if burner_wallet.lower() == signer_account_address.lower():
                print("Burner wallet matches with the signer account address, continuing...")
                sys.exit(0)
            else:
                print("Burner wallet does not match with the signer account address.")
                assign_burner = input("Do you want to assign a burner wallet to a slot? (yes/no): ")

                if assign_burner == "yes":
                    break
                elif assign_burner == "no":
                    print("Cannot proceed with a different burner wallet.")
                    sys.exit(1)
                else:
                    continue

    print("To assign a burner wallet to a slot, you need to sign a message with the private key of the Account holding the slot.")
    private_key = getpass("Private Key: ")

    message = encode_defunct(text=f'Assign Burner Wallet to Slot {slot_id}')
    signed_message = Account.sign_message(message, private_key=private_key)

    url = "https://devnet-reg-api.powerloom.dev/assignBurnerWallet"

    # TODO: keep this list updated as new protocol state contracts are added to devnet
    contract_addresses = [
        '0x573906E80C30dA608E3a24A0938BCB3f0C68Ed2f',
        '0x12e11e7327d1A35CbB8B9116382D4c80bBbd66FF',
        '0x3a201ee51C24f399E8Eb914A9609BC7Bb79D593B',
        '0x6fa98eD982d7c6c27E2181778905D1F26D110c95'
    ]
    responses = []
    for contract_address in contract_addresses:
        payload = {
            "address": signer_account_address,
            "slotId": slot_id,
            "signature": signed_message.signature.hex(),
            "contractAddress": contract_address
        }

        try:
            response = requests.post(url, json=payload)
            responses.append(response)
            response.raise_for_status()
            if not response.json().get('info', {}).get('success'):
                print("Error assigning burner wallet to slot.")
                sys.exit(1)
        except requests.RequestException as e:
            print(f"Error communicating with registration server: {e}")
            sys.exit(1)

    for response in responses:
        if response.status_code != 200:
            print(f"Error assigning burner wallet to slot: {response.text}")
            sys.exit(1)

    print("Burner wallet assigned successfully.")

if __name__ == '__main__':
    assign_burner_wallet()
