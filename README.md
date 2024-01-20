# PowerLoom Deployment
Scripts to deploy PowerLoom services ([audit-protocol](https://github.com/PowerLoom/audit-protocol) and [pooler](https://github.com/PowerLoom/pooler)) to [PowerLoom Network](https://onchain-consensus.powerloom.io).

> Note: We just announced an incentivized testnet, [register here](https://coinlist.co/powerloom-testnet) to participate in the network.

## Requirements

1. Latest version of `docker` (`>= 20.10.21`) and `docker-compose` (`>= v2.13.0`)
2. At least 4 core CPU, 8GB RAM and 50GB SSD - make sure to choose the correct spec when deploying to Github Codespaces.
3. IPFS node
    - While we have __included__ a node in our autobuild docker setup, IPFS daemon can hog __*a lot*__ of resources - it is not recommended to run this on a personal computer unless you have a strong internet connection and dedicated CPU+RAM.
    - 3rd party IPFS services that provide default IFPS interface like Infura are now supported.
4. RPC URL for `Ethereum mainnet`. We recommend running a full geth node to save costs and to stick to ethos of decentralization! :)
> Our default (lite mode) setup is designed to work well with a free plan on any of the RPC providers like [Alchemy](https://alchemy.com/?r=15ce6db6d0a109d5), [Infura](https://infura.io), [Quicknode](https://www.quicknode.com?tap_a=67226-09396e&tap_s=3491854-f4a458), etc. It even works with Ankr's [public endpoint](https://rpc.ankr.com/eth) but we recommend signing up to track usage. For those interested in exploring the the full setup, we can also arrange for a special pan through our partners such as BlockVigil.

## For snapshotters

1. Copy `env.example` to `.env`.
   - Ensure the following required variables are filled:
     - `SOURCE_RPC_URL`: The URL for the source RPC (Remote Procedure Call) service.
     - `SIGNER_ACCOUNT_ADDRESS`: The address of the signer account.
     - `SIGNER_ACCOUNT_PRIVATE_KEY`: The private key corresponding to the signer account address.
   - Optionally, you may also set the following variables:
     - `PROST_RPC_URL`: The URL for the PROST RPC service.
     - `IPFS_URL`: The URL for the IPFS (InterPlanetary File System) service in HTTP(s) (e.g. `https://ipfs.infura.io:5001`) multiaddr format (e.g. `/dns4/ipfs.infura.io/tcp/5001/https`)
     - `IPFS_API_KEY`: The API key for the IPFS service (if required).
     - `IPFS_API_SECRET`: The API secret for the IPFS service (if required).
     - `PROTOCOL_STATE_CONTRACT`: The contract address for the protocol state.
     - `RELAYER_HOST`: The host address for the relayer.
     - `SLACK_REPORTING_URL`: The URL for reporting to Slack.
     - `POWERLOOM_REPORTING_URL`: The URL for reporting to PowerLoom.
     - `WEB3_STORAGE_TOKEN`: The token for Web3.Storage. You can generate or retrieve this token from your [API tokens page](https://web3.storage/tokens/?create=true) after signing up for a free plan at web3.storage.

2. Run the following command (ideally in a `screen`) and follow instructions

    `./build.sh`

3. Once all the services are up and running, the front-end can be accessed via [Pooler Frontend](http://localhost:3000) to see an AAVE summary data dashboard.
    - A sample screenshot of the dashboard is given [here](./sample_images/sample-frontend.jpg)

    - This will also give an idea in case your snapshotting has fallen behind as you can notice from the time of last snapshot shown in the screenshot.

    - The configuration is set to snapshot all Aave assets by default. Refer to contributors section below to change which assets are snapshotted.

4. To shutdown services, just press `Ctrl+C` (and again to force).

    > If you don't keep services running for extended periods of time, this will affect consensus and we may be forced to de-activate your snapshotter account.
    
5. If you see issues with data, you can do a clean *reset* by running the following command before restarting step 3:

    `docker-compose --profile ipfs down --volumes`

## Instructions for code contributors

1. Ensure `settings.json` and other relevant files are populated in proper directories
    - `../audit-protocol`
    - `../pooler`
    - Copy `env.example` to `.env` in `../pooler-frontend`

4. Git checkout the `aave` branch in the necessary directories:
    - `../pooler-frontend`
    - `../pooler`
        - ensure that `../pooler/config` and `../pooler/snapshotter/modules/computes` submodules are properly initialized and on the `aave` branch.
        - Refer to [Pooler Architecture](https://github.com/PowerLoom/pooler?tab=readme-ov-file#architecture) for help with Git Submodules.
        - Refer to [Aave snapshotter-computes](https://github.com/Seth-Schmidt/snapshotter-computes/tree/aave#setup) for setup instructions for the compute module.

3. Run the following command:

    `./build-dev.sh`
4. If you see issues with data, you can do a clean *reset* by running the following command before restarting step 2:

    `docker-compose -f docker-compose-dev.yaml --profile ipfs down --volumes`

## Questions?
1. Ask on our [Discord](https://powerloom.io/discord) - if you don't see the channel, ask an admin to add the snapshotter `role` to your account.
2. Create an [issue](https://github.com/PowerLoom/deploy/issues/new)
